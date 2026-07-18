;
;  Bondwell 12/14 Version. Assumes approximately 4MHz Z80 CPU
;
;  PCPUT - Sends a file from CP/M to a PC through Bondwell SIO0/SIO1
;  using the XMODEM checksum or CRC protocol.
;
;  Adapted from Mike Douglas's Kaypro 10 PCPUT Ver 1.1.
;
;  Bondwell Serial Port Equates

SIOADR  EQU     040H            ;Port A data register
SIOACR  EQU     041H            ;Port A control/status register
SIOBDR  EQU     042H            ;Port B data register
SIOBCR  EQU     043H            ;Port B control/status register
SIOCR   EQU     SIOACR          ;assembly-time placeholder, patched at run time
SIODR   EQU     SIOADR          ;assembly-time placeholder, patched at run time

XMTMASK	EQU	4		;MASK TO ISOLATE XMIT READY BIT
XMTRDY	EQU	4		;VALUE WHEN READY
RCVMASK	EQU	1		;MASK TO ISOLATE RECEIVE READY BIT
RCVRDY	EQU	1		;VALUE WHEN READY

ERRLMT	EQU	5		;MAX ALLOWABLE ERRORS

;DEFINE ASCII CHARACTERS USED

SOH	EQU	1
EOT	EQU	4
ACK	EQU	6
NAK	EQU	15H
CTRLC	EQU	3		;Control-C
LF	EQU	10
CR	EQU	13

	org	100h

;  Verify a file name was specified

	lda	PARAM1		;A=1st character of parameter 1
	cpi	' '		;make sure file name present
	jnz	haveFn		;yes, have a file name
	lxi	d,mHelp		;display usage message
	mvi	c,print
	call	bdos
	ret			;return to CPM

; Switch to local stack. See if modem serial port "M" specified

haveFn	LXI	H,0		;save CP/M stack, switch to local stack
	DAD	SP		;HL=STACK FROM CP/M
	SHLD	STACK		;save original stack
	LXI	SP,STACK	;SP=local stack
	mvi	b,SIOADR	;default to Bondwell Port A
	xra	a
	sta	fPortB		;Port A selected
	lda	PARAM2		;A=1st character of parameter 2
	ani	5fh		;force upper case
	cpi	'B'		;Port B specified?
	jnz	doXfer
	mvi	b,SIOBDR	;use Bondwell Port B
	mvi	a,1
	sta	fPortB
	
;  doXfer - Patch selected SIO addresses and start transfer

doXfer	mov	a,b		;A=data register address
	sta	rcvSDR		;patch IN data-register operand
	sta	sndSDR		;patch OUT data-register operand
	inr	a		;control/status register is data+1
	sta	rcvSCR		;patch RECV status operand
	sta	sndSCR		;patch SEND status operand
	sta	iniSCR		;patch SIO initialization operand
	call	initSio		;initialize selected SIO channel
	xra	a		
	sta	SECTNO		;initialize sector number to zero
	CALL	OPEN$FILE	;OPEN THE FILE
	lxi	d,mRcvA		;default prompt for Port A
	lda	fPortB
	ora	a
	jz	usingPort
	lxi	d,mRcvB		;prompt for Port B
usingPort MVI	C,PRINT
	CALL	BDOS		;print receive file prompt

;  GOBBLE UP GARBAGE CHARS FROM THE LINE

purge	MVI	B,1		;times out after 1 second if no data
	CALL	RECV
	jc	lineClr		;line is clear, go wait for initial NAK
	cpi	ctrlc		;exit if abort requested
	jz	abort
	jmp	purge

; WAIT FOR INITIAL NAK, THEN SEND THE FILE
	
lineClr	xra	a		;clear crc flag = checksum mode
	sta	crcFlag
WAITNAK	MVI	B,1		;TIMEOUT DELAY
	CALL	RECV
	JC	WAITNAK
	cpi	ctrlc		;abort requested?
	jz	abort
	CPI	NAK		;NAK RECEIVED?
	jz	SENDB		;yes, send file in checksum mode
	cpi	'C'		;'C' for CRC mode received?
	JNZ	WAITNAK		;no, keep waiting
	sta	crcFlag		;set CRC flag non-zero = true
				;fall through to start the send operation
;
;*****************SEND A FILE***************
;

;READ SECTOR, SEND IT

SENDB	CALL	READ$SECTOR
	LDA	SECTNO		;INCR SECT NO.
	INR	A
	STA	SECTNO

;SEND OR REPEAT SECTOR

REPTB	MVI	A,SOH
	CALL	SEND
	LDA	SECTNO
	CALL	SEND
	LDA	SECTNO
	CMA
	CALL	SEND
	lxi	h,0		;init crc to zero
	shld	crc16
	mov	c,h		;init checksum in c to zero
	LXI	H,80H
SENDC	MOV	A,M
	CALL	SEND
	call	calCrc		;update CRC
	INX	H
	MOV	A,H
	CPI	1		;DONE WITH SECTOR?
	JNZ	SENDC

; Send checksum or CRC based on crcFlag

	lda	crcFlag		;crc or checksum?
	ora	a
	jz	sndCsum		;flag clear = checksum
	lda	crc16+1		;a=high byte of CRC
	call	SEND		;send it
	lda	crc16		;a=low byte of crc
	jmp	sndSkip		;skip next instruction	
sndCsum	mov	a,c		;send the checksum byte
sndSkip	call	SEND

;GET ACK ON SECTOR

	MVI	B,4		;WAIT 4 SECONDS MAX
	CALL	RECV
	JC	REPTB		;TIMEOUT, SEND AGAIN

