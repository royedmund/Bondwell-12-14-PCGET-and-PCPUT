; BWT100.ASM
; Bondwell 12/14 CP/M VT100-compatible serial terminal
;
; Z80 source intended for PASMO / Z80ASM-style assemblers.
; Assemble at 0x0100 to create VT100C.COM.
;
; Confirmed from supplied BOOTROM.BIN:
;   Video RAM base = F800H
;   Video RAM size = 2 KB (F800H-FFFFH)
;
; Serial interface:
;   SIO0 data           = 0x40
;   SIO0 status/control = 0x41
;
; The status masks below assume an Intel 8251-compatible status layout:
;   bit 0 = TX ready
;   bit 1 = RX ready
; Change TX_MASK and RX_MASK if hardware testing proves otherwise.
;
; Local CONNECT escape:
;   Ctrl-] C       Return to CP/M
;   Ctrl-] ?       Display local help
;   Ctrl-] Ctrl-]  Send a literal Ctrl-] to the remote host
;
; This program is a standalone terminal.  Its serial and VT100 routines
; can also be adapted into the machine-dependent CONNECT section of
; Kermit-80.

        ORG     0x0100

BDOS: EQU 0x0005
BDOS_DIRIO: EQU 0x06
BDOS_PRINT: EQU 0x09

SIO_DATA: EQU 0x040
SIO_STAT: EQU 0x041
TX_MASK: EQU 0x004
RX_MASK: EQU 0x001

VIDEO_BASE: EQU 0x0F800
CRTC_INDEX: EQU 0x010
CRTC_DATA: EQU 0x011
COLS: EQU 80
ROWS: EQU 25
SCREEN_SIZE: EQU 2000

ESCAPE_CHAR: EQU 0x01D            ; Ctrl-]
ESC: EQU 0x01B
BEL: EQU 0x007
BS: EQU 0x008
HT: EQU 0x009
LF: EQU 0x00A
CR: EQU 0x00D
DEL: EQU 0x07F

STATE_NORMAL: EQU 0
STATE_ESC: EQU 1
STATE_CSI: EQU 2

START:
        LD      SP,STACK_TOP
        CALL    SIO_INIT
        CALL    TERM_RESET
        LD      DE,BANNER
        CALL    PRINT_STRING

MAIN_LOOP:
        CALL    SERIAL_POLL
        CALL    KEYBOARD_POLL
        CALL    UPDATE_HW_CURSOR
        JP      MAIN_LOOP

; ----------------------------------------------------------------------
; CP/M keyboard polling
; Returns Z if no key, NZ with A = character.
; ----------------------------------------------------------------------
KEY_GET:
        PUSH    BC
        PUSH    DE
        LD      C,BDOS_DIRIO
        LD      E,0x0FF
        CALL    BDOS
        POP     DE
        POP     BC
        OR      A
        RET

KEYBOARD_POLL:
        CALL    KEY_GET
        RET     Z

        LD      B,A
        LD      A,(LOCAL_ESC)
        OR      A
        JP      NZ,KEY_AFTER_ESCAPE

        LD      A,B
        CP      ESCAPE_CHAR
        JP      NZ,KEY_SEND
        LD      A,1
        LD      (LOCAL_ESC),A
        RET

KEY_AFTER_ESCAPE:
        XOR     A
        LD      (LOCAL_ESC),A
        LD      A,B
        AND     0x05F                    ; upper case
        CP      67
        JP      Z,EXIT_TO_CPM
        CP      63
        JP      Z,SHOW_HELP

        LD      A,B
        CP      ESCAPE_CHAR
        RET     NZ
        ; Double escape sends literal Ctrl-]
        LD      A,ESCAPE_CHAR
        JP      SERIAL_SEND

KEY_SEND:
        LD      A,B
        JP      SERIAL_SEND

SHOW_HELP:
        LD      DE,HELP_TEXT
        JP      PRINT_STRING

EXIT_TO_CPM:
        LD      DE,EXIT_TEXT
        CALL    PRINT_STRING
        JP      0x0000

