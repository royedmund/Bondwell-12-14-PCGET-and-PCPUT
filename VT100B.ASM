;===============================================================================
; VT100B - Bondwell 12/14 Limited VT100/ANSI Terminal
;===============================================================================
;
; PURPOSE
; -------
; VT100B turns a Bondwell 12 or Bondwell 14 running CP/M into a basic
; VT100-compatible serial terminal. It communicates through SIO channel A
; at I/O ports 40H/41H and writes characters directly to Bondwell video RAM.
;
; DESIGN NOTES
; ------------
; The source is organised in the traditional CP/M/Kermit-80 style:
;
;   1. Hardware and operating-system definitions
;   2. Program entry and main polling loop
;   3. Local keyboard and command-prefix handling
;   4. Z80 SIO initialisation, receive and transmit routines
;   5. VT100 escape-sequence state machine
;   6. Cursor, erase, scrolling and character-output routines
;   7. Program variables, response strings and stack storage
;
; The layout and comments are inspired by the modular, hardware-oriented
; organisation used by the original CP/M Kermit-80 source. No executable
; behaviour has been changed while documenting this file.
;
; LOCAL COMMAND PREFIX
; --------------------
;   Ctrl-] C        Exit to CP/M
;   Ctrl-] ?        Display local help
;   Ctrl-] X        Send a literal Ctrl-X (useful for Nano)
;   Ctrl-] Ctrl-]   Send a literal ESC byte
;
; BONDWELL CURSOR KEY CODES
; -------------------------
;   Up    05H       Down  18H
;   Right 04H       Left  13H
;
; These CP/M/WordStar-style keyboard codes are translated to either
; ESC [ A/B/C/D or ESC O A/B/C/D, according to VT100 cursor-key mode.
;
; HARDWARE SUMMARY
; ----------------
;   SIO channel A data       40H
;   SIO channel A status     41H
;   Video RAM base           F800H
;   6845 CRTC index/data     10H/11H
;   Display geometry         80 columns x 25 rows
;
;===============================================================================

;===============================================================================
; CP/M, HARDWARE AND TERMINAL CONSTANTS
;===============================================================================
        ORG 0x0100
BDOS EQU 0x0005
BDOS_DIRIO EQU 0x06
BDOS_PRINT EQU 0x09
SIO_DATA EQU 0x40
SIO_STAT EQU 0x41
TX_MASK EQU 0x04
RX_MASK EQU 0x01
VIDEO_BASE EQU 0xF800
CRTC_INDEX EQU 0x10
CRTC_DATA EQU 0x11
COLS EQU 80
ROWS EQU 25
SCREEN_SIZE EQU 2000
ESC EQU 0x1B
BEL EQU 7
BS EQU 8
HT EQU 9
LF EQU 10
CR EQU 13
DEL EQU 0x7F
ESCAPE_CHAR EQU 0x1D
STATE_NORMAL EQU 0
STATE_ESC EQU 1
STATE_CSI EQU 2
STATE_G0 EQU 3
STATE_G1 EQU 4
STATE_HASH EQU 5
STATE_BARE_CSI EQU 6
CHARSET_ASCII EQU 0
CHARSET_DEC EQU 1

;===============================================================================
; PROGRAM ENTRY AND MAIN SERVICE LOOP
;===============================================================================
;
; CP/M loads a transient program at 0100H. The program installs its own stack,
; initialises the Z80 SIO, resets the emulated terminal state and then repeatedly
; services received serial data, the local keyboard and the hardware cursor.
;
; Initialise private stack, serial hardware and terminal state.
START:
 LD SP,STACK_TOP
 CALL SIO_INIT
 CALL TERM_RESET

 ; Display the local command keys once at startup. Terminal operation starts
 ; immediately afterwards; no keypress is required.
 LD DE,STARTUP_TEXT
 CALL PRINT_STRING

; Cooperative polling loop. No interrupts are used.
MAIN_LOOP:
 CALL SERIAL_POLL
 CALL KEYBOARD_POLL
 CALL UPDATE_HW_CURSOR
 JP MAIN_LOOP

;===============================================================================
; LOCAL KEYBOARD INPUT AND COMMAND-PREFIX PROCESSING
;===============================================================================
;
; Keyboard input is obtained through CP/M BDOS function 6 in non-blocking mode.
; A zero result means no key is waiting. Ctrl-] is intercepted locally and makes
; the following key a terminal command rather than a byte sent to the host.
;
; Return A=0 when no CP/M console key is available.
KEY_GET:
 PUSH BC
 PUSH DE
 LD C,BDOS_DIRIO
 LD E,0xFF
 CALL BDOS
 POP DE
 POP BC
 OR A
 RET
; Process one local key, including the Ctrl-] prefix.
KEYBOARD_POLL:
 CALL KEY_GET
 RET Z
 LD B,A
 LD A,(LOCAL_ESC)
 OR A
 JP NZ,KEY_AFTER_ESCAPE
 LD A,B
 CP ESCAPE_CHAR
 JP NZ,KEY_SEND
 LD A,1
 LD (LOCAL_ESC),A
 RET