;NO TIMEOUT SENDING SECTOR

	CPI	ACK		;ACK RECIEVED?
	JZ	SENDB		;..YES, SEND NEXT SECT
	cpi	ctrlc		;control-c to abort?
	jz	abort
	JMP	REPTB		;PROBABLY NAK - TRY AGAIN
;
;
; S U B R O U T I N E S
;
;OPEN FILE
OPEN$FILE LXI	D,FCB
	MVI	C,OPEN
	CALL	BDOS
	INR	A		;OPEN OK?
	RNZ			;GOOD OPEN
	CALL	ERXIT
	DB	13,10,'Can''t Open File',13,10,'$'

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
MWTI	IN	SIOCR
	ANI	RCVMASK
	CPI	RCVRDY
	JZ	MCHAR		;GOT CHAR

; When transferring on Port B, check console Port A for CTRL-C.
; Do not do this during a Port A transfer, since Port A is then XMODEM.

	lda	fPortB
	ora	a
	jz	NOKEY
	in	SIOACR		;character waiting on console Port A?
	ani	RCVMASK
	jz	NOKEY
	in	SIOADR		;read console character
	cpi	CTRLC
	jnz	NOKEY
	pop	d		;restore D,E
	ora	a		;clear carry: character received
	ret

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
MCHAR	IN	SIODR
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
SENDW	IN	SIOCR
	ANI	XMTMASK
	CPI	XMTRDY
	JNZ	SENDW
	POP	PSW		;GET CHAR

sndSDR	equ	$+1		;address of I/O port for the following IN
	OUT	SIODR
	RET

;
;FILE READ ROUTINE
;
READ$SECTOR:
	LXI	D,FCB
	MVI	C,READ
	CALL	BDOS
	ORA	A
	RZ
	DCR	A		;EOF?
	JNZ	RDERR

;EOF

	XRA	A
	STA	ERRCT
SEOT	MVI	A,EOT
	CALL	SEND
	MVI	B,3		;WAIT 3 SEC FOR TIMEOUT
	CALL	RECV
	JC	EOTTOT		;EOT TIMEOUT
	CPI	ACK
	JZ	XFER$CPLT

;ACK NOT RECIEVED

EOTERR	LDA	ERRCT
	INR	A
	STA	ERRCT
	CPI	ERRLMT
	JC	SEOT
	CALL	ERXIT
	db	13,10,10
	db	'No ACK received on EOT, but transfer is complete.',13,10,'$'

;
;TIMEOUT ON EOT
;
EOTTOT	JMP	EOTERR
;
;READ ERROR
;
RDERR	CALL	ERXIT
	DB	13,10,'File Read Error',13,10,'$'

;DONE - CLOSE UP SHOP

XFER$CPLT:
	CALL	ERXIT
	DB	13,10,10,'Transfer Complete',13,10,'$'

abort	call	erxit
	DB	13,10,10,'Transfer Aborted',13,10,'$'

;-----------------------------------------------------------------------------
; calCrc - update the 16-bit CRC with one more byte. 
;    (Copied from M. Eberhard)
; On Entry:
;   a has the new byte
;   crc16 is current except this byte
; On Exit:
;   crc16 has been updated
;   Trashes a,de
;-----------------------------------------------------------------------------
calCrc	push	b		;save bc, hl
	push	h
	lhld	crc16		;get CRC so far
	xra	h		;XOR into CRC top byte
	mov	h,a
	lxi	b,1021h		;bc=CRC16 polynomial
	mvi	d,8		;prepare to rotate 8 bits

; do 8 bit shift/divide by CRC polynomial

cRotLp	dad	h		;16-bit shift
	jnc	cClr		;skip if bit 15 was 0
	mov	a,h		;CRC=CRC xor 1021H
	xra	b
	mov	h,a
	mov	a,l
	xra	c
	mov	l,a
cClr	dcr	d
	jnz	cRotLp		;rotate 8 times

; save the updated CRC and exit

	shld	crc16		;save updated CRC
	pop	h		;restore hl, bc
	pop	b
	ret

;---------------------------------------
;  Z80-SIO Initialization. The SIO is initialized after a 1/4
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
	out	SIOCR
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

mRcvA	db	'Start XMODEM receive on PC using Bondwell Port A...$'
mRcvB	db	'Start XMODEM receive on PC using Bondwell Port B...$'
mHelp	db	CR,LF,'PCPUT Ver 1.1 for Bondwell 12/14',CR,LF,LF
	db	'Transmits a CP/M file to a PC using XMODEM',CR,LF
	db	'through Bondwell serial Port A or Port B.',CR,LF,LF
	db	'Usage: PCPUT file.ext [B]',CR,LF
	db	'  Transfer defaults to Port A (40H/41H)',CR,LF
	db	'  B selects Port B (42H/43H)',CR,LF,'$'

; Data Area

	DS	40	;STACK AREA
STACK	DS	2	;STACK POINTER
SECTNO	DS	1	;CURRENT SECTOR NUMBER 
ERRCT	DS	1	;ERROR COUNT
crcFlag	ds	1	;non-zero if using CRC
crc16	ds	2	;computed crc
fPortB	ds	1	;non-zero when Bondwell Port B selected

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
FCB	EQU	5CH	;SYSTEM FCB
PARAM1	EQU	FCB+1	;COMMAND LINE PARAMETER 1 IN FCB
PARAM2	EQU	PARAM1+16	;COMMAND LINE PARAMETER 2
	END