; ----------------------------------------------------------------------
; Initialise Bondwell SIO0 exactly as the working Kaypro-derived Kermit.
; This resets the Z80 SIO register pointer and selects 8-bit asynchronous
; receive/transmit operation before any status polling occurs.
; ----------------------------------------------------------------------
SIO_INIT:
        LD      HL,SIO_INIT_TABLE
        LD      B,SIO_INIT_LEN
SIO_INIT_LOOP:
        LD      A,(HL)
        OUT     (SIO_STAT),A
        INC     HL
        DJNZ    SIO_INIT_LOOP
        RET

SIO_INIT_TABLE:
        DB      0x18,0x18              ; channel reset twice
        DB      0x04,0x44              ; WR4: x16 clock, 1 stop, no parity
        DB      0x01,0x00              ; WR1: no interrupts
        DB      0x03,0x0C1             ; WR3: receiver enabled, 8 bits
        DB      0x05,0x0EA             ; WR5: transmitter enabled, 8 bits, RTS/DTR
SIO_INIT_LEN: EQU $-SIO_INIT_TABLE

; ----------------------------------------------------------------------
; Serial I/O
; ----------------------------------------------------------------------
SERIAL_POLL:
        IN      A,(SIO_STAT)
        AND     RX_MASK
        RET     Z
        IN      A,(SIO_DATA)
        JP      VT_INPUT

SERIAL_SEND:
        PUSH    AF
SERIAL_WAIT_TX:
        IN      A,(SIO_STAT)
        AND     TX_MASK
        JP      Z,SERIAL_WAIT_TX
        POP     AF
        OUT     (SIO_DATA),A
        RET

; ----------------------------------------------------------------------
; VT100 parser
; ----------------------------------------------------------------------
VT_INPUT:
        PUSH    AF
        LD      A,(PARSER_STATE)
        OR      A
        JP      Z,VT_NORMAL_DISPATCH
        CP      STATE_ESC
        JP      Z,VT_ESC_DISPATCH
        POP     AF
        JP      VT_CSI

VT_NORMAL_DISPATCH:
        POP     AF
VT_NORMAL:
        CP      ESC
        JP      Z,VT_BEGIN_ESC
        CP      BEL
        JP      Z,VT_BELL
        CP      BS
        JP      Z,CURSOR_LEFT
        CP      HT
        JP      Z,TAB_FORWARD
        CP      LF
        JP      Z,LINE_FEED
        CP      CR
        JP      Z,CARRIAGE_RETURN
        CP      0x020
        RET     C
        CP      DEL
        RET     Z
        JP      PUT_CHAR

VT_BEGIN_ESC:
        LD      A,STATE_ESC
        LD      (PARSER_STATE),A
        RET

VT_BELL:
        LD      C,BDOS_DIRIO
        LD      E,BEL
        JP      BDOS

VT_ESC_DISPATCH:
        POP     AF
VT_ESC:
        CP      91
        JP      Z,VT_BEGIN_CSI
        CP      55
        JP      Z,SAVE_CURSOR
        CP      56
        JP      Z,RESTORE_CURSOR
        CP      68
        JP      Z,ESC_INDEX
        CP      77
        JP      Z,REVERSE_INDEX
        CP      69
        JP      Z,ESC_NEXT_LINE
        CP      99
        JP      Z,TERM_RESET
        XOR     A
        LD      (PARSER_STATE),A
        RET

VT_BEGIN_CSI:
        LD      A,STATE_CSI
        LD      (PARSER_STATE),A
        XOR     A
        LD      (PARAM1),A
        LD      (PARAM2),A
        LD      (PARAM_INDEX),A
        LD      (PRIVATE_FLAG),A
        RET

VT_CSI:
        CP      63
        JP      NZ,CSI_NOT_PRIVATE
        LD      A,1
        LD      (PRIVATE_FLAG),A
        RET

CSI_NOT_PRIVATE:
        CP      48
        JP      C,CSI_NOT_DIGIT
        CP      57+1
        JP      NC,CSI_NOT_DIGIT
        SUB     48
        LD      B,A
        LD      A,(PARAM_INDEX)
        OR      A
        JP      NZ,CSI_DIGIT_PARAM2

        LD      A,(PARAM1)
        CALL    MUL10_ADD_B
        LD      (PARAM1),A
        RET