; Decode the character following the local Ctrl-] prefix.
KEY_AFTER_ESCAPE:
 XOR A
 LD (LOCAL_ESC),A
 LD A,B
 AND 0x5F
 CP 67
 JP Z,EXIT_TO_CPM
 CP 63
 JP Z,SHOW_HELP
 CP 88
 JP Z,SEND_CTRL_X
 LD A,B
 CP ESCAPE_CHAR
 RET NZ
 ; Ctrl-] Ctrl-] sends a literal ESC to the remote host.
 LD A,ESC
 JP SERIAL_SEND
; Send raw 18H so Nano can receive its normal exit command.
SEND_CTRL_X:
 LD A,18H
 JP SERIAL_SEND
; Normal keyboard path before cursor-key translation.
KEY_SEND:
 ; Normalise DEL from the Bondwell BIOS to Ctrl-H/BS.  This makes both
 ; the Backspace key and Ctrl-H send a conventional 08H backspace.
 LD A,B
 CP DEL
 JP NZ,KEY_SEND_NOT_DEL
 LD B,BS
KEY_SEND_NOT_DEL:
 ; Bondwell cursor keys use the traditional CP/M/WordStar control codes:
 ; Up=05H, Down=18H, Right=04H, Left=13H.
 ; Translate them into VT100 cursor-key sequences.
 JP ARROW_KEY_SEND
; Display local command help through CP/M BDOS.
SHOW_HELP:
 LD DE,HELP_TEXT
 JP PRINT_STRING
; Print a closing message and warm-boot CP/M through address 0000H.
EXIT_TO_CPM:
 LD DE,EXIT_TEXT
 CALL PRINT_STRING
 JP 0

;===============================================================================
; Z80 SIO CHANNEL-A DRIVER
;===============================================================================
;
; SIO channel A is programmed for the Bondwell serial port. Receive polling
; drains all currently available bytes before returning to slower BDOS and CRTC
; work. This reduces receive overruns during dense ANSI screen updates.
;
; Write the precomputed channel-A setup bytes to the SIO control port.
SIO_INIT:
 LD HL,SIO_INIT_TABLE
 LD B,SIO_INIT_LEN
SIO_INIT_LOOP:
 LD A,(HL)
 OUT (SIO_STAT),A
 INC HL
 DJNZ SIO_INIT_LOOP
 RET
SIO_INIT_TABLE:
 DB 0x18,0x18,0x04,0x44,0x01,0x00,0x03,0xC1,0x05,0xEA
SIO_INIT_LEN EQU $-SIO_INIT_TABLE
; Consume every byte currently waiting in the SIO receiver.
SERIAL_POLL:
 ; Drain all available serial input before calling BDOS or updating the cursor.
 ; Nano sends dense groups of VT100 sequences. Returning after only 32 bytes
 ; allowed the three-byte SIO FIFO to overrun while the main loop performed
 ; slower keyboard and hardware-cursor work, often losing the leading ESC.
SERIAL_DRAIN_LOOP:
 IN A,(SIO_STAT)
 AND RX_MASK
 JP Z,SERIAL_DRAIN_DONE
 IN A,(SIO_DATA)
 CALL VT_INPUT
 JP SERIAL_DRAIN_LOOP
SERIAL_DRAIN_DONE:
 ; Z80 SIO WR0 command 30H resets parity/overrun/framing error latches.
 ; This also restores the register pointer to WR0 for the next status read.
 LD A,30H
 OUT (SIO_STAT),A
 RET
; Send one byte with a finite TX-ready timeout.
SERIAL_SEND:
 ; Never wait forever for the SIO transmitter.  A missing or unexpected
 ; TX-ready indication previously locked the whole terminal, preventing
 ; the local exit command from working after a cursor key was pressed.
 PUSH AF
 PUSH BC
 LD BC,0FFFFH
SERIAL_WAIT_TX:
 IN A,(SIO_STAT)
 AND TX_MASK
 JP NZ,SERIAL_TX_READY
 DEC BC
 LD A,B
 OR C
 JP NZ,SERIAL_WAIT_TX
 ; Timed out: discard this byte and return to the main loop rather than hang.
 POP BC
 POP AF
 RET
SERIAL_TX_READY:
 POP BC
 POP AF
 OUT (SIO_DATA),A
 RET

