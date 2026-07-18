;
;  Bondwell 12/14 Version. Assumes 4MHz Z80 CPU
;
;  PCGET - This CP/M program receives a file from a PC via a serial 
;  port and writes it to a file on the CP/M system. The file transfer uses
;  the XMODEM protocol. 
;
;  Note this program is gutted from the Ward Christenson Modem program.
;
;  Adapted from Mike Douglas' Kaypro 10 version for the Bondwell 12/14
;
;	Ver	Date	   Desc
;   	---    --------    -----------------------------------------------
;	1.0    18/07/26	   Bondwell 12/14 SIO0/SIO1 version
;
;  Serial Port Equates
;
;  Bondwell 12/14 serial I/O map:
;       Port A: data 40H, status/control 41H
;       Port B: data 42H, status/control 43H

SIOADR	EQU	040H		;Port A data register
SIOACR	EQU	041H		;Port A status/control register
SIOBDR	EQU	042H		;Port B data register
SIOBCR	EQU	043H		;Port B status/control register

XMTMASK	EQU	4		;RR0 bit 2: transmit buffer empty
XMTRDY	EQU	4		;VALUE WHEN READY
RCVMASK	EQU	1		;RR0 bit 0: receive character available
RCVRDY	EQU	1		;VALUE WHEN READY

;  Transfer related equates

SOH	EQU	1
EOT	EQU	4
ACK	EQU	6
NAK	EQU	15H
CTRLC	EQU	3		;Control-C
LF	EQU	10
CR	EQU	13

	ORG	100H

;  Verify a file name was specified

	lda	PARAM1		;A=1st character of parameter 1
	cpi	' '		;make sure file name present
	jnz	haveFn		;yes, have a file name
	lxi	d,mHelp		;display usage message
	mvi	c,print
	call	bdos
	ret			;return to CPM

;  Switch to local stack. See if modem serial port "M" specified

haveFn	LXI	H,0		;save CP/M stack, switch to local stack
	DAD	SP		;HL=STACK FROM CP/M
	SHLD	STACK		;..SAVE IT
	LXI	SP,STACK	;SP=MY STACK
	mvi	b,SIOADR		;default to Bondwell Port A
	lxi	d,mSendA	;d->Port A prompt
	xra	a
	sta	fPortB		;Port A selected
	lda	PARAM2		;A=1st character of parameter 2
	ani	5fh		;force upper case
	cpi	'B'		;Port B specified?
	jnz	doXfer		;no, use Port A
	mvi	b,SIOBDR		;use Bondwell Port B
	lxi	d,mSendB	;d->Port B prompt
	mvi	a,1
	sta	fPortB		;remember Port B for Ctrl-C polling
	
;  doXfer - Initialize then do the transfer

doXfer	mov	a,b		;a=address of serial port to use
	sta	rcvSDR		;modify IN instruction for data register
	sta	sndSDR		;modify OUT instruction for data register
	inr	a		;a=serial port status/control address
	sta	rcvSCR		;modify IN for control register in RECV
	sta	sndSCR		;modify IN for control register in SEND
	sta	iniSCR		;modify OUT for control register in init
	call	initSio		;initialize SIO
	xra	a
	sta	SECTNO		;init sector number to zero
	MVI	C,PRINT		;print the send message
	CALL	BDOS		;PRINT ID MESSAGE

;  GOBBLE UP GARBAGE CHARS FROM THE LINE

purge	MVI	B,1		;times out after 1 second if no data
	CALL	RECV
	jc	RECEIVE$FILE	;line is clear, go receive the file
	cpi	ctrlc		;exit if abort requested
	jz	abort
	jmp	purge
;
;**************RECEIVE FILE****************
;
RECEIVE$FILE:
	CALL	ERASE$OLD$FILE
	CALL	MAKE$NEW$FILE
	MVI	A,NAK
	CALL	SEND		;SEND NAK

RECV$LOOP:
RECV$HDR:
	MVI	B,3		;3 SEC TIMEOUT
	CALL	RECV
	JNC	RHNTO		;NO TIMEOUT

RECV$HDR$TIMEOUT:
RECV$SECT$ERR:			;PURGE THE LINE OF INPUT CHARS
	MVI	B,1		;1 SEC W/NO CHARS
	CALL	RECV
	JNC	RECV$SECT$ERR 	;LOOP UNTIL SENDER DONE
	MVI	A,NAK
	CALL	SEND		;SEND NAK
	JMP	RECV$HDR

;GOT CHAR - MUST BE SOH OR CTRL-C TO ABORT

RHNTO:	CPI	SOH
	JZ	GOT$SOH
	cpi	ctrlc		;control-c to abort?
	jz	abort
	CPI	EOT
	JZ	GOT$EOT
	JMP	RECV$SECT$ERR

