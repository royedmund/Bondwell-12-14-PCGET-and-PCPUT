;-----------------------------------------------------------------------------
; PCPUT-BW 1.2 - XMODEM sender for Bondwell 12 / 14 CP/M
;
; Serial ports (Bondwell Z80 SIO/ASIO):
;   COM1 / Port A: data 40H, control/status 41H
;   COM2 / Port B: data 42H, control/status 43H
;   RR0 bit 0 = receive character available
;   RR0 bit 2 = transmit buffer empty
;
; Usage:
;   PCPUT filename.ext        ; COM1 / Port A
;   PCPUT filename.ext A      ; COM1 / Port A
;   PCPUT filename.ext 1      ; COM1 / Port A
;   PCPUT filename.ext B      ; COM2 / Port B
;   PCPUT filename.ext 2      ; COM2 / Port B
;
; Protocol: XMODEM-128, checksum or CRC-16/XMODEM. The PC receiver chooses
; checksum by sending NAK (15H) or CRC mode by sending ASCII 'C'.
;
; This version deliberately does NOT use self-modifying IN/OUT operands.
; Separate Port-A and Port-B paths make the selected Bondwell hardware port
; explicit and easy to audit.
;-----------------------------------------------------------------------------

SIOADR  EQU     040H
SIOACR  EQU     041H
SIOBDR  EQU     042H
SIOBCR  EQU     043H

XMTMASK EQU     04H
XMTRDY  EQU     04H
RCVMASK EQU     01H
RCVRDY  EQU     01H

SOH     EQU     01H
EOT     EQU     04H
ACK     EQU     06H
NAK     EQU     15H
CAN     EQU     18H
CTRLC   EQU     03H
CR      EQU     13
LF      EQU     10

ERRLMT  EQU     10

RDCON   EQU     1
WRCON   EQU     2
PRINT   EQU     9
CONST   EQU     11
OPEN    EQU     15
CLOSE   EQU     16
READ    EQU     20
STDMA   EQU     26
BDOS    EQU     5
FCB     EQU     05CH
PARAM1  EQU     05DH
PARAM2  EQU     06DH

        ORG     0100H

START:
        LDA     PARAM1
        CPI     20H
        JNZ     HAVEFN
        LXI     D,MHELP
        MVI     C,PRINT
        CALL    BDOS
        RET

HAVEFN:
        LXI     H,0
        DAD     SP
        SHLD    CPMSTACK
        LXI     SP,STACKTOP

; Default COM1 / Port A.
        XRA     A
        STA     PORTB

; Optional second parameter: B or 2 selects COM2 / Port B.
        LDA     PARAM2
        ANI     5FH
        CPI     'B'
        JZ      SELB
        CPI     '2'
        JZ      SELB
        JMP     PORTSEL_DONE

SELB:
        MVI     A,1
        STA     PORTB

PORTSEL_DONE:
        CALL    INITSIO
        XRA     A
        STA     SECTNO
        STA     RETRYCT
        STA     CRCFLAG

        CALL    OPENFILE

        LDA     PORTB
        ORA     A
        JNZ     PROMPTB
        LXI     D,MRVCA
        JMP     PROMPT
PROMPTB:
        LXI     D,MRVCB
PROMPT:
        MVI     C,PRINT
        CALL    BDOS

; Wait directly for receiver startup: NAK -> checksum, 'C' -> CRC mode.
; Unlike the older adaptation, do not require a one-second quiet-line purge here.
; Modern XMODEM receivers can send 'C' or NAK repeatedly; purging until the line
; is quiet can consume those startup characters and prevent the sender starting.
        XRA     A
        STA     CRCFLAG
WAITSTART:
        MVI     B,1
        CALL    RECV
        JC      WAITSTART
        CPI     CTRLC
        JZ      ABORT
        CPI     CAN
        JZ      ABORT
        CPI     NAK
        JZ      SENDBLOCK
        CPI     'C'
        JNZ     WAITSTART
        STA     CRCFLAG

; Read next CP/M 128-byte record. On EOF READSECTOR completes the transfer.
SENDBLOCK:
        CALL    READSECTOR
        LDA     SECTNO
        INR     A
        STA     SECTNO
        XRA     A
        STA     RETRYCT

REPEATBLOCK:
        MVI     A,SOH
        CALL    SEND
        LDA     SECTNO
        CALL    SEND
        LDA     SECTNO
        CMA
        CALL    SEND

        LXI     H,0
        SHLD    CRC16
        MOV     C,H
        LXI     H,080H