CSI_DIGIT_PARAM2:
        LD      A,(PARAM2)
        CALL    MUL10_ADD_B
        LD      (PARAM2),A
        RET

CSI_NOT_DIGIT:
        CP      59
        JP      NZ,CSI_COMMAND
        LD      A,1
        LD      (PARAM_INDEX),A
        RET

CSI_COMMAND:
        PUSH    AF
        XOR     A
        LD      (PARSER_STATE),A
        POP     AF

        CP      65
        JP      Z,CSI_CURSOR_UP
        CP      66
        JP      Z,CSI_CURSOR_DOWN
        CP      67
        JP      Z,CSI_CURSOR_RIGHT
        CP      68
        JP      Z,CSI_CURSOR_LEFT
        CP      72
        JP      Z,CSI_CURSOR_POSITION
        CP      102
        JP      Z,CSI_CURSOR_POSITION
        CP      74
        JP      Z,CSI_ERASE_DISPLAY
        CP      75
        JP      Z,CSI_ERASE_LINE
        CP      109
        RET     Z                       ; attributes ignored safely
        CP      115
        JP      Z,SAVE_CURSOR
        CP      117
        JP      Z,RESTORE_CURSOR
        CP      110
        JP      Z,CSI_DEVICE_STATUS
        CP      99
        JP      Z,CSI_IDENTIFY
        CP      104
        RET     Z                       ; private modes ignored
        CP      108
        RET     Z
        RET

MUL10_ADD_B:
        ; A = A*10 + B
        LD      C,A
        ADD     A,A
        ADD     A,A
        ADD     A,C
        ADD     A,A
        ADD     A,B
        RET

PARAM1_DEFAULT1:
        LD      A,(PARAM1)
        OR      A
        RET     NZ
        INC     A
        RET

CSI_CURSOR_UP:
        CALL    PARAM1_DEFAULT1
        LD      B,A
CU_LOOP:
        CALL    CURSOR_UP
        DJNZ    CU_LOOP
        RET

CSI_CURSOR_DOWN:
        CALL    PARAM1_DEFAULT1
        LD      B,A
CD_LOOP:
        CALL    CURSOR_DOWN
        DJNZ    CD_LOOP
        RET

CSI_CURSOR_RIGHT:
        CALL    PARAM1_DEFAULT1
        LD      B,A
CR_LOOP:
        CALL    CURSOR_RIGHT
        DJNZ    CR_LOOP
        RET

CSI_CURSOR_LEFT:
        CALL    PARAM1_DEFAULT1
        LD      B,A
CL_LOOP:
        CALL    CURSOR_LEFT
        DJNZ    CL_LOOP
        RET

CSI_CURSOR_POSITION:
        LD      A,(PARAM1)
        OR      A
        JP      NZ,CP_ROW_OK
        INC     A
CP_ROW_OK:
        DEC     A
        CP      ROWS
        JP      C,CP_ROW_RANGE
        LD      A,ROWS-1
CP_ROW_RANGE:
        LD      (CUR_ROW),A

        LD      A,(PARAM2)
        OR      A
        JP      NZ,CP_COL_OK
        INC     A
CP_COL_OK:
        DEC     A
        CP      COLS
        JP      C,CP_COL_RANGE
        LD      A,COLS-1
CP_COL_RANGE:
        LD      (CUR_COL),A
        RET

CSI_ERASE_DISPLAY:
        LD      A,(PARAM1)
        CP      2
        JP      Z,CLEAR_SCREEN
        OR      A
        JP      Z,CLEAR_TO_SCREEN_END
        CP      1
        JP      Z,CLEAR_TO_SCREEN_START
        RET

CSI_ERASE_LINE:
        LD      A,(PARAM1)
        CP      2
        JP      Z,CLEAR_WHOLE_LINE
        OR      A
        JP      Z,CLEAR_TO_LINE_END
        CP      1
        JP      Z,CLEAR_TO_LINE_START
        RET