GOT$SOH:
	MVI	B,1
	CALL	RECV
	JC	RECV$HDR$TIMEOUT
	MOV	D,A		;D=BLK #
	MVI	B,1
	CALL	RECV		;GET CMA'D SECT #
	JC	RECV$HDR$TIMEOUT
	CMA
	CMP	D		;GOOD SECTOR #?
	JZ	RECV$SECTOR
	JMP	RECV$SECT$ERR

;  Receive Sector

RECV$SECTOR:
	MOV	A,D		;GET SECTOR #
	STA	RSECTNO
	MVI	C,0		;INIT CKSUM
	LXI	H,80H		;POINT TO BUFFER
RECV$CHAR:
	MVI	B,1		;1 SEC TIMEOUT
	CALL	RECV		;GET CHAR
	JC	RECV$HDR$TIMEOUT
	MOV	M,A		;STORE CHAR
	INR	L		;DONE?
	JNZ	RECV$CHAR

;VERIFY CHECKSUM

	MOV	D,C		;SAVE CHECKSUM
	MVI	B,1		;TIMEOUT
	CALL	RECV		;GET CHECKSUM
	JC	RECV$HDR$TIMEOUT
	CMP	D		;CHECK
	JNZ	RECV$SECT$ERR
;
;GOT A SECTOR, WRITE IF = 1+PREV SECTOR
;
	LDA	RSECTNO
	MOV	B,A		;SAVE IT
	LDA	SECTNO		;GET PREV
	INR	A		;CALC NEXT SECTOR #
	CMP	B		;MATCH?
	JNZ	DO$ACK

;GOT NEW SECTOR - WRITE IT

	LXI	D,FCB
	MVI	C,WRITE
	CALL	BDOS
	ORA	A
	JNZ	WRITE$ERROR
	LDA	RSECTNO
	STA	SECTNO		;UPDATE SECTOR #
DO$ACK	MVI	A,ACK
	CALL	SEND
	JMP	RECV$LOOP

WRITE$ERROR:
	CALL	ERXIT
	DB	13,10,10,'Error Writing File',13,10,'$'

GOT$EOT:
	MVI	A,ACK		;ACK THE EOT
	CALL	SEND
	LXI	D,FCB
	MVI	C,CLOSE
	CALL	BDOS
	INR	A
	JNZ	XFER$CPLT
	CALL	ERXIT
	DB	13,10,10,'Error Closing File',13,10,'$'
;
ERASE$OLD$FILE:
	LXI	D,FCB
	MVI	C,SRCHF		;SEE IF IT EXISTS
	CALL	BDOS
	INR	A		;FOUND?
	RZ			;NO, RETURN
ERAY:	LXI	D,FCB
	MVI	C,ERASE
	CALL	BDOS
	RET
;
MAKE$NEW$FILE:
	LXI	D,FCB
	MVI	C,MAKE
	CALL	BDOS
	INR	A		;FF=BAD
	RNZ			;OPEN OK

;DIRECTORY FULL - CAN'T MAKE FILE
	CALL	ERXIT
	DB	13,10,10,'Error - Can''t Make File',13,10
	DB	'(directory must be full)',13,10,'$'
;
; S U B R O U T I N E S
;
; - - - - - - - - - - - - - - -

;EXIT PRINTING MESSAGE FOLLOWING 'CALL ERXIT'

ERXIT	POP	D		;GET MESSAGE
	MVI	C,PRINT
	CALL	BDOS		;PRINT MESSAGE
EXIT	LHLD	STACK		;GET ORIGINAL STACK
	SPHL			;RESTORE IT
	RET			;--EXIT-- TO CP/M

; - - - - - - - - - - - - - - -
;MODEM RECV
;-------------------------------------
RECV	PUSH	D		;SAVE
MSEC	lxi	d,(206 shl 8)	;76 cycles, 4.86ms/wrap*206=1s (4MHz)

rcvSCR	equ	$+1		;address of I/O port for the following IN
MWTI	IN	SIOACR
	ANI	RCVMASK
	CPI	RCVRDY
	JZ	MCHAR		;GOT CHAR

; When receiving through Port B, Port A remains the CP/M console.
; Poll Port A for Ctrl-C so a transfer can be aborted.  When Port A is
; the transfer port, no independent console channel is available here.

	lda	fPortB
	ora	a
	jz	NOKEY
	in	SIOACR		;character waiting on console Port A?
	ani	RCVMASK
	jz	NOKEY
	in	SIOADR		;read console character
	cpi	CTRLC
	jnz	NOKEY
	pop	d		;restore d,e
	ora	a		;clear carry, return Ctrl-C in A
	ret

; No console Ctrl-C

NOKEY	DCR	E		;COUNT DOWN
	JNZ	MWTI		;FOR TIMEOUT
	DCR	D
	JNZ	MWTI
	DCR	B		;DCR # OF SECONDS
	JNZ	MSEC

;MODEM TIMED OUT RECEIVING

	POP	D		;RESTORE D,E
	STC			;CARRY SHOWS TIMEOUT
	RET

;GOT MODEM CHAR

rcvSDR	equ	$+1		;address of I/O port for the following IN
MCHAR	IN	SIOADR
	POP	D		;RESTORE DE
	PUSH	PSW		;CALC CHECKSUM
	ADD	C
	MOV	C,A
	POP	PSW
	ORA	A		;TURN OFF CARRY TO SHOW NO TIMEOUT
	RET


; - - - - - - - - - - - - - - -
;MODEM SEND CHAR ROUTINE
;----------------------------------
;
SEND	PUSH	PSW		;CHECK IF MONITORING OUTPUT
	ADD	C		;CALC CKSUM
	MOV	C,A

sndSCR	equ	$+1		;address of I/O port for the following IN
SENDW	IN	SIOACR
	ANI	XMTMASK
	CPI	XMTRDY
	JNZ	SENDW
	POP	PSW		;GET CHAR

sndSDR	equ	$+1		;address of I/O port for the following IN
	OUT	SIOADR
	RET

;---------------------------------------
;  Z80-SIO Initialization. The selected Bondwell SIO channel is
;  initialized after approximately a 1/4
;     second delay to let a possible character in the FIFO finish
;     transmitting.
;---------------------------------------
initSio	lxi	h,0		;delay 1/4 second before init	
iniWait	dcr	l
	jnz	iniWait
	dcr	h
	jnz	iniWait

; Initialize the SIO from the values in initTbl

	lxi	h,initTbl	;hl->SIO initialization table
	mov	b,m		;b=bytes in table
iniLoop	inx	h
	mov	a,m		;next byte from table
iniSCR	equ	$+1		;address of I/O port for the following OUT
	out	SIOACR
	dcr	b
	jnz	iniLoop		;loop until all bytes sent
	ret

; SIO initialization table

initTbl	db	9		; Size of table
	db	18H		; Channel RESET to SIO
	db	4,44h		; WR4: Clock divider, 1 stop bit,no parity
	db	1,0		; WR1: no interrupts
	db	3,0c1h		; WR3: 8 bits/ch, no auto enable, enable RCVR
	db	5,0EAh		; WR5: 8 bits/ch, set DTR & RTS

;-----------------------------------------
;  messages
;-----------------------------------------
mSendA	db	'Send file now using XMODEM on Bondwell Port A...$'
mSendB	db	'Send file now using XMODEM on Bondwell Port B...$'
mHelp	db	CR,LF,'PCGET Ver 1.0 for Bondwell 12/14',CR,LF,LF
	db	'Receives a file from a PC through SIO Port A or',CR,LF
	db	'Port B using the XMODEM checksum protocol.',CR,LF,LF
	db	'Usage: PCGET file.ext [B]',CR,LF
	db	'  Transfer defaults to Port A at 40H/41H',CR,LF
	db	'  "B" selects Port B at 42H/43H',CR,LF,'$'

;DONE - CLOSE UP SHOP

XFER$CPLT:
	CALL	ERXIT
	DB	13,10,10,'Transfer Complete',13,10,'$'

abort:	call	erxit
	db	13,10,10,'Transfer Aborted',13,10,'$'

; Data Storage

	DS	40	;STACK AREA
STACK	DS	2	;STACK POINTER
RSECTNO	DS	1	;RECEIVED SECTOR NUMBER
SECTNO	DS	1	;CURRENT SECTOR NUMBER 
fPortB	DS	1	;non-zero when Port B is selected

;
; BDOS EQUATES (VERSION 2)
;
RDCON	EQU	1
WRCON	EQU	2
PRINT	EQU	9
CONST	EQU	11	;CONSOLE STAT
OPEN	EQU	15	;0FFH=NOT FOUND
CLOSE	EQU	16	;   "	"
SRCHF	EQU	17	;   "	"
SRCHN	EQU	18	;   "	"
ERASE	EQU	19	;NO RET CODE
READ	EQU	20	;0=OK, 1=EOF
WRITE	EQU	21	;0=OK, 1=ERR, 2=?, 0FFH=NO DIR SPC
MAKE	EQU	22	;0FFH=BAD
REN	EQU	23	;0FFH=BAD
STDMA	EQU	26
BDOS	EQU	5
REIPL	EQU	0
FCB	EQU	5CH	;DEFAULT FCB
PARAM1	EQU	FCB+1	;COMMAND LINE PARAMETER 1 IN FCB
PARAM2	EQU	PARAM1+16	;COMMAND LINE PARAMETER 2
	END