SENDDATA:
        MOV     A,M
        CALL    SEND
        CALL    CALCRC
        INX     H
        MOV     A,H
        CPI     1
        JNZ     SENDDATA

; Trailer: checksum byte or CRC high then low.
        LDA     CRCFLAG
        ORA     A
        JZ      SENDSUM
        LDA     CRC16+1
        CALL    SEND
        LDA     CRC16
        CALL    SEND
        JMP     WAITACK
SENDSUM:
        MOV     A,C
        CALL    SEND

WAITACK:
        MVI     B,4
        CALL    RECV
        JC      BLOCKERR
        CPI     ACK
        JZ      SENDBLOCK
        CPI     CTRLC
        JZ      ABORT
        CPI     CAN
        JZ      ABORT

BLOCKERR:
        LDA     RETRYCT
        INR     A
        STA     RETRYCT
        CPI     ERRLMT
        JC      REPEATBLOCK
        CALL    ERXIT
        DB      CR,LF,'Too many retries - transfer aborted.',CR,LF,'$'

;-----------------------------------------------------------------------------
; Open CP/M file.
;-----------------------------------------------------------------------------
OPENFILE:
        LXI     D,FCB
        MVI     C,OPEN
        CALL    BDOS
        INR     A
        RNZ
        CALL    ERXIT
        DB      CR,LF,'Cannot open file.',CR,LF,'$'

;-----------------------------------------------------------------------------
; RECV - receive one serial byte, B = timeout seconds.
; Carry set on timeout. A is byte on success.
;-----------------------------------------------------------------------------
RECV:
        PUSH    D
RXSEC:
; 206 x 65536 inner decrements is approximately one second at ~4 MHz with
; the additional SIO status tests in this implementation.
        LXI     D,0CE00H
RXLOOP:
        LDA     PORTB
        ORA     A
        JNZ     RXB

RXA:
        IN      SIOACR
        ANI     RCVMASK
        CPI     RCVRDY
        JZ      RXCHARA
        JMP     RXCOUNT

RXB:
        IN      SIOBCR
        ANI     RCVMASK
        CPI     RCVRDY
        JZ      RXCHARB

; When transfer uses COM2/B, allow Ctrl-C from COM1/A as in the working PCGET.
        IN      SIOACR
        ANI     RCVMASK
        CPI     RCVRDY
        JNZ     RXCOUNT
        IN      SIOADR
        CPI     CTRLC
        JNZ     RXCOUNT
        POP     D
        ORA     A
        RET

RXCOUNT:
        DCR     E
        JNZ     RXLOOP
        DCR     D
        JNZ     RXLOOP
        DCR     B
        JNZ     RXSEC
        POP     D
        STC
        RET

RXCHARA:
        IN      SIOADR
        JMP     RXGOT
RXCHARB:
        IN      SIOBDR
RXGOT:
        POP     D
; Preserve A, but maintain the original PCGET/PCPUT checksum convention in C.
        PUSH    PSW
        ADD     C
        MOV     C,A
        POP     PSW
        ORA     A
        RET

;-----------------------------------------------------------------------------
; SEND - transmit A through selected Bondwell serial port.
; Waits on RR0 bit 2 (TX buffer empty), exactly as the working PCGET does.
;-----------------------------------------------------------------------------
SEND:
        PUSH    PSW
        ADD     C
        MOV     C,A
        LDA     PORTB
        ORA     A
        JNZ     SENDWAITB

SENDWAITA:
        IN      SIOACR
        ANI     XMTMASK
        CPI     XMTRDY
        JNZ     SENDWAITA
        POP     PSW
        OUT     SIOADR
        RET

SENDWAITB:
        IN      SIOBCR
        ANI     XMTMASK
        CPI     XMTRDY
        JNZ     SENDWAITB
        POP     PSW
        OUT     SIOBDR
        RET

;-----------------------------------------------------------------------------
; READSECTOR - CP/M sequential 128-byte record read to default DMA 0080H.
;-----------------------------------------------------------------------------
READSECTOR:
        LXI     D,FCB
        MVI     C,READ
        CALL    BDOS
        ORA     A
        RZ
        DCR     A
        JNZ     READERR

; EOF: perform standard XMODEM EOT handshake. Some receivers NAK first EOT;
; repeating EOT handles both one-EOT and two-EOT receiver behaviour.
        XRA     A
        STA     RETRYCT
EOTSEND:
        MVI     A,EOT
        CALL    SEND
        MVI     B,3
        CALL    RECV
        JC      EOTERR
        CPI     ACK
        JZ      COMPLETE
        CPI     CTRLC
        JZ      ABORT
        CPI     CAN
        JZ      ABORT
EOTERR:
        LDA     RETRYCT
        INR     A
        STA     RETRYCT
        CPI     ERRLMT
        JC      EOTSEND
        CALL    ERXIT
        DB      CR,LF,'No ACK for EOT.',CR,LF,'$'

READERR:
        CALL    ERXIT
        DB      CR,LF,'File read error.',CR,LF,'$'

COMPLETE:
        CALL    ERXIT
        DB      CR,LF,'Transfer complete.',CR,LF,'$'

ABORT:
        CALL    ERXIT
        DB      CR,LF,'Transfer aborted.',CR,LF,'$'

;-----------------------------------------------------------------------------
; CALCRC - CRC-16/XMODEM polynomial 1021H, initial value 0000H.
;-----------------------------------------------------------------------------
CALCRC:
        PUSH    B
        PUSH    H
        LHLD    CRC16
        XRA     H
        MOV     H,A
        LXI     B,1021H
        MVI     D,8
CRCROT:
        DAD     H
        JNC     CRCCLR
        MOV     A,H
        XRA     B
        MOV     H,A
        MOV     A,L
        XRA     C
        MOV     L,A
CRCCLR:
        DCR     D
        JNZ     CRCROT
        SHLD    CRC16
        POP     H
        POP     B
        RET

;-----------------------------------------------------------------------------
; INITSIO - configure only the selected Bondwell SIO channel.
; This is the same sequence used by the working Bondwell PCGET build:
; channel reset; WR4 x16, 1 stop, no parity; WR1 no interrupts;
; WR3 8-bit receiver enabled; WR5 8-bit transmitter, DTR/RTS enabled.
;-----------------------------------------------------------------------------
INITSIO:
        LXI     H,0
INITDELAY:
        DCR     L
        JNZ     INITDELAY
        DCR     H
        JNZ     INITDELAY

        LDA     PORTB
        ORA     A
        JNZ     INITB

INITA:
        MVI     A,18H
        OUT     SIOACR
        MVI     A,4
        OUT     SIOACR
        MVI     A,44H
        OUT     SIOACR
        MVI     A,1
        OUT     SIOACR
        XRA     A
        OUT     SIOACR
        MVI     A,3
        OUT     SIOACR
        MVI     A,0C1H
        OUT     SIOACR
        MVI     A,5
        OUT     SIOACR
        MVI     A,0EAH
        OUT     SIOACR
        RET

INITB:
        MVI     A,18H
        OUT     SIOBCR
        MVI     A,4
        OUT     SIOBCR
        MVI     A,44H
        OUT     SIOBCR
        MVI     A,1
        OUT     SIOBCR
        XRA     A
        OUT     SIOBCR
        MVI     A,3
        OUT     SIOBCR
        MVI     A,0C1H
        OUT     SIOBCR
        MVI     A,5
        OUT     SIOBCR
        MVI     A,0EAH
        OUT     SIOBCR
        RET

;-----------------------------------------------------------------------------
; ERXIT - inline $-terminated message follows CALL ERXIT.
; Restore CP/M stack and return to CCP after message.
;-----------------------------------------------------------------------------
ERXIT:
        POP     D
        MVI     C,PRINT
        CALL    BDOS
        LHLD    CPMSTACK
        SPHL
        RET

MRVCA:
        DB      CR,LF,'PCPUT-BW: COM1 / Port A 40H/41H',CR,LF
        DB      'Start XMODEM receive on the PC now.',CR,LF,'$'
MRVCB:
        DB      CR,LF,'PCPUT-BW: COM2 / Port B 42H/43H',CR,LF
        DB      'Start XMODEM receive on the PC now.',CR,LF,'$'
MHELP:
        DB      CR,LF,'PCPUT-BW 1.2 for Bondwell 12/14',CR,LF
        DB      'Usage: PCPUT file.ext [A|B|1|2]',CR,LF
        DB      ' A or 1 = COM1 / Port A, data 40H status 41H',CR,LF
        DB      ' B or 2 = COM2 / Port B, data 42H status 43H',CR,LF
        DB      ' Default = COM1 / Port A',CR,LF,'$'

; Private stack grows down into STACKAREA.
STACKAREA:
        DS      96
STACKTOP:
CPMSTACK:
        DS      2
SECTNO:
        DS      1
RETRYCT:
        DS      1
CRCFLAG:
        DS      1
CRC16:
        DS      2
PORTB:
        DS      1

        END