CSI_DEVICE_STATUS:
        LD      A,(PARAM1)
        CP      6
        RET     NZ
        ; Return ESC[row;colR
        LD      A,ESC
        CALL    SERIAL_SEND
        LD      A,91
        CALL    SERIAL_SEND
        LD      A,(CUR_ROW)
        INC     A
        CALL    SEND_DECIMAL
        LD      A,59
        CALL    SERIAL_SEND
        LD      A,(CUR_COL)
        INC     A
        CALL    SEND_DECIMAL
        LD      A,82
        JP      SERIAL_SEND

CSI_IDENTIFY:
        ; VT100 "what are you" response: ESC[?1;0c
        LD      HL,IDENT_RESPONSE
SEND_ZERO_STRING:
        LD      A,(HL)
        OR      A
        RET     Z
        INC     HL
        CALL    SERIAL_SEND
        JP      SEND_ZERO_STRING

SEND_DECIMAL:
        ; Send unsigned A as 1-3 decimal digits
        LD      B,0
SD_100:
        CP      100
        JP      C,SD_10
        SUB     100
        INC     B
        JP      SD_100
SD_10:
        LD      C,0
SD_10_LOOP:
        CP      10
        JP      C,SD_OUT
        SUB     10
        INC     C
        JP      SD_10_LOOP
SD_OUT:
        LD      D,A
        LD      A,B
        OR      A
        JP      Z,SD_SKIP100
        ADD     A,48
        CALL    SERIAL_SEND
SD_SKIP100:
        LD      A,C
        OR      A
        JP      NZ,SD_SEND10
        LD      A,B
        OR      A
        JP      Z,SD_SKIP10
        XOR     A
SD_SEND10:
        ADD     A,48
        CALL    SERIAL_SEND
SD_SKIP10:
        LD      A,D
        ADD     A,48
        JP      SERIAL_SEND

; ----------------------------------------------------------------------
; Screen engine: direct 80x25 text output at F800H
; ----------------------------------------------------------------------
TERM_RESET:
        XOR     A
        LD      (PARSER_STATE),A
        LD      (LOCAL_ESC),A
        LD      (CUR_ROW),A
        LD      (CUR_COL),A
        LD      (SAVED_ROW),A
        LD      (SAVED_COL),A
        JP      CLEAR_SCREEN

PUT_CHAR:
        PUSH    AF
        CALL    CURSOR_ADDRESS
        POP     AF
        LD      (HL),A
        JP      CURSOR_RIGHT_WRAP

CURSOR_ADDRESS:
        LD      A,(CUR_ROW)
        LD      L,A
        LD      H,0
        ; HL = row*80 = row*64 + row*16
        ADD     HL,HL                   ; *2
        ADD     HL,HL                   ; *4
        ADD     HL,HL                   ; *8
        ADD     HL,HL                   ; *16
        PUSH    HL
        ADD     HL,HL                   ; *32
        ADD     HL,HL                   ; *64
        POP     DE
        ADD     HL,DE                   ; *80
        LD      A,(CUR_COL)
        LD      E,A
        LD      D,0
        ADD     HL,DE
        LD      DE,VIDEO_BASE
        ADD     HL,DE
        RET

CURSOR_RIGHT:
        LD      A,(CUR_COL)
        CP      COLS-1
        RET     NC
        INC     A
        LD      (CUR_COL),A
        RET

CURSOR_RIGHT_WRAP:
        LD      A,(CUR_COL)
        INC     A
        CP      COLS
        JP      C,CRW_STORE
        XOR     A
        LD      (CUR_COL),A
        JP      LINE_FEED
CRW_STORE:
        LD      (CUR_COL),A
        RET

CURSOR_LEFT:
        LD      A,(CUR_COL)
        OR      A
        RET     Z
        DEC     A
        LD      (CUR_COL),A
        RET

CURSOR_UP:
        LD      A,(CUR_ROW)
        OR      A
        RET     Z
        DEC     A
        LD      (CUR_ROW),A
        RET

CURSOR_DOWN:
        LD      A,(CUR_ROW)
        CP      ROWS-1
        RET     NC
        INC     A
        LD      (CUR_ROW),A
        RET

CARRIAGE_RETURN:
        XOR     A
        LD      (CUR_COL),A
        RET

LINE_FEED:
        LD      A,(CUR_ROW)
        CP      ROWS-1
        JP      Z,SCROLL_UP
        INC     A
        LD      (CUR_ROW),A
        RET

ESC_INDEX:
        XOR     A
        LD      (PARSER_STATE),A
        JP      LINE_FEED

ESC_NEXT_LINE:
        XOR     A
        LD      (PARSER_STATE),A
        CALL    CARRIAGE_RETURN
        JP      LINE_FEED

REVERSE_INDEX:
        XOR     A
        LD      (PARSER_STATE),A
        LD      A,(CUR_ROW)
        OR      A
        JP      NZ,CURSOR_UP
        JP      SCROLL_DOWN

TAB_FORWARD:
        LD      A,(CUR_COL)
        ADD     A,8
        AND     0x0F8
        CP      COLS
        JP      C,TAB_STORE
        LD      A,COLS-1
TAB_STORE:
        LD      (CUR_COL),A
        RET

SAVE_CURSOR:
        XOR     A
        LD      (PARSER_STATE),A
        LD      A,(CUR_ROW)
        LD      (SAVED_ROW),A
        LD      A,(CUR_COL)
        LD      (SAVED_COL),A
        RET

RESTORE_CURSOR:
        XOR     A
        LD      (PARSER_STATE),A
        LD      A,(SAVED_ROW)
        LD      (CUR_ROW),A
        LD      A,(SAVED_COL)
        LD      (CUR_COL),A
        RET

CLEAR_SCREEN:
        LD      HL,VIDEO_BASE
        LD      DE,VIDEO_BASE+1
        LD      BC,SCREEN_SIZE-1
        LD      (HL),32
        LDIR
        XOR     A
        LD      (CUR_ROW),A
        LD      (CUR_COL),A
        RET

CLEAR_WHOLE_LINE:
        LD      A,(CUR_COL)
        PUSH    AF
        XOR     A
        LD      (CUR_COL),A
        CALL    CURSOR_ADDRESS
        LD      B,COLS
CWL_LOOP:
        LD      (HL),32
        INC     HL
        DJNZ    CWL_LOOP
        POP     AF
        LD      (CUR_COL),A
        RET

CLEAR_TO_LINE_END:
        CALL    CURSOR_ADDRESS
        LD      A,(CUR_COL)
        LD      B,A
        LD      A,COLS
        SUB     B
        LD      B,A
CTLE_LOOP:
        LD      (HL),32
        INC     HL
        DJNZ    CTLE_LOOP
        RET

CLEAR_TO_LINE_START:
        CALL    CURSOR_ADDRESS
        LD      A,(CUR_COL)
        INC     A
        LD      B,A
CTLS_LOOP:
        LD      (HL),32
        DEC     HL
        DJNZ    CTLS_LOOP
        RET

CLEAR_TO_SCREEN_END:
        CALL    CURSOR_ADDRESS
        LD      DE,VIDEO_BASE+SCREEN_SIZE
        EX      DE,HL
        OR      A
        SBC     HL,DE
        LD      B,H
        LD      C,L
        EX      DE,HL
        LD      A,B
        OR      C
        RET     Z
CTSE_LOOP:
        LD      (HL),32
        INC     HL
        DEC     BC
        LD      A,B
        OR      C
        JP      NZ,CTSE_LOOP
        RET

CLEAR_TO_SCREEN_START:
        CALL    CURSOR_ADDRESS
        LD      DE,VIDEO_BASE
        OR      A
        SBC     HL,DE
        INC     HL
        LD      B,H
        LD      C,L
        LD      HL,VIDEO_BASE
CTSS_LOOP:
        LD      (HL),32
        INC     HL
        DEC     BC
        LD      A,B
        OR      C
        JP      NZ,CTSS_LOOP
        RET

SCROLL_UP:
        LD      HL,VIDEO_BASE+COLS
        LD      DE,VIDEO_BASE
        LD      BC,SCREEN_SIZE-COLS
        LDIR
        LD      HL,VIDEO_BASE+SCREEN_SIZE-COLS
        LD      B,COLS
SU_CLEAR:
        LD      (HL),32
        INC     HL
        DJNZ    SU_CLEAR
        LD      A,ROWS-1
        LD      (CUR_ROW),A
        RET

SCROLL_DOWN:
        ; Copy bottom-up to avoid overlap
        LD      HL,VIDEO_BASE+SCREEN_SIZE-COLS-1
        LD      DE,VIDEO_BASE+SCREEN_SIZE-1
        LD      BC,SCREEN_SIZE-COLS
        LDDR
        LD      HL,VIDEO_BASE
        LD      B,COLS
SD_CLEAR:
        LD      (HL),32
        INC     HL
        DJNZ    SD_CLEAR
        XOR     A
        LD      (CUR_ROW),A
        RET

; ----------------------------------------------------------------------
; Bondwell hardware cursor
; The CRT controller uses index port 10H and data port 11H.
; Registers 14 and 15 hold the cursor character address.
; ----------------------------------------------------------------------
UPDATE_HW_CURSOR:
        PUSH    AF
        PUSH    BC
        PUSH    DE
        PUSH    HL

        LD      A,(CUR_ROW)
        LD      L,A
        LD      H,0
        ADD     HL,HL                   ; row * 2
        ADD     HL,HL                   ; row * 4
        ADD     HL,HL                   ; row * 8
        ADD     HL,HL                   ; row * 16
        PUSH    HL
        ADD     HL,HL                   ; row * 32
        ADD     HL,HL                   ; row * 64
        POP     DE
        ADD     HL,DE                   ; row * 80

        LD      A,(CUR_COL)
        LD      E,A
        LD      D,0
        ADD     HL,DE                   ; row * 80 + column

        LD      A,14
        OUT     (CRTC_INDEX),A
        LD      A,H
        OUT     (CRTC_DATA),A
        LD      A,15
        OUT     (CRTC_INDEX),A
        LD      A,L
        OUT     (CRTC_DATA),A

        POP     HL
        POP     DE
        POP     BC
        POP     AF
        RET

; ----------------------------------------------------------------------
; CP/M utility
; ----------------------------------------------------------------------
PRINT_STRING:
        PUSH    BC
        LD      C,BDOS_PRINT
        CALL    BDOS
        POP     BC
        RET

; ----------------------------------------------------------------------
; State
; ----------------------------------------------------------------------
PARSER_STATE:   DB      0
PARAM1:         DB      0
PARAM2:         DB      0
PARAM_INDEX:    DB      0
PRIVATE_FLAG:   DB      0
CUR_ROW:        DB      0
CUR_COL:        DB      0
SAVED_ROW:      DB      0
SAVED_COL:      DB      0
LOCAL_ESC:      DB      0

IDENT_RESPONSE:
        DB      ESC,91,63,49,59,48,99,0

BANNER:
        DB      13,10
        DB      66,111,110,100,119,101,108,108,32,49,50,47,49,52,32,86,84,49,48,48,32,116,101,114,109,105,110,97,108,13,10
        DB      83,73,79,48,32,48,120,52,48,47,48,120,52,49,46,32,32,67,116,114,108,45,93,32,67,32,101,120,105,116,115,46,13,10,36

HELP_TEXT:
        DB      13,10
        DB      91,76,111,99,97,108,32,99,111,109,109,97,110,100,115,58,32,67,61,99,108,111,115,101,44,32,63,61,104,101,108,112,44,32,67,116,114,108,45,93,61,115,101,110,100,32,101,115,99,97,112,101,93,13,10,36

EXIT_TEXT:
        DB      13,10,91,67,111,110,110,101,99,116,105,111,110,32,99,108,111,115,101,100,44,32,98,97,99,107,32,97,116,32,67,80,47,77,93,13,10,36

        DS      256
STACK_TOP:
