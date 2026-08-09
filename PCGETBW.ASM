;
;  Bondwell 12/14 Version. Assumes approximately 4MHz CPU
;
;  PCGET - This CP/M program receives a file from a PC via a serial 
;  port and writes it to a file on the CP/M system. The file transfer uses
;  the XMODEM protocol. 
;
;  Note this program is gutted from the Ward Christenson Modem program.
;
 ;  Original Kaypro 10 adaptation by Mike Douglas
;  Bondwell 12/14 hardware adaptation: serial ports 40H-43H
;
;	Ver	Date	   Desc
;   	---    --------    -----------------------------------------------
;	1.0    01/04/15	   Initial version
;
;  Serial Port Equates

BCR	EQU	43h		;Bondwell Port B status/control
BDR	EQU	42h		;Bondwell Port B data
ACR	EQU	41h		;Bondwell Port A status/control
ADR	EQU	40h		;Bondwell Port A data
KSTAT	EQU	3Fh		;Bondwell keyboard status
KDATA	EQU	3Eh		;Bondwell keyboard data
KEYMASK	EQU	80h		;keyboard data-ready bit (bit 7)

XMTMASK	EQU	4		;MASK TO ISOLATE XMIT READY BIT
XMTRDY	EQU	4		;VALUE WHEN READY
RCVMASK	EQU	1		;MASK TO ISOLATE RECEIVE READY BIT
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

;  Switch to local stack. See if Bondwell Port B "B" specified

haveFn	LXI	H,0		;save CP/M stack, switch to local stack
	DAD	SP		;HL=STACK FROM CP/M
	SHLD	STACK		;..SAVE IT
	LXI	SP,STACK	;SP=MY STACK
	mvi	b,ADR		;default to Bondwell Port A
	lxi	d,mSendA	;d->Bondwell Port A prompt
	lda	PARAM2		;A=1st character of parameter 2
	ani	5fh		;force upper case
	cpi	'B'		;Bondwell Port B specified?
	jnz	doXfer		;no, go do the transfer
	mvi	b,BDR		;use Bondwell Port B
	lxi	d,mSendB	;d->Bondwell Port B prompt
	
;  doXfer - Initialize then do the transfer

doXfer	mov	a,b		;a=address of serial port to use
	sta	rcvSDR		;modify IN instruction for data register
	sta	sndSDR		;modify OUT instruction for data register
	adi	1		;a=Bondwell status/control port (data+1)
	sta	rcvSCR		;modify IN for control register in RECV
	sta	sndSCR		;modify IN for control register in SEND
	sta	iniSCR		;modify OUT for control register in init
	nop			;Bondwell: preserve CP/M serial configuration
	nop			;do not apply Kaypro SIO reset/format sequence
	nop
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
;SERIAL RECV
;-------------------------------------
RECV	PUSH	D		;SAVE
MSEC	lxi	d,(206 shl 8)	;76 cycles, 4.86ms/wrap*206=1s (4MHz)

rcvSCR	equ	$+1		;address of I/O port for the following IN
MWTI	IN	BCR
	ANI	RCVMASK
	CPI	RCVRDY
	JZ	MCHAR		;GOT CHAR

; Look for local CTRL-C using Bondwell keyboard hardware.
; Boot ROM waits on KSTAT bit 7 then reads KDATA.
	in	KSTAT		;key available?
	ani	KEYMASK
	jz	NOKEY		;no key pressed
	in	KDATA		;read key
	cpi	CTRLC
	jnz	NOKEY		;not CTRL-C
	pop	d		;restore d,e
	ret			;return CTRL-C to caller

; Not local CTRL-C

NOKEY	DCR	E		;COUNT DOWN
	JNZ	MWTI		;FOR TIMEOUT
	DCR	D
	JNZ	MWTI
	DCR	B		;DCR # OF SECONDS
	JNZ	MSEC

;SERIAL TIMED OUT RECEIVING

	POP	D		;RESTORE D,E
	STC			;CARRY SHOWS TIMEOUT
	RET

;GOT SERIAL CHAR

rcvSDR	equ	$+1		;address of I/O port for the following IN
MCHAR	IN	BDR
	POP	D		;RESTORE DE
	PUSH	PSW		;CALC CHECKSUM
	ADD	C
	MOV	C,A
	POP	PSW
	ORA	A		;TURN OFF CARRY TO SHOW NO TIMEOUT
	RET


; - - - - - - - - - - - - - - -
;SERIAL SEND CHAR ROUTINE
;----------------------------------
;
SEND	PUSH	PSW		;CHECK IF MONITORING OUTPUT
	ADD	C		;CALC CKSUM
	MOV	C,A

sndSCR	equ	$+1		;address of I/O port for the following IN
SENDW	IN	BCR
	ANI	XMTMASK
	CPI	XMTRDY
	JNZ	SENDW
	POP	PSW		;GET CHAR

sndSDR	equ	$+1		;address of I/O port for the following IN
	OUT	BDR
	RET

;---------------------------------------
 ;  Original Kaypro Z80-SIO initialization retained for reference only.
;  The Bondwell build does not call this routine. Original code initialized after a 1/4
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
	out	BCR
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
	db	'Receives a file from a PC through serial Port A or Port B',CR,LF
	db	'using the XMODEM checksum protocol.',CR,LF,LF
	db	'Usage: PCGET file.ext [B]',CR,LF
	db	'  Transfer defaults to Bondwell Port A',CR,LF
	db	'  "B" selects Bondwell Port B',CR,LF,'$'

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