;===============================================================================
; VT100 INPUT PARSER
;===============================================================================
;
; Each received serial byte is dispatched according to PARSER_STATE.
;
;   STATE_NORMAL    Ordinary text and C0 control characters
;   STATE_ESC       Character immediately following ESC
;   STATE_CSI       ANSI Control Sequence Introducer parameters
;   STATE_G0/G1     Character-set designator following ESC ( or ESC )
;   STATE_HASH      ESC # line-size/alignment sequence
;   STATE_BARE_CSI  Recovery for a missing ESC before [
;
; CAN and SUB cancel a partially received escape sequence.
;
; Top-level state-machine dispatcher for one received byte.
VT_INPUT:
 ; CAN and SUB cancel any in-progress escape sequence.
 CP 0x18
 JP Z,VT_CANCEL
 CP 0x1A
 JP Z,VT_CANCEL
 PUSH AF
 LD A,(PARSER_STATE)
 OR A
 JP Z,VT_NORMAL_DISPATCH
 CP STATE_ESC
 JP Z,VT_ESC_DISPATCH
 CP STATE_CSI
 JP Z,VT_CSI_DISPATCH
 CP STATE_G0
 JP Z,VT_G0_DISPATCH
 CP STATE_G1
 JP Z,VT_G1_DISPATCH
 CP STATE_BARE_CSI
 JP Z,VT_BARE_CSI_DISPATCH
 POP AF
 JP VT_SUPPRESS_FINAL
VT_CANCEL:
 XOR A
 LD (PARSER_STATE),A
 RET
VT_NORMAL_DISPATCH:
 POP AF
; Handle printable characters and single-byte C0 controls.
VT_NORMAL:
 CP ESC
 JP Z,VT_BEGIN_ESC
 CP BEL
 JP Z,VT_BELL
 CP BS
 JP Z,CURSOR_LEFT
 CP HT
 JP Z,TAB_FORWARD
 CP LF
 JP Z,LINE_FEED
 CP 0x0B
 JP Z,LINE_FEED
 CP 0x0C
 JP Z,LINE_FEED
 CP CR
 JP Z,CARRIAGE_RETURN
 CP 0x0E
 JP Z,SELECT_G1
 CP 0x0F
 JP Z,SELECT_G0
 CP 0x20
 RET C
 CP '['
 JP Z,VT_BEGIN_BARE_CSI
 CP DEL
 RET Z
 JP PUT_CHAR

; Recovery for a CSI sequence whose leading ESC was lost because of a serial
; receive overrun.  The common readline backspace echo ends with ESC [ K.
; If only [ K arrives, treat it as EL 0 rather than displaying literal [K.

;-------------------------------------------------------------------------------
; Lost-ESC recovery
;-------------------------------------------------------------------------------
;
; Some serial overruns observed during command-line editing lost the ESC byte
; from ESC [ K. Holding a bare '[' for one byte lets the parser recognise [K as
; erase-to-end-of-line while still displaying a normal '[' in ordinary text.
;
VT_BEGIN_BARE_CSI:
 LD A,STATE_BARE_CSI
 LD (PARSER_STATE),A
 RET
VT_BARE_CSI_DISPATCH:
 POP AF
 LD B,A
 XOR A
 LD (PARSER_STATE),A
 LD A,B
 CP 'K'
 JP Z,CLEAR_TO_LINE_END
 ; It was an ordinary '[' followed by another character. Display the held
 ; bracket, then process the current character normally.
 PUSH AF
 LD A,'['
 CALL PUT_CHAR
 POP AF
 JP VT_NORMAL


;-------------------------------------------------------------------------------
; ESC sequence dispatcher
;-------------------------------------------------------------------------------
VT_BEGIN_ESC:
 LD A,STATE_ESC
 LD (PARSER_STATE),A
 RET
VT_BELL:
 LD C,BDOS_DIRIO
 LD E,BEL
 JP BDOS
VT_ESC_DISPATCH:
 POP AF
; Decode the byte following ESC.
VT_ESC:
 CP 40
 JP Z,BEGIN_G0
 CP 41
 JP Z,BEGIN_G1
 CP 35
 JP Z,BEGIN_HASH
 CP 91
 JP Z,BEGIN_CSI
 CP 55
 JP Z,SAVE_CURSOR
 CP 56
 JP Z,RESTORE_CURSOR
 CP 68
 JP Z,ESC_INDEX
 CP 69
 JP Z,ESC_NEXT_LINE
 CP 77
 JP Z,REVERSE_INDEX
 CP 90
 JP Z,ESC_IDENTIFY
 CP 72
 JP Z,ESC_SUPPRESS
 CP 61
 JP Z,ESC_SUPPRESS
 CP 62
 JP Z,ESC_SUPPRESS
 CP 49
 JP Z,ESC_SUPPRESS
 CP 50
 JP Z,ESC_SUPPRESS
 CP 99
 JP Z,TERM_RESET
ESC_SUPPRESS:
 XOR A
 LD (PARSER_STATE),A
 RET
ESC_IDENTIFY:
 XOR A
 LD (PARSER_STATE),A
 JP CSI_IDENTIFY
BEGIN_G0:
 LD A,STATE_G0
 LD (PARSER_STATE),A
 RET
BEGIN_G1:
 LD A,STATE_G1
 LD (PARSER_STATE),A
 RET
BEGIN_HASH:
 LD A,STATE_HASH
 LD (PARSER_STATE),A
 RET
VT_G0_DISPATCH:
 POP AF
 LD B,A
 XOR A
 LD (PARSER_STATE),A
 LD A,B
 CP 48
 JP Z,G0_DEC
 ; B and A are treated as ASCII; 1/2 unsupported ROMs are suppressed.
 XOR A
 LD (G0_CHARSET),A
 RET
G0_DEC:
 LD A,CHARSET_DEC
 LD (G0_CHARSET),A
 RET
VT_G1_DISPATCH:
 POP AF
 LD B,A
 XOR A
 LD (PARSER_STATE),A
 LD A,B
 CP 48
 JP Z,G1_DEC
 XOR A
 LD (G1_CHARSET),A
 RET
G1_DEC:
 LD A,CHARSET_DEC
 LD (G1_CHARSET),A
 RET
VT_SUPPRESS_FINAL:
 ; Consumes ESC # 3/4/5/6 line-size requests and ESC # 8 alignment test.
 XOR A
 LD (PARSER_STATE),A
 RET
SELECT_G0:
 XOR A
 LD (GL_SELECT),A
 RET
SELECT_G1:
 LD A,1
 LD (GL_SELECT),A
 RET

;-------------------------------------------------------------------------------
; ANSI CSI parser
;-------------------------------------------------------------------------------
;
; This compact parser stores two numeric parameters separated by ';'. Private
; DEC modes are identified by '?' and recorded in PRIVATE_FLAG.
;
; Enter CSI state and clear parameter storage.
BEGIN_CSI:
 LD A,STATE_CSI
 LD (PARSER_STATE),A
 XOR A
 LD (PARAM1),A
 LD (PARAM2),A
 LD (PARAM_INDEX),A
 LD (PRIVATE_FLAG),A
 RET
VT_CSI_DISPATCH:
 POP AF
; Accumulate digits, separators and DEC private-mode markers.
VT_CSI:
 CP ESC
 JP Z,VT_BEGIN_ESC
 CP 63
 JP NZ,CSI_NOT_PRIVATE
 LD A,1
 LD (PRIVATE_FLAG),A
 RET
CSI_NOT_PRIVATE:
 CP 48
 JP C,CSI_NOT_DIGIT
 CP 58
 JP NC,CSI_NOT_DIGIT
 SUB 48
 LD B,A
 LD A,(PARAM_INDEX)
 OR A
 JP NZ,CSI_DIGIT2
 LD A,(PARAM1)
 CALL MUL10_ADD_B
 LD (PARAM1),A
 RET
CSI_DIGIT2:
 LD A,(PARAM2)
 CALL MUL10_ADD_B
 LD (PARAM2),A
 RET
CSI_NOT_DIGIT:
 CP 59
 JP NZ,CSI_COMMAND
 LD A,1
 LD (PARAM_INDEX),A
 RET
; Dispatch the final CSI command character.
CSI_COMMAND:
 PUSH AF
 XOR A
 LD (PARSER_STATE),A
 POP AF
 CP 65
 JP Z,CSI_CURSOR_UP
 CP 66
 JP Z,CSI_CURSOR_DOWN
 CP 67
 JP Z,CSI_CURSOR_RIGHT
 CP 68
 JP Z,CSI_CURSOR_LEFT
 CP 69
 JP Z,CSI_CNL
 CP 70
 JP Z,CSI_CPL
 CP 71
 JP Z,CSI_CHA
 CP 72
 JP Z,CSI_CURSOR_POSITION
 CP 102
 JP Z,CSI_CURSOR_POSITION
 CP 100
 JP Z,CSI_VPA
 CP 97
 JP Z,CSI_CURSOR_RIGHT
 CP 101
 JP Z,CSI_CURSOR_DOWN
 CP 74
 JP Z,CSI_ERASE_DISPLAY
 CP 75
 JP Z,CSI_ERASE_LINE
 CP 109
 JP Z,CSI_SGR
 CP 115
 JP Z,SAVE_CURSOR
 CP 117
 JP Z,RESTORE_CURSOR
 CP 110
 JP Z,CSI_DEVICE_STATUS
 CP 99
 JP Z,CSI_IDENTIFY
 CP 104
 JP Z,CSI_MODE_SET
 CP 108
 JP Z,CSI_MODE_RESET
 ; Other modes, scrolling regions, tabs, LEDs and tests are safely suppressed.
 RET

;-------------------------------------------------------------------------------
; CSI command implementations
;-------------------------------------------------------------------------------
MUL10_ADD_B:
 LD C,A
 ADD A,A
 ADD A,A
 ADD A,C
 ADD A,A
 ADD A,B
 RET
PARAM1_DEFAULT1:
 LD A,(PARAM1)
 OR A
 RET NZ
 INC A
 RET
CSI_CURSOR_UP:
 CALL PARAM1_DEFAULT1
 LD B,A
CCU_LOOP:
 CALL CURSOR_UP
 DJNZ CCU_LOOP
 RET
CSI_CURSOR_DOWN:
 CALL PARAM1_DEFAULT1
 LD B,A
CCD_LOOP:
 CALL CURSOR_DOWN
 DJNZ CCD_LOOP
 RET
CSI_CURSOR_RIGHT:
 CALL PARAM1_DEFAULT1
 LD B,A
CCR_LOOP:
 CALL CURSOR_RIGHT
 DJNZ CCR_LOOP
 RET
CSI_CURSOR_LEFT:
 CALL PARAM1_DEFAULT1
 LD B,A
CCL_LOOP:
 CALL CURSOR_LEFT
 DJNZ CCL_LOOP
 RET
CSI_CNL:
 CALL PARAM1_DEFAULT1
 LD B,A
CNL_LOOP:
 CALL CURSOR_DOWN
 DJNZ CNL_LOOP
 JP CARRIAGE_RETURN
CSI_CPL:
 CALL PARAM1_DEFAULT1
 LD B,A
CPL_LOOP:
 CALL CURSOR_UP
 DJNZ CPL_LOOP
 JP CARRIAGE_RETURN
CSI_CHA:
 LD A,(PARAM1)
 OR A
 JP NZ,CHA_OK
 INC A
CHA_OK:
 DEC A
 CP COLS
 JP C,CHA_STORE
 LD A,COLS-1
CHA_STORE:
 LD (CUR_COL),A
 RET
CSI_VPA:
 LD A,(PARAM1)
 OR A
 JP NZ,VPA_OK
 INC A
VPA_OK:
 DEC A
 CP ROWS
 JP C,VPA_STORE
 LD A,ROWS-1
VPA_STORE:
 LD (CUR_ROW),A
 RET
CSI_CURSOR_POSITION:
 CALL CSI_VPA
 JP CSI_CHA_PARAM2
CSI_CHA_PARAM2:
 LD A,(PARAM2)
 OR A
 JP NZ,CHAP2_OK
 INC A
CHAP2_OK:
 DEC A
 CP COLS
 JP C,CHAP2_STORE
 LD A,COLS-1
CHAP2_STORE:
 LD (CUR_COL),A
 RET
CSI_ERASE_DISPLAY:
 LD A,(PARAM1)
 CP 2
 JP Z,CLEAR_SCREEN
 CP 3
 RET Z
 OR A
 JP Z,CLEAR_TO_SCREEN_END
 CP 1
 JP Z,CLEAR_TO_SCREEN_START
 RET
CSI_ERASE_LINE:
 LD A,(PARAM1)
 CP 2
 JP Z,CLEAR_WHOLE_LINE
 OR A
 JP Z,CLEAR_TO_LINE_END
 CP 1
 JP Z,CLEAR_TO_LINE_START
 RET
CSI_SGR:
 LD A,(PARAM1)
 CALL APPLY_SGR
 LD A,(PARAM_INDEX)
 OR A
 RET Z
 LD A,(PARAM2)
 JP APPLY_SGR
APPLY_SGR:
 OR A
 JP Z,SGR_RESET
 CP 7
 JP Z,SGR_ON
 CP 27
 JP Z,SGR_OFF
 ; 1,4,5,22,24,25 and colour SGR are accepted but not rendered.
 RET
SGR_RESET:
 XOR A
 LD (CURRENT_ATTR),A
 RET
SGR_ON:
 LD A,(CURRENT_ATTR)
 OR 1
 LD (CURRENT_ATTR),A
 RET
SGR_OFF:
 LD A,(CURRENT_ATTR)
 AND 0xFE
 LD (CURRENT_ATTR),A
 RET
CSI_DEVICE_STATUS:
 LD A,(PARAM1)
 CP 5
 JP Z,DSR_OK
 CP 6
 RET NZ
 LD A,ESC
 CALL SERIAL_SEND
 LD A,91
 CALL SERIAL_SEND
 LD A,(CUR_ROW)
 INC A
 CALL SEND_DECIMAL
 LD A,59
 CALL SERIAL_SEND
 LD A,(CUR_COL)
 INC A
 CALL SEND_DECIMAL
 LD A,82
 JP SERIAL_SEND
DSR_OK:
 LD HL,STATUS_OK
 JP SEND_ZERO_STRING
CSI_MODE_SET:
 ; DEC private mode 1 selects VT100 application cursor-key mode.
 LD A,(PRIVATE_FLAG)
 OR A
 RET Z
 LD A,(PARAM1)
 CP 1
 RET NZ
 LD A,1
 LD (CURSOR_APP_MODE),A
 RET
CSI_MODE_RESET:
 ; DEC private mode 1 restores normal ANSI cursor-key mode.
 LD A,(PRIVATE_FLAG)
 OR A
 RET Z
 LD A,(PARAM1)
 CP 1
 RET NZ
 XOR A
 LD (CURSOR_APP_MODE),A
 RET
CSI_IDENTIFY:
 LD HL,IDENT_RESPONSE
SEND_ZERO_STRING:
 LD A,(HL)
 OR A
 RET Z
 INC HL
 CALL SERIAL_SEND
 JP SEND_ZERO_STRING
SEND_DECIMAL:
 LD B,0
SD100:
 CP 100
 JP C,SD10
 SUB 100
 INC B
 JP SD100
SD10:
 LD C,0
SD10L:
 CP 10
 JP C,SDOUT
 SUB 10
 INC C
 JP SD10L
SDOUT:
 LD D,A
 LD A,B
 OR A
 JP Z,SDS100
 ADD A,48
 CALL SERIAL_SEND
SDS100:
 LD A,C
 OR A
 JP NZ,SEND10
 LD A,B
 OR A
 JP Z,SDS10
 XOR A
SEND10:
 ADD A,48
 CALL SERIAL_SEND
SDS10:
 LD A,D
 ADD A,48
 JP SERIAL_SEND

;===============================================================================
; TERMINAL RESET, CHARACTER OUTPUT AND CHARACTER-SET MAPPING
;===============================================================================
;
; TERM_RESET restores default parser, cursor, attribute and G0/G1 state.
; PUT_CHAR maps DEC Special Graphics when selected, applies inverse video by
; setting bit 7, writes directly to video RAM and advances the logical cursor.
;
; Restore VT100 defaults and clear the display.
TERM_RESET:
 XOR A
 LD (PARSER_STATE),A
 LD (LOCAL_ESC),A
 LD (CURSOR_APP_MODE),A
 LD (CUR_ROW),A
 LD (CUR_COL),A
 LD (SAVED_ROW),A
 LD (SAVED_COL),A
 LD (CURRENT_ATTR),A
 LD (SAVED_ATTR),A
 LD (G0_CHARSET),A
 LD (GL_SELECT),A
 LD (SAVED_G0_CHARSET),A
 LD (SAVED_GL_SELECT),A
 LD A,CHARSET_DEC
 LD (G1_CHARSET),A
 LD (SAVED_G1_CHARSET),A
 JP CLEAR_SCREEN
; Render one printable character at the current position.
PUT_CHAR:
 CALL MAP_GL_CHARACTER
 PUSH AF
 CALL CURSOR_ADDRESS
 POP AF
 LD B,A
 LD A,(CURRENT_ATTR)
 AND 1
 LD A,B
 JP Z,PUT_STORE
 OR 0x80
PUT_STORE:
 LD (HL),A
 JP CURSOR_RIGHT_WRAP
; Map 60H-7EH through the selected DEC graphics set.
MAP_GL_CHARACTER:
 LD B,A
 LD A,(GL_SELECT)
 OR A
 JP NZ,MAP_G1
 LD A,(G0_CHARSET)
 JP MAP_TEST
MAP_G1:
 LD A,(G1_CHARSET)
MAP_TEST:
 CP CHARSET_DEC
 LD A,B
 RET NZ
 CP 0x60
 RET C
 CP 0x7F
 RET NC
 SUB 0x60
 RET

;===============================================================================
; CURSOR POSITIONING AND BASIC CONTROL ACTIONS
;===============================================================================
;
; CURSOR_ADDRESS calculates:
;
;       VIDEO_BASE + (row * 80) + column
;
; The multiplication by 80 is performed using shifts and additions so no
; multiply instruction or large lookup table is required.
;
; Return HL pointing at the current video-memory cell.
CURSOR_ADDRESS:
 LD A,(CUR_ROW)
 LD L,A
 LD H,0
 ADD HL,HL
 ADD HL,HL
 ADD HL,HL
 ADD HL,HL
 PUSH HL
 ADD HL,HL
 ADD HL,HL
 POP DE
 ADD HL,DE
 LD A,(CUR_COL)
 LD E,A
 LD D,0
 ADD HL,DE
 LD DE,VIDEO_BASE
 ADD HL,DE
 RET
CURSOR_RIGHT:
 LD A,(CUR_COL)
 CP COLS-1
 RET NC
 INC A
 LD (CUR_COL),A
 RET
CURSOR_RIGHT_WRAP:
 LD A,(CUR_COL)
 INC A
 CP COLS
 JP C,CRW_STORE
 XOR A
 LD (CUR_COL),A
 JP LINE_FEED
CRW_STORE:
 LD (CUR_COL),A
 RET
CURSOR_LEFT:
 LD A,(CUR_COL)
 OR A
 RET Z
 DEC A
 LD (CUR_COL),A
 RET
CURSOR_UP:
 LD A,(CUR_ROW)
 OR A
 RET Z
 DEC A
 LD (CUR_ROW),A
 RET
CURSOR_DOWN:
 LD A,(CUR_ROW)
 CP ROWS-1
 RET NC
 INC A
 LD (CUR_ROW),A
 RET
CARRIAGE_RETURN:
 XOR A
 LD (CUR_COL),A
 RET
; Move down one row or scroll when already on the last row.
LINE_FEED:
 LD A,(CUR_ROW)
 CP ROWS-1
 JP Z,SCROLL_UP
 INC A
 LD (CUR_ROW),A
 RET
ESC_INDEX:
 XOR A
 LD (PARSER_STATE),A
 JP LINE_FEED
ESC_NEXT_LINE:
 XOR A
 LD (PARSER_STATE),A
 CALL CARRIAGE_RETURN
 JP LINE_FEED
REVERSE_INDEX:
 XOR A
 LD (PARSER_STATE),A
 LD A,(CUR_ROW)
 OR A
 JP NZ,CURSOR_UP
 JP SCROLL_DOWN
TAB_FORWARD:
 LD A,(CUR_COL)
 ADD A,8
 AND 0xF8
 CP COLS
 JP C,TAB_STORE
 LD A,COLS-1
TAB_STORE:
 LD (CUR_COL),A
 RET

;===============================================================================
; SAVED CURSOR, ERASE AND SCROLL OPERATIONS
;===============================================================================
; Save cursor, attribute and G0/G1 selection state.
SAVE_CURSOR:
 XOR A
 LD (PARSER_STATE),A
 LD A,(CUR_ROW)
 LD (SAVED_ROW),A
 LD A,(CUR_COL)
 LD (SAVED_COL),A
 LD A,(CURRENT_ATTR)
 LD (SAVED_ATTR),A
 LD A,(G0_CHARSET)
 LD (SAVED_G0_CHARSET),A
 LD A,(G1_CHARSET)
 LD (SAVED_G1_CHARSET),A
 LD A,(GL_SELECT)
 LD (SAVED_GL_SELECT),A
 RET
; Restore cursor, attribute and G0/G1 selection state.
RESTORE_CURSOR:
 XOR A
 LD (PARSER_STATE),A
 LD A,(SAVED_ROW)
 LD (CUR_ROW),A
 LD A,(SAVED_COL)
 LD (CUR_COL),A
 LD A,(SAVED_ATTR)
 LD (CURRENT_ATTR),A
 LD A,(SAVED_G0_CHARSET)
 LD (G0_CHARSET),A
 LD A,(SAVED_G1_CHARSET)
 LD (G1_CHARSET),A
 LD A,(SAVED_GL_SELECT)
 LD (GL_SELECT),A
 RET
; Fill all 2,000 character cells with spaces.
CLEAR_SCREEN:
 LD HL,VIDEO_BASE
 LD DE,VIDEO_BASE+1
 LD BC,SCREEN_SIZE-1
 LD (HL),32
 LDIR
 XOR A
 LD (CUR_ROW),A
 LD (CUR_COL),A
 RET
CLEAR_WHOLE_LINE:
 LD A,(CUR_COL)
 PUSH AF
 XOR A
 LD (CUR_COL),A
 CALL CURSOR_ADDRESS
 LD B,COLS
CWL:
 LD (HL),32
 INC HL
 DJNZ CWL
 POP AF
 LD (CUR_COL),A
 RET
CLEAR_TO_LINE_END:
 CALL CURSOR_ADDRESS
 LD A,(CUR_COL)
 LD B,A
 LD A,COLS
 SUB B
 LD B,A
CTLE:
 LD (HL),32
 INC HL
 DJNZ CTLE
 RET
CLEAR_TO_LINE_START:
 CALL CURSOR_ADDRESS
 LD A,(CUR_COL)
 INC A
 LD B,A
CTLS:
 LD (HL),32
 DEC HL
 DJNZ CTLS
 RET
CLEAR_TO_SCREEN_END:
 CALL CURSOR_ADDRESS
 LD DE,VIDEO_BASE+SCREEN_SIZE
 EX DE,HL
 OR A
 SBC HL,DE
 LD B,H
 LD C,L
 EX DE,HL
 LD A,B
 OR C
 RET Z
CTSE:
 LD (HL),32
 INC HL
 DEC BC
 LD A,B
 OR C
 JP NZ,CTSE
 RET
CLEAR_TO_SCREEN_START:
 CALL CURSOR_ADDRESS
 LD DE,VIDEO_BASE
 OR A
 SBC HL,DE
 INC HL
 LD B,H
 LD C,L
 LD HL,VIDEO_BASE
CTSS:
 LD (HL),32
 INC HL
 DEC BC
 LD A,B
 OR C
 JP NZ,CTSS
 RET
; Move rows 2-25 upward and blank the new bottom row.
SCROLL_UP:
 LD HL,VIDEO_BASE+COLS
 LD DE,VIDEO_BASE
 LD BC,SCREEN_SIZE-COLS
 LDIR
 LD HL,VIDEO_BASE+SCREEN_SIZE-COLS
 LD B,COLS
SUC:
 LD (HL),32
 INC HL
 DJNZ SUC
 LD A,ROWS-1
 LD (CUR_ROW),A
 RET
; Move rows 1-24 downward and blank the new top row.
SCROLL_DOWN:
 LD HL,VIDEO_BASE+SCREEN_SIZE-COLS-1
 LD DE,VIDEO_BASE+SCREEN_SIZE-1
 LD BC,SCREEN_SIZE-COLS
 LDDR
 LD HL,VIDEO_BASE
 LD B,COLS
SDC:
 LD (HL),32
 INC HL
 DJNZ SDC
 XOR A
 LD (CUR_ROW),A
 RET

;===============================================================================
; 6845 HARDWARE CURSOR AND CP/M STRING OUTPUT
;===============================================================================
;
; The Bondwell display cursor is maintained separately from the character data.
; Registers 14 and 15 of the 6845-compatible CRTC receive the current character
; offset within the 2,000-byte screen.
;
; Program CRTC cursor registers from CUR_ROW/CUR_COL.
UPDATE_HW_CURSOR:
 PUSH AF
 PUSH BC
 PUSH DE
 PUSH HL
 LD A,(CUR_ROW)
 LD L,A
 LD H,0
 ADD HL,HL
 ADD HL,HL
 ADD HL,HL
 ADD HL,HL
 PUSH HL
 ADD HL,HL
 ADD HL,HL
 POP DE
 ADD HL,DE
 LD A,(CUR_COL)
 LD E,A
 LD D,0
 ADD HL,DE
 LD A,14
 OUT (CRTC_INDEX),A
 LD A,H
 OUT (CRTC_DATA),A
 LD A,15
 OUT (CRTC_INDEX),A
 LD A,L
 OUT (CRTC_DATA),A
 POP HL
 POP DE
 POP BC
 POP AF
 RET
; Print a '$'-terminated string using BDOS function 9.
PRINT_STRING:
 PUSH BC
 LD C,BDOS_PRINT
 CALL BDOS
 POP BC
 RET

;===============================================================================
; WORKING STORAGE AND FIXED RESPONSE STRINGS
;===============================================================================
PARSER_STATE: DB 0
PARAM1: DB 0
PARAM2: DB 0
PARAM_INDEX: DB 0
PRIVATE_FLAG: DB 0
CUR_ROW: DB 0
CUR_COL: DB 0
SAVED_ROW: DB 0
SAVED_COL: DB 0
CURRENT_ATTR: DB 0
SAVED_ATTR: DB 0
G0_CHARSET: DB 0
G1_CHARSET: DB 1
GL_SELECT: DB 0
SAVED_G0_CHARSET: DB 0
SAVED_G1_CHARSET: DB 1
SAVED_GL_SELECT: DB 0
LOCAL_ESC: DB 0
CURSOR_APP_MODE: DB 0
IDENT_RESPONSE: DB ESC,91,63,49,59,48,99,0
STATUS_OK: DB ESC,91,48,110,0

; Brief instructions displayed once when VT100B starts.
STARTUP_TEXT:
 DB 13,10,"VT100B local commands:",13,10
 DB "  Ctrl-] C        Exit to CP/M",13,10
 DB "  Ctrl-] Ctrl-]  Send ESC to the remote system",13,10
 DB "  Ctrl-] X        Send Ctrl-X to Nano",13,10,13,10,36

HELP_TEXT: DB 13,10,"[Ctrl-] C=close, Ctrl-] ?=help]",13,10
 DB "[Ctrl-] X=send Ctrl-X, Ctrl-] Ctrl-]=send ESC]",13,10,36
EXIT_TEXT: DB 13,10,"[Connection closed, back at CP/M]",13,10,36

; Local Bondwell cursor-key translation.  Ordinary Ctrl-D/E/S/X input is
; intentionally translated too, because the Bondwell BIOS presents the
; physical cursor keys using those same console character codes.

;===============================================================================
; BONDWELL CURSOR-KEY TRANSLATION
;===============================================================================
;
; The Bondwell BIOS returns CP/M/WordStar control codes for the four physical
; cursor keys. VT100B converts these to ANSI cursor sequences. In DEC private
; application-cursor mode the second byte is 'O'; otherwise it is '['.
;
; Translate Bondwell cursor codes or send an ordinary key.
ARROW_KEY_SEND:
 LD A,B
 CP 05H
 JP Z,ARROW_UP
 CP 18H
 JP Z,ARROW_DOWN
 CP 04H
 JP Z,ARROW_RIGHT
 CP 13H
 JP Z,ARROW_LEFT
 LD A,B
 JP SERIAL_SEND
ARROW_UP:
 LD C,'A'
 JP SEND_CURSOR_SEQUENCE
ARROW_DOWN:
 LD C,'B'
 JP SEND_CURSOR_SEQUENCE
ARROW_RIGHT:
 LD C,'C'
 JP SEND_CURSOR_SEQUENCE
ARROW_LEFT:
 LD C,'D'
; Emit ESC plus '[' or 'O', followed by A/B/C/D.
SEND_CURSOR_SEQUENCE:
 LD A,ESC
 CALL SERIAL_SEND
 LD A,(CURSOR_APP_MODE)
 OR A
 LD A,'['
 JP Z,SEND_CURSOR_PREFIX
 LD A,'O'
SEND_CURSOR_PREFIX:
 CALL SERIAL_SEND
 LD A,C
 JP SERIAL_SEND

; Dedicated stack storage. The stack grows downward from STACK_TOP into this
; reserved area. In earlier builds STACK_TOP immediately followed the arrow
; routines while the DS 256 block was before them, so PUSH instructions
; overwrote the cursor-key code and caused freezes when an arrow was pressed.

;===============================================================================
; PRIVATE STACK
;===============================================================================
;
; The Z80 stack grows downward from STACK_TOP into this reserved block.
; Keeping the stack separate prevents PUSH/CALL activity from overwriting code.
;
STACK_AREA:
 DS 256
STACK_TOP:
