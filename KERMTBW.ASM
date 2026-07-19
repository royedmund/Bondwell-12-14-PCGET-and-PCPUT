;==============================================================================
; KERMTBW.ASM
;
; Documented Z80 disassembly of KERMTKP.COM, patched for Bondwell 12/14 SIO0.
; CP/M load address: 0100H
;
; Bondwell serial ports:
;   SIO0 data 40H, status/control 41H
;   SIO1 data 42H, status/control 43H
;
; References:
;   http://www.z80.eu/kermit.html
;   https://github.com/glitchwrks/kermit80
;
; Kermit-80 uses a system-independent core linked with a machine-dependent
; communications module. The glitchwrks archive includes CPVKPR.HEX for
; Kaypro systems. This listing documents the complete linked COM image
; supplied by the user, not merely the small machine-dependent overlay.
;
; Exact-rebuild method:
;   Each source line is a DB directive preserving the original bytes.
;   The decoded Z80 instruction appears as a comment.
;   This safely preserves mixed executable code, strings and tables.
;==============================================================================

                ORG     0100H

SIO0_DATA       EQU     040H
SIO0_STATUS     EQU     041H
SIO1_DATA       EQU     042H
SIO1_STATUS     EQU     043H
BDOS            EQU     0005H

;------------------------------------------------------------------------------
; Bondwell patch map
;------------------------------------------------------------------------------
; 0F3CH: 06H -> 41H  TX status port in primary communications output routine
; 0F47H: 04H -> 40H  TX data port in primary communications output routine
; 0F50H: 06H -> 41H  RX status port in primary communications input routine
; 0F94H: 04H -> 40H  RX data port in primary communications input routine
; 148BH: 06H -> 41H  RX status port in terminal-mode polling routine
; 1490H: 04H -> 40H  RX data port in terminal-mode polling routine
; 1B99H: 06H -> 41H  TX status port in secondary communications output routine
; 1BA1H: 04H -> 40H  TX data port in secondary communications output routine

;------------------------------------------------------------------------------
; Complete linked image
;------------------------------------------------------------------------------


CPM_ENTRY:
; CP/M transient-program entry and Kermit initialisation.
                DB      00H                     ; 0100: NOP
                DB      00H                     ; 0101: NOP
                DB      21H,00H,00H             ; 0102: LD HL,0
                DB      39H                     ; 0105: ADD HL,SP
                DB      22H,DFH,30H             ; 0106: LD (0x30df),HL

KermitExit:
                DB      31H,21H,31H             ; 0109: LD SP,0x3121
                DB      0EH,19H                 ; 010C: LD C,0x19
                DB      CDH,05H,00H             ; 010E: CALL 0x0005
                DB      3CH                     ; 0111: INC A
                DB      32H,25H,31H             ; 0112: LD (0x3125),A
                DB      11H,C2H,2CH             ; 0115: LD DE,0x2cc2
                DB      CDH,D0H,21H             ; 0118: CALL L21D0
                DB      11H,E4H,34H             ; 011B: LD DE,0x34e4
                DB      0EH,0AH                 ; 011E: LD C,10

L0120:
                DB      1AH                     ; 0120: LD A,(DE)
                DB      13H                     ; 0121: INC DE
                DB      D3H,06H                 ; 0122: OUT (0x0006),A
                DB      0DH                     ; 0124: DEC C
                DB      C2H,20H,01H             ; 0125: JP nz,L0120
                DB      CDH,2EH,01H             ; 0128: CALL L012E
                DB      CDH,AEH,12H             ; 012B: CALL L12AE

L012E:
                DB      3AH,25H,31H             ; 012E: LD A,(0x3125)
                DB      C6H,40H                 ; 0131: ADD A,0x40
                DB      32H,15H,22H             ; 0133: LD (0x2215),A
                DB      AFH                     ; 0136: XOR A
                DB      32H,E2H,34H             ; 0137: LD (0x34e2),A
                DB      32H,E3H,34H             ; 013A: LD (0x34e3),A
                DB      11H,0AH,22H             ; 013D: LD DE,0x220a
                DB      CDH,20H,1CH             ; 0140: CALL L1C20
                DB      11H,3CH,2DH             ; 0143: LD DE,0x2d3c
                DB      21H,02H,27H             ; 0146: LD HL,0x2702
                DB      CDH,E7H,1BH             ; 0149: CALL L1BE7
                DB      21H,54H,01H             ; 014C: LD HL,0x154
                DB      4FH                     ; 014F: LD C,A
                DB      06H,00H                 ; 0150: LD B,0
                DB      09H                     ; 0152: ADD HL,BC
                DB      E9H                     ; 0153: JP (HL)
                DB      C3H,6CH,14H             ; 0154: JP L146C
                DB      C3H,ABH,12H             ; 0157: JP L12AB
                DB      C3H,F4H,12H             ; 015A: JP L12F4
                DB      C3H,B3H,12H             ; 015D: JP L12B3
                DB      C3H,93H,01H             ; 0160: JP L0193
                DB      C3H,8FH,05H             ; 0163: JP L058F
                DB      C3H,6BH,16H             ; 0166: JP L166B
                DB      C3H,1FH,18H             ; 0169: JP L181F
                DB      C3H,28H,18H             ; 016C: JP L1828
                DB      C3H,00H,12H             ; 016F: JP L1200
                DB      C3H,4DH,12H             ; 0172: JP L124D
                DB      C3H,9FH,12H             ; 0175: JP L129F
                DB      C3H,8BH,19H             ; 0178: JP L198B
                DB      C3H,4DH,1BH             ; 017B: JP L1B4D
                DB      C3H,00H,13H             ; 017E: JP L1300

L0181:
                DB      11H,28H,22H             ; 0181: LD DE,0x2228
                DB      CDH,D0H,21H             ; 0184: CALL L21D0
                DB      C3H,2EH,01H             ; 0187: JP L012E

L018A:
                DB      11H,55H,22H             ; 018A: LD DE,0x2255
                DB      CDH,D0H,21H             ; 018D: CALL L21D0
                DB      C3H,2EH,01H             ; 0190: JP L012E

L0193:
                DB      11H,65H,31H             ; 0193: LD DE,0x3165
                DB      3EH,05H                 ; 0196: LD A,5
                DB      CDH,91H,1CH             ; 0198: CALL L1C91
                DB      C3H,8AH,01H             ; 019B: JP L018A
                DB      B7H                     ; 019E: OR A
                DB      CAH,CBH,01H             ; 019F: JP z,L01CB
                DB      32H,B0H,32H             ; 01A2: LD (0x32b0),A
                DB      EBH                     ; 01A5: EX DE,HL
                DB      36H,24H                 ; 01A6: LD (HL),0x24
                DB      CDH,5AH,02H             ; 01A8: CALL L025A
                DB      11H,F7H,2CH             ; 01AB: LD DE,0x2cf7
                DB      CDH,D0H,21H             ; 01AE: CALL L21D0
                DB      11H,65H,31H             ; 01B1: LD DE,0x3165
                DB      CDH,D0H,21H             ; 01B4: CALL L21D0
                DB      3EH,31H                 ; 01B7: LD A,0x31
                DB      32H,56H,31H             ; 01B9: LD (0x3156),A
                DB      AFH                     ; 01BC: XOR A
                DB      32H,AFH,32H             ; 01BD: LD (0x32af),A
                DB      3EH,52H                 ; 01C0: LD A,0x52
                DB      CDH,2BH,0EH             ; 01C2: CALL L0E2B
                DB      C3H,8AH,01H             ; 01C5: JP L018A
                DB      C3H,CEH,01H             ; 01C8: JP L01CE

L01CB:
                DB      CDH,5AH,02H             ; 01CB: CALL L025A

L01CE:
                DB      AFH                     ; 01CE: XOR A
                DB      32H,58H,31H             ; 01CF: LD (0x3158),A
                DB      21H,00H,00H             ; 01D2: LD HL,0
                DB      22H,5AH,31H             ; 01D5: LD (0x315a),HL
                DB      22H,5CH,31H             ; 01D8: LD (0x315c),HL
                DB      32H,59H,31H             ; 01DB: LD (0x3159),A
                DB      32H,5EH,31H             ; 01DE: LD (0x315e),A
                DB      11H,F1H,2CH             ; 01E1: LD DE,0x2cf1
                DB      CDH,D0H,21H             ; 01E4: CALL L21D0
                DB      21H,00H,00H             ; 01E7: LD HL,0
                DB      CDH,F9H,1BH             ; 01EA: CALL L1BF9
                DB      3EH,52H                 ; 01ED: LD A,0x52
                DB      32H,60H,31H             ; 01EF: LD (0x3160),A

L01F2:
                DB      11H,ECH,2CH             ; 01F2: LD DE,L2CEC
                DB      CDH,D0H,21H             ; 01F5: CALL L21D0
                DB      2AH,5AH,31H             ; 01F8: LD HL,(0x315a)
                DB      CDH,F9H,1BH             ; 01FB: CALL L1BF9
                DB      3AH,60H,31H             ; 01FE: LD A,(0x3160)
                DB      FEH,44H                 ; 0201: CP 0x44
                DB      C2H,0CH,02H             ; 0203: JP nz,L020C
                DB      CDH,ABH,04H             ; 0206: CALL L04AB
                DB      C3H,F2H,01H             ; 0209: JP L01F2

L020C:
                DB      FEH,46H                 ; 020C: CP 0x46
                DB      C2H,17H,02H             ; 020E: JP nz,L0217
                DB      CDH,DFH,03H             ; 0211: CALL L03DF
                DB      C3H,F2H,01H             ; 0214: JP L01F2

L0217:
                DB      FEH,52H                 ; 0217: CP 0x52
                DB      C2H,30H,02H             ; 0219: JP nz,L0230
                DB      CDH,72H,02H             ; 021C: CALL L0272
                DB      3AH,60H,31H             ; 021F: LD A,(0x3160)
                DB      FEH,46H                 ; 0222: CP 0x46
                DB      C2H,F2H,01H             ; 0224: JP nz,L01F2
                DB      11H,57H,26H             ; 0227: LD DE,0x2657
                DB      CDH,EEH,11H             ; 022A: CALL L11EE
                DB      C3H,F2H,01H             ; 022D: JP L01F2

L0230:
                DB      FEH,43H                 ; 0230: CP 0x43
                DB      C2H,4CH,02H             ; 0232: JP nz,L024C
                DB      11H,B3H,23H             ; 0235: LD DE,L23B3
                DB      3AH,58H,31H             ; 0238: LD A,(0x3158)
                DB      B7H                     ; 023B: OR A
                DB      CAH,46H,02H             ; 023C: JP z,L0246
                DB      AFH                     ; 023F: XOR A
                DB      32H,58H,31H             ; 0240: LD (0x3158),A
                DB      11H,8BH,24H             ; 0243: LD DE,0x248b

L0246:
                DB      CDH,EEH,11H             ; 0246: CALL L11EE
                DB      C3H,2EH,01H             ; 0249: JP L012E

L024C:
                DB      FEH,41H                 ; 024C: CP 0x41
                DB      C2H,51H,02H             ; 024E: JP nz,L0251

L0251:
                DB      11H,BEH,23H             ; 0251: LD DE,0x23be
                DB      CDH,EEH,11H             ; 0254: CALL L11EE
                DB      C3H,2EH,01H             ; 0257: JP L012E

L025A:
                DB      11H,BDH,2CH             ; 025A: LD DE,0x2cbd
                DB      CDH,D0H,21H             ; 025D: CALL L21D0
                DB      11H,D5H,21H             ; 0260: LD DE,0x21d5
                DB      CDH,D0H,21H             ; 0263: CALL L21D0

L0266:
                DB      3EH,80H                 ; 0266: LD A,0x80
                DB      32H,38H,31H             ; 0268: LD (0x3138),A
                DB      21H,80H,00H             ; 026B: LD HL,0x80
                DB      22H,3CH,31H             ; 026E: LD (0x313c),HL
                DB      C9H                     ; 0271: RET

L0272:
                DB      3AH,5EH,31H             ; 0272: LD A,(0x315e)
                DB      FEH,10H                 ; 0275: CP 0x10
                DB      FAH,83H,02H             ; 0277: JP m,L0283
                DB      11H,66H,22H             ; 027A: LD DE,0x2266
                DB      CDH,D8H,11H             ; 027D: CALL L11D8
                DB      C3H,D8H,02H             ; 0280: JP L02D8

L0283:
                DB      3CH                     ; 0283: INC A
                DB      32H,5EH,31H             ; 0284: LD (0x315e),A
                DB      3EH,31H                 ; 0287: LD A,0x31
                DB      32H,56H,31H             ; 0289: LD (0x3156),A
                DB      CDH,A4H,0FH             ; 028C: CALL L0FA4
                DB      C3H,E1H,02H             ; 028F: JP L02E1
                DB      FEH,53H                 ; 0292: CP 0x53
                DB      C2H,CDH,02H             ; 0294: JP nz,L02CD
                DB      3AH,5EH,31H             ; 0297: LD A,(0x315e)
                DB      32H,5FH,31H             ; 029A: LD (0x315f),A
                DB      AFH                     ; 029D: XOR A
                DB      32H,5EH,31H             ; 029E: LD (0x315e),A
                DB      3AH,AFH,32H             ; 02A1: LD A,(0x32af)
                DB      CDH,B2H,1BH             ; 02A4: CALL L1BB2
                DB      3AH,B0H,32H             ; 02A7: LD A,(0x32b0)
                DB      21H,65H,31H             ; 02AA: LD HL,0x3165
                DB      CDH,53H,03H             ; 02AD: CALL L0353
                DB      21H,65H,31H             ; 02B0: LD HL,0x3165
                DB      CDH,12H,03H             ; 02B3: CALL L0312
                DB      32H,B0H,32H             ; 02B6: LD (0x32b0),A
                DB      3EH,59H                 ; 02B9: LD A,0x59
                DB      CDH,2BH,0EH             ; 02BB: CALL L0E2B
                DB      C3H,D8H,02H             ; 02BE: JP L02D8
                DB      3AH,57H,31H             ; 02C1: LD A,(0x3157)
                DB      32H,56H,31H             ; 02C4: LD (0x3156),A
                DB      3EH,46H                 ; 02C7: LD A,0x46
                DB      32H,60H,31H             ; 02C9: LD (0x3160),A
                DB      C9H                     ; 02CC: RET

L02CD:
                DB      FEH,45H                 ; 02CD: CP 0x45
                DB      C2H,DEH,02H             ; 02CF: JP nz,L02DE
                DB      CDH,B3H,11H             ; 02D2: CALL L11B3
                DB      C3H,D8H,02H             ; 02D5: JP L02D8

L02D8:
                DB      3EH,41H                 ; 02D8: LD A,0x41
                DB      32H,60H,31H             ; 02DA: LD (0x3160),A
                DB      C9H                     ; 02DD: RET

L02DE:
                DB      CDH,F4H,02H             ; 02DE: CALL L02F4

L02E1:
                DB      3AH,59H,31H             ; 02E1: LD A,(0x3159)
                DB      32H,AFH,32H             ; 02E4: LD (0x32af),A
                DB      AFH                     ; 02E7: XOR A
                DB      32H,B0H,32H             ; 02E8: LD (0x32b0),A
                DB      3EH,4EH                 ; 02EB: LD A,0x4e
                DB      CDH,2BH,0EH             ; 02ED: CALL L0E2B
                DB      C3H,D8H,02H             ; 02F0: JP L02D8
                DB      C9H                     ; 02F3: RET

L02F4:
                DB      11H,F1H,2CH             ; 02F4: LD DE,0x2cf1
                DB      CDH,D0H,21H             ; 02F7: CALL L21D0
                DB      2AH,5CH,31H             ; 02FA: LD HL,(0x315c)
                DB      23H                     ; 02FD: INC HL
                DB      22H,5CH,31H             ; 02FE: LD (0x315c),HL
                DB      CDH,F9H,1BH             ; 0301: CALL L1BF9
                DB      C9H                     ; 0304: RET

L0305:
                DB      C5H                     ; 0305: PUSH BC
                DB      D5H                     ; 0306: PUSH DE
                DB      E5H                     ; 0307: PUSH HL
                DB      11H,64H,26H             ; 0308: LD DE,0x2664
                DB      CDH,D8H,11H             ; 030B: CALL L11D8
                DB      E1H                     ; 030E: POP HL
                DB      D1H                     ; 030F: POP DE
                DB      C1H                     ; 0310: POP BC
                DB      C9H                     ; 0311: RET

L0312:
                DB      3AH,4AH,31H             ; 0312: LD A,(0x314a)
                DB      C6H,20H                 ; 0315: ADD A,0x20
                DB      77H                     ; 0317: LD (HL),A
                DB      23H                     ; 0318: INC HL
                DB      3AH,4CH,31H             ; 0319: LD A,(0x314c)
                DB      C6H,20H                 ; 031C: ADD A,0x20
                DB      77H                     ; 031E: LD (HL),A
                DB      23H                     ; 031F: INC HL
                DB      3AH,4EH,31H             ; 0320: LD A,(0x314e)
                DB      C6H,20H                 ; 0323: ADD A,0x20
                DB      77H                     ; 0325: LD (HL),A
                DB      23H                     ; 0326: INC HL
                DB      3AH,50H,31H             ; 0327: LD A,(0x3150)
                DB      C6H,40H                 ; 032A: ADD A,0x40
                DB      E6H,7FH                 ; 032C: AND 0x7f
                DB      77H                     ; 032E: LD (HL),A
                DB      23H                     ; 032F: INC HL
                DB      3AH,52H,31H             ; 0330: LD A,(0x3152)
                DB      C6H,20H                 ; 0333: ADD A,0x20
                DB      77H                     ; 0335: LD (HL),A
                DB      23H                     ; 0336: INC HL
                DB      3AH,54H,31H             ; 0337: LD A,(0x3154)
                DB      77H                     ; 033A: LD (HL),A
                DB      23H                     ; 033B: INC HL
                DB      36H,59H                 ; 033C: LD (HL),0x59
                DB      3AH,34H,31H             ; 033E: LD A,(0x3134)
                DB      FEH,06H                 ; 0341: CP 6
                DB      CAH,4AH,03H             ; 0343: JP z,L034A
                DB      3AH,2BH,31H             ; 0346: LD A,(0x312b)
                DB      77H                     ; 0349: LD (HL),A

L034A:
                DB      23H                     ; 034A: INC HL
                DB      3AH,57H,31H             ; 034B: LD A,(0x3157)
                DB      77H                     ; 034E: LD (HL),A
                DB      23H                     ; 034F: INC HL
                DB      3EH,08H                 ; 0350: LD A,8
                DB      C9H                     ; 0352: RET

L0353:
                DB      32H,AEH,32H             ; 0353: LD (0x32ae),A
                DB      7EH                     ; 0356: LD A,(HL)
                DB      DEH,20H                 ; 0357: SBC A,0x20
                DB      32H,49H,31H             ; 0359: LD (L3149),A
                DB      3AH,AEH,32H             ; 035C: LD A,(0x32ae)
                DB      FEH,03H                 ; 035F: CP 3
                DB      F8H                     ; 0361: RET m
                DB      23H                     ; 0362: INC HL
                DB      23H                     ; 0363: INC HL
                DB      7EH                     ; 0364: LD A,(HL)
                DB      DEH,20H                 ; 0365: SBC A,0x20
                DB      32H,4DH,31H             ; 0367: LD (L314D),A
                DB      3AH,AEH,32H             ; 036A: LD A,(0x32ae)
                DB      FEH,04H                 ; 036D: CP 4
                DB      F8H                     ; 036F: RET m
                DB      23H                     ; 0370: INC HL
                DB      7EH                     ; 0371: LD A,(HL)
                DB      C6H,40H                 ; 0372: ADD A,0x40
                DB      E6H,7FH                 ; 0374: AND 0x7f
                DB      32H,4FH,31H             ; 0376: LD (0x314f),A
                DB      3AH,AEH,32H             ; 0379: LD A,(0x32ae)
                DB      FEH,05H                 ; 037C: CP 5
                DB      F8H                     ; 037E: RET m
                DB      23H                     ; 037F: INC HL
                DB      7EH                     ; 0380: LD A,(HL)
                DB      DEH,20H                 ; 0381: SBC A,0x20
                DB      32H,51H,31H             ; 0383: LD (0x3151),A
                DB      3AH,AEH,32H             ; 0386: LD A,(0x32ae)
                DB      FEH,06H                 ; 0389: CP 6
                DB      F8H                     ; 038B: RET m
                DB      23H                     ; 038C: INC HL
                DB      7EH                     ; 038D: LD A,(HL)
                DB      32H,53H,31H             ; 038E: LD (0x3153),A
                DB      3AH,AEH,32H             ; 0391: LD A,(0x32ae)
                DB      FEH,07H                 ; 0394: CP 7
                DB      F8H                     ; 0396: RET m
                DB      23H                     ; 0397: INC HL
                DB      3EH,00H                 ; 0398: LD A,0
                DB      32H,2CH,31H             ; 039A: LD (L312C),A
                DB      7EH                     ; 039D: LD A,(HL)
                DB      FEH,4EH                 ; 039E: CP 0x4e
                DB      CAH,C5H,03H             ; 03A0: JP z,L03C5
                DB      FEH,20H                 ; 03A3: CP 0x20
                DB      CAH,C5H,03H             ; 03A5: JP z,L03C5
                DB      FEH,59H                 ; 03A8: CP 0x59
                DB      C2H,BDH,03H             ; 03AA: JP nz,L03BD
                DB      3AH,34H,31H             ; 03AD: LD A,(0x3134)
                DB      FEH,06H                 ; 03B0: CP 6
                DB      CAH,C5H,03H             ; 03B2: JP z,L03C5
                DB      3EH,FFH                 ; 03B5: LD A,0xff
                DB      32H,2CH,31H             ; 03B7: LD (L312C),A
                DB      C3H,C5H,03H             ; 03BA: JP L03C5

L03BD:
                DB      32H,2BH,31H             ; 03BD: LD (0x312b),A
                DB      3EH,FFH                 ; 03C0: LD A,0xff
                DB      32H,2CH,31H             ; 03C2: LD (L312C),A

L03C5:
                DB      3AH,AEH,32H             ; 03C5: LD A,(0x32ae)
                DB      FEH,08H                 ; 03C8: CP 8
                DB      F8H                     ; 03CA: RET m
                DB      23H                     ; 03CB: INC HL
                DB      7EH                     ; 03CC: LD A,(HL)
                DB      47H                     ; 03CD: LD B,A
                DB      3AH,55H,31H             ; 03CE: LD A,(0x3155)
                DB      B8H                     ; 03D1: CP B
                DB      CAH,DBH,03H             ; 03D2: JP z,L03DB
                DB      3EH,31H                 ; 03D5: LD A,0x31
                DB      32H,57H,31H             ; 03D7: LD (0x3157),A
                DB      C9H                     ; 03DA: RET

L03DB:
                DB      32H,57H,31H             ; 03DB: LD (0x3157),A
                DB      C9H                     ; 03DE: RET

L03DF:
                DB      3AH,5EH,31H             ; 03DF: LD A,(0x315e)
                DB      FEH,05H                 ; 03E2: CP 5
                DB      FAH,F0H,03H             ; 03E4: JP m,L03F0
                DB      11H,84H,22H             ; 03E7: LD DE,0x2284
                DB      CDH,D8H,11H             ; 03EA: CALL L11D8
                DB      C3H,D8H,02H             ; 03ED: JP L02D8

L03F0:
                DB      3CH                     ; 03F0: INC A
                DB      32H,5EH,31H             ; 03F1: LD (0x315e),A
                DB      CDH,A4H,0FH             ; 03F4: CALL L0FA4
                DB      C3H,E1H,02H             ; 03F7: JP L02E1
                DB      FEH,53H                 ; 03FA: CP 0x53
                DB      C2H,39H,04H             ; 03FC: JP nz,L0439
                DB      3AH,5FH,31H             ; 03FF: LD A,(0x315f)
                DB      FEH,10H                 ; 0402: CP 0x10
                DB      FAH,10H,04H             ; 0404: JP m,L0410
                DB      11H,66H,22H             ; 0407: LD DE,0x2266
                DB      CDH,D8H,11H             ; 040A: CALL L11D8
                DB      C3H,D8H,02H             ; 040D: JP L02D8

L0410:
                DB      3CH                     ; 0410: INC A
                DB      32H,5FH,31H             ; 0411: LD (0x315f),A
                DB      3AH,59H,31H             ; 0414: LD A,(0x3159)
                DB      3DH                     ; 0417: DEC A
                DB      47H                     ; 0418: LD B,A
                DB      3AH,AFH,32H             ; 0419: LD A,(0x32af)
                DB      B8H                     ; 041C: CP B
                DB      C2H,DEH,02H             ; 041D: JP nz,L02DE
                DB      CDH,F4H,02H             ; 0420: CALL L02F4
                DB      AFH                     ; 0423: XOR A
                DB      32H,5EH,31H             ; 0424: LD (0x315e),A
                DB      21H,65H,31H             ; 0427: LD HL,0x3165
                DB      CDH,12H,03H             ; 042A: CALL L0312
                DB      32H,B0H,32H             ; 042D: LD (0x32b0),A
                DB      3EH,59H                 ; 0430: LD A,0x59
                DB      CDH,2BH,0EH             ; 0432: CALL L0E2B
                DB      C3H,D8H,02H             ; 0435: JP L02D8
                DB      C9H                     ; 0438: RET

L0439:
                DB      FEH,5AH                 ; 0439: CP 0x5a
                DB      C2H,53H,04H             ; 043B: JP nz,L0453
                DB      3AH,5FH,31H             ; 043E: LD A,(0x315f)
                DB      FEH,05H                 ; 0441: CP 5
                DB      FAH,4FH,04H             ; 0443: JP m,L044F
                DB      11H,A3H,22H             ; 0446: LD DE,0x22a3
                DB      CDH,D8H,11H             ; 0449: CALL L11D8
                DB      C3H,D8H,02H             ; 044C: JP L02D8

L044F:
                DB      CDH,D0H,1BH             ; 044F: CALL L1BD0
                DB      C9H                     ; 0452: RET

L0453:
                DB      FEH,46H                 ; 0453: CP 0x46
                DB      C2H,83H,04H             ; 0455: JP nz,L0483
                DB      CDH,A9H,1BH             ; 0458: CALL L1BA9
                DB      C2H,DEH,02H             ; 045B: JP nz,L02DE
                DB      CDH,B2H,1BH             ; 045E: CALL L1BB2
                DB      CDH,A5H,0CH             ; 0461: CALL L0CA5
                DB      C3H,D8H,02H             ; 0464: JP L02D8
                DB      CDH,66H,02H             ; 0467: CALL L0266
                DB      3AH,5EH,31H             ; 046A: LD A,(0x315e)
                DB      32H,5FH,31H             ; 046D: LD (0x315f),A
                DB      CDH,C0H,1BH             ; 0470: CALL L1BC0
                DB      3EH,44H                 ; 0473: LD A,0x44
                DB      32H,60H,31H             ; 0475: LD (0x3160),A
                DB      3AH,58H,31H             ; 0478: LD A,(0x3158)
                DB      FEH,5AH                 ; 047B: CP 0x5a
                DB      C8H                     ; 047D: RET z
                DB      AFH                     ; 047E: XOR A
                DB      32H,58H,31H             ; 047F: LD (0x3158),A
                DB      C9H                     ; 0482: RET

L0483:
                DB      FEH,42H                 ; 0483: CP 0x42
                DB      C2H,A0H,04H             ; 0485: JP nz,L04A0
                DB      CDH,A9H,1BH             ; 0488: CALL L1BA9
                DB      C2H,DEH,02H             ; 048B: JP nz,L02DE
                DB      AFH                     ; 048E: XOR A
                DB      32H,B0H,32H             ; 048F: LD (0x32b0),A
                DB      3EH,59H                 ; 0492: LD A,0x59
                DB      CDH,2BH,0EH             ; 0494: CALL L0E2B
                DB      C3H,D8H,02H             ; 0497: JP L02D8
                DB      3EH,43H                 ; 049A: LD A,0x43
                DB      32H,60H,31H             ; 049C: LD (0x3160),A
                DB      C9H                     ; 049F: RET

L04A0:
                DB      FEH,45H                 ; 04A0: CP 0x45
                DB      C2H,D8H,02H             ; 04A2: JP nz,L02D8
                DB      CDH,B3H,11H             ; 04A5: CALL L11B3
                DB      C3H,D8H,02H             ; 04A8: JP L02D8

L04AB:
                DB      3AH,5EH,31H             ; 04AB: LD A,(0x315e)
                DB      FEH,05H                 ; 04AE: CP 5
                DB      FAH,BCH,04H             ; 04B0: JP m,L04BC
                DB      11H,C4H,22H             ; 04B3: LD DE,0x22c4
                DB      CDH,D8H,11H             ; 04B6: CALL L11D8
                DB      C3H,D8H,02H             ; 04B9: JP L02D8

L04BC:
                DB      3CH                     ; 04BC: INC A
                DB      32H,5EH,31H             ; 04BD: LD (0x315e),A
                DB      CDH,A4H,0FH             ; 04C0: CALL L0FA4
                DB      C3H,E1H,02H             ; 04C3: JP L02E1
                DB      FEH,44H                 ; 04C6: CP 0x44
                DB      C2H,1AH,05H             ; 04C8: JP nz,L051A
                DB      CDH,A9H,1BH             ; 04CB: CALL L1BA9
                DB      CAH,E6H,04H             ; 04CE: JP z,L04E6
                DB      3AH,5FH,31H             ; 04D1: LD A,(0x315f)
                DB      FEH,05H                 ; 04D4: CP 5
                DB      FAH,E2H,04H             ; 04D6: JP m,L04E2
                DB      11H,C4H,22H             ; 04D9: LD DE,0x22c4
                DB      CDH,D8H,11H             ; 04DC: CALL L11D8
                DB      C3H,D8H,02H             ; 04DF: JP L02D8

L04E2:
                DB      CDH,D0H,1BH             ; 04E2: CALL L1BD0
                DB      C9H                     ; 04E5: RET

L04E6:
                DB      CDH,B2H,1BH             ; 04E6: CALL L1BB2
                DB      3AH,5EH,31H             ; 04E9: LD A,(0x315e)
                DB      32H,5FH,31H             ; 04EC: LD (0x315f),A
                DB      3AH,B0H,32H             ; 04EF: LD A,(0x32b0)
                DB      CDH,D3H,09H             ; 04F2: CALL L09D3
                DB      C3H,D8H,02H             ; 04F5: JP L02D8
                DB      AFH                     ; 04F8: XOR A
                DB      32H,5EH,31H             ; 04F9: LD (0x315e),A
                DB      32H,B0H,32H             ; 04FC: LD (0x32b0),A
                DB      4FH                     ; 04FF: LD C,A
                DB      3AH,58H,31H             ; 0500: LD A,(0x3158)
                DB      B7H                     ; 0503: OR A
                DB      CAH,11H,05H             ; 0504: JP z,L0511
                DB      4FH                     ; 0507: LD C,A
                DB      3EH,01H                 ; 0508: LD A,1
                DB      32H,B0H,32H             ; 050A: LD (0x32b0),A
                DB      79H                     ; 050D: LD A,C
                DB      32H,65H,31H             ; 050E: LD (0x3165),A

L0511:
                DB      3EH,59H                 ; 0511: LD A,0x59
                DB      CDH,2BH,0EH             ; 0513: CALL L0E2B
                DB      C3H,D8H,02H             ; 0516: JP L02D8
                DB      C9H                     ; 0519: RET

L051A:
                DB      FEH,46H                 ; 051A: CP 0x46
                DB      C2H,34H,05H             ; 051C: JP nz,L0534
                DB      3AH,5FH,31H             ; 051F: LD A,(0x315f)
                DB      FEH,05H                 ; 0522: CP 5
                DB      FAH,30H,05H             ; 0524: JP m,L0530
                DB      11H,84H,22H             ; 0527: LD DE,0x2284
                DB      CDH,D8H,11H             ; 052A: CALL L11D8
                DB      C3H,D8H,02H             ; 052D: JP L02D8

L0530:
                DB      CDH,D0H,1BH             ; 0530: CALL L1BD0
                DB      C9H                     ; 0533: RET

L0534:
                DB      FEH,5AH                 ; 0534: CP 0x5a
                DB      C2H,84H,05H             ; 0536: JP nz,L0584
                DB      CDH,A9H,1BH             ; 0539: CALL L1BA9
                DB      C2H,DEH,02H             ; 053C: JP nz,L02DE
                DB      CDH,B2H,1BH             ; 053F: CALL L1BB2
                DB      3AH,B0H,32H             ; 0542: LD A,(0x32b0)
                DB      FEH,01H                 ; 0545: CP 1
                DB      C2H,52H,05H             ; 0547: JP nz,L0552
                DB      3AH,65H,31H             ; 054A: LD A,(0x3165)
                DB      FEH,44H                 ; 054D: CP 0x44
                DB      CAH,75H,05H             ; 054F: JP z,L0575

L0552:
                DB      2AH,3CH,31H             ; 0552: LD HL,(0x313c)
                DB      3AH,38H,31H             ; 0555: LD A,(0x3138)

L0558:
                DB      3DH                     ; 0558: DEC A
                DB      B7H                     ; 0559: OR A
                DB      FAH,63H,05H             ; 055A: JP m,L0563
                DB      36H,1AH                 ; 055D: LD (HL),0x1a
                DB      23H                     ; 055F: INC HL
                DB      C3H,58H,05H             ; 0560: JP L0558

L0563:
                DB      CDH,4BH,0AH             ; 0563: CALL L0A4B
                DB      C3H,D8H,02H             ; 0566: JP L02D8
                DB      0EH,10H                 ; 0569: LD C,0x10
                DB      11H,5CH,00H             ; 056B: LD DE,0x5c
                DB      CDH,05H,00H             ; 056E: CALL 0x0005
                DB      AFH                     ; 0571: XOR A
                DB      32H,58H,31H             ; 0572: LD (0x3158),A

L0575:
                DB      3AH,5EH,31H             ; 0575: LD A,(0x315e)
                DB      32H,5FH,31H             ; 0578: LD (0x315f),A
                DB      CDH,C0H,1BH             ; 057B: CALL L1BC0
                DB      3EH,46H                 ; 057E: LD A,0x46
                DB      32H,60H,31H             ; 0580: LD (0x3160),A
                DB      C9H                     ; 0583: RET

L0584:
                DB      FEH,45H                 ; 0584: CP 0x45
                DB      C2H,D8H,02H             ; 0586: JP nz,L02D8
                DB      CDH,B3H,11H             ; 0589: CALL L11B3
                DB      C3H,D8H,02H             ; 058C: JP L02D8

L058F:
                DB      3EH,02H                 ; 058F: LD A,2
                DB      11H,5CH,00H             ; 0591: LD DE,0x5c
                DB      CDH,91H,1CH             ; 0594: CALL L1C91
                DB      C3H,2EH,01H             ; 0597: JP L012E
                DB      CDH,F0H,1BH             ; 059A: CALL L1BF0
                DB      CDH,E3H,0BH             ; 059D: CALL L0BE3
                DB      D2H,ACH,05H             ; 05A0: JP nc,L05AC
                DB      11H,21H,23H             ; 05A3: LD DE,L2321
                DB      CDH,D8H,11H             ; 05A6: CALL L11D8
                DB      C3H,2EH,01H             ; 05A9: JP L012E

L05AC:
                DB      CDH,5AH,02H             ; 05AC: CALL L025A
                DB      AFH                     ; 05AF: XOR A
                DB      32H,59H,31H             ; 05B0: LD (0x3159),A
                DB      32H,5EH,31H             ; 05B3: LD (0x315e),A
                DB      32H,2AH,31H             ; 05B6: LD (0x312a),A
                DB      21H,00H,00H             ; 05B9: LD HL,0
                DB      22H,5AH,31H             ; 05BC: LD (0x315a),HL
                DB      22H,5CH,31H             ; 05BF: LD (0x315c),HL
                DB      11H,F1H,2CH             ; 05C2: LD DE,0x2cf1
                DB      CDH,D0H,21H             ; 05C5: CALL L21D0
                DB      21H,00H,00H             ; 05C8: LD HL,0
                DB      CDH,F9H,1BH             ; 05CB: CALL L1BF9
                DB      3EH,31H                 ; 05CE: LD A,0x31
                DB      32H,56H,31H             ; 05D0: LD (0x3156),A
                DB      3EH,53H                 ; 05D3: LD A,0x53
                DB      32H,60H,31H             ; 05D5: LD (0x3160),A

L05D8:
                DB      11H,ECH,2CH             ; 05D8: LD DE,L2CEC
                DB      CDH,D0H,21H             ; 05DB: CALL L21D0
                DB      2AH,5AH,31H             ; 05DE: LD HL,(0x315a)
                DB      CDH,F9H,1BH             ; 05E1: CALL L1BF9
                DB      3AH,60H,31H             ; 05E4: LD A,(0x3160)
                DB      FEH,44H                 ; 05E7: CP 0x44
                DB      C2H,F2H,05H             ; 05E9: JP nz,L05F2
                DB      CDH,D5H,07H             ; 05EC: CALL L07D5
                DB      C3H,D8H,05H             ; 05EF: JP L05D8

L05F2:
                DB      FEH,46H                 ; 05F2: CP 0x46
                DB      C2H,FDH,05H             ; 05F4: JP nz,L05FD
                DB      CDH,F0H,06H             ; 05F7: CALL L06F0
                DB      C3H,D8H,05H             ; 05FA: JP L05D8

L05FD:
                DB      FEH,5AH                 ; 05FD: CP 0x5a
                DB      C2H,08H,06H             ; 05FF: JP nz,L0608
                DB      CDH,CAH,08H             ; 0602: CALL L08CA
                DB      C3H,D8H,05H             ; 0605: JP L05D8

L0608:
                DB      FEH,53H                 ; 0608: CP 0x53
                DB      C2H,21H,06H             ; 060A: JP nz,L0621
                DB      CDH,5BH,06H             ; 060D: CALL L065B
                DB      3AH,60H,31H             ; 0610: LD A,(0x3160)
                DB      FEH,46H                 ; 0613: CP 0x46
                DB      C2H,D8H,05H             ; 0615: JP nz,L05D8
                DB      11H,4CH,26H             ; 0618: LD DE,0x264c
                DB      CDH,EEH,11H             ; 061B: CALL L11EE
                DB      C3H,D8H,05H             ; 061E: JP L05D8

L0621:
                DB      FEH,42H                 ; 0621: CP 0x42
                DB      C2H,2CH,06H             ; 0623: JP nz,L062C
                DB      CDH,6AH,09H             ; 0626: CALL L096A
                DB      C3H,D8H,05H             ; 0629: JP L05D8

L062C:
                DB      FEH,43H                 ; 062C: CP 0x43
                DB      C2H,44H,06H             ; 062E: JP nz,L0644
                DB      11H,B3H,23H             ; 0631: LD DE,L23B3
                DB      3AH,58H,31H             ; 0634: LD A,(0x3158)
                DB      B7H                     ; 0637: OR A
                DB      CAH,3EH,06H             ; 0638: JP z,L063E
                DB      11H,8BH,24H             ; 063B: LD DE,0x248b

L063E:
                DB      CDH,EEH,11H             ; 063E: CALL L11EE
                DB      C3H,2EH,01H             ; 0641: JP L012E

L0644:
                DB      FEH,41H                 ; 0644: CP 0x41
                DB      C2H,52H,06H             ; 0646: JP nz,L0652
                DB      11H,BEH,23H             ; 0649: LD DE,0x23be
                DB      CDH,EEH,11H             ; 064C: CALL L11EE
                DB      C3H,2EH,01H             ; 064F: JP L012E

L0652:
                DB      11H,BEH,23H             ; 0652: LD DE,0x23be
                DB      CDH,EEH,11H             ; 0655: CALL L11EE
                DB      C3H,2EH,01H             ; 0658: JP L012E

L065B:
                DB      3AH,5EH,31H             ; 065B: LD A,(0x315e)
                DB      FEH,10H                 ; 065E: CP 0x10
                DB      FAH,6CH,06H             ; 0660: JP m,L066C
                DB      11H,EBH,22H             ; 0663: LD DE,0x22eb
                DB      CDH,D8H,11H             ; 0666: CALL L11D8
                DB      C3H,D8H,02H             ; 0669: JP L02D8

L066C:
                DB      3CH                     ; 066C: INC A
                DB      32H,5EH,31H             ; 066D: LD (0x315e),A
                DB      3EH,31H                 ; 0670: LD A,0x31
                DB      32H,56H,31H             ; 0672: LD (0x3156),A
                DB      3AH,55H,31H             ; 0675: LD A,(0x3155)
                DB      32H,57H,31H             ; 0678: LD (0x3157),A
                DB      21H,65H,31H             ; 067B: LD HL,0x3165
                DB      CDH,12H,03H             ; 067E: CALL L0312
                DB      32H,B0H,32H             ; 0681: LD (0x32b0),A
                DB      3AH,5AH,31H             ; 0684: LD A,(0x315a)
                DB      32H,AFH,32H             ; 0687: LD (0x32af),A
                DB      3EH,53H                 ; 068A: LD A,0x53
                DB      CDH,2BH,0EH             ; 068C: CALL L0E2B
                DB      C3H,D8H,02H             ; 068F: JP L02D8
                DB      CDH,A4H,0FH             ; 0692: CALL L0FA4
                DB      C3H,A8H,1BH             ; 0695: JP L1BA8
                DB      FEH,59H                 ; 0698: CP 0x59
                DB      C2H,C9H,06H             ; 069A: JP nz,L06C9
                DB      CDH,A9H,1BH             ; 069D: CALL L1BA9
                DB      C0H                     ; 06A0: RET nz
                DB      CDH,B2H,1BH             ; 06A1: CALL L1BB2
                DB      3AH,B0H,32H             ; 06A4: LD A,(0x32b0)
                DB      21H,65H,31H             ; 06A7: LD HL,0x3165
                DB      CDH,53H,03H             ; 06AA: CALL L0353
                DB      3AH,5EH,31H             ; 06AD: LD A,(0x315e)
                DB      32H,5FH,31H             ; 06B0: LD (0x315f),A
                DB      AFH                     ; 06B3: XOR A
                DB      32H,5EH,31H             ; 06B4: LD (0x315e),A
                DB      3AH,57H,31H             ; 06B7: LD A,(0x3157)
                DB      32H,56H,31H             ; 06BA: LD (0x3156),A
                DB      3EH,46H                 ; 06BD: LD A,0x46
                DB      32H,60H,31H             ; 06BF: LD (0x3160),A
                DB      CDH,88H,0CH             ; 06C2: CALL L0C88
                DB      C3H,D8H,02H             ; 06C5: JP L02D8
                DB      C9H                     ; 06C8: RET

L06C9:
                DB      FEH,4EH                 ; 06C9: CP 0x4e
                DB      C2H,E5H,06H             ; 06CB: JP nz,L06E5
                DB      CDH,F4H,02H             ; 06CE: CALL L02F4
                DB      3AH,59H,31H             ; 06D1: LD A,(0x3159)
                DB      3CH                     ; 06D4: INC A
                DB      47H                     ; 06D5: LD B,A
                DB      3AH,AFH,32H             ; 06D6: LD A,(0x32af)
                DB      B8H                     ; 06D9: CP B
                DB      C0H                     ; 06DA: RET nz
                DB      AFH                     ; 06DB: XOR A
                DB      32H,5EH,31H             ; 06DC: LD (0x315e),A
                DB      3EH,46H                 ; 06DF: LD A,0x46
                DB      32H,60H,31H             ; 06E1: LD (0x3160),A
                DB      C9H                     ; 06E4: RET

L06E5:
                DB      FEH,45H                 ; 06E5: CP 0x45
                DB      C2H,D8H,02H             ; 06E7: JP nz,L02D8
                DB      CDH,B3H,11H             ; 06EA: CALL L11B3
                DB      C3H,D8H,02H             ; 06ED: JP L02D8

L06F0:
                DB      3AH,5EH,31H             ; 06F0: LD A,(0x315e)
                DB      FEH,05H                 ; 06F3: CP 5
                DB      FAH,01H,07H             ; 06F5: JP m,L0701
                DB      11H,EBH,22H             ; 06F8: LD DE,0x22eb
                DB      CDH,D8H,11H             ; 06FB: CALL L11D8
                DB      C3H,D8H,02H             ; 06FE: JP L02D8

L0701:
                DB      3CH                     ; 0701: INC A
                DB      32H,5EH,31H             ; 0702: LD (0x315e),A
                DB      AFH                     ; 0705: XOR A
                DB      32H,58H,31H             ; 0706: LD (0x3158),A
                DB      21H,65H,31H             ; 0709: LD HL,0x3165
                DB      22H,42H,31H             ; 070C: LD (0x3142),HL
                DB      21H,5DH,00H             ; 070F: LD HL,0x5d
                DB      22H,40H,31H             ; 0712: LD (0x3140),HL
                DB      06H,00H                 ; 0715: LD B,0
                DB      0EH,00H                 ; 0717: LD C,0

L0719:
                DB      78H                     ; 0719: LD A,B
                DB      FEH,08H                 ; 071A: CP 8
                DB      C2H,2AH,07H             ; 071C: JP nz,L072A
                DB      3EH,2EH                 ; 071F: LD A,0x2e
                DB      2AH,42H,31H             ; 0721: LD HL,(0x3142)
                DB      77H                     ; 0724: LD (HL),A
                DB      23H                     ; 0725: INC HL
                DB      22H,42H,31H             ; 0726: LD (0x3142),HL
                DB      0CH                     ; 0729: INC C

L072A:
                DB      04H                     ; 072A: INC B
                DB      78H                     ; 072B: LD A,B
                DB      FEH,0CH                 ; 072C: CP 12
                DB      F2H,4CH,07H             ; 072E: JP p,L074C
                DB      2AH,40H,31H             ; 0731: LD HL,(0x3140)
                DB      7EH                     ; 0734: LD A,(HL)
                DB      E6H,7FH                 ; 0735: AND 0x7f
                DB      23H                     ; 0737: INC HL
                DB      22H,40H,31H             ; 0738: LD (0x3140),HL
                DB      FEH,21H                 ; 073B: CP 0x21
                DB      FAH,19H,07H             ; 073D: JP m,L0719
                DB      2AH,42H,31H             ; 0740: LD HL,(0x3142)
                DB      77H                     ; 0743: LD (HL),A
                DB      23H                     ; 0744: INC HL
                DB      22H,42H,31H             ; 0745: LD (0x3142),HL
                DB      0CH                     ; 0748: INC C
                DB      C3H,19H,07H             ; 0749: JP L0719

L074C:
                DB      79H                     ; 074C: LD A,C
                DB      32H,B0H,32H             ; 074D: LD (0x32b0),A
                DB      2AH,42H,31H             ; 0750: LD HL,(0x3142)
                DB      3EH,24H                 ; 0753: LD A,0x24
                DB      77H                     ; 0755: LD (HL),A
                DB      11H,F7H,2CH             ; 0756: LD DE,0x2cf7
                DB      CDH,D0H,21H             ; 0759: CALL L21D0
                DB      11H,65H,31H             ; 075C: LD DE,0x3165
                DB      CDH,D0H,21H             ; 075F: CALL L21D0
                DB      3AH,59H,31H             ; 0762: LD A,(0x3159)
                DB      32H,AFH,32H             ; 0765: LD (0x32af),A
                DB      3EH,46H                 ; 0768: LD A,0x46
                DB      CDH,2BH,0EH             ; 076A: CALL L0E2B
                DB      C3H,D8H,02H             ; 076D: JP L02D8
                DB      CDH,A4H,0FH             ; 0770: CALL L0FA4
                DB      C3H,A8H,1BH             ; 0773: JP L1BA8
                DB      FEH,59H                 ; 0776: CP 0x59
                DB      C2H,B5H,07H             ; 0778: JP nz,L07B5
                DB      CDH,A9H,1BH             ; 077B: CALL L1BA9
                DB      C0H                     ; 077E: RET nz

L077F:
                DB      CDH,B2H,1BH             ; 077F: CALL L1BB2
                DB      3AH,5EH,31H             ; 0782: LD A,(0x315e)
                DB      32H,5FH,31H             ; 0785: LD (0x315f),A
                DB      AFH                     ; 0788: XOR A
                DB      32H,5EH,31H             ; 0789: LD (0x315e),A
                DB      AFH                     ; 078C: XOR A
                DB      32H,7CH,00H             ; 078D: LD (0x007c),A
                DB      32H,23H,31H             ; 0790: LD (0x3123),A
                DB      3EH,FFH                 ; 0793: LD A,0xff
                DB      32H,24H,31H             ; 0795: LD (L3124),A
                DB      CDH,6EH,0AH             ; 0798: CALL L0A6E
                DB      C3H,A1H,07H             ; 079B: JP L07A1
                DB      C3H,ACH,07H             ; 079E: JP L07AC

L07A1:
                DB      FEH,FFH                 ; 07A1: CP 0xff
                DB      C2H,D8H,02H             ; 07A3: JP nz,L02D8
                DB      3EH,5AH                 ; 07A6: LD A,0x5a
                DB      32H,60H,31H             ; 07A8: LD (0x3160),A
                DB      C9H                     ; 07AB: RET

L07AC:
                DB      32H,48H,31H             ; 07AC: LD (0x3148),A
                DB      3EH,44H                 ; 07AF: LD A,0x44
                DB      32H,60H,31H             ; 07B1: LD (0x3160),A
                DB      C9H                     ; 07B4: RET

L07B5:
                DB      FEH,4EH                 ; 07B5: CP 0x4e
                DB      C2H,CAH,07H             ; 07B7: JP nz,L07CA
                DB      CDH,F4H,02H             ; 07BA: CALL L02F4
                DB      3AH,59H,31H             ; 07BD: LD A,(0x3159)
                DB      3CH                     ; 07C0: INC A
                DB      47H                     ; 07C1: LD B,A
                DB      3AH,AFH,32H             ; 07C2: LD A,(0x32af)
                DB      B8H                     ; 07C5: CP B
                DB      C0H                     ; 07C6: RET nz
                DB      C3H,7FH,07H             ; 07C7: JP L077F

L07CA:
                DB      FEH,45H                 ; 07CA: CP 0x45
                DB      C2H,D8H,02H             ; 07CC: JP nz,L02D8
                DB      CDH,B3H,11H             ; 07CF: CALL L11B3
                DB      C3H,D8H,02H             ; 07D2: JP L02D8

L07D5:
                DB      3AH,5EH,31H             ; 07D5: LD A,(0x315e)
                DB      FEH,05H                 ; 07D8: CP 5
                DB      FAH,E6H,07H             ; 07DA: JP m,L07E6
                DB      11H,EBH,22H             ; 07DD: LD DE,0x22eb
                DB      CDH,D8H,11H             ; 07E0: CALL L11D8
                DB      C3H,D8H,02H             ; 07E3: JP L02D8

L07E6:
                DB      3CH                     ; 07E6: INC A
                DB      32H,5EH,31H             ; 07E7: LD (0x315e),A
                DB      21H,65H,31H             ; 07EA: LD HL,0x3165
                DB      22H,42H,31H             ; 07ED: LD (0x3142),HL
                DB      21H,26H,32H             ; 07F0: LD HL,0x3226
                DB      22H,44H,31H             ; 07F3: LD (0x3144),HL
                DB      06H,01H                 ; 07F6: LD B,1

L07F8:
                DB      2AH,44H,31H             ; 07F8: LD HL,(0x3144)
                DB      7EH                     ; 07FB: LD A,(HL)
                DB      23H                     ; 07FC: INC HL
                DB      22H,44H,31H             ; 07FD: LD (0x3144),HL
                DB      4FH                     ; 0800: LD C,A
                DB      3AH,2CH,31H             ; 0801: LD A,(L312C)
                DB      B7H                     ; 0804: OR A
                DB      79H                     ; 0805: LD A,C
                DB      C2H,2AH,08H             ; 0806: JP nz,L082A
                DB      3AH,34H,31H             ; 0809: LD A,(0x3134)
                DB      FEH,06H                 ; 080C: CP 6
                DB      79H                     ; 080E: LD A,C
                DB      CAH,2AH,08H             ; 080F: JP z,L082A
                DB      3AH,2AH,31H             ; 0812: LD A,(0x312a)
                DB      B7H                     ; 0815: OR A
                DB      C2H,27H,08H             ; 0816: JP nz,L0827
                DB      79H                     ; 0819: LD A,C
                DB      E6H,80H                 ; 081A: AND 0x80
                DB      CAH,27H,08H             ; 081C: JP z,L0827
                DB      CDH,05H,03H             ; 081F: CALL L0305
                DB      3EH,FFH                 ; 0822: LD A,0xff
                DB      32H,2AH,31H             ; 0824: LD (0x312a),A

L0827:
                DB      79H                     ; 0827: LD A,C
                DB      E6H,7FH                 ; 0828: AND 0x7f

L082A:
                DB      2AH,42H,31H             ; 082A: LD HL,(0x3142)
                DB      77H                     ; 082D: LD (HL),A
                DB      23H                     ; 082E: INC HL
                DB      22H,42H,31H             ; 082F: LD (0x3142),HL
                DB      04H                     ; 0832: INC B
                DB      3AH,48H,31H             ; 0833: LD A,(0x3148)
                DB      B8H                     ; 0836: CP B
                DB      F2H,F8H,07H             ; 0837: JP p,L07F8
                DB      3AH,48H,31H             ; 083A: LD A,(0x3148)
                DB      32H,B0H,32H             ; 083D: LD (0x32b0),A
                DB      3AH,59H,31H             ; 0840: LD A,(0x3159)
                DB      32H,AFH,32H             ; 0843: LD (0x32af),A
                DB      3EH,44H                 ; 0846: LD A,0x44
                DB      CDH,2BH,0EH             ; 0848: CALL L0E2B
                DB      C3H,D8H,02H             ; 084B: JP L02D8
                DB      CDH,A4H,0FH             ; 084E: CALL L0FA4
                DB      C3H,A8H,1BH             ; 0851: JP L1BA8
                DB      FEH,59H                 ; 0854: CP 0x59
                DB      C2H,AAH,08H             ; 0856: JP nz,L08AA
                DB      CDH,A9H,1BH             ; 0859: CALL L1BA9
                DB      C0H                     ; 085C: RET nz
                DB      3AH,AFH,32H             ; 085D: LD A,(0x32af)
                DB      CDH,B2H,1BH             ; 0860: CALL L1BB2
                DB      3AH,5EH,31H             ; 0863: LD A,(0x315e)
                DB      32H,5FH,31H             ; 0866: LD (0x315f),A
                DB      AFH                     ; 0869: XOR A
                DB      32H,5EH,31H             ; 086A: LD (0x315e),A
                DB      3AH,B0H,32H             ; 086D: LD A,(0x32b0)
                DB      FEH,01H                 ; 0870: CP 1
                DB      C2H,88H,08H             ; 0872: JP nz,L0888
                DB      3AH,65H,31H             ; 0875: LD A,(0x3165)
                DB      FEH,5AH                 ; 0878: CP 0x5a
                DB      C2H,80H,08H             ; 087A: JP nz,L0880
                DB      32H,58H,31H             ; 087D: LD (0x3158),A

L0880:
                DB      FEH,58H                 ; 0880: CP 0x58
                DB      C2H,88H,08H             ; 0882: JP nz,L0888
                DB      32H,58H,31H             ; 0885: LD (0x3158),A

L0888:
                DB      3AH,58H,31H             ; 0888: LD A,(0x3158)
                DB      B7H                     ; 088B: OR A
                DB      CAH,95H,08H             ; 088C: JP z,L0895
                DB      3EH,5AH                 ; 088F: LD A,0x5a
                DB      32H,60H,31H             ; 0891: LD (0x3160),A
                DB      C9H                     ; 0894: RET

L0895:
                DB      CDH,6EH,0AH             ; 0895: CALL L0A6E
                DB      C3H,9FH,08H             ; 0898: JP L089F
                DB      32H,48H,31H             ; 089B: LD (0x3148),A
                DB      C9H                     ; 089E: RET

L089F:
                DB      FEH,FFH                 ; 089F: CP 0xff
                DB      C2H,D8H,02H             ; 08A1: JP nz,L02D8
                DB      3EH,5AH                 ; 08A4: LD A,0x5a
                DB      32H,60H,31H             ; 08A6: LD (0x3160),A
                DB      C9H                     ; 08A9: RET

L08AA:
                DB      FEH,4EH                 ; 08AA: CP 0x4e
                DB      C2H,BFH,08H             ; 08AC: JP nz,L08BF
                DB      CDH,F4H,02H             ; 08AF: CALL L02F4
                DB      3AH,59H,31H             ; 08B2: LD A,(0x3159)
                DB      3CH                     ; 08B5: INC A
                DB      47H                     ; 08B6: LD B,A
                DB      3AH,AFH,32H             ; 08B7: LD A,(0x32af)
                DB      B8H                     ; 08BA: CP B
                DB      C0H                     ; 08BB: RET nz
                DB      C3H,95H,08H             ; 08BC: JP L0895

L08BF:
                DB      FEH,45H                 ; 08BF: CP 0x45
                DB      C2H,D8H,02H             ; 08C1: JP nz,L02D8
                DB      CDH,B3H,11H             ; 08C4: CALL L11B3
                DB      C3H,D8H,02H             ; 08C7: JP L02D8

L08CA:
                DB      3AH,5EH,31H             ; 08CA: LD A,(0x315e)
                DB      FEH,05H                 ; 08CD: CP 5
                DB      FAH,DBH,08H             ; 08CF: JP m,L08DB
                DB      11H,EBH,22H             ; 08D2: LD DE,0x22eb
                DB      CDH,D8H,11H             ; 08D5: CALL L11D8
                DB      C3H,D8H,02H             ; 08D8: JP L02D8

L08DB:
                DB      3CH                     ; 08DB: INC A
                DB      32H,5EH,31H             ; 08DC: LD (0x315e),A
                DB      3AH,59H,31H             ; 08DF: LD A,(0x3159)
                DB      32H,AFH,32H             ; 08E2: LD (0x32af),A
                DB      AFH                     ; 08E5: XOR A
                DB      32H,B0H,32H             ; 08E6: LD (0x32b0),A
                DB      3AH,58H,31H             ; 08E9: LD A,(0x3158)
                DB      B7H                     ; 08EC: OR A
                DB      CAH,FAH,08H             ; 08ED: JP z,L08FA
                DB      3EH,44H                 ; 08F0: LD A,0x44
                DB      32H,65H,31H             ; 08F2: LD (0x3165),A
                DB      3EH,01H                 ; 08F5: LD A,1
                DB      32H,B0H,32H             ; 08F7: LD (0x32b0),A

L08FA:
                DB      3EH,5AH                 ; 08FA: LD A,0x5a
                DB      CDH,2BH,0EH             ; 08FC: CALL L0E2B
                DB      C3H,D8H,02H             ; 08FF: JP L02D8
                DB      CDH,A4H,0FH             ; 0902: CALL L0FA4
                DB      C3H,A8H,1BH             ; 0905: JP L1BA8
                DB      FEH,59H                 ; 0908: CP 0x59
                DB      C2H,4AH,09H             ; 090A: JP nz,L094A
                DB      CDH,A9H,1BH             ; 090D: CALL L1BA9
                DB      C0H                     ; 0910: RET nz

L0911:
                DB      CDH,B2H,1BH             ; 0911: CALL L1BB2
                DB      3AH,5EH,31H             ; 0914: LD A,(0x315e)
                DB      32H,5FH,31H             ; 0917: LD (0x315f),A
                DB      AFH                     ; 091A: XOR A
                DB      32H,5EH,31H             ; 091B: LD (0x315e),A
                DB      0EH,10H                 ; 091E: LD C,0x10
                DB      11H,5CH,00H             ; 0920: LD DE,0x5c
                DB      CDH,05H,00H             ; 0923: CALL 0x0005
                DB      3AH,58H,31H             ; 0926: LD A,(0x3158)
                DB      FEH,5AH                 ; 0929: CP 0x5a
                DB      CAH,44H,09H             ; 092B: JP z,L0944
                DB      CDH,E3H,0BH             ; 092E: CALL L0BE3
                DB      DAH,44H,09H             ; 0931: JP c,L0944
                DB      CDH,88H,0CH             ; 0934: CALL L0C88
                DB      C3H,D8H,02H             ; 0937: JP L02D8
                DB      AFH                     ; 093A: XOR A
                DB      32H,58H,31H             ; 093B: LD (0x3158),A
                DB      3EH,46H                 ; 093E: LD A,0x46
                DB      32H,60H,31H             ; 0940: LD (0x3160),A
                DB      C9H                     ; 0943: RET

L0944:
                DB      3EH,42H                 ; 0944: LD A,0x42
                DB      32H,60H,31H             ; 0946: LD (0x3160),A
                DB      C9H                     ; 0949: RET

L094A:
                DB      FEH,4EH                 ; 094A: CP 0x4e
                DB      C2H,5FH,09H             ; 094C: JP nz,L095F
                DB      CDH,F4H,02H             ; 094F: CALL L02F4
                DB      3AH,59H,31H             ; 0952: LD A,(0x3159)
                DB      3CH                     ; 0955: INC A
                DB      47H                     ; 0956: LD B,A
                DB      3AH,AFH,32H             ; 0957: LD A,(0x32af)
                DB      B8H                     ; 095A: CP B
                DB      C0H                     ; 095B: RET nz
                DB      C3H,11H,09H             ; 095C: JP L0911

L095F:
                DB      FEH,45H                 ; 095F: CP 0x45
                DB      C2H,D8H,02H             ; 0961: JP nz,L02D8
                DB      CDH,B3H,11H             ; 0964: CALL L11B3
                DB      C3H,D8H,02H             ; 0967: JP L02D8

L096A:
                DB      3AH,5EH,31H             ; 096A: LD A,(0x315e)
                DB      FEH,05H                 ; 096D: CP 5
                DB      FAH,7BH,09H             ; 096F: JP m,L097B
                DB      11H,EBH,22H             ; 0972: LD DE,0x22eb
                DB      CDH,D8H,11H             ; 0975: CALL L11D8
                DB      C3H,D8H,02H             ; 0978: JP L02D8

L097B:
                DB      3CH                     ; 097B: INC A
                DB      32H,5EH,31H             ; 097C: LD (0x315e),A
                DB      3AH,59H,31H             ; 097F: LD A,(0x3159)
                DB      32H,AFH,32H             ; 0982: LD (0x32af),A
                DB      AFH                     ; 0985: XOR A
                DB      32H,B0H,32H             ; 0986: LD (0x32b0),A
                DB      3EH,42H                 ; 0989: LD A,0x42
                DB      CDH,2BH,0EH             ; 098B: CALL L0E2B
                DB      C3H,D8H,02H             ; 098E: JP L02D8
                DB      CDH,A4H,0FH             ; 0991: CALL L0FA4
                DB      C3H,A8H,1BH             ; 0994: JP L1BA8
                DB      FEH,59H                 ; 0997: CP 0x59
                DB      C2H,B3H,09H             ; 0999: JP nz,L09B3
                DB      CDH,A9H,1BH             ; 099C: CALL L1BA9
                DB      C0H                     ; 099F: RET nz

L09A0:
                DB      CDH,B2H,1BH             ; 09A0: CALL L1BB2
                DB      3AH,5EH,31H             ; 09A3: LD A,(0x315e)
                DB      32H,5FH,31H             ; 09A6: LD (0x315f),A
                DB      AFH                     ; 09A9: XOR A
                DB      32H,5EH,31H             ; 09AA: LD (0x315e),A
                DB      3EH,43H                 ; 09AD: LD A,0x43
                DB      32H,60H,31H             ; 09AF: LD (0x3160),A
                DB      C9H                     ; 09B2: RET

L09B3:
                DB      FEH,4EH                 ; 09B3: CP 0x4e
                DB      C2H,C8H,09H             ; 09B5: JP nz,L09C8
                DB      CDH,F4H,02H             ; 09B8: CALL L02F4
                DB      3AH,59H,31H             ; 09BB: LD A,(0x3159)
                DB      3CH                     ; 09BE: INC A
                DB      47H                     ; 09BF: LD B,A
                DB      3AH,AFH,32H             ; 09C0: LD A,(0x32af)
                DB      B8H                     ; 09C3: CP B
                DB      C0H                     ; 09C4: RET nz
                DB      C3H,A0H,09H             ; 09C5: JP L09A0

L09C8:
                DB      FEH,45H                 ; 09C8: CP 0x45
                DB      C2H,D8H,02H             ; 09CA: JP nz,L02D8
                DB      CDH,B3H,11H             ; 09CD: CALL L11B3
                DB      C3H,D8H,02H             ; 09D0: JP L02D8

L09D3:
                DB      32H,ABH,32H             ; 09D3: LD (L32AB),A
                DB      21H,65H,31H             ; 09D6: LD HL,0x3165
                DB      22H,3AH,31H             ; 09D9: LD (0x313a),HL
                DB      3AH,54H,31H             ; 09DC: LD A,(0x3154)
                DB      47H                     ; 09DF: LD B,A
                DB      0EH,00H                 ; 09E0: LD C,0
                DB      3AH,2CH,31H             ; 09E2: LD A,(L312C)
                DB      B7H                     ; 09E5: OR A
                DB      CAH,EDH,09H             ; 09E6: JP z,L09ED
                DB      3AH,2BH,31H             ; 09E9: LD A,(0x312b)
                DB      4FH                     ; 09EC: LD C,A

L09ED:
                DB      21H,ABH,32H             ; 09ED: LD HL,L32AB
                DB      35H                     ; 09F0: DEC (HL)
                DB      FAH,A3H,1BH             ; 09F1: JP m,L1BA3
                DB      21H,38H,31H             ; 09F4: LD HL,0x3138
                DB      35H                     ; 09F7: DEC (HL)
                DB      F2H,01H,0AH             ; 09F8: JP p,L0A01
                DB      CDH,4BH,0AH             ; 09FB: CALL L0A4B
                DB      C3H,A8H,1BH             ; 09FE: JP L1BA8

L0A01:
                DB      2AH,3AH,31H             ; 0A01: LD HL,(0x313a)
                DB      7EH                     ; 0A04: LD A,(HL)
                DB      23H                     ; 0A05: INC HL
                DB      22H,3AH,31H             ; 0A06: LD (0x313a),HL
                DB      1EH,00H                 ; 0A09: LD E,0
                DB      B9H                     ; 0A0B: CP C
                DB      C2H,1DH,0AH             ; 0A0C: JP nz,L0A1D
                DB      1EH,80H                 ; 0A0F: LD E,0x80
                DB      3AH,ABH,32H             ; 0A11: LD A,(L32AB)
                DB      3DH                     ; 0A14: DEC A
                DB      32H,ABH,32H             ; 0A15: LD (L32AB),A
                DB      7EH                     ; 0A18: LD A,(HL)
                DB      23H                     ; 0A19: INC HL
                DB      22H,3AH,31H             ; 0A1A: LD (0x313a),HL

L0A1D:
                DB      B8H                     ; 0A1D: CP B
                DB      C2H,3FH,0AH             ; 0A1E: JP nz,L0A3F
                DB      7EH                     ; 0A21: LD A,(HL)
                DB      23H                     ; 0A22: INC HL
                DB      22H,3AH,31H             ; 0A23: LD (0x313a),HL
                DB      21H,ABH,32H             ; 0A26: LD HL,L32AB
                DB      35H                     ; 0A29: DEC (HL)
                DB      57H                     ; 0A2A: LD D,A
                DB      E6H,80H                 ; 0A2B: AND 0x80
                DB      B3H                     ; 0A2D: OR E
                DB      5FH                     ; 0A2E: LD E,A
                DB      7AH                     ; 0A2F: LD A,D
                DB      E6H,7FH                 ; 0A30: AND 0x7f
                DB      B8H                     ; 0A32: CP B
                DB      CAH,3FH,0AH             ; 0A33: JP z,L0A3F
                DB      B9H                     ; 0A36: CP C
                DB      CAH,3FH,0AH             ; 0A37: JP z,L0A3F
                DB      7AH                     ; 0A3A: LD A,D
                DB      C6H,40H                 ; 0A3B: ADD A,0x40
                DB      E6H,7FH                 ; 0A3D: AND 0x7f

L0A3F:
                DB      B3H                     ; 0A3F: OR E
                DB      2AH,3CH,31H             ; 0A40: LD HL,(0x313c)
                DB      77H                     ; 0A43: LD (HL),A
                DB      23H                     ; 0A44: INC HL
                DB      22H,3CH,31H             ; 0A45: LD (0x313c),HL
                DB      C3H,EDH,09H             ; 0A48: JP L09ED

L0A4B:
                DB      C5H                     ; 0A4B: PUSH BC
                DB      0EH,15H                 ; 0A4C: LD C,0x15
                DB      11H,5CH,00H             ; 0A4E: LD DE,0x5c
                DB      CDH,05H,00H             ; 0A51: CALL 0x0005
                DB      C1H                     ; 0A54: POP BC
                DB      B7H                     ; 0A55: OR A
                DB      CAH,60H,0AH             ; 0A56: JP z,L0A60
                DB      11H,DEH,22H             ; 0A59: LD DE,0x22de
                DB      CDH,D8H,11H             ; 0A5C: CALL L11D8
                DB      C9H                     ; 0A5F: RET

L0A60:
                DB      21H,80H,00H             ; 0A60: LD HL,0x80
                DB      22H,3CH,31H             ; 0A63: LD (0x313c),HL
                DB      3EH,7FH                 ; 0A66: LD A,0x7f
                DB      32H,38H,31H             ; 0A68: LD (0x3138),A
                DB      C3H,A3H,1BH             ; 0A6B: JP L1BA3

L0A6E:
                DB      3AH,53H,31H             ; 0A6E: LD A,(0x3153)
                DB      4FH                     ; 0A71: LD C,A
                DB      3AH,24H,31H             ; 0A72: LD A,(L3124)
                DB      B7H                     ; 0A75: OR A
                DB      CAH,81H,0AH             ; 0A76: JP z,L0A81
                DB      06H,00H                 ; 0A79: LD B,0
                DB      CDH,96H,0BH             ; 0A7B: CALL L0B96
                DB      C3H,93H,0BH             ; 0A7E: JP L0B93

L0A81:
                DB      3AH,56H,31H             ; 0A81: LD A,(0x3156)
                DB      D6H,31H                 ; 0A84: SUB 0x31
                DB      47H                     ; 0A86: LD B,A
                DB      3AH,49H,31H             ; 0A87: LD A,(L3149)
                DB      D6H,05H                 ; 0A8A: SUB 5
                DB      90H                     ; 0A8C: SUB B
                DB      32H,ABH,32H             ; 0A8D: LD (L32AB),A
                DB      21H,26H,32H             ; 0A90: LD HL,0x3226
                DB      22H,44H,31H             ; 0A93: LD (0x3144),HL
                DB      06H,00H                 ; 0A96: LD B,0

L0A98:
                DB      3AH,ABH,32H             ; 0A98: LD A,(L32AB)
                DB      3DH                     ; 0A9B: DEC A
                DB      F2H,A3H,0AH             ; 0A9C: JP p,L0AA3
                DB      78H                     ; 0A9F: LD A,B
                DB      C3H,A3H,1BH             ; 0AA0: JP L1BA3

L0AA3:
                DB      32H,ABH,32H             ; 0AA3: LD (L32AB),A
                DB      3AH,38H,31H             ; 0AA6: LD A,(0x3138)
                DB      3DH                     ; 0AA9: DEC A
                DB      FAH,B3H,0AH             ; 0AAA: JP m,L0AB3
                DB      32H,38H,31H             ; 0AAD: LD (0x3138),A
                DB      C3H,C4H,0AH             ; 0AB0: JP L0AC4

L0AB3:
                DB      CDH,96H,0BH             ; 0AB3: CALL L0B96
                DB      C3H,BCH,0AH             ; 0AB6: JP L0ABC
                DB      C3H,C4H,0AH             ; 0AB9: JP L0AC4

L0ABC:
                DB      78H                     ; 0ABC: LD A,B
                DB      B7H                     ; 0ABD: OR A
                DB      C2H,A3H,1BH             ; 0ABE: JP nz,L1BA3
                DB      C3H,93H,0BH             ; 0AC1: JP L0B93

L0AC4:
                DB      2AH,3CH,31H             ; 0AC4: LD HL,(0x313c)
                DB      7EH                     ; 0AC7: LD A,(HL)
                DB      23H                     ; 0AC8: INC HL
                DB      22H,3CH,31H             ; 0AC9: LD (0x313c),HL
                DB      57H                     ; 0ACC: LD D,A
                DB      E6H,80H                 ; 0ACD: AND 0x80
                DB      5FH                     ; 0ACF: LD E,A
                DB      CAH,F4H,0AH             ; 0AD0: JP z,L0AF4
                DB      3AH,2CH,31H             ; 0AD3: LD A,(L312C)
                DB      B7H                     ; 0AD6: OR A
                DB      CAH,F4H,0AH             ; 0AD7: JP z,L0AF4
                DB      3AH,ABH,32H             ; 0ADA: LD A,(L32AB)
                DB      FEH,02H                 ; 0ADD: CP 2
                DB      FAH,84H,0BH             ; 0ADF: JP m,L0B84
                DB      3DH                     ; 0AE2: DEC A
                DB      32H,ABH,32H             ; 0AE3: LD (L32AB),A
                DB      2AH,44H,31H             ; 0AE6: LD HL,(0x3144)
                DB      3AH,2BH,31H             ; 0AE9: LD A,(0x312b)
                DB      77H                     ; 0AEC: LD (HL),A
                DB      23H                     ; 0AED: INC HL
                DB      22H,44H,31H             ; 0AEE: LD (0x3144),HL
                DB      04H                     ; 0AF1: INC B
                DB      1EH,00H                 ; 0AF2: LD E,0

L0AF4:
                DB      7AH                     ; 0AF4: LD A,D
                DB      E6H,7FH                 ; 0AF5: AND 0x7f
                DB      57H                     ; 0AF7: LD D,A
                DB      FEH,20H                 ; 0AF8: CP 0x20
                DB      FAH,26H,0BH             ; 0AFA: JP m,L0B26
                DB      FEH,7FH                 ; 0AFD: CP 0x7f
                DB      CAH,26H,0BH             ; 0AFF: JP z,L0B26
                DB      3AH,2CH,31H             ; 0B02: LD A,(L312C)
                DB      B7H                     ; 0B05: OR A
                DB      CAH,10H,0BH             ; 0B06: JP z,L0B10
                DB      3AH,2BH,31H             ; 0B09: LD A,(0x312b)
                DB      BAH                     ; 0B0C: CP D
                DB      CAH,15H,0BH             ; 0B0D: JP z,L0B15

L0B10:
                DB      7AH                     ; 0B10: LD A,D
                DB      B9H                     ; 0B11: CP C
                DB      C2H,77H,0BH             ; 0B12: JP nz,L0B77

L0B15:
                DB      21H,ABH,32H             ; 0B15: LD HL,L32AB
                DB      35H                     ; 0B18: DEC (HL)
                DB      2AH,44H,31H             ; 0B19: LD HL,(0x3144)
                DB      71H                     ; 0B1C: LD (HL),C
                DB      23H                     ; 0B1D: INC HL
                DB      22H,44H,31H             ; 0B1E: LD (0x3144),HL
                DB      04H                     ; 0B21: INC B
                DB      7AH                     ; 0B22: LD A,D
                DB      C3H,77H,0BH             ; 0B23: JP L0B77

L0B26:
                DB      B3H                     ; 0B26: OR E
                DB      FEH,1AH                 ; 0B27: CP 0x1a
                DB      C2H,60H,0BH             ; 0B29: JP nz,L0B60
                DB      3AH,33H,31H             ; 0B2C: LD A,(0x3133)
                DB      FEH,01H                 ; 0B2F: CP 1
                DB      CAH,4FH,0BH             ; 0B31: JP z,L0B4F
                DB      3AH,23H,31H             ; 0B34: LD A,(0x3123)
                DB      B7H                     ; 0B37: OR A
                DB      CAH,5EH,0BH             ; 0B38: JP z,L0B5E
                DB      3AH,33H,31H             ; 0B3B: LD A,(0x3133)
                DB      FEH,02H                 ; 0B3E: CP 2
                DB      CAH,5EH,0BH             ; 0B40: JP z,L0B5E
                DB      2AH,3CH,31H             ; 0B43: LD HL,(0x313c)
                DB      3AH,38H,31H             ; 0B46: LD A,(0x3138)
                DB      57H                     ; 0B49: LD D,A

L0B4A:
                DB      15H                     ; 0B4A: DEC D
                DB      7AH                     ; 0B4B: LD A,D
                DB      F2H,57H,0BH             ; 0B4C: JP p,L0B57

L0B4F:
                DB      AFH                     ; 0B4F: XOR A
                DB      32H,38H,31H             ; 0B50: LD (0x3138),A
                DB      78H                     ; 0B53: LD A,B
                DB      C3H,A3H,1BH             ; 0B54: JP L1BA3

L0B57:
                DB      7EH                     ; 0B57: LD A,(HL)
                DB      23H                     ; 0B58: INC HL
                DB      FEH,1AH                 ; 0B59: CP 0x1a
                DB      CAH,4AH,0BH             ; 0B5B: JP z,L0B4A

L0B5E:
                DB      3EH,1AH                 ; 0B5E: LD A,0x1a

L0B60:
                DB      32H,ACH,32H             ; 0B60: LD (0x32ac),A
                DB      21H,ABH,32H             ; 0B63: LD HL,L32AB
                DB      35H                     ; 0B66: DEC (HL)
                DB      2AH,44H,31H             ; 0B67: LD HL,(0x3144)
                DB      71H                     ; 0B6A: LD (HL),C
                DB      23H                     ; 0B6B: INC HL
                DB      22H,44H,31H             ; 0B6C: LD (0x3144),HL
                DB      04H                     ; 0B6F: INC B
                DB      3AH,ACH,32H             ; 0B70: LD A,(0x32ac)
                DB      C6H,40H                 ; 0B73: ADD A,0x40
                DB      E6H,7FH                 ; 0B75: AND 0x7f

L0B77:
                DB      2AH,44H,31H             ; 0B77: LD HL,(0x3144)
                DB      B3H                     ; 0B7A: OR E
                DB      77H                     ; 0B7B: LD (HL),A
                DB      23H                     ; 0B7C: INC HL
                DB      22H,44H,31H             ; 0B7D: LD (0x3144),HL
                DB      04H                     ; 0B80: INC B
                DB      C3H,98H,0AH             ; 0B81: JP L0A98

L0B84:
                DB      2AH,3CH,31H             ; 0B84: LD HL,(0x313c)
                DB      2BH                     ; 0B87: DEC HL
                DB      22H,3CH,31H             ; 0B88: LD (0x313c),HL
                DB      21H,38H,31H             ; 0B8B: LD HL,0x3138
                DB      34H                     ; 0B8E: INC (HL)
                DB      78H                     ; 0B8F: LD A,B
                DB      C3H,A3H,1BH             ; 0B90: JP L1BA3

L0B93:
                DB      3EH,FFH                 ; 0B93: LD A,0xff
                DB      C9H                     ; 0B95: RET

L0B96:
                DB      3AH,23H,31H             ; 0B96: LD A,(0x3123)
                DB      B7H                     ; 0B99: OR A
                DB      CAH,A0H,0BH             ; 0B9A: JP z,L0BA0
                DB      06H,00H                 ; 0B9D: LD B,0
                DB      C0H                     ; 0B9F: RET nz

L0BA0:
                DB      C5H                     ; 0BA0: PUSH BC
                DB      D5H                     ; 0BA1: PUSH DE
                DB      E5H                     ; 0BA2: PUSH HL
                DB      21H,38H,31H             ; 0BA3: LD HL,0x3138
                DB      3AH,24H,31H             ; 0BA6: LD A,(L3124)
                DB      B7H                     ; 0BA9: OR A
                DB      CAH,B6H,0BH             ; 0BAA: JP z,L0BB6
                DB      36H,80H                 ; 0BAD: LD (HL),0x80
                DB      AFH                     ; 0BAF: XOR A
                DB      32H,24H,31H             ; 0BB0: LD (L3124),A
                DB      C3H,B8H,0BH             ; 0BB3: JP L0BB8

L0BB6:
                DB      36H,7FH                 ; 0BB6: LD (HL),0x7f

L0BB8:
                DB      21H,80H,00H             ; 0BB8: LD HL,0x80
                DB      22H,3CH,31H             ; 0BBB: LD (0x313c),HL
                DB      0EH,14H                 ; 0BBE: LD C,0x14
                DB      11H,5CH,00H             ; 0BC0: LD DE,0x5c
                DB      CDH,05H,00H             ; 0BC3: CALL 0x0005
                DB      B7H                     ; 0BC6: OR A
                DB      CAH,D1H,0BH             ; 0BC7: JP z,L0BD1
                DB      C3H,D7H,0BH             ; 0BCA: JP L0BD7

L0BCD:
                DB      E1H                     ; 0BCD: POP HL
                DB      D1H                     ; 0BCE: POP DE
                DB      C1H                     ; 0BCF: POP BC
                DB      C9H                     ; 0BD0: RET

L0BD1:
                DB      E1H                     ; 0BD1: POP HL
                DB      D1H                     ; 0BD2: POP DE
                DB      C1H                     ; 0BD3: POP BC
                DB      C3H,A3H,1BH             ; 0BD4: JP L1BA3

L0BD7:
                DB      AFH                     ; 0BD7: XOR A
                DB      32H,38H,31H             ; 0BD8: LD (0x3138),A
                DB      3EH,FFH                 ; 0BDB: LD A,0xff
                DB      32H,23H,31H             ; 0BDD: LD (0x3123),A
                DB      C3H,CDH,0BH             ; 0BE0: JP L0BCD

L0BE3:
                DB      D2H,E7H,0BH             ; 0BE3: JP nc,L0BE7
                DB      3FH                     ; 0BE6: CCF

L0BE7:
                DB      C5H                     ; 0BE7: PUSH BC
                DB      D5H                     ; 0BE8: PUSH DE
                DB      E5H                     ; 0BE9: PUSH HL
                DB      0EH,1AH                 ; 0BEA: LD C,0x1a
                DB      11H,80H,00H             ; 0BEC: LD DE,0x80
                DB      CDH,05H,00H             ; 0BEF: CALL 0x0005
                DB      AFH                     ; 0BF2: XOR A
                DB      32H,68H,00H             ; 0BF3: LD (0x0068),A
                DB      3AH,E2H,34H             ; 0BF6: LD A,(0x34e2)
                DB      B7H                     ; 0BF9: OR A
                DB      C2H,17H,0CH             ; 0BFA: JP nz,L0C17
                DB      32H,E3H,34H             ; 0BFD: LD (0x34e3),A
                DB      21H,5CH,00H             ; 0C00: LD HL,0x5c
                DB      11H,D6H,34H             ; 0C03: LD DE,0x34d6
                DB      01H,0CH,00H             ; 0C06: LD BC,12
                DB      CDH,69H,0CH             ; 0C09: CALL L0C69
                DB      0EH,11H                 ; 0C0C: LD C,0x11
                DB      11H,5CH,00H             ; 0C0E: LD DE,0x5c
                DB      CDH,05H,00H             ; 0C11: CALL 0x0005
                DB      C3H,34H,0CH             ; 0C14: JP L0C34

L0C17:
                DB      3DH                     ; 0C17: DEC A
                DB      32H,E3H,34H             ; 0C18: LD (0x34e3),A
                DB      21H,D6H,34H             ; 0C1B: LD HL,0x34d6
                DB      11H,5CH,00H             ; 0C1E: LD DE,0x5c
                DB      01H,0CH,00H             ; 0C21: LD BC,12
                DB      CDH,69H,0CH             ; 0C24: CALL L0C69
                DB      0EH,11H                 ; 0C27: LD C,0x11
                DB      11H,5CH,00H             ; 0C29: LD DE,0x5c
                DB      CDH,05H,00H             ; 0C2C: CALL 0x0005

L0C2F:
                DB      0EH,12H                 ; 0C2F: LD C,0x12
                DB      CDH,05H,00H             ; 0C31: CALL 0x0005

L0C34:
                DB      F5H                     ; 0C34: PUSH AF
                DB      3AH,E3H,34H             ; 0C35: LD A,(0x34e3)
                DB      B7H                     ; 0C38: OR A
                DB      CAH,44H,0CH             ; 0C39: JP z,L0C44
                DB      3DH                     ; 0C3C: DEC A
                DB      32H,E3H,34H             ; 0C3D: LD (0x34e3),A
                DB      F1H                     ; 0C40: POP AF
                DB      C3H,2FH,0CH             ; 0C41: JP L0C2F

L0C44:
                DB      F1H                     ; 0C44: POP AF
                DB      B7H                     ; 0C45: OR A
                DB      FAH,65H,0CH             ; 0C46: JP m,L0C65
                DB      CDH,74H,0CH             ; 0C49: CALL L0C74
                DB      3AH,D6H,34H             ; 0C4C: LD A,(0x34d6)
                DB      32H,5CH,00H             ; 0C4F: LD (0x005c),A
                DB      3AH,E2H,34H             ; 0C52: LD A,(0x34e2)
                DB      3CH                     ; 0C55: INC A
                DB      32H,E2H,34H             ; 0C56: LD (0x34e2),A
                DB      3EH,00H                 ; 0C59: LD A,0
                DB      32H,68H,00H             ; 0C5B: LD (0x0068),A
                DB      32H,7DH,00H             ; 0C5E: LD (0x007d),A

L0C61:
                DB      E1H                     ; 0C61: POP HL
                DB      D1H                     ; 0C62: POP DE
                DB      C1H                     ; 0C63: POP BC
                DB      C9H                     ; 0C64: RET

L0C65:
                DB      37H                     ; 0C65: SCF
                DB      C3H,61H,0CH             ; 0C66: JP L0C61

L0C69:
                DB      7EH                     ; 0C69: LD A,(HL)
                DB      12H                     ; 0C6A: LD (DE),A
                DB      23H                     ; 0C6B: INC HL
                DB      13H                     ; 0C6C: INC DE
                DB      0BH                     ; 0C6D: DEC BC
                DB      78H                     ; 0C6E: LD A,B
                DB      B1H                     ; 0C6F: OR C
                DB      C2H,69H,0CH             ; 0C70: JP nz,L0C69
                DB      C9H                     ; 0C73: RET

L0C74:
                DB      87H                     ; 0C74: ADD A,A
                DB      87H                     ; 0C75: ADD A,A
                DB      87H                     ; 0C76: ADD A,A
                DB      87H                     ; 0C77: ADD A,A
                DB      87H                     ; 0C78: ADD A,A
                DB      C6H,80H                 ; 0C79: ADD A,0x80
                DB      6FH                     ; 0C7B: LD L,A
                DB      26H,00H                 ; 0C7C: LD H,0
                DB      11H,5CH,00H             ; 0C7E: LD DE,0x5c
                DB      01H,0CH,00H             ; 0C81: LD BC,12
                DB      CDH,69H,0CH             ; 0C84: CALL L0C69
                DB      C9H                     ; 0C87: RET

L0C88:
                DB      3EH,FFH                 ; 0C88: LD A,0xff
                DB      32H,24H,31H             ; 0C8A: LD (L3124),A
                DB      AFH                     ; 0C8D: XOR A
                DB      32H,23H,31H             ; 0C8E: LD (0x3123),A
                DB      32H,68H,00H             ; 0C91: LD (0x0068),A
                DB      32H,6AH,00H             ; 0C94: LD (0x006a),A
                DB      32H,7CH,00H             ; 0C97: LD (0x007c),A
                DB      0EH,0FH                 ; 0C9A: LD C,15
                DB      11H,5CH,00H             ; 0C9C: LD DE,0x5c
                DB      CDH,05H,00H             ; 0C9F: CALL 0x0005
                DB      C3H,A3H,1BH             ; 0CA2: JP L1BA3

L0CA5:
                DB      21H,65H,31H             ; 0CA5: LD HL,0x3165
                DB      22H,42H,31H             ; 0CA8: LD (0x3142),HL
                DB      21H,5DH,00H             ; 0CAB: LD HL,0x5d
                DB      22H,40H,31H             ; 0CAE: LD (0x3140),HL
                DB      AFH                     ; 0CB1: XOR A
                DB      32H,ABH,32H             ; 0CB2: LD (L32AB),A
                DB      32H,ACH,32H             ; 0CB5: LD (0x32ac),A
                DB      32H,5CH,00H             ; 0CB8: LD (0x005c),A
                DB      06H,20H                 ; 0CBB: LD B,0x20

L0CBD:
                DB      70H                     ; 0CBD: LD (HL),B
                DB      23H                     ; 0CBE: INC HL
                DB      3CH                     ; 0CBF: INC A
                DB      FEH,0CH                 ; 0CC0: CP 12
                DB      FAH,BDH,0CH             ; 0CC2: JP m,L0CBD

L0CC5:
                DB      2AH,42H,31H             ; 0CC5: LD HL,(0x3142)
                DB      7EH                     ; 0CC8: LD A,(HL)
                DB      FEH,61H                 ; 0CC9: CP 0x61
                DB      FAH,D0H,0CH             ; 0CCB: JP m,L0CD0
                DB      E6H,5FH                 ; 0CCE: AND 0x5f

L0CD0:
                DB      23H                     ; 0CD0: INC HL
                DB      FEH,2EH                 ; 0CD1: CP 0x2e
                DB      C2H,EDH,0CH             ; 0CD3: JP nz,L0CED
                DB      22H,42H,31H             ; 0CD6: LD (0x3142),HL
                DB      21H,65H,00H             ; 0CD9: LD HL,0x65
                DB      22H,40H,31H             ; 0CDC: LD (0x3140),HL
                DB      3AH,ABH,32H             ; 0CDF: LD A,(L32AB)
                DB      32H,ACH,32H             ; 0CE2: LD (0x32ac),A
                DB      3EH,09H                 ; 0CE5: LD A,9
                DB      32H,ABH,32H             ; 0CE7: LD (L32AB),A
                DB      C3H,1CH,0DH             ; 0CEA: JP L0D1C

L0CED:
                DB      B7H                     ; 0CED: OR A
                DB      CAH,43H,0DH             ; 0CEE: JP z,L0D43
                DB      22H,42H,31H             ; 0CF1: LD (0x3142),HL
                DB      2AH,40H,31H             ; 0CF4: LD HL,(0x3140)
                DB      77H                     ; 0CF7: LD (HL),A
                DB      23H                     ; 0CF8: INC HL
                DB      22H,40H,31H             ; 0CF9: LD (0x3140),HL
                DB      3AH,ABH,32H             ; 0CFC: LD A,(L32AB)
                DB      3CH                     ; 0CFF: INC A
                DB      32H,ABH,32H             ; 0D00: LD (L32AB),A
                DB      FEH,08H                 ; 0D03: CP 8
                DB      FAH,C5H,0CH             ; 0D05: JP m,L0CC5

L0D08:
                DB      32H,ACH,32H             ; 0D08: LD (0x32ac),A
                DB      2AH,42H,31H             ; 0D0B: LD HL,(0x3142)
                DB      7EH                     ; 0D0E: LD A,(HL)
                DB      23H                     ; 0D0F: INC HL
                DB      22H,42H,31H             ; 0D10: LD (0x3142),HL
                DB      B7H                     ; 0D13: OR A
                DB      CAH,43H,0DH             ; 0D14: JP z,L0D43
                DB      FEH,2EH                 ; 0D17: CP 0x2e
                DB      C2H,08H,0DH             ; 0D19: JP nz,L0D08

L0D1C:
                DB      2AH,42H,31H             ; 0D1C: LD HL,(0x3142)
                DB      7EH                     ; 0D1F: LD A,(HL)
                DB      FEH,61H                 ; 0D20: CP 0x61
                DB      FAH,27H,0DH             ; 0D22: JP m,L0D27
                DB      E6H,5FH                 ; 0D25: AND 0x5f

L0D27:
                DB      B7H                     ; 0D27: OR A
                DB      CAH,43H,0DH             ; 0D28: JP z,L0D43
                DB      23H                     ; 0D2B: INC HL
                DB      22H,42H,31H             ; 0D2C: LD (0x3142),HL
                DB      2AH,40H,31H             ; 0D2F: LD HL,(0x3140)
                DB      77H                     ; 0D32: LD (HL),A
                DB      23H                     ; 0D33: INC HL
                DB      22H,40H,31H             ; 0D34: LD (0x3140),HL
                DB      3AH,ABH,32H             ; 0D37: LD A,(L32AB)
                DB      3CH                     ; 0D3A: INC A
                DB      32H,ABH,32H             ; 0D3B: LD (L32AB),A
                DB      FEH,0CH                 ; 0D3E: CP 12
                DB      FAH,1CH,0DH             ; 0D40: JP m,L0D1C

L0D43:
                DB      2AH,42H,31H             ; 0D43: LD HL,(0x3142)
                DB      36H,24H                 ; 0D46: LD (HL),0x24
                DB      11H,F7H,2CH             ; 0D48: LD DE,0x2cf7
                DB      CDH,D0H,21H             ; 0D4B: CALL L21D0
                DB      11H,65H,31H             ; 0D4E: LD DE,0x3165
                DB      CDH,D0H,21H             ; 0D51: CALL L21D0
                DB      3AH,31H,31H             ; 0D54: LD A,(0x3131)
                DB      B7H                     ; 0D57: OR A
                DB      CAH,05H,0EH             ; 0D58: JP z,L0E05
                DB      0EH,0FH                 ; 0D5B: LD C,15
                DB      11H,5CH,00H             ; 0D5D: LD DE,0x5c
                DB      CDH,05H,00H             ; 0D60: CALL 0x0005
                DB      FEH,FFH                 ; 0D63: CP 0xff
                DB      CAH,05H,0EH             ; 0D65: JP z,L0E05
                DB      11H,C6H,23H             ; 0D68: LD DE,0x23c6
                DB      CDH,D8H,11H             ; 0D6B: CALL L11D8
                DB      3AH,ACH,32H             ; 0D6E: LD A,(0x32ac)
                DB      B7H                     ; 0D71: OR A
                DB      C2H,7BH,0DH             ; 0D72: JP nz,L0D7B
                DB      3AH,ABH,32H             ; 0D75: LD A,(L32AB)
                DB      32H,ACH,32H             ; 0D78: LD (0x32ac),A

L0D7B:
                DB      06H,00H                 ; 0D7B: LD B,0
                DB      50H                     ; 0D7D: LD D,B
                DB      3CH                     ; 0D7E: INC A
                DB      FEH,09H                 ; 0D7F: CP 9
                DB      C2H,87H,0DH             ; 0D81: JP nz,L0D87
                DB      06H,FFH                 ; 0D84: LD B,0xff
                DB      3DH                     ; 0D86: DEC A

L0D87:
                DB      5FH                     ; 0D87: LD E,A

L0D88:
                DB      21H,5CH,00H             ; 0D88: LD HL,0x5c
                DB      19H                     ; 0D8B: ADD HL,DE
                DB      36H,26H                 ; 0D8C: LD (HL),0x26
                DB      C5H                     ; 0D8E: PUSH BC
                DB      D5H                     ; 0D8F: PUSH DE
                DB      21H,5CH,00H             ; 0D90: LD HL,0x5c
                DB      0EH,0CH                 ; 0D93: LD C,12

L0D95:
                DB      7EH                     ; 0D95: LD A,(HL)
                DB      E6H,7FH                 ; 0D96: AND 0x7f
                DB      77H                     ; 0D98: LD (HL),A
                DB      23H                     ; 0D99: INC HL
                DB      0DH                     ; 0D9A: DEC C
                DB      C2H,95H,0DH             ; 0D9B: JP nz,L0D95
                DB      0EH,0FH                 ; 0D9E: LD C,15
                DB      11H,5CH,00H             ; 0DA0: LD DE,0x5c
                DB      CDH,05H,00H             ; 0DA3: CALL 0x0005
                DB      D1H                     ; 0DA6: POP DE
                DB      C1H                     ; 0DA7: POP BC
                DB      FEH,FFH                 ; 0DA8: CP 0xff
                DB      CAH,D2H,0DH             ; 0DAA: JP z,L0DD2
                DB      78H                     ; 0DAD: LD A,B
                DB      B7H                     ; 0DAE: OR A
                DB      CAH,BBH,0DH             ; 0DAF: JP z,L0DBB
                DB      1DH                     ; 0DB2: DEC E
                DB      7BH                     ; 0DB3: LD A,E
                DB      B7H                     ; 0DB4: OR A
                DB      CAH,CBH,0DH             ; 0DB5: JP z,L0DCB
                DB      C3H,88H,0DH             ; 0DB8: JP L0D88

L0DBB:
                DB      1CH                     ; 0DBB: INC E
                DB      7BH                     ; 0DBC: LD A,E
                DB      FEH,09H                 ; 0DBD: CP 9
                DB      FAH,88H,0DH             ; 0DBF: JP m,L0D88
                DB      3AH,ACH,32H             ; 0DC2: LD A,(0x32ac)
                DB      5FH                     ; 0DC5: LD E,A
                DB      06H,FFH                 ; 0DC6: LD B,0xff
                DB      C3H,88H,0DH             ; 0DC8: JP L0D88

L0DCB:
                DB      11H,3AH,23H             ; 0DCB: LD DE,0x233a
                DB      CDH,D0H,21H             ; 0DCE: CALL L21D0
                DB      C9H                     ; 0DD1: RET

L0DD2:
                DB      0EH,08H                 ; 0DD2: LD C,8
                DB      11H,8BH,32H             ; 0DD4: LD DE,0x328b
                DB      21H,5DH,00H             ; 0DD7: LD HL,0x5d
                DB      06H,00H                 ; 0DDA: LD B,0

L0DDC:
                DB      7EH                     ; 0DDC: LD A,(HL)
                DB      23H                     ; 0DDD: INC HL
                DB      FEH,20H                 ; 0DDE: CP 0x20
                DB      CAH,E9H,0DH             ; 0DE0: JP z,L0DE9
                DB      12H                     ; 0DE3: LD (DE),A
                DB      13H                     ; 0DE4: INC DE
                DB      0DH                     ; 0DE5: DEC C
                DB      C2H,DCH,0DH             ; 0DE6: JP nz,L0DDC

L0DE9:
                DB      78H                     ; 0DE9: LD A,B
                DB      B7H                     ; 0DEA: OR A
                DB      C2H,FCH,0DH             ; 0DEB: JP nz,L0DFC
                DB      3EH,2EH                 ; 0DEE: LD A,0x2e
                DB      12H                     ; 0DF0: LD (DE),A
                DB      13H                     ; 0DF1: INC DE
                DB      06H,FFH                 ; 0DF2: LD B,0xff
                DB      0EH,03H                 ; 0DF4: LD C,3
                DB      21H,65H,00H             ; 0DF6: LD HL,0x65
                DB      C3H,DCH,0DH             ; 0DF9: JP L0DDC

L0DFC:
                DB      3EH,24H                 ; 0DFC: LD A,0x24
                DB      12H                     ; 0DFE: LD (DE),A
                DB      11H,8BH,32H             ; 0DFF: LD DE,0x328b
                DB      CDH,D0H,21H             ; 0E02: CALL L21D0

L0E05:
                DB      0EH,13H                 ; 0E05: LD C,0x13
                DB      11H,5CH,00H             ; 0E07: LD DE,0x5c
                DB      CDH,05H,00H             ; 0E0A: CALL 0x0005
                DB      AFH                     ; 0E0D: XOR A
                DB      32H,68H,00H             ; 0E0E: LD (0x0068),A
                DB      32H,6AH,00H             ; 0E11: LD (0x006a),A
                DB      32H,7CH,00H             ; 0E14: LD (0x007c),A
                DB      0EH,16H                 ; 0E17: LD C,0x16
                DB      11H,5CH,00H             ; 0E19: LD DE,0x5c
                DB      CDH,05H,00H             ; 0E1C: CALL 0x0005
                DB      FEH,FFH                 ; 0E1F: CP 0xff
                DB      C2H,A3H,1BH             ; 0E21: JP nz,L1BA3
                DB      11H,DEH,22H             ; 0E24: LD DE,0x22de
                DB      CDH,D8H,11H             ; 0E27: CALL L11D8
                DB      C9H                     ; 0E2A: RET

L0E2B:
                DB      32H,B1H,32H             ; 0E2B: LD (0x32b1),A
                DB      21H,61H,31H             ; 0E2E: LD HL,0x3161
                DB      3EH,01H                 ; 0E31: LD A,1
                DB      77H                     ; 0E33: LD (HL),A
                DB      23H                     ; 0E34: INC HL
                DB      3AH,56H,31H             ; 0E35: LD A,(0x3156)
                DB      D6H,31H                 ; 0E38: SUB 0x31
                DB      47H                     ; 0E3A: LD B,A
                DB      3AH,B0H,32H             ; 0E3B: LD A,(0x32b0)
                DB      C6H,23H                 ; 0E3E: ADD A,0x23
                DB      80H                     ; 0E40: ADD A,B
                DB      77H                     ; 0E41: LD (HL),A
                DB      23H                     ; 0E42: INC HL
                DB      01H,00H,00H             ; 0E43: LD BC,0
                DB      4FH                     ; 0E46: LD C,A
                DB      3AH,AFH,32H             ; 0E47: LD A,(0x32af)
                DB      C6H,20H                 ; 0E4A: ADD A,0x20
                DB      77H                     ; 0E4C: LD (HL),A
                DB      23H                     ; 0E4D: INC HL
                DB      81H                     ; 0E4E: ADD A,C
                DB      4FH                     ; 0E4F: LD C,A
                DB      3EH,00H                 ; 0E50: LD A,0
                DB      88H                     ; 0E52: ADC A,B
                DB      47H                     ; 0E53: LD B,A
                DB      3AH,B1H,32H             ; 0E54: LD A,(0x32b1)
                DB      77H                     ; 0E57: LD (HL),A
                DB      23H                     ; 0E58: INC HL
                DB      81H                     ; 0E59: ADD A,C
                DB      4FH                     ; 0E5A: LD C,A
                DB      3EH,00H                 ; 0E5B: LD A,0
                DB      88H                     ; 0E5D: ADC A,B
                DB      47H                     ; 0E5E: LD B,A

L0E5F:
                DB      3AH,B0H,32H             ; 0E5F: LD A,(0x32b0)
                DB      B7H                     ; 0E62: OR A
                DB      CAH,75H,0EH             ; 0E63: JP z,L0E75
                DB      3DH                     ; 0E66: DEC A
                DB      32H,B0H,32H             ; 0E67: LD (0x32b0),A
                DB      7EH                     ; 0E6A: LD A,(HL)
                DB      23H                     ; 0E6B: INC HL
                DB      81H                     ; 0E6C: ADD A,C
                DB      4FH                     ; 0E6D: LD C,A
                DB      3EH,00H                 ; 0E6E: LD A,0
                DB      88H                     ; 0E70: ADC A,B
                DB      47H                     ; 0E71: LD B,A
                DB      C3H,5FH,0EH             ; 0E72: JP L0E5F

L0E75:
                DB      3AH,56H,31H             ; 0E75: LD A,(0x3156)
                DB      FEH,32H                 ; 0E78: CP 0x32
                DB      CAH,A6H,0EH             ; 0E7A: JP z,L0EA6
                DB      D2H,8FH,0EH             ; 0E7D: JP nc,L0E8F
                DB      79H                     ; 0E80: LD A,C
                DB      E6H,C0H                 ; 0E81: AND 0xc0
                DB      07H                     ; 0E83: RLCA
                DB      07H                     ; 0E84: RLCA
                DB      81H                     ; 0E85: ADD A,C
                DB      E6H,3FH                 ; 0E86: AND 0x3f
                DB      C6H,20H                 ; 0E88: ADD A,0x20
                DB      77H                     ; 0E8A: LD (HL),A
                DB      23H                     ; 0E8B: INC HL
                DB      C3H,BDH,0EH             ; 0E8C: JP L0EBD

L0E8F:
                DB      36H,00H                 ; 0E8F: LD (HL),0
                DB      E5H                     ; 0E91: PUSH HL
                DB      21H,62H,31H             ; 0E92: LD HL,0x3162
                DB      CDH,3DH,11H             ; 0E95: CALL L113D
                DB      E1H                     ; 0E98: POP HL
                DB      4BH                     ; 0E99: LD C,E
                DB      42H                     ; 0E9A: LD B,D
                DB      7AH                     ; 0E9B: LD A,D
                DB      07H                     ; 0E9C: RLCA
                DB      07H                     ; 0E9D: RLCA
                DB      07H                     ; 0E9E: RLCA
                DB      07H                     ; 0E9F: RLCA
                DB      E6H,0FH                 ; 0EA0: AND 15
                DB      C6H,20H                 ; 0EA2: ADD A,0x20
                DB      77H                     ; 0EA4: LD (HL),A
                DB      23H                     ; 0EA5: INC HL

L0EA6:
                DB      78H                     ; 0EA6: LD A,B
                DB      E6H,0FH                 ; 0EA7: AND 15
                DB      07H                     ; 0EA9: RLCA
                DB      07H                     ; 0EAA: RLCA
                DB      47H                     ; 0EAB: LD B,A
                DB      79H                     ; 0EAC: LD A,C
                DB      07H                     ; 0EAD: RLCA
                DB      07H                     ; 0EAE: RLCA
                DB      E6H,03H                 ; 0EAF: AND 3
                DB      B0H                     ; 0EB1: OR B
                DB      C6H,20H                 ; 0EB2: ADD A,0x20
                DB      77H                     ; 0EB4: LD (HL),A
                DB      23H                     ; 0EB5: INC HL
                DB      79H                     ; 0EB6: LD A,C
                DB      E6H,3FH                 ; 0EB7: AND 0x3f
                DB      C6H,20H                 ; 0EB9: ADD A,0x20
                DB      77H                     ; 0EBB: LD (HL),A
                DB      23H                     ; 0EBC: INC HL

L0EBD:
                DB      3AH,51H,31H             ; 0EBD: LD A,(0x3151)
                DB      77H                     ; 0EC0: LD (HL),A
                DB      23H                     ; 0EC1: INC HL
                DB      AFH                     ; 0EC2: XOR A
                DB      77H                     ; 0EC3: LD (HL),A
                DB      CDH,CDH,0EH             ; 0EC4: CALL L0ECD
                DB      C3H,A8H,1BH             ; 0EC7: JP L1BA8
                DB      C3H,A3H,1BH             ; 0ECA: JP L1BA3

L0ECD:
                DB      3AH,4DH,31H             ; 0ECD: LD A,(L314D)
                DB      32H,ABH,32H             ; 0ED0: LD (L32AB),A

L0ED3:
                DB      3AH,ABH,32H             ; 0ED3: LD A,(L32AB)
                DB      3DH                     ; 0ED6: DEC A
                DB      B7H                     ; 0ED7: OR A
                DB      FAH,E8H,0EH             ; 0ED8: JP m,L0EE8
                DB      32H,ABH,32H             ; 0EDB: LD (L32AB),A
                DB      3AH,4FH,31H             ; 0EDE: LD A,(0x314f)
                DB      5FH                     ; 0EE1: LD E,A
                DB      CDH,3BH,0FH             ; 0EE2: CALL ComOutputWait
                DB      C3H,D3H,0EH             ; 0EE5: JP L0ED3

L0EE8:
                DB      21H,61H,31H             ; 0EE8: LD HL,0x3161

L0EEB:
                DB      7EH                     ; 0EEB: LD A,(HL)
                DB      B7H                     ; 0EEC: OR A
                DB      CAH,F8H,0EH             ; 0EED: JP z,L0EF8
                DB      5FH                     ; 0EF0: LD E,A
                DB      CDH,3BH,0FH             ; 0EF1: CALL ComOutputWait
                DB      23H                     ; 0EF4: INC HL
                DB      C3H,EBH,0EH             ; 0EF5: JP L0EEB

L0EF8:
                DB      C3H,A3H,1BH             ; 0EF8: JP L1BA3

L0EFB:
                DB      E5H                     ; 0EFB: PUSH HL
                DB      C5H                     ; 0EFC: PUSH BC
                DB      21H,34H,31H             ; 0EFD: LD HL,0x3134
                DB      4EH                     ; 0F00: LD C,(HL)
                DB      06H,00H                 ; 0F01: LD B,0
                DB      21H,08H,0FH             ; 0F03: LD HL,0xf08
                DB      09H                     ; 0F06: ADD HL,BC
                DB      E9H                     ; 0F07: JP (HL)
                DB      C3H,1AH,0FH             ; 0F08: JP L0F1A
                DB      C3H,24H,0FH             ; 0F0B: JP L0F24
                DB      C3H,17H,0FH             ; 0F0E: JP L0F17
                DB      C3H,29H,0FH             ; 0F11: JP L0F29
                DB      C3H,33H,0FH             ; 0F14: JP L0F33

L0F17:
                DB      C3H,38H,0FH             ; 0F17: JP L0F38

L0F1A:
                DB      E6H,7FH                 ; 0F1A: AND 0x7f
                DB      EAH,38H,0FH             ; 0F1C: JP pe,L0F38
                DB      F6H,80H                 ; 0F1F: OR 0x80
                DB      C3H,38H,0FH             ; 0F21: JP L0F38

L0F24:
                DB      F6H,80H                 ; 0F24: OR 0x80
                DB      C3H,38H,0FH             ; 0F26: JP L0F38

L0F29:
                DB      E6H,7FH                 ; 0F29: AND 0x7f
                DB      E2H,38H,0FH             ; 0F2B: JP po,L0F38
                DB      F6H,80H                 ; 0F2E: OR 0x80
                DB      C3H,38H,0FH             ; 0F30: JP L0F38

L0F33:
                DB      E6H,7FH                 ; 0F33: AND 0x7f
                DB      C3H,38H,0FH             ; 0F35: JP L0F38

L0F38:
                DB      C1H                     ; 0F38: POP BC
                DB      E1H                     ; 0F39: POP HL
                DB      C9H                     ; 0F3A: RET

ComOutputWait:
; Bondwell SIO0 transmitter-ready loop. Port 41H, status bit 2.
                DB      DBH,41H                 ; 0F3B: IN A,(0x0041)
                DB      E6H,04H                 ; 0F3D: AND 4
                DB      CAH,3BH,0FH             ; 0F3F: JP z,ComOutputWait
                DB      7BH                     ; 0F42: LD A,E
                DB      CDH,FBH,0EH             ; 0F43: CALL L0EFB

ComOutputByte:
; Write character in A to Bondwell SIO0 data port 40H.
                DB      D3H,40H                 ; 0F46: OUT (0x0040),A
                DB      C9H                     ; 0F48: RET

ComInput:
; Communications input routine, including CP/M console abort checking.
                DB      21H,00H,00H             ; 0F49: LD HL,0
                DB      22H,28H,31H             ; 0F4C: LD (0x3128),HL

ComInputPoll:
; Bondwell SIO0 receive-ready poll. Port 41H, status bit 0.
                DB      DBH,41H                 ; 0F4F: IN A,(0x0041)
                DB      E6H,01H                 ; 0F51: AND 1
                DB      C2H,93H,0FH             ; 0F53: JP nz,ComInputByte
                DB      0EH,0BH                 ; 0F56: LD C,11
                DB      CDH,05H,00H             ; 0F58: CALL 0x0005
                DB      B7H                     ; 0F5B: OR A
                DB      CAH,7CH,0FH             ; 0F5C: JP z,L0F7C
                DB      0EH,01H                 ; 0F5F: LD C,1
                DB      CDH,05H,00H             ; 0F61: CALL 0x0005
                DB      FEH,0DH                 ; 0F64: CP 13
                DB      C8H                     ; 0F66: RET z
                DB      FEH,1AH                 ; 0F67: CP 0x1a
                DB      CAH,76H,0FH             ; 0F69: JP z,L0F76
                DB      FEH,03H                 ; 0F6C: CP 3
                DB      CAH,09H,01H             ; 0F6E: JP z,KermitExit
                DB      FEH,18H                 ; 0F71: CP 0x18
                DB      C2H,7CH,0FH             ; 0F73: JP nz,L0F7C

L0F76:
                DB      C6H,40H                 ; 0F76: ADD A,0x40
                DB      32H,58H,31H             ; 0F78: LD (0x3158),A
                DB      C9H                     ; 0F7B: RET

L0F7C:
                DB      3AH,27H,31H             ; 0F7C: LD A,(L3127)
                DB      B7H                     ; 0F7F: OR A
                DB      CAH,4FH,0FH             ; 0F80: JP z,ComInputPoll
                DB      2AH,28H,31H             ; 0F83: LD HL,(0x3128)
                DB      23H                     ; 0F86: INC HL
                DB      22H,28H,31H             ; 0F87: LD (0x3128),HL
                DB      7CH                     ; 0F8A: LD A,H
                DB      B5H                     ; 0F8B: OR L
                DB      C2H,4FH,0FH             ; 0F8C: JP nz,ComInputPoll
                DB      CDH,F4H,02H             ; 0F8F: CALL L02F4
                DB      C9H                     ; 0F92: RET

ComInputByte:
; Read one byte from Bondwell SIO0 data port 40H.
                DB      DBH,40H                 ; 0F93: IN A,(0x0040)
                DB      47H                     ; 0F95: LD B,A
                DB      3AH,34H,31H             ; 0F96: LD A,(0x3134)
                DB      FEH,06H                 ; 0F99: CP 6
                DB      78H                     ; 0F9B: LD A,B
                DB      CAH,A3H,1BH             ; 0F9C: JP z,L1BA3
                DB      E6H,7FH                 ; 0F9F: AND 0x7f
                DB      C3H,A3H,1BH             ; 0FA1: JP L1BA3

L0FA4:
                DB      CDH,CBH,10H             ; 0FA4: CALL L10CB
                DB      C3H,A8H,1BH             ; 0FA7: JP L1BA8

L0FAA:
                DB      CDH,2FH,11H             ; 0FAA: CALL L112F
                DB      C3H,A4H,0FH             ; 0FAD: JP L0FA4
                DB      FEH,01H                 ; 0FB0: CP 1
                DB      C2H,AAH,0FH             ; 0FB2: JP nz,L0FAA

L0FB5:
                DB      CDH,2FH,11H             ; 0FB5: CALL L112F
                DB      C3H,A8H,1BH             ; 0FB8: JP L1BA8
                DB      FEH,01H                 ; 0FBB: CP 1
                DB      CAH,B5H,0FH             ; 0FBD: JP z,L0FB5
                DB      32H,62H,31H             ; 0FC0: LD (0x3162),A
                DB      4FH                     ; 0FC3: LD C,A
                DB      3AH,56H,31H             ; 0FC4: LD A,(0x3156)
                DB      D6H,31H                 ; 0FC7: SUB 0x31
                DB      47H                     ; 0FC9: LD B,A
                DB      79H                     ; 0FCA: LD A,C
                DB      D6H,23H                 ; 0FCB: SUB 0x23
                DB      90H                     ; 0FCD: SUB B
                DB      32H,B0H,32H             ; 0FCE: LD (0x32b0),A
                DB      06H,00H                 ; 0FD1: LD B,0
                DB      CDH,2FH,11H             ; 0FD3: CALL L112F
                DB      C3H,A8H,1BH             ; 0FD6: JP L1BA8
                DB      FEH,01H                 ; 0FD9: CP 1
                DB      CAH,B5H,0FH             ; 0FDB: JP z,L0FB5
                DB      32H,AFH,32H             ; 0FDE: LD (0x32af),A
                DB      32H,63H,31H             ; 0FE1: LD (0x3163),A
                DB      81H                     ; 0FE4: ADD A,C
                DB      4FH                     ; 0FE5: LD C,A
                DB      3EH,00H                 ; 0FE6: LD A,0
                DB      88H                     ; 0FE8: ADC A,B
                DB      47H                     ; 0FE9: LD B,A
                DB      3AH,AFH,32H             ; 0FEA: LD A,(0x32af)
                DB      D6H,20H                 ; 0FED: SUB 0x20
                DB      32H,AFH,32H             ; 0FEF: LD (0x32af),A
                DB      CDH,2FH,11H             ; 0FF2: CALL L112F
                DB      C3H,A8H,1BH             ; 0FF5: JP L1BA8
                DB      FEH,01H                 ; 0FF8: CP 1
                DB      CAH,B5H,0FH             ; 0FFA: JP z,L0FB5
                DB      32H,ABH,32H             ; 0FFD: LD (L32AB),A
                DB      32H,64H,31H             ; 1000: LD (0x3164),A
                DB      81H                     ; 1003: ADD A,C
                DB      4FH                     ; 1004: LD C,A
                DB      3EH,00H                 ; 1005: LD A,0
                DB      88H                     ; 1007: ADC A,B
                DB      47H                     ; 1008: LD B,A
                DB      3AH,B0H,32H             ; 1009: LD A,(0x32b0)
                DB      32H,ACH,32H             ; 100C: LD (0x32ac),A
                DB      21H,65H,31H             ; 100F: LD HL,0x3165
                DB      22H,42H,31H             ; 1012: LD (0x3142),HL

L1015:
                DB      3AH,ACH,32H             ; 1015: LD A,(0x32ac)
                DB      D6H,01H                 ; 1018: SUB 1
                DB      FAH,3CH,10H             ; 101A: JP m,L103C
                DB      32H,ACH,32H             ; 101D: LD (0x32ac),A
                DB      CDH,2FH,11H             ; 1020: CALL L112F
                DB      C3H,A8H,1BH             ; 1023: JP L1BA8
                DB      FEH,01H                 ; 1026: CP 1
                DB      CAH,B5H,0FH             ; 1028: JP z,L0FB5
                DB      2AH,42H,31H             ; 102B: LD HL,(0x3142)
                DB      77H                     ; 102E: LD (HL),A
                DB      23H                     ; 102F: INC HL
                DB      22H,42H,31H             ; 1030: LD (0x3142),HL
                DB      81H                     ; 1033: ADD A,C
                DB      4FH                     ; 1034: LD C,A
                DB      3EH,00H                 ; 1035: LD A,0
                DB      88H                     ; 1037: ADC A,B
                DB      47H                     ; 1038: LD B,A
                DB      C3H,15H,10H             ; 1039: JP L1015

L103C:
                DB      CDH,2FH,11H             ; 103C: CALL L112F
                DB      C3H,A8H,1BH             ; 103F: JP L1BA8
                DB      FEH,01H                 ; 1042: CP 1
                DB      CAH,B5H,0FH             ; 1044: JP z,L0FB5
                DB      D6H,20H                 ; 1047: SUB 0x20
                DB      32H,ADH,32H             ; 1049: LD (0x32ad),A
                DB      3AH,56H,31H             ; 104C: LD A,(0x3156)
                DB      FEH,32H                 ; 104F: CP 0x32
                DB      CAH,97H,10H             ; 1051: JP z,L1097
                DB      D2H,6BH,10H             ; 1054: JP nc,L106B
                DB      79H                     ; 1057: LD A,C
                DB      E6H,C0H                 ; 1058: AND 0xc0
                DB      07H                     ; 105A: RLCA
                DB      07H                     ; 105B: RLCA
                DB      81H                     ; 105C: ADD A,C
                DB      E6H,3FH                 ; 105D: AND 0x3f
                DB      47H                     ; 105F: LD B,A
                DB      3AH,ADH,32H             ; 1060: LD A,(0x32ad)
                DB      B8H                     ; 1063: CP B
                DB      CAH,C0H,10H             ; 1064: JP z,L10C0

L1067:
                DB      CDH,F4H,02H             ; 1067: CALL L02F4
                DB      C9H                     ; 106A: RET

L106B:
                DB      2AH,42H,31H             ; 106B: LD HL,(0x3142)
                DB      36H,00H                 ; 106E: LD (HL),0
                DB      21H,62H,31H             ; 1070: LD HL,0x3162
                DB      CDH,3DH,11H             ; 1073: CALL L113D
                DB      4BH                     ; 1076: LD C,E
                DB      42H                     ; 1077: LD B,D
                DB      7AH                     ; 1078: LD A,D
                DB      07H                     ; 1079: RLCA
                DB      07H                     ; 107A: RLCA
                DB      07H                     ; 107B: RLCA
                DB      07H                     ; 107C: RLCA
                DB      E6H,0FH                 ; 107D: AND 15
                DB      57H                     ; 107F: LD D,A
                DB      3AH,ADH,32H             ; 1080: LD A,(0x32ad)
                DB      BAH                     ; 1083: CP D
                DB      C2H,67H,10H             ; 1084: JP nz,L1067
                DB      CDH,2FH,11H             ; 1087: CALL L112F
                DB      C3H,A8H,1BH             ; 108A: JP L1BA8
                DB      FEH,01H                 ; 108D: CP 1
                DB      CAH,B5H,0FH             ; 108F: JP z,L0FB5
                DB      D6H,20H                 ; 1092: SUB 0x20
                DB      32H,ADH,32H             ; 1094: LD (0x32ad),A

L1097:
                DB      78H                     ; 1097: LD A,B
                DB      E6H,0FH                 ; 1098: AND 15
                DB      07H                     ; 109A: RLCA
                DB      07H                     ; 109B: RLCA
                DB      47H                     ; 109C: LD B,A
                DB      79H                     ; 109D: LD A,C
                DB      07H                     ; 109E: RLCA
                DB      07H                     ; 109F: RLCA
                DB      E6H,03H                 ; 10A0: AND 3
                DB      B0H                     ; 10A2: OR B
                DB      47H                     ; 10A3: LD B,A
                DB      3AH,ADH,32H             ; 10A4: LD A,(0x32ad)
                DB      B8H                     ; 10A7: CP B
                DB      C2H,67H,10H             ; 10A8: JP nz,L1067
                DB      CDH,2FH,11H             ; 10AB: CALL L112F
                DB      C3H,A8H,1BH             ; 10AE: JP L1BA8
                DB      FEH,01H                 ; 10B1: CP 1
                DB      CAH,B5H,0FH             ; 10B3: JP z,L0FB5
                DB      D6H,20H                 ; 10B6: SUB 0x20
                DB      47H                     ; 10B8: LD B,A
                DB      79H                     ; 10B9: LD A,C
                DB      E6H,3FH                 ; 10BA: AND 0x3f
                DB      B8H                     ; 10BC: CP B
                DB      C2H,67H,10H             ; 10BD: JP nz,L1067

L10C0:
                DB      2AH,42H,31H             ; 10C0: LD HL,(0x3142)
                DB      36H,00H                 ; 10C3: LD (HL),0
                DB      3AH,ABH,32H             ; 10C5: LD A,(L32AB)
                DB      C3H,A3H,1BH             ; 10C8: JP L1BA3

L10CB:
                DB      21H,BFH,31H             ; 10CB: LD HL,0x31bf
                DB      22H,46H,31H             ; 10CE: LD (0x3146),HL

L10D1:
                DB      CDH,49H,0FH             ; 10D1: CALL ComInput
                DB      C3H,A8H,1BH             ; 10D4: JP L1BA8
                DB      FEH,01H                 ; 10D7: CP 1
                DB      C2H,D1H,10H             ; 10D9: JP nz,L10D1
                DB      C3H,F0H,10H             ; 10DC: JP L10F0

L10DF:
                DB      CDH,49H,0FH             ; 10DF: CALL ComInput
                DB      C3H,A8H,1BH             ; 10E2: JP L1BA8
                DB      FEH,01H                 ; 10E5: CP 1
                DB      C2H,F0H,10H             ; 10E7: JP nz,L10F0
                DB      21H,BFH,31H             ; 10EA: LD HL,0x31bf
                DB      22H,46H,31H             ; 10ED: LD (0x3146),HL

L10F0:
                DB      2AH,46H,31H             ; 10F0: LD HL,(0x3146)
                DB      77H                     ; 10F3: LD (HL),A
                DB      23H                     ; 10F4: INC HL
                DB      22H,46H,31H             ; 10F5: LD (0x3146),HL
                DB      47H                     ; 10F8: LD B,A
                DB      11H,DCH,CDH             ; 10F9: LD DE,0xcddc
                DB      19H                     ; 10FC: ADD HL,DE
                DB      DAH,CBH,10H             ; 10FD: JP c,L10CB
                DB      3AH,52H,31H             ; 1100: LD A,(0x3152)
                DB      B8H                     ; 1103: CP B
                DB      C2H,DFH,10H             ; 1104: JP nz,L10DF
                DB      3AH,32H,31H             ; 1107: LD A,(L3132)
                DB      B7H                     ; 110A: OR A
                DB      CAH,21H,11H             ; 110B: JP z,L1121
                DB      3AH,60H,31H             ; 110E: LD A,(0x3160)
                DB      FEH,53H                 ; 1111: CP 0x53
                DB      CAH,21H,11H             ; 1113: JP z,L1121

L1116:
                DB      CDH,49H,0FH             ; 1116: CALL ComInput
                DB      C3H,21H,11H             ; 1119: JP L1121
                DB      FEH,11H                 ; 111C: CP 0x11
                DB      C2H,16H,11H             ; 111E: JP nz,L1116

L1121:
                DB      2AH,46H,31H             ; 1121: LD HL,(0x3146)
                DB      36H,0DH                 ; 1124: LD (HL),13
                DB      21H,BFH,31H             ; 1126: LD HL,0x31bf
                DB      22H,46H,31H             ; 1129: LD (0x3146),HL
                DB      C3H,A3H,1BH             ; 112C: JP L1BA3

L112F:
                DB      2AH,46H,31H             ; 112F: LD HL,(0x3146)
                DB      7EH                     ; 1132: LD A,(HL)
                DB      23H                     ; 1133: INC HL
                DB      22H,46H,31H             ; 1134: LD (0x3146),HL
                DB      FEH,0DH                 ; 1137: CP 13
                DB      C2H,A3H,1BH             ; 1139: JP nz,L1BA3
                DB      C9H                     ; 113C: RET

L113D:
                DB      E5H                     ; 113D: PUSH HL
                DB      C5H                     ; 113E: PUSH BC
                DB      11H,00H,00H             ; 113F: LD DE,0

L1142:
                DB      7EH                     ; 1142: LD A,(HL)
                DB      B7H                     ; 1143: OR A
                DB      CAH,70H,11H             ; 1144: JP z,L1170
                DB      E5H                     ; 1147: PUSH HL
                DB      ABH                     ; 1148: XOR E
                DB      5FH                     ; 1149: LD E,A
                DB      E6H,0FH                 ; 114A: AND 15
                DB      4FH                     ; 114C: LD C,A
                DB      06H,00H                 ; 114D: LD B,0
                DB      21H,93H,11H             ; 114F: LD HL,0x1193
                DB      09H                     ; 1152: ADD HL,BC
                DB      09H                     ; 1153: ADD HL,BC
                DB      E5H                     ; 1154: PUSH HL
                DB      7BH                     ; 1155: LD A,E
                DB      0FH                     ; 1156: RRCA
                DB      0FH                     ; 1157: RRCA
                DB      0FH                     ; 1158: RRCA
                DB      E6H,1EH                 ; 1159: AND 0x1e
                DB      4FH                     ; 115B: LD C,A
                DB      21H,73H,11H             ; 115C: LD HL,0x1173
                DB      09H                     ; 115F: ADD HL,BC
                DB      7EH                     ; 1160: LD A,(HL)
                DB      AAH                     ; 1161: XOR D
                DB      23H                     ; 1162: INC HL
                DB      56H                     ; 1163: LD D,(HL)
                DB      E1H                     ; 1164: POP HL
                DB      AEH                     ; 1165: XOR (HL)
                DB      5FH                     ; 1166: LD E,A
                DB      23H                     ; 1167: INC HL
                DB      7EH                     ; 1168: LD A,(HL)
                DB      AAH                     ; 1169: XOR D
                DB      57H                     ; 116A: LD D,A
                DB      E1H                     ; 116B: POP HL
                DB      23H                     ; 116C: INC HL
                DB      C3H,42H,11H             ; 116D: JP L1142

L1170:
                DB      C1H                     ; 1170: POP BC
                DB      E1H                     ; 1171: POP HL
                DB      C9H                     ; 1172: RET
                DB      00H                     ; 1173: NOP
                DB      00H                     ; 1174: NOP
                DB      81H                     ; 1175: ADD A,C
                DB      10H,02H                 ; 1176: DJNZ L117A
                DB      21H,83H,31H             ; 1178: LD HL,0x3183
                DB      04H                     ; 117B: INC B
                DB      42H                     ; 117C: LD B,D
                DB      85H                     ; 117D: ADD A,L
                DB      52H                     ; 117E: LD D,D
                DB      06H,63H                 ; 117F: LD B,0x63
                DB      87H                     ; 1181: ADD A,A
                DB      73H                     ; 1182: LD (HL),E
                DB      08H                     ; 1183: EX AF,AF'
                DB      84H                     ; 1184: ADD A,H
                DB      89H                     ; 1185: ADC A,C
                DB      94H                     ; 1186: SUB H
                DB      0AH                     ; 1187: LD A,(BC)
                DB      A5H                     ; 1188: AND L
                DB      8BH                     ; 1189: ADC A,E
                DB      B5H                     ; 118A: OR L
                DB      0CH                     ; 118B: INC C
                DB      C6H,8DH                 ; 118C: ADD A,0x8d
                DB      D6H,0EH                 ; 118E: SUB 14
                DB      E7H                     ; 1190: RST 0x20
                DB      8FH                     ; 1191: ADC A,A
                DB      F7H                     ; 1192: RST 0x30
                DB      00H                     ; 1193: NOP
                DB      00H                     ; 1194: NOP
                DB      89H                     ; 1195: ADC A,C
                DB      11H,12H,23H             ; 1196: LD DE,0x2312
                DB      9BH                     ; 1199: SBC A,E
                DB      32H,24H,46H             ; 119A: LD (0x4624),A
                DB      ADH                     ; 119D: XOR L
                DB      57H                     ; 119E: LD D,A
                DB      36H,65H                 ; 119F: LD (HL),0x65
                DB      BFH                     ; 11A1: CP A
                DB      74H                     ; 11A2: LD (HL),H
                DB      48H                     ; 11A3: LD C,B
                DB      8CH                     ; 11A4: ADC A,H
                DB      C1H                     ; 11A5: POP BC
                DB      9DH                     ; 11A6: SBC A,L
                DB      5AH                     ; 11A7: LD E,D
                DB      AFH                     ; 11A8: XOR A
                DB      D3H,BEH                 ; 11A9: OUT (0x00be),A
                DB      6CH                     ; 11AB: LD L,H
                DB      CAH,E5H,DBH             ; 11AC: JP z,0xdbe5
                DB      7EH                     ; 11AF: LD A,(HL)
                DB      E9H                     ; 11B0: JP (HL)
                DB      F7H                     ; 11B1: RST 0x30
                DB      F8H                     ; 11B2: RET m

L11B3:
                DB      CDH,E7H,11H             ; 11B3: CALL L11E7
                DB      3EH,41H                 ; 11B6: LD A,0x41
                DB      32H,60H,31H             ; 11B8: LD (0x3160),A
                DB      C3H,C4H,11H             ; 11BB: JP L11C4

L11BE:
                DB      11H,25H,22H             ; 11BE: LD DE,0x2225
                DB      CDH,D0H,21H             ; 11C1: CALL L21D0

L11C4:
                DB      3AH,B0H,32H             ; 11C4: LD A,(0x32b0)
                DB      4FH                     ; 11C7: LD C,A
                DB      06H,00H                 ; 11C8: LD B,0
                DB      21H,65H,31H             ; 11CA: LD HL,0x3165
                DB      09H                     ; 11CD: ADD HL,BC
                DB      3EH,24H                 ; 11CE: LD A,0x24
                DB      77H                     ; 11D0: LD (HL),A
                DB      11H,65H,31H             ; 11D1: LD DE,0x3165
                DB      CDH,D0H,21H             ; 11D4: CALL L21D0
                DB      C9H                     ; 11D7: RET

L11D8:
                DB      D5H                     ; 11D8: PUSH DE
                DB      CDH,E7H,11H             ; 11D9: CALL L11E7
                DB      11H,E7H,2CH             ; 11DC: LD DE,0x2ce7
                DB      CDH,D0H,21H             ; 11DF: CALL L21D0
                DB      D1H                     ; 11E2: POP DE
                DB      CDH,D0H,21H             ; 11E3: CALL L21D0
                DB      C9H                     ; 11E6: RET

L11E7:
                DB      11H,07H,2DH             ; 11E7: LD DE,0x2d07
                DB      CDH,D0H,21H             ; 11EA: CALL L21D0
                DB      C9H                     ; 11ED: RET

L11EE:
                DB      D5H                     ; 11EE: PUSH DE
                DB      11H,FDH,2CH             ; 11EF: LD DE,0x2cfd
                DB      CDH,D0H,21H             ; 11F2: CALL L21D0
                DB      D1H                     ; 11F5: POP DE
                DB      CDH,D0H,21H             ; 11F6: CALL L21D0
                DB      11H,02H,2DH             ; 11F9: LD DE,0x2d02
                DB      CDH,D0H,21H             ; 11FC: CALL L21D0
                DB      C9H                     ; 11FF: RET

L1200:
                DB      CDH,F0H,1BH             ; 1200: CALL L1BF0
                DB      AFH                     ; 1203: XOR A
                DB      32H,5EH,31H             ; 1204: LD (0x315e),A
                DB      3EH,31H                 ; 1207: LD A,0x31
                DB      32H,56H,31H             ; 1209: LD (0x3156),A

L120C:
                DB      3AH,5EH,31H             ; 120C: LD A,(0x315e)
                DB      FEH,05H                 ; 120F: CP 5
                DB      FAH,1DH,12H             ; 1211: JP m,L121D

L1214:
                DB      11H,5EH,23H             ; 1214: LD DE,0x235e
                DB      CDH,D0H,21H             ; 1217: CALL L21D0
                DB      C3H,2EH,01H             ; 121A: JP L012E

L121D:
                DB      3CH                     ; 121D: INC A
                DB      32H,5EH,31H             ; 121E: LD (0x315e),A
                DB      AFH                     ; 1221: XOR A
                DB      32H,AFH,32H             ; 1222: LD (0x32af),A
                DB      3EH,01H                 ; 1225: LD A,1
                DB      32H,B0H,32H             ; 1227: LD (0x32b0),A
                DB      21H,65H,31H             ; 122A: LD HL,0x3165
                DB      36H,46H                 ; 122D: LD (HL),0x46
                DB      3EH,47H                 ; 122F: LD A,0x47
                DB      CDH,2BH,0EH             ; 1231: CALL L0E2B
                DB      C3H,14H,12H             ; 1234: JP L1214
                DB      CDH,A4H,0FH             ; 1237: CALL L0FA4
                DB      C3H,0CH,12H             ; 123A: JP L120C
                DB      FEH,59H                 ; 123D: CP 0x59
                DB      CAH,2EH,01H             ; 123F: JP z,L012E
                DB      FEH,45H                 ; 1242: CP 0x45
                DB      C2H,0CH,12H             ; 1244: JP nz,L120C
                DB      CDH,BEH,11H             ; 1247: CALL L11BE
                DB      C3H,2EH,01H             ; 124A: JP L012E

L124D:
                DB      CDH,F0H,1BH             ; 124D: CALL L1BF0
                DB      CDH,59H,12H             ; 1250: CALL L1259
                DB      C3H,2EH,01H             ; 1253: JP L012E
                DB      C3H,2EH,01H             ; 1256: JP L012E

L1259:
                DB      AFH                     ; 1259: XOR A
                DB      32H,5EH,31H             ; 125A: LD (0x315e),A
                DB      3EH,31H                 ; 125D: LD A,0x31
                DB      32H,56H,31H             ; 125F: LD (0x3156),A

L1262:
                DB      3AH,5EH,31H             ; 1262: LD A,(0x315e)
                DB      FEH,05H                 ; 1265: CP 5
                DB      FAH,71H,12H             ; 1267: JP m,L1271

L126A:
                DB      11H,92H,23H             ; 126A: LD DE,0x2392
                DB      CDH,D0H,21H             ; 126D: CALL L21D0
                DB      C9H                     ; 1270: RET

L1271:
                DB      3CH                     ; 1271: INC A
                DB      32H,5EH,31H             ; 1272: LD (0x315e),A
                DB      AFH                     ; 1275: XOR A
                DB      32H,AFH,32H             ; 1276: LD (0x32af),A
                DB      3EH,01H                 ; 1279: LD A,1
                DB      32H,B0H,32H             ; 127B: LD (0x32b0),A
                DB      21H,65H,31H             ; 127E: LD HL,0x3165
                DB      36H,4CH                 ; 1281: LD (HL),0x4c
                DB      3EH,47H                 ; 1283: LD A,0x47
                DB      CDH,2BH,0EH             ; 1285: CALL L0E2B
                DB      C3H,6AH,12H             ; 1288: JP L126A
                DB      CDH,A4H,0FH             ; 128B: CALL L0FA4
                DB      C3H,62H,12H             ; 128E: JP L1262
                DB      FEH,59H                 ; 1291: CP 0x59
                DB      CAH,A3H,1BH             ; 1293: JP z,L1BA3
                DB      FEH,45H                 ; 1296: CP 0x45
                DB      C2H,62H,12H             ; 1298: JP nz,L1262
                DB      CDH,BEH,11H             ; 129B: CALL L11BE
                DB      C9H                     ; 129E: RET

L129F:
                DB      CDH,F0H,1BH             ; 129F: CALL L1BF0
                DB      CDH,59H,12H             ; 12A2: CALL L1259
                DB      C3H,2EH,01H             ; 12A5: JP L012E
                DB      C3H,AEH,12H             ; 12A8: JP L12AE

L12AB:
                DB      CDH,F0H,1BH             ; 12AB: CALL L1BF0

L12AE:
                DB      2AH,DFH,30H             ; 12AE: LD HL,(0x30df)
                DB      F9H                     ; 12B1: LD SP,HL
                DB      C9H                     ; 12B2: RET

L12B3:
                DB      3EH,03H                 ; 12B3: LD A,3
                DB      11H,5CH,00H             ; 12B5: LD DE,0x5c
                DB      CDH,91H,1CH             ; 12B8: CALL L1C91
                DB      C3H,8AH,01H             ; 12BB: JP L018A
                DB      CDH,F0H,1BH             ; 12BE: CALL L1BF0
                DB      21H,2DH,31H             ; 12C1: LD HL,0x312d
                DB      36H,FFH                 ; 12C4: LD (HL),0xff
                DB      21H,80H,00H             ; 12C6: LD HL,0x80
                DB      22H,3CH,31H             ; 12C9: LD (0x313c),HL
                DB      0EH,13H                 ; 12CC: LD C,0x13
                DB      11H,5CH,00H             ; 12CE: LD DE,0x5c
                DB      CDH,05H,00H             ; 12D1: CALL 0x0005
                DB      AFH                     ; 12D4: XOR A
                DB      32H,68H,00H             ; 12D5: LD (0x0068),A
                DB      32H,6AH,00H             ; 12D8: LD (0x006a),A
                DB      32H,7CH,00H             ; 12DB: LD (0x007c),A
                DB      0EH,16H                 ; 12DE: LD C,0x16
                DB      11H,5CH,00H             ; 12E0: LD DE,0x5c
                DB      CDH,05H,00H             ; 12E3: CALL 0x0005
                DB      FEH,FFH                 ; 12E6: CP 0xff
                DB      C2H,2EH,01H             ; 12E8: JP nz,L012E
                DB      11H,51H,23H             ; 12EB: LD DE,0x2351
                DB      CDH,D0H,21H             ; 12EE: CALL L21D0
                DB      C3H,2EH,01H             ; 12F1: JP L012E

L12F4:
                DB      CDH,F0H,1BH             ; 12F4: CALL L1BF0
                DB      11H,02H,27H             ; 12F7: LD DE,0x2702
                DB      CDH,D0H,21H             ; 12FA: CALL L21D0
                DB      C3H,2EH,01H             ; 12FD: JP L012E

L1300:
                DB      3EH,03H                 ; 1300: LD A,3
                DB      11H,5CH,00H             ; 1302: LD DE,0x5c
                DB      CDH,91H,1CH             ; 1305: CALL L1C91
                DB      C3H,2EH,01H             ; 1308: JP L012E
                DB      CDH,F0H,1BH             ; 130B: CALL L1BF0
                DB      CDH,88H,0CH             ; 130E: CALL L0C88
                DB      C3H,2EH,01H             ; 1311: JP L012E
                DB      FEH,FFH                 ; 1314: CP 0xff
                DB      C2H,22H,13H             ; 1316: JP nz,L1322
                DB      11H,21H,23H             ; 1319: LD DE,L2321
                DB      CDH,D8H,11H             ; 131C: CALL L11D8
                DB      C3H,2EH,01H             ; 131F: JP L012E

L1322:
                DB      11H,EBH,24H             ; 1322: LD DE,0x24eb
                DB      CDH,D0H,21H             ; 1325: CALL L21D0
                DB      CDH,7EH,1BH             ; 1328: CALL L1B7E
                DB      11H,C3H,25H             ; 132B: LD DE,0x25c3
                DB      CDH,D0H,21H             ; 132E: CALL L21D0
                DB      CDH,7EH,1BH             ; 1331: CALL L1B7E
                DB      11H,EFH,25H             ; 1334: LD DE,L25EF
                DB      CDH,D0H,21H             ; 1337: CALL L21D0
                DB      3EH,01H                 ; 133A: LD A,1
                DB      32H,36H,31H             ; 133C: LD (0x3136),A
                DB      AFH                     ; 133F: XOR A
                DB      32H,37H,31H             ; 1340: LD (0x3137),A
                DB      32H,38H,31H             ; 1343: LD (0x3138),A

L1346:
                DB      CDH,8AH,14H             ; 1346: CALL TerminalRxPoll
                DB      0EH,06H                 ; 1349: LD C,6
                DB      1EH,FFH                 ; 134B: LD E,0xff
                DB      CDH,05H,00H             ; 134D: CALL 0x0005
                DB      B7H                     ; 1350: OR A
                DB      CAH,46H,13H             ; 1351: JP z,L1346
                DB      3AH,23H,31H             ; 1354: LD A,(0x3123)
                DB      B7H                     ; 1357: OR A
                DB      C2H,50H,14H             ; 1358: JP nz,L1450
                DB      2AH,3CH,31H             ; 135B: LD HL,(0x313c)
                DB      3AH,38H,31H             ; 135E: LD A,(0x3138)
                DB      B7H                     ; 1361: OR A
                DB      C2H,6BH,13H             ; 1362: JP nz,L136B
                DB      CDH,0FH,14H             ; 1365: CALL L140F
                DB      3AH,38H,31H             ; 1368: LD A,(0x3138)

L136B:
                DB      47H                     ; 136B: LD B,A
                DB      AFH                     ; 136C: XOR A
                DB      4FH                     ; 136D: LD C,A
                DB      32H,45H,30H             ; 136E: LD (0x3045),A
                DB      11H,52H,30H             ; 1371: LD DE,0x3052

L1374:
                DB      7EH                     ; 1374: LD A,(HL)
                DB      23H                     ; 1375: INC HL
                DB      E6H,7FH                 ; 1376: AND 0x7f
                DB      FEH,0DH                 ; 1378: CP 13
                DB      CAH,9FH,13H             ; 137A: JP z,L139F
                DB      FEH,1AH                 ; 137D: CP 0x1a
                DB      CAH,A5H,13H             ; 137F: JP z,L13A5
                DB      FEH,0AH                 ; 1382: CP 10
                DB      CAH,A8H,13H             ; 1384: JP z,L13A8
                DB      12H                     ; 1387: LD (DE),A
                DB      13H                     ; 1388: INC DE
                DB      3AH,45H,30H             ; 1389: LD A,(0x3045)
                DB      B7H                     ; 138C: OR A
                DB      C2H,91H,13H             ; 138D: JP nz,L1391
                DB      0CH                     ; 1390: INC C

L1391:
                DB      05H                     ; 1391: DEC B
                DB      C2H,74H,13H             ; 1392: JP nz,L1374
                DB      CDH,0FH,14H             ; 1395: CALL L140F
                DB      3AH,38H,31H             ; 1398: LD A,(0x3138)
                DB      47H                     ; 139B: LD B,A
                DB      C3H,74H,13H             ; 139C: JP L1374

L139F:
                DB      32H,45H,30H             ; 139F: LD (0x3045),A
                DB      C3H,91H,13H             ; 13A2: JP L1391

L13A5:
                DB      32H,23H,31H             ; 13A5: LD (0x3123),A

L13A8:
                DB      22H,3CH,31H             ; 13A8: LD (0x313c),HL
                DB      05H                     ; 13AB: DEC B
                DB      78H                     ; 13AC: LD A,B
                DB      32H,38H,31H             ; 13AD: LD (0x3138),A
                DB      79H                     ; 13B0: LD A,C
                DB      32H,39H,31H             ; 13B1: LD (0x3139),A

L13B4:
                DB      3AH,39H,31H             ; 13B4: LD A,(0x3139)
                DB      32H,46H,30H             ; 13B7: LD (0x3046),A
                DB      21H,52H,30H             ; 13BA: LD HL,0x3052
                DB      22H,D7H,30H             ; 13BD: LD (0x30d7),HL

L13C0:
                DB      CDH,8AH,14H             ; 13C0: CALL TerminalRxPoll
                DB      3AH,37H,31H             ; 13C3: LD A,(0x3137)
                DB      B7H                     ; 13C6: OR A
                DB      C2H,C0H,13H             ; 13C7: JP nz,L13C0
                DB      3AH,46H,30H             ; 13CA: LD A,(0x3046)
                DB      B7H                     ; 13CD: OR A
                DB      CAH,F7H,13H             ; 13CE: JP z,L13F7
                DB      3DH                     ; 13D1: DEC A
                DB      32H,46H,30H             ; 13D2: LD (0x3046),A
                DB      2AH,D7H,30H             ; 13D5: LD HL,(0x30d7)
                DB      7EH                     ; 13D8: LD A,(HL)
                DB      23H                     ; 13D9: INC HL
                DB      22H,D7H,30H             ; 13DA: LD (0x30d7),HL
                DB      CDH,FBH,0EH             ; 13DD: CALL L0EFB
                DB      5FH                     ; 13E0: LD E,A
                DB      CDH,98H,1BH             ; 13E1: CALL ComOutputWait2
                DB      3AH,2EH,31H             ; 13E4: LD A,(0x312e)
                DB      B7H                     ; 13E7: OR A
                DB      CAH,C0H,13H             ; 13E8: JP z,L13C0
                DB      7BH                     ; 13EB: LD A,E
                DB      E6H,7FH                 ; 13EC: AND 0x7f
                DB      5FH                     ; 13EE: LD E,A
                DB      0EH,06H                 ; 13EF: LD C,6
                DB      CDH,05H,00H             ; 13F1: CALL 0x0005
                DB      C3H,C0H,13H             ; 13F4: JP L13C0

L13F7:
                DB      AFH                     ; 13F7: XOR A
                DB      32H,ABH,32H             ; 13F8: LD (L32AB),A

L13FB:
                DB      CDH,8AH,14H             ; 13FB: CALL TerminalRxPoll
                DB      CDH,07H,15H             ; 13FE: CALL L1507
                DB      C3H,59H,14H             ; 1401: JP L1459
                DB      3AH,ABH,32H             ; 1404: LD A,(L32AB)
                DB      FEH,0DH                 ; 1407: CP 13
                DB      CAH,46H,13H             ; 1409: JP z,L1346
                DB      C3H,FBH,13H             ; 140C: JP L13FB

L140F:
                DB      3AH,23H,31H             ; 140F: LD A,(0x3123)
                DB      B7H                     ; 1412: OR A
                DB      C2H,4FH,14H             ; 1413: JP nz,L144F
                DB      C5H                     ; 1416: PUSH BC
                DB      D5H                     ; 1417: PUSH DE
                DB      0EH,14H                 ; 1418: LD C,0x14
                DB      11H,5CH,00H             ; 141A: LD DE,0x5c
                DB      CDH,05H,00H             ; 141D: CALL 0x0005
                DB      D1H                     ; 1420: POP DE
                DB      C1H                     ; 1421: POP BC
                DB      3EH,80H                 ; 1422: LD A,0x80
                DB      32H,38H,31H             ; 1424: LD (0x3138),A
                DB      21H,80H,00H             ; 1427: LD HL,0x80
                DB      22H,3CH,31H             ; 142A: LD (0x313c),HL
                DB      3AH,3EH,31H             ; 142D: LD A,(L313E)
                DB      D6H,01H                 ; 1430: SUB 1
                DB      32H,3EH,31H             ; 1432: LD (L313E),A
                DB      C9H                     ; 1435: RET
                DB      3AH,3FH,31H             ; 1436: LD A,(0x313f)
                DB      FEH,00H                 ; 1439: CP 0
                DB      CAH,49H,14H             ; 143B: JP z,L1449
                DB      D6H,01H                 ; 143E: SUB 1
                DB      32H,3FH,31H             ; 1440: LD (0x313f),A
                DB      3EH,80H                 ; 1443: LD A,0x80
                DB      32H,3EH,31H             ; 1445: LD (L313E),A
                DB      C9H                     ; 1448: RET

L1449:
                DB      3EH,FFH                 ; 1449: LD A,0xff
                DB      32H,23H,31H             ; 144B: LD (0x3123),A
                DB      C9H                     ; 144E: RET

L144F:
                DB      C1H                     ; 144F: POP BC

L1450:
                DB      CDH,5FH,14H             ; 1450: CALL L145F
                DB      11H,0BH,26H             ; 1453: LD DE,0x260b
                DB      C3H,72H,14H             ; 1456: JP L1472

L1459:
                DB      CDH,5FH,14H             ; 1459: CALL L145F
                DB      C3H,2EH,01H             ; 145C: JP L012E

L145F:
                DB      0EH,10H                 ; 145F: LD C,0x10
                DB      11H,5CH,00H             ; 1461: LD DE,0x5c
                DB      CDH,05H,00H             ; 1464: CALL 0x0005
                DB      AFH                     ; 1467: XOR A
                DB      32H,36H,31H             ; 1468: LD (0x3136),A
                DB      C9H                     ; 146B: RET

L146C:
                DB      CDH,F0H,1BH             ; 146C: CALL L1BF0
                DB      11H,F2H,23H             ; 146F: LD DE,L23F2

L1472:
                DB      CDH,D0H,21H             ; 1472: CALL L21D0
                DB      CDH,7EH,1BH             ; 1475: CALL L1B7E
                DB      11H,15H,24H             ; 1478: LD DE,0x2415
                DB      CDH,D0H,21H             ; 147B: CALL L21D0

L147E:
                DB      CDH,8AH,14H             ; 147E: CALL TerminalRxPoll
                DB      CDH,07H,15H             ; 1481: CALL L1507
                DB      C3H,2EH,01H             ; 1484: JP L012E
                DB      C3H,7EH,14H             ; 1487: JP L147E

TerminalRxPoll:
; Terminal-mode nonblocking receive poll on Bondwell SIO0.
                DB      DBH,41H                 ; 148A: IN A,(0x0041)
                DB      E6H,01H                 ; 148C: AND 1
                DB      C8H                     ; 148E: RET z

TerminalRxByte:
; Terminal-mode byte read from Bondwell SIO0 port 40H.
                DB      DBH,40H                 ; 148F: IN A,(0x0040)
                DB      E6H,7FH                 ; 1491: AND 0x7f
                DB      5FH                     ; 1493: LD E,A
                DB      3AH,32H,31H             ; 1494: LD A,(L3132)
                DB      B7H                     ; 1497: OR A
                DB      CAH,B0H,14H             ; 1498: JP z,L14B0
                DB      7BH                     ; 149B: LD A,E
                DB      FEH,00H                 ; 149C: CP 0
                DB      CAH,8AH,14H             ; 149E: JP z,TerminalRxPoll
                DB      FEH,11H                 ; 14A1: CP 0x11
                DB      CAH,8AH,14H             ; 14A3: JP z,TerminalRxPoll
                DB      FEH,13H                 ; 14A6: CP 0x13
                DB      CAH,8AH,14H             ; 14A8: JP z,TerminalRxPoll
                DB      FEH,7FH                 ; 14AB: CP 0x7f
                DB      CAH,8AH,14H             ; 14AD: JP z,TerminalRxPoll

L14B0:
                DB      FEH,11H                 ; 14B0: CP 0x11
                DB      C2H,BDH,14H             ; 14B2: JP nz,L14BD
                DB      AFH                     ; 14B5: XOR A
                DB      32H,37H,31H             ; 14B6: LD (0x3137),A
                DB      7BH                     ; 14B9: LD A,E
                DB      C3H,C5H,14H             ; 14BA: JP L14C5

L14BD:
                DB      FEH,13H                 ; 14BD: CP 0x13
                DB      C2H,C5H,14H             ; 14BF: JP nz,L14C5
                DB      32H,37H,31H             ; 14C2: LD (0x3137),A

L14C5:
                DB      3AH,30H,31H             ; 14C5: LD A,(0x3130)
                DB      B7H                     ; 14C8: OR A
                DB      CAH,E4H,14H             ; 14C9: JP z,L14E4
                DB      3AH,2FH,31H             ; 14CC: LD A,(0x312f)
                DB      B7H                     ; 14CF: OR A
                DB      C2H,FFH,15H             ; 14D0: JP nz,L15FF
                DB      7BH                     ; 14D3: LD A,E
                DB      FEH,7FH                 ; 14D4: CP 0x7f
                DB      C8H                     ; 14D6: RET z
                DB      FEH,1BH                 ; 14D7: CP 0x1b
                DB      C2H,E4H,14H             ; 14D9: JP nz,L14E4
                DB      3EH,01H                 ; 14DC: LD A,1
                DB      32H,2FH,31H             ; 14DE: LD (0x312f),A
                DB      C3H,8AH,14H             ; 14E1: JP TerminalRxPoll

L14E4:
                DB      3AH,2DH,31H             ; 14E4: LD A,(0x312d)
                DB      B7H                     ; 14E7: OR A
                DB      C4H,3BH,16H             ; 14E8: CALL nz,L163B
                DB      3AH,26H,31H             ; 14EB: LD A,(0x3126)
                DB      B7H                     ; 14EE: OR A
                DB      CAH,F7H,14H             ; 14EF: JP z,L14F7
                DB      0EH,05H                 ; 14F2: LD C,5
                DB      CDH,05H,00H             ; 14F4: CALL 0x0005

L14F7:
                DB      0EH,06H                 ; 14F7: LD C,6
                DB      7BH                     ; 14F9: LD A,E
                DB      FEH,09H                 ; 14FA: CP 9
                DB      C2H,01H,15H             ; 14FC: JP nz,L1501
                DB      0EH,02H                 ; 14FF: LD C,2

L1501:
                DB      CDH,05H,00H             ; 1501: CALL 0x0005
                DB      C3H,8AH,14H             ; 1504: JP TerminalRxPoll

L1507:
                DB      0EH,06H                 ; 1507: LD C,6
                DB      1EH,FFH                 ; 1509: LD E,0xff
                DB      CDH,05H,00H             ; 150B: CALL 0x0005
                DB      E6H,7FH                 ; 150E: AND 0x7f
                DB      CAH,A3H,1BH             ; 1510: JP z,L1BA3
                DB      5FH                     ; 1513: LD E,A
                DB      32H,ABH,32H             ; 1514: LD (L32AB),A
                DB      3AH,35H,31H             ; 1517: LD A,(0x3135)
                DB      BBH                     ; 151A: CP E
                DB      CAH,3BH,15H             ; 151B: JP z,L153B
                DB      7BH                     ; 151E: LD A,E
                DB      CDH,FBH,0EH             ; 151F: CALL L0EFB
                DB      5FH                     ; 1522: LD E,A
                DB      D5H                     ; 1523: PUSH DE
                DB      CDH,98H,1BH             ; 1524: CALL ComOutputWait2
                DB      D1H                     ; 1527: POP DE
                DB      3AH,2EH,31H             ; 1528: LD A,(0x312e)
                DB      B7H                     ; 152B: OR A
                DB      CAH,A3H,1BH             ; 152C: JP z,L1BA3
                DB      7BH                     ; 152F: LD A,E
                DB      E6H,7FH                 ; 1530: AND 0x7f
                DB      5FH                     ; 1532: LD E,A
                DB      0EH,06H                 ; 1533: LD C,6
                DB      CDH,05H,00H             ; 1535: CALL 0x0005
                DB      C3H,A3H,1BH             ; 1538: JP L1BA3

L153B:
                DB      0EH,06H                 ; 153B: LD C,6
                DB      1EH,FFH                 ; 153D: LD E,0xff
                DB      CDH,05H,00H             ; 153F: CALL 0x0005
                DB      B7H                     ; 1542: OR A
                DB      CAH,3BH,15H             ; 1543: JP z,L153B
                DB      47H                     ; 1546: LD B,A
                DB      FEH,03H                 ; 1547: CP 3
                DB      CAH,53H,15H             ; 1549: JP z,L1553
                DB      E6H,5FH                 ; 154C: AND 0x5f
                DB      FEH,43H                 ; 154E: CP 0x43
                DB      C2H,7EH,15H             ; 1550: JP nz,L157E

L1553:
                DB      11H,24H,24H             ; 1553: LD DE,0x2424
                DB      CDH,D0H,21H             ; 1556: CALL L21D0
                DB      3AH,2DH,31H             ; 1559: LD A,(0x312d)
                DB      B7H                     ; 155C: OR A
                DB      C8H                     ; 155D: RET z
                DB      AFH                     ; 155E: XOR A
                DB      32H,2DH,31H             ; 155F: LD (0x312d),A
                DB      11H,D9H,23H             ; 1562: LD DE,L23D9
                DB      CDH,D0H,21H             ; 1565: CALL L21D0
                DB      2AH,3CH,31H             ; 1568: LD HL,(0x313c)
                DB      36H,1AH                 ; 156B: LD (HL),0x1a
                DB      0EH,15H                 ; 156D: LD C,0x15
                DB      11H,5CH,00H             ; 156F: LD DE,0x5c
                DB      CDH,05H,00H             ; 1572: CALL 0x0005
                DB      0EH,10H                 ; 1575: LD C,0x10
                DB      11H,5CH,00H             ; 1577: LD DE,0x5c
                DB      CDH,05H,00H             ; 157A: CALL 0x0005
                DB      C9H                     ; 157D: RET

L157E:
                DB      FEH,53H                 ; 157E: CP 0x53
                DB      C2H,89H,15H             ; 1580: JP nz,L1589
                DB      CDH,31H,18H             ; 1583: CALL L1831
                DB      C3H,A3H,1BH             ; 1586: JP L1BA3

L1589:
                DB      FEH,12H                 ; 1589: CP 0x12
                DB      CAH,93H,15H             ; 158B: JP z,L1593
                DB      FEH,52H                 ; 158E: CP 0x52
                DB      C2H,9EH,15H             ; 1590: JP nz,L159E

L1593:
                DB      3AH,36H,31H             ; 1593: LD A,(0x3136)
                DB      B7H                     ; 1596: OR A
                DB      CAH,9EH,15H             ; 1597: JP z,L159E
                DB      C1H                     ; 159A: POP BC
                DB      C3H,B4H,13H             ; 159B: JP L13B4

L159E:
                DB      78H                     ; 159E: LD A,B
                DB      FEH,3FH                 ; 159F: CP 0x3f
                DB      C2H,C3H,15H             ; 15A1: JP nz,L15C3
                DB      3AH,36H,31H             ; 15A4: LD A,(0x3136)
                DB      B7H                     ; 15A7: OR A
                DB      CAH,B1H,15H             ; 15A8: JP z,L15B1
                DB      11H,88H,2AH             ; 15AB: LD DE,0x2a88
                DB      CDH,D0H,21H             ; 15AE: CALL L21D0

L15B1:
                DB      11H,A5H,2AH             ; 15B1: LD DE,0x2aa5
                DB      CDH,D0H,21H             ; 15B4: CALL L21D0
                DB      CDH,7EH,1BH             ; 15B7: CALL L1B7E
                DB      11H,19H,2BH             ; 15BA: LD DE,0x2b19
                DB      CDH,D0H,21H             ; 15BD: CALL L21D0
                DB      C3H,3BH,15H             ; 15C0: JP L153B

L15C3:
                DB      78H                     ; 15C3: LD A,B
                DB      E6H,5FH                 ; 15C4: AND 0x5f
                DB      FEH,42H                 ; 15C6: CP 0x42
                DB      C2H,D4H,15H             ; 15C8: JP nz,L15D4
                DB      11H,76H,24H             ; 15CB: LD DE,0x2476
                DB      CDH,D0H,21H             ; 15CE: CALL L21D0
                DB      C3H,A3H,1BH             ; 15D1: JP L1BA3

L15D4:
                DB      78H                     ; 15D4: LD A,B
                DB      FEH,30H                 ; 15D5: CP 0x30
                DB      C2H,E2H,15H             ; 15D7: JP nz,L15E2
                DB      1EH,00H                 ; 15DA: LD E,0
                DB      CDH,98H,1BH             ; 15DC: CALL ComOutputWait2
                DB      C3H,A3H,1BH             ; 15DF: JP L1BA3

L15E2:
                DB      5FH                     ; 15E2: LD E,A
                DB      3AH,35H,31H             ; 15E3: LD A,(0x3135)
                DB      BBH                     ; 15E6: CP E
                DB      C2H,F5H,15H             ; 15E7: JP nz,L15F5
                DB      7BH                     ; 15EA: LD A,E
                DB      CDH,FBH,0EH             ; 15EB: CALL L0EFB
                DB      5FH                     ; 15EE: LD E,A
                DB      CDH,98H,1BH             ; 15EF: CALL ComOutputWait2
                DB      C3H,A3H,1BH             ; 15F2: JP L1BA3

L15F5:
                DB      1EH,07H                 ; 15F5: LD E,7
                DB      0EH,06H                 ; 15F7: LD C,6
                DB      CDH,05H,00H             ; 15F9: CALL 0x0005
                DB      C3H,A3H,1BH             ; 15FC: JP L1BA3

L15FF:
                DB      3EH,00H                 ; 15FF: LD A,0
                DB      32H,2FH,31H             ; 1601: LD (0x312f),A
                DB      7BH                     ; 1604: LD A,E
                DB      FEH,59H                 ; 1605: CP 0x59
                DB      C2H,11H,16H             ; 1607: JP nz,L1611
                DB      11H,0CH,2DH             ; 160A: LD DE,0x2d0c
                DB      CDH,D0H,21H             ; 160D: CALL L21D0
                DB      C9H                     ; 1610: RET

L1611:
                DB      FEH,41H                 ; 1611: CP 0x41
                DB      FAH,2BH,16H             ; 1613: JP m,L162B
                DB      FEH,4CH                 ; 1616: CP 0x4c
                DB      F2H,2BH,16H             ; 1618: JP p,L162B
                DB      D6H,41H                 ; 161B: SUB 0x41
                DB      07H                     ; 161D: RLCA
                DB      07H                     ; 161E: RLCA
                DB      21H,10H,2DH             ; 161F: LD HL,0x2d10
                DB      5FH                     ; 1622: LD E,A
                DB      16H,00H                 ; 1623: LD D,0
                DB      19H                     ; 1625: ADD HL,DE
                DB      EBH                     ; 1626: EX DE,HL
                DB      CDH,D0H,21H             ; 1627: CALL L21D0
                DB      C9H                     ; 162A: RET

L162B:
                DB      F5H                     ; 162B: PUSH AF
                DB      1EH,1BH                 ; 162C: LD E,0x1b
                DB      0EH,02H                 ; 162E: LD C,2
                DB      CDH,05H,00H             ; 1630: CALL 0x0005
                DB      F1H                     ; 1633: POP AF
                DB      5FH                     ; 1634: LD E,A
                DB      0EH,02H                 ; 1635: LD C,2
                DB      CDH,05H,00H             ; 1637: CALL 0x0005
                DB      C9H                     ; 163A: RET

L163B:
                DB      2AH,3CH,31H             ; 163B: LD HL,(0x313c)
                DB      73H                     ; 163E: LD (HL),E
                DB      23H                     ; 163F: INC HL
                DB      22H,3CH,31H             ; 1640: LD (0x313c),HL
                DB      7DH                     ; 1643: LD A,L
                DB      B7H                     ; 1644: OR A
                DB      C0H                     ; 1645: RET nz
                DB      D5H                     ; 1646: PUSH DE
                DB      1EH,13H                 ; 1647: LD E,0x13
                DB      CDH,98H,1BH             ; 1649: CALL ComOutputWait2
                DB      0EH,15H                 ; 164C: LD C,0x15
                DB      11H,5CH,00H             ; 164E: LD DE,0x5c
                DB      CDH,05H,00H             ; 1651: CALL 0x0005
                DB      B7H                     ; 1654: OR A
                DB      CAH,5EH,16H             ; 1655: JP z,L165E
                DB      11H,DEH,22H             ; 1658: LD DE,0x22de
                DB      CDH,D0H,21H             ; 165B: CALL L21D0

L165E:
                DB      1EH,11H                 ; 165E: LD E,0x11
                DB      CDH,98H,1BH             ; 1660: CALL ComOutputWait2
                DB      21H,80H,00H             ; 1663: LD HL,0x80
                DB      22H,3CH,31H             ; 1666: LD (0x313c),HL
                DB      D1H                     ; 1669: POP DE
                DB      C9H                     ; 166A: RET

L166B:
                DB      11H,C7H,2DH             ; 166B: LD DE,0x2dc7
                DB      21H,8DH,28H             ; 166E: LD HL,0x288d
                DB      CDH,E7H,1BH             ; 1671: CALL L1BE7
                DB      21H,7CH,16H             ; 1674: LD HL,0x167c
                DB      4FH                     ; 1677: LD C,A
                DB      06H,00H                 ; 1678: LD B,0
                DB      09H                     ; 167A: ADD HL,BC
                DB      E9H                     ; 167B: JP (HL)
                DB      C3H,29H,17H             ; 167C: JP L1729
                DB      C3H,B5H,17H             ; 167F: JP L17B5
                DB      C3H,3DH,17H             ; 1682: JP L173D
                DB      C3H,8AH,01H             ; 1685: JP L018A
                DB      C3H,ECH,16H             ; 1688: JP L16EC
                DB      C3H,9DH,17H             ; 168B: JP L179D
                DB      C3H,EFH,17H             ; 168E: JP L17EF
                DB      C3H,07H,18H             ; 1691: JP L1807
                DB      C3H,A9H,16H             ; 1694: JP L16A9
                DB      C3H,55H,17H             ; 1697: JP L1755
                DB      C3H,E6H,17H             ; 169A: JP L17E6
                DB      C3H,0FH,17H             ; 169D: JP L170F
                DB      C3H,C1H,16H             ; 16A0: JP L16C1
                DB      C3H,6DH,17H             ; 16A3: JP L176D
                DB      C3H,85H,17H             ; 16A6: JP L1785

L16A9:
                DB      11H,7BH,2EH             ; 16A9: LD DE,0x2e7b
                DB      21H,17H,2AH             ; 16AC: LD HL,0x2a17
                DB      CDH,E7H,1BH             ; 16AF: CALL L1BE7
                DB      32H,ABH,32H             ; 16B2: LD (L32AB),A
                DB      CDH,F0H,1BH             ; 16B5: CALL L1BF0
                DB      3AH,ABH,32H             ; 16B8: LD A,(L32AB)
                DB      32H,55H,31H             ; 16BB: LD (0x3155),A
                DB      C3H,2EH,01H             ; 16BE: JP L012E

L16C1:
                DB      11H,5CH,00H             ; 16C1: LD DE,0x5c
                DB      3EH,10H                 ; 16C4: LD A,0x10
                DB      CDH,91H,1CH             ; 16C6: CALL L1C91
                DB      C3H,CCH,16H             ; 16C9: JP L16CC

L16CC:
                DB      3AH,5CH,00H             ; 16CC: LD A,(0x005c)
                DB      FEH,00H                 ; 16CF: CP 0
                DB      C2H,D7H,16H             ; 16D1: JP nz,L16D7
                DB      3AH,25H,31H             ; 16D4: LD A,(0x3125)

L16D7:
                DB      32H,25H,31H             ; 16D7: LD (0x3125),A
                DB      0EH,0DH                 ; 16DA: LD C,13
                DB      CDH,05H,00H             ; 16DC: CALL 0x0005
                DB      3AH,25H,31H             ; 16DF: LD A,(0x3125)
                DB      3DH                     ; 16E2: DEC A
                DB      5FH                     ; 16E3: LD E,A
                DB      0EH,0EH                 ; 16E4: LD C,14
                DB      CDH,05H,00H             ; 16E6: CALL 0x0005
                DB      C3H,2EH,01H             ; 16E9: JP L012E

L16EC:
                DB      11H,63H,2EH             ; 16EC: LD DE,0x2e63
                DB      21H,03H,2AH             ; 16EF: LD HL,0x2a03
                DB      CDH,E7H,1BH             ; 16F2: CALL L1BE7
                DB      21H,FDH,16H             ; 16F5: LD HL,0x16fd
                DB      4FH                     ; 16F8: LD C,A
                DB      06H,00H                 ; 16F9: LD B,0
                DB      09H                     ; 16FB: ADD HL,BC
                DB      E9H                     ; 16FC: JP (HL)
                DB      C3H,09H,17H             ; 16FD: JP L1709
                DB      C3H,03H,17H             ; 1700: JP L1703

L1703:
                DB      CDH,F0H,1BH             ; 1703: CALL L1BF0
                DB      C3H,2EH,01H             ; 1706: JP L012E

L1709:
                DB      CDH,F0H,1BH             ; 1709: CALL L1BF0
                DB      C3H,2EH,01H             ; 170C: JP L012E

L170F:
                DB      11H,C9H,2FH             ; 170F: LD DE,0x2fc9
                DB      21H,5CH,2CH             ; 1712: LD HL,0x2c5c
                DB      CDH,E7H,1BH             ; 1715: CALL L1BE7
                DB      32H,ABH,32H             ; 1718: LD (L32AB),A
                DB      CDH,F0H,1BH             ; 171B: CALL L1BF0
                DB      3AH,ABH,32H             ; 171E: LD A,(L32AB)
                DB      32H,D0H,34H             ; 1721: LD (0x34d0),A
                DB      D3H,00H                 ; 1724: OUT (0x0000),A
                DB      C3H,2EH,01H             ; 1726: JP L012E

L1729:
                DB      CDH,F0H,1BH             ; 1729: CALL L1BF0
                DB      11H,DFH,26H             ; 172C: LD DE,0x26df
                DB      CDH,D0H,21H             ; 172F: CALL L21D0
                DB      0EH,01H                 ; 1732: LD C,1
                DB      CDH,05H,00H             ; 1734: CALL 0x0005
                DB      32H,35H,31H             ; 1737: LD (0x3135),A
                DB      C3H,2EH,01H             ; 173A: JP L012E

L173D:
                DB      11H,EEH,2EH             ; 173D: LD DE,0x2eee
                DB      21H,76H,2AH             ; 1740: LD HL,0x2a76
                DB      CDH,E7H,1BH             ; 1743: CALL L1BE7
                DB      32H,ABH,32H             ; 1746: LD (L32AB),A
                DB      CDH,F0H,1BH             ; 1749: CALL L1BF0
                DB      3AH,ABH,32H             ; 174C: LD A,(L32AB)
                DB      32H,2EH,31H             ; 174F: LD (0x312e),A
                DB      C3H,2EH,01H             ; 1752: JP L012E

L1755:
                DB      11H,EEH,2EH             ; 1755: LD DE,0x2eee
                DB      21H,76H,2AH             ; 1758: LD HL,0x2a76
                DB      CDH,E7H,1BH             ; 175B: CALL L1BE7
                DB      32H,ABH,32H             ; 175E: LD (L32AB),A
                DB      CDH,F0H,1BH             ; 1761: CALL L1BF0
                DB      3AH,ABH,32H             ; 1764: LD A,(L32AB)
                DB      32H,30H,31H             ; 1767: LD (0x3130),A
                DB      C3H,2EH,01H             ; 176A: JP L012E

L176D:
                DB      11H,EEH,2EH             ; 176D: LD DE,0x2eee
                DB      21H,76H,2AH             ; 1770: LD HL,0x2a76
                DB      CDH,E7H,1BH             ; 1773: CALL L1BE7
                DB      32H,ABH,32H             ; 1776: LD (L32AB),A
                DB      CDH,F0H,1BH             ; 1779: CALL L1BF0
                DB      3AH,ABH,32H             ; 177C: LD A,(L32AB)
                DB      32H,26H,31H             ; 177F: LD (0x3126),A
                DB      C3H,2EH,01H             ; 1782: JP L012E

L1785:
                DB      11H,EEH,2EH             ; 1785: LD DE,0x2eee
                DB      21H,76H,2AH             ; 1788: LD HL,0x2a76
                DB      CDH,E7H,1BH             ; 178B: CALL L1BE7
                DB      32H,ABH,32H             ; 178E: LD (L32AB),A
                DB      CDH,F0H,1BH             ; 1791: CALL L1BF0
                DB      3AH,ABH,32H             ; 1794: LD A,(L32AB)
                DB      32H,27H,31H             ; 1797: LD (L3127),A
                DB      C3H,2EH,01H             ; 179A: JP L012E

L179D:
                DB      11H,EEH,2EH             ; 179D: LD DE,0x2eee
                DB      21H,76H,2AH             ; 17A0: LD HL,0x2a76
                DB      CDH,E7H,1BH             ; 17A3: CALL L1BE7
                DB      32H,ABH,32H             ; 17A6: LD (L32AB),A
                DB      CDH,F0H,1BH             ; 17A9: CALL L1BF0
                DB      3AH,ABH,32H             ; 17AC: LD A,(L32AB)
                DB      32H,31H,31H             ; 17AF: LD (0x3131),A
                DB      C3H,2EH,01H             ; 17B2: JP L012E

L17B5:
                DB      11H,EEH,2EH             ; 17B5: LD DE,0x2eee
                DB      21H,76H,2AH             ; 17B8: LD HL,0x2a76
                DB      CDH,E7H,1BH             ; 17BB: CALL L1BE7
                DB      32H,ABH,32H             ; 17BE: LD (L32AB),A
                DB      CDH,F0H,1BH             ; 17C1: CALL L1BF0
                DB      3AH,ABH,32H             ; 17C4: LD A,(L32AB)
                DB      32H,32H,31H             ; 17C7: LD (L3132),A
                DB      B7H                     ; 17CA: OR A
                DB      CAH,D5H,17H             ; 17CB: JP z,L17D5
                DB      3EH,03H                 ; 17CE: LD A,3
                DB      06H,01H                 ; 17D0: LD B,1
                DB      C3H,D9H,17H             ; 17D2: JP L17D9

L17D5:
                DB      3EH,06H                 ; 17D5: LD A,6
                DB      06H,00H                 ; 17D7: LD B,0

L17D9:
                DB      32H,34H,31H             ; 17D9: LD (0x3134),A
                DB      78H                     ; 17DC: LD A,B
                DB      32H,2EH,31H             ; 17DD: LD (0x312e),A
                DB      32H,27H,31H             ; 17E0: LD (L3127),A
                DB      C3H,2EH,01H             ; 17E3: JP L012E

L17E6:
                DB      11H,76H,24H             ; 17E6: LD DE,0x2476
                DB      CDH,D0H,21H             ; 17E9: CALL L21D0
                DB      C3H,2EH,01H             ; 17EC: JP L012E

L17EF:
                DB      11H,FCH,2EH             ; 17EF: LD DE,0x2efc
                DB      21H,83H,2BH             ; 17F2: LD HL,0x2b83
                DB      CDH,E7H,1BH             ; 17F5: CALL L1BE7
                DB      32H,ABH,32H             ; 17F8: LD (L32AB),A
                DB      CDH,F0H,1BH             ; 17FB: CALL L1BF0
                DB      3AH,ABH,32H             ; 17FE: LD A,(L32AB)
                DB      32H,33H,31H             ; 1801: LD (0x3133),A
                DB      C3H,2EH,01H             ; 1804: JP L012E

L1807:
                DB      11H,C5H,2EH             ; 1807: LD DE,0x2ec5
                DB      21H,5BH,2AH             ; 180A: LD HL,0x2a5b
                DB      CDH,E7H,1BH             ; 180D: CALL L1BE7
                DB      32H,ABH,32H             ; 1810: LD (L32AB),A
                DB      CDH,F0H,1BH             ; 1813: CALL L1BF0
                DB      3AH,ABH,32H             ; 1816: LD A,(L32AB)
                DB      32H,34H,31H             ; 1819: LD (0x3134),A
                DB      C3H,2EH,01H             ; 181C: JP L012E

L181F:
                DB      CDH,F0H,1BH             ; 181F: CALL L1BF0
                DB      CDH,31H,18H             ; 1822: CALL L1831
                DB      C3H,2EH,01H             ; 1825: JP L012E

L1828:
                DB      CDH,2EH,18H             ; 1828: CALL L182E
                DB      C3H,2EH,01H             ; 182B: JP L012E

L182E:
                DB      CDH,F0H,1BH             ; 182E: CALL L1BF0

L1831:
                DB      3AH,36H,31H             ; 1831: LD A,(0x3136)
                DB      B7H                     ; 1834: OR A
                DB      CAH,3EH,18H             ; 1835: JP z,L183E
                DB      11H,48H,2BH             ; 1838: LD DE,0x2b48
                DB      CDH,D0H,21H             ; 183B: CALL L21D0

L183E:
                DB      11H,5EH,2BH             ; 183E: LD DE,0x2b5e
                DB      CDH,D0H,21H             ; 1841: CALL L21D0
                DB      3AH,2EH,31H             ; 1844: LD A,(0x312e)
                DB      B7H                     ; 1847: OR A
                DB      CAH,51H,18H             ; 1848: JP z,L1851
                DB      11H,3FH,2BH             ; 184B: LD DE,0x2b3f
                DB      C3H,54H,18H             ; 184E: JP L1854

L1851:
                DB      11H,43H,2BH             ; 1851: LD DE,0x2b43

L1854:
                DB      CDH,D0H,21H             ; 1854: CALL L21D0
                DB      11H,9AH,2BH             ; 1857: LD DE,0x2b9a
                DB      CDH,D0H,21H             ; 185A: CALL L21D0
                DB      3AH,30H,31H             ; 185D: LD A,(0x3130)
                DB      B7H                     ; 1860: OR A
                DB      CAH,6AH,18H             ; 1861: JP z,L186A
                DB      11H,3FH,2BH             ; 1864: LD DE,0x2b3f
                DB      C3H,6DH,18H             ; 1867: JP L186D

L186A:
                DB      11H,43H,2BH             ; 186A: LD DE,0x2b43

L186D:
                DB      CDH,D0H,21H             ; 186D: CALL L21D0
                DB      11H,ABH,2BH             ; 1870: LD DE,0x2bab
                DB      CDH,D0H,21H             ; 1873: CALL L21D0
                DB      3AH,33H,31H             ; 1876: LD A,(0x3133)
                DB      B7H                     ; 1879: OR A
                DB      CAH,8BH,18H             ; 187A: JP z,L188B
                DB      FEH,01H                 ; 187D: CP 1
                DB      11H,74H,2BH             ; 187F: LD DE,0x2b74
                DB      CAH,8EH,18H             ; 1882: JP z,L188E
                DB      11H,7BH,2BH             ; 1885: LD DE,0x2b7b
                DB      C3H,8EH,18H             ; 1888: JP L188E

L188B:
                DB      11H,6BH,2BH             ; 188B: LD DE,0x2b6b

L188E:
                DB      CDH,D0H,21H             ; 188E: CALL L21D0
                DB      11H,B7H,2BH             ; 1891: LD DE,L2BB7
                DB      CDH,D0H,21H             ; 1894: CALL L21D0
                DB      3AH,32H,31H             ; 1897: LD A,(L3132)
                DB      B7H                     ; 189A: OR A
                DB      CAH,A4H,18H             ; 189B: JP z,L18A4
                DB      11H,3FH,2BH             ; 189E: LD DE,0x2b3f
                DB      C3H,A7H,18H             ; 18A1: JP L18A7

L18A4:
                DB      11H,43H,2BH             ; 18A4: LD DE,0x2b43

L18A7:
                DB      CDH,D0H,21H             ; 18A7: CALL L21D0
                DB      11H,C2H,2BH             ; 18AA: LD DE,0x2bc2
                DB      CDH,D0H,21H             ; 18AD: CALL L21D0
                DB      3AH,31H,31H             ; 18B0: LD A,(0x3131)
                DB      B7H                     ; 18B3: OR A
                DB      CAH,BDH,18H             ; 18B4: JP z,L18BD
                DB      11H,3FH,2BH             ; 18B7: LD DE,0x2b3f
                DB      C3H,C0H,18H             ; 18BA: JP L18C0

L18BD:
                DB      11H,43H,2BH             ; 18BD: LD DE,0x2b43

L18C0:
                DB      CDH,D0H,21H             ; 18C0: CALL L21D0
                DB      11H,D1H,2BH             ; 18C3: LD DE,L2BD1
                DB      CDH,D0H,21H             ; 18C6: CALL L21D0
                DB      3AH,26H,31H             ; 18C9: LD A,(0x3126)
                DB      B7H                     ; 18CC: OR A
                DB      CAH,D6H,18H             ; 18CD: JP z,L18D6
                DB      11H,3FH,2BH             ; 18D0: LD DE,0x2b3f
                DB      C3H,D9H,18H             ; 18D3: JP L18D9

L18D6:
                DB      11H,43H,2BH             ; 18D6: LD DE,0x2b43

L18D9:
                DB      CDH,D0H,21H             ; 18D9: CALL L21D0
                DB      11H,F0H,2BH             ; 18DC: LD DE,0x2bf0
                DB      CDH,D0H,21H             ; 18DF: CALL L21D0
                DB      3AH,34H,31H             ; 18E2: LD A,(0x3134)
                DB      11H,1BH,2CH             ; 18E5: LD DE,0x2c1b
                DB      FEH,03H                 ; 18E8: CP 3
                DB      C2H,F3H,18H             ; 18EA: JP nz,L18F3
                DB      11H,20H,2CH             ; 18ED: LD DE,0x2c20
                DB      C3H,11H,19H             ; 18F0: JP L1911

L18F3:
                DB      FEH,0CH                 ; 18F3: CP 12
                DB      C2H,FEH,18H             ; 18F5: JP nz,L18FE
                DB      11H,25H,2CH             ; 18F8: LD DE,0x2c25
                DB      C3H,11H,19H             ; 18FB: JP L1911

L18FE:
                DB      FEH,09H                 ; 18FE: CP 9
                DB      C2H,09H,19H             ; 1900: JP nz,L1909
                DB      11H,2BH,2CH             ; 1903: LD DE,0x2c2b
                DB      C3H,11H,19H             ; 1906: JP L1911

L1909:
                DB      FEH,00H                 ; 1909: CP 0
                DB      C2H,11H,19H             ; 190B: JP nz,L1911
                DB      11H,2FH,2CH             ; 190E: LD DE,0x2c2f

L1911:
                DB      CDH,D0H,21H             ; 1911: CALL L21D0
                DB      11H,FBH,2BH             ; 1914: LD DE,0x2bfb
                DB      CDH,D0H,21H             ; 1917: CALL L21D0
                DB      3AH,55H,31H             ; 191A: LD A,(0x3155)
                DB      5FH                     ; 191D: LD E,A
                DB      0EH,02H                 ; 191E: LD C,2
                DB      CDH,05H,00H             ; 1920: CALL 0x0005
                DB      11H,10H,2CH             ; 1923: LD DE,0x2c10
                DB      CDH,D0H,21H             ; 1926: CALL L21D0
                DB      11H,E0H,2BH             ; 1929: LD DE,0x2be0
                DB      CDH,D0H,21H             ; 192C: CALL L21D0
                DB      CDH,7EH,1BH             ; 192F: CALL L1B7E
                DB      11H,25H,22H             ; 1932: LD DE,0x2225
                DB      CDH,D0H,21H             ; 1935: CALL L21D0
                DB      11H,34H,2CH             ; 1938: LD DE,0x2c34
                DB      CDH,D0H,21H             ; 193B: CALL L21D0
                DB      3AH,D0H,34H             ; 193E: LD A,(0x34d0)
                DB      21H,3BH,2CH             ; 1941: LD HL,0x2c3b
                DB      FEH,FFH                 ; 1944: CP 0xff
                DB      CAH,64H,19H             ; 1946: JP z,L1964
                DB      21H,CAH,2FH             ; 1949: LD HL,0x2fca

L194C:
                DB      46H                     ; 194C: LD B,(HL)
                DB      04H                     ; 194D: INC B
                DB      23H                     ; 194E: INC HL
                DB      22H,ABH,32H             ; 194F: LD (L32AB),HL

L1952:
                DB      23H                     ; 1952: INC HL
                DB      05H                     ; 1953: DEC B
                DB      C2H,52H,19H             ; 1954: JP nz,L1952
                DB      4EH                     ; 1957: LD C,(HL)
                DB      B9H                     ; 1958: CP C
                DB      CAH,61H,19H             ; 1959: JP z,L1961
                DB      23H                     ; 195C: INC HL
                DB      23H                     ; 195D: INC HL
                DB      C3H,4CH,19H             ; 195E: JP L194C

L1961:
                DB      2AH,ABH,32H             ; 1961: LD HL,(L32AB)

L1964:
                DB      EBH                     ; 1964: EX DE,HL
                DB      CDH,D0H,21H             ; 1965: CALL L21D0
                DB      11H,25H,22H             ; 1968: LD DE,0x2225
                DB      CDH,D0H,21H             ; 196B: CALL L21D0
                DB      11H,56H,2CH             ; 196E: LD DE,0x2c56
                DB      CDH,D0H,21H             ; 1971: CALL L21D0
                DB      11H,3FH,2BH             ; 1974: LD DE,0x2b3f
                DB      3AH,27H,31H             ; 1977: LD A,(L3127)
                DB      B7H                     ; 197A: OR A
                DB      C2H,81H,19H             ; 197B: JP nz,L1981
                DB      11H,43H,2BH             ; 197E: LD DE,0x2b43

L1981:
                DB      CDH,D0H,21H             ; 1981: CALL L21D0
                DB      11H,25H,22H             ; 1984: LD DE,0x2225
                DB      CDH,D0H,21H             ; 1987: CALL L21D0
                DB      C9H                     ; 198A: RET

L198B:
                DB      11H,5CH,00H             ; 198B: LD DE,0x5c
                DB      3EH,10H                 ; 198E: LD A,0x10
                DB      CDH,91H,1CH             ; 1990: CALL L1C91
                DB      C3H,99H,19H             ; 1993: JP L1999
                DB      C3H,B1H,19H             ; 1996: JP L19B1

L1999:
                DB      3AH,5CH,00H             ; 1999: LD A,(0x005c)
                DB      FEH,20H                 ; 199C: CP 0x20
                DB      C2H,A5H,19H             ; 199E: JP nz,L19A5
                DB      AFH                     ; 19A1: XOR A
                DB      32H,5CH,00H             ; 19A2: LD (0x005c),A

L19A5:
                DB      21H,5DH,00H             ; 19A5: LD HL,0x5d
                DB      06H,0BH                 ; 19A8: LD B,11

L19AA:
                DB      36H,3FH                 ; 19AA: LD (HL),0x3f
                DB      23H                     ; 19AC: INC HL
                DB      05H                     ; 19AD: DEC B
                DB      C2H,AAH,19H             ; 19AE: JP nz,L19AA

L19B1:
                DB      3AH,5CH,00H             ; 19B1: LD A,(0x005c)
                DB      FEH,00H                 ; 19B4: CP 0
                DB      C2H,BCH,19H             ; 19B6: JP nz,L19BC
                DB      3AH,25H,31H             ; 19B9: LD A,(0x3125)

L19BC:
                DB      C6H,40H                 ; 19BC: ADD A,0x40
                DB      32H,B2H,24H             ; 19BE: LD (0x24b2),A
                DB      11H,25H,22H             ; 19C1: LD DE,0x2225
                DB      CDH,D0H,21H             ; 19C4: CALL L21D0
                DB      11H,98H,24H             ; 19C7: LD DE,0x2498
                DB      CDH,D0H,21H             ; 19CA: CALL L21D0
                DB      3EH,04H                 ; 19CD: LD A,4
                DB      32H,D5H,34H             ; 19CF: LD (0x34d5),A
                DB      CDH,33H,1BH             ; 19D2: CALL L1B33

L19D5:
                DB      CDH,E3H,0BH             ; 19D5: CALL L0BE3
                DB      D2H,DEH,19H             ; 19D8: JP nc,L19DE
                DB      C3H,60H,1AH             ; 19DB: JP L1A60

L19DE:
                DB      0EH,0BH                 ; 19DE: LD C,11
                DB      CDH,05H,00H             ; 19E0: CALL 0x0005
                DB      B7H                     ; 19E3: OR A
                DB      CAH,EFH,19H             ; 19E4: JP z,L19EF
                DB      0EH,01H                 ; 19E7: LD C,1
                DB      CDH,05H,00H             ; 19E9: CALL 0x0005
                DB      C3H,60H,1AH             ; 19EC: JP L1A60

L19EF:
                DB      21H,5DH,00H             ; 19EF: LD HL,0x5d
                DB      06H,08H                 ; 19F2: LD B,8
                DB      CDH,30H,1AH             ; 19F4: CALL L1A30
                DB      3EH,2EH                 ; 19F7: LD A,0x2e
                DB      CDH,23H,1AH             ; 19F9: CALL L1A23
                DB      06H,03H                 ; 19FC: LD B,3
                DB      CDH,30H,1AH             ; 19FE: CALL L1A30
                DB      CDH,D8H,1AH             ; 1A01: CALL L1AD8
                DB      21H,D5H,34H             ; 1A04: LD HL,0x34d5
                DB      35H                     ; 1A07: DEC (HL)
                DB      F5H                     ; 1A08: PUSH AF
                DB      C4H,13H,1AH             ; 1A09: CALL nz,L1A13
                DB      F1H                     ; 1A0C: POP AF
                DB      CCH,3CH,1AH             ; 1A0D: CALL z,L1A3C
                DB      C3H,D5H,19H             ; 1A10: JP L19D5

L1A13:
                DB      CDH,21H,1AH             ; 1A13: CALL L1A21
                DB      3EH,3AH                 ; 1A16: LD A,0x3a
                DB      CDH,23H,1AH             ; 1A18: CALL L1A23
                DB      C3H,21H,1AH             ; 1A1B: JP L1A21

L1A1E:
                DB      CDH,21H,1AH             ; 1A1E: CALL L1A21

L1A21:
                DB      3EH,20H                 ; 1A21: LD A,0x20

L1A23:
                DB      C5H                     ; 1A23: PUSH BC
                DB      D5H                     ; 1A24: PUSH DE
                DB      E5H                     ; 1A25: PUSH HL
                DB      5FH                     ; 1A26: LD E,A
                DB      0EH,02H                 ; 1A27: LD C,2
                DB      CDH,05H,00H             ; 1A29: CALL 0x0005
                DB      E1H                     ; 1A2C: POP HL
                DB      D1H                     ; 1A2D: POP DE
                DB      C1H                     ; 1A2E: POP BC
                DB      C9H                     ; 1A2F: RET

L1A30:
                DB      7EH                     ; 1A30: LD A,(HL)
                DB      E6H,7FH                 ; 1A31: AND 0x7f
                DB      CDH,23H,1AH             ; 1A33: CALL L1A23
                DB      23H                     ; 1A36: INC HL
                DB      05H                     ; 1A37: DEC B
                DB      C2H,30H,1AH             ; 1A38: JP nz,L1A30
                DB      C9H                     ; 1A3B: RET

L1A3C:
                DB      3EH,0DH                 ; 1A3C: LD A,13
                DB      CDH,23H,1AH             ; 1A3E: CALL L1A23
                DB      3EH,0AH                 ; 1A41: LD A,10
                DB      CDH,23H,1AH             ; 1A43: CALL L1A23
                DB      36H,04H                 ; 1A46: LD (HL),4
                DB      C9H                     ; 1A48: RET
                DB      D1H                     ; 1A49: POP DE
                DB      CDH,D0H,21H             ; 1A4A: CALL L21D0

L1A4D:
                DB      11H,25H,22H             ; 1A4D: LD DE,0x2225
                DB      CDH,D0H,21H             ; 1A50: CALL L21D0
                DB      3AH,25H,31H             ; 1A53: LD A,(0x3125)
                DB      3DH                     ; 1A56: DEC A
                DB      5FH                     ; 1A57: LD E,A
                DB      0EH,0EH                 ; 1A58: LD C,14
                DB      CDH,05H,00H             ; 1A5A: CALL 0x0005
                DB      C3H,2EH,01H             ; 1A5D: JP L012E

L1A60:
                DB      AFH                     ; 1A60: XOR A
                DB      32H,E2H,34H             ; 1A61: LD (0x34e2),A
                DB      32H,E3H,34H             ; 1A64: LD (0x34e3),A
                DB      3AH,5CH,00H             ; 1A67: LD A,(0x005c)
                DB      B7H                     ; 1A6A: OR A
                DB      CAH,75H,1AH             ; 1A6B: JP z,L1A75
                DB      3DH                     ; 1A6E: DEC A
                DB      5FH                     ; 1A6F: LD E,A
                DB      0EH,0EH                 ; 1A70: LD C,14
                DB      CDH,05H,00H             ; 1A72: CALL 0x0005

L1A75:
                DB      0EH,1BH                 ; 1A75: LD C,0x1b
                DB      CDH,05H,00H             ; 1A77: CALL 0x0005
                DB      EBH                     ; 1A7A: EX DE,HL
                DB      2AH,D1H,34H             ; 1A7B: LD HL,(0x34d1)
                DB      23H                     ; 1A7E: INC HL
                DB      01H,00H,00H             ; 1A7F: LD BC,0

L1A82:
                DB      D5H                     ; 1A82: PUSH DE
                DB      1AH                     ; 1A83: LD A,(DE)
                DB      1EH,08H                 ; 1A84: LD E,8

L1A86:
                DB      17H                     ; 1A86: RLA
                DB      DAH,8BH,1AH             ; 1A87: JP c,L1A8B
                DB      03H                     ; 1A8A: INC BC

L1A8B:
                DB      57H                     ; 1A8B: LD D,A
                DB      2BH                     ; 1A8C: DEC HL
                DB      7DH                     ; 1A8D: LD A,L
                DB      B4H                     ; 1A8E: OR H
                DB      CAH,9CH,1AH             ; 1A8F: JP z,L1A9C
                DB      7AH                     ; 1A92: LD A,D
                DB      1DH                     ; 1A93: DEC E
                DB      C2H,86H,1AH             ; 1A94: JP nz,L1A86
                DB      D1H                     ; 1A97: POP DE
                DB      13H                     ; 1A98: INC DE
                DB      C3H,82H,1AH             ; 1A99: JP L1A82

L1A9C:
                DB      D1H                     ; 1A9C: POP DE
                DB      69H                     ; 1A9D: LD L,C
                DB      60H                     ; 1A9E: LD H,B
                DB      3AH,D4H,34H             ; 1A9F: LD A,(0x34d4)
                DB      D6H,03H                 ; 1AA2: SUB 3
                DB      CAH,ACH,1AH             ; 1AA4: JP z,L1AAC

L1AA7:
                DB      29H                     ; 1AA7: ADD HL,HL
                DB      3DH                     ; 1AA8: DEC A
                DB      C2H,A7H,1AH             ; 1AA9: JP nz,L1AA7

L1AAC:
                DB      E5H                     ; 1AAC: PUSH HL
                DB      11H,B7H,24H             ; 1AAD: LD DE,0x24b7
                DB      CDH,D0H,21H             ; 1AB0: CALL L21D0
                DB      3AH,5CH,00H             ; 1AB3: LD A,(0x005c)
                DB      B7H                     ; 1AB6: OR A
                DB      C2H,C0H,1AH             ; 1AB7: JP nz,L1AC0
                DB      0EH,19H                 ; 1ABA: LD C,0x19
                DB      CDH,05H,00H             ; 1ABC: CALL 0x0005
                DB      3CH                     ; 1ABF: INC A

L1AC0:
                DB      C6H,40H                 ; 1AC0: ADD A,0x40
                DB      32H,C2H,24H             ; 1AC2: LD (0x24c2),A
                DB      11H,C2H,24H             ; 1AC5: LD DE,0x24c2
                DB      CDH,D0H,21H             ; 1AC8: CALL L21D0
                DB      E1H                     ; 1ACB: POP HL
                DB      CDH,F9H,1BH             ; 1ACC: CALL L1BF9
                DB      11H,C9H,24H             ; 1ACF: LD DE,0x24c9
                DB      CDH,D0H,21H             ; 1AD2: CALL L21D0
                DB      C3H,4DH,1AH             ; 1AD5: JP L1A4D

L1AD8:
                DB      0EH,23H                 ; 1AD8: LD C,0x23
                DB      11H,5CH,00H             ; 1ADA: LD DE,0x5c
                DB      CDH,05H,00H             ; 1ADD: CALL 0x0005
                DB      3AH,7DH,00H             ; 1AE0: LD A,(0x007d)
                DB      6FH                     ; 1AE3: LD L,A
                DB      E6H,07H                 ; 1AE4: AND 7
                DB      CAH,EBH,1AH             ; 1AE6: JP z,L1AEB
                DB      C6H,08H                 ; 1AE9: ADD A,8

L1AEB:
                DB      85H                     ; 1AEB: ADD A,L
                DB      0FH                     ; 1AEC: RRCA
                DB      0FH                     ; 1AED: RRCA
                DB      0FH                     ; 1AEE: RRCA
                DB      E6H,1FH                 ; 1AEF: AND 0x1f
                DB      6FH                     ; 1AF1: LD L,A
                DB      16H,00H                 ; 1AF2: LD D,0
                DB      3AH,7EH,00H             ; 1AF4: LD A,(0x007e)
                DB      0FH                     ; 1AF7: RRCA
                DB      D2H,00H,1BH             ; 1AF8: JP nc,L1B00
                DB      1EH,20H                 ; 1AFB: LD E,0x20
                DB      19H                     ; 1AFD: ADD HL,DE
                DB      E6H,7FH                 ; 1AFE: AND 0x7f

L1B00:
                DB      0FH                     ; 1B00: RRCA
                DB      D2H,09H,1BH             ; 1B01: JP nc,L1B09
                DB      1EH,40H                 ; 1B04: LD E,0x40
                DB      19H                     ; 1B06: ADD HL,DE
                DB      E6H,7FH                 ; 1B07: AND 0x7f

L1B09:
                DB      0FH                     ; 1B09: RRCA
                DB      D2H,12H,1BH             ; 1B0A: JP nc,L1B12
                DB      1EH,80H                 ; 1B0D: LD E,0x80
                DB      19H                     ; 1B0F: ADD HL,DE
                DB      E6H,7FH                 ; 1B10: AND 0x7f

L1B12:
                DB      67H                     ; 1B12: LD H,A
                DB      7DH                     ; 1B13: LD A,L
                DB      FEH,0AH                 ; 1B14: CP 10
                DB      F2H,1FH,1BH             ; 1B16: JP p,L1B1F
                DB      CDH,1EH,1AH             ; 1B19: CALL L1A1E
                DB      C3H,27H,1BH             ; 1B1C: JP L1B27

L1B1F:
                DB      FEH,64H                 ; 1B1F: CP 0x64
                DB      F2H,27H,1BH             ; 1B21: JP p,L1B27
                DB      CDH,21H,1AH             ; 1B24: CALL L1A21

L1B27:
                DB      CDH,21H,1AH             ; 1B27: CALL L1A21
                DB      CDH,F9H,1BH             ; 1B2A: CALL L1BF9
                DB      3EH,6BH                 ; 1B2D: LD A,0x6b
                DB      CDH,23H,1AH             ; 1B2F: CALL L1A23
                DB      C9H                     ; 1B32: RET

L1B33:
                DB      0EH,1FH                 ; 1B33: LD C,0x1f
                DB      CDH,05H,00H             ; 1B35: CALL 0x0005
                DB      23H                     ; 1B38: INC HL
                DB      23H                     ; 1B39: INC HL
                DB      7EH                     ; 1B3A: LD A,(HL)
                DB      32H,D4H,34H             ; 1B3B: LD (0x34d4),A
                DB      23H                     ; 1B3E: INC HL
                DB      7EH                     ; 1B3F: LD A,(HL)
                DB      32H,D3H,34H             ; 1B40: LD (L34D3),A
                DB      23H                     ; 1B43: INC HL
                DB      23H                     ; 1B44: INC HL
                DB      5EH                     ; 1B45: LD E,(HL)
                DB      23H                     ; 1B46: INC HL
                DB      56H                     ; 1B47: LD D,(HL)
                DB      EBH                     ; 1B48: EX DE,HL
                DB      22H,D1H,34H             ; 1B49: LD (0x34d1),HL
                DB      C9H                     ; 1B4C: RET

L1B4D:
                DB      3EH,02H                 ; 1B4D: LD A,2
                DB      11H,5CH,00H             ; 1B4F: LD DE,0x5c
                DB      CDH,91H,1CH             ; 1B52: CALL L1C91
                DB      C3H,2EH,01H             ; 1B55: JP L012E
                DB      11H,5CH,00H             ; 1B58: LD DE,0x5c
                DB      0EH,11H                 ; 1B5B: LD C,0x11
                DB      CDH,05H,00H             ; 1B5D: CALL 0x0005
                DB      3CH                     ; 1B60: INC A
                DB      C2H,6DH,1BH             ; 1B61: JP nz,L1B6D
                DB      11H,21H,23H             ; 1B64: LD DE,L2321
                DB      CDH,D0H,21H             ; 1B67: CALL L21D0
                DB      C3H,2EH,01H             ; 1B6A: JP L012E

L1B6D:
                DB      11H,5CH,00H             ; 1B6D: LD DE,0x5c
                DB      0EH,13H                 ; 1B70: LD C,0x13
                DB      CDH,05H,00H             ; 1B72: CALL 0x0005
                DB      11H,D8H,24H             ; 1B75: LD DE,0x24d8
                DB      CDH,D0H,21H             ; 1B78: CALL L21D0
                DB      C3H,2EH,01H             ; 1B7B: JP L012E

L1B7E:
                DB      3AH,35H,31H             ; 1B7E: LD A,(0x3135)
                DB      FEH,20H                 ; 1B81: CP 0x20
                DB      F2H,91H,1BH             ; 1B83: JP p,L1B91
                DB      11H,49H,24H             ; 1B86: LD DE,0x2449
                DB      CDH,D0H,21H             ; 1B89: CALL L21D0
                DB      3AH,35H,31H             ; 1B8C: LD A,(0x3135)
                DB      F6H,40H                 ; 1B8F: OR 0x40

L1B91:
                DB      0EH,02H                 ; 1B91: LD C,2
                DB      5FH                     ; 1B93: LD E,A
                DB      CDH,05H,00H             ; 1B94: CALL 0x0005
                DB      C9H                     ; 1B97: RET

ComOutputWait2:
; Secondary transmitter-ready loop using Bondwell port 41H.
                DB      DBH,41H                 ; 1B98: IN A,(0x0041)
                DB      E6H,04H                 ; 1B9A: AND 4
                DB      CAH,98H,1BH             ; 1B9C: JP z,ComOutputWait2

ComOutputByte2:
; Secondary character output using Bondwell port 40H.
                DB      7BH                     ; 1B9F: LD A,E
                DB      D3H,40H                 ; 1BA0: OUT (0x0040),A
                DB      C9H                     ; 1BA2: RET

L1BA3:
                DB      E1H                     ; 1BA3: POP HL
                DB      23H                     ; 1BA4: INC HL
                DB      23H                     ; 1BA5: INC HL
                DB      23H                     ; 1BA6: INC HL
                DB      E9H                     ; 1BA7: JP (HL)

L1BA8:
                DB      C9H                     ; 1BA8: RET

L1BA9:
                DB      3AH,59H,31H             ; 1BA9: LD A,(0x3159)
                DB      47H                     ; 1BAC: LD B,A
                DB      3AH,AFH,32H             ; 1BAD: LD A,(0x32af)
                DB      B8H                     ; 1BB0: CP B
                DB      C9H                     ; 1BB1: RET

L1BB2:
                DB      3CH                     ; 1BB2: INC A
                DB      E6H,3FH                 ; 1BB3: AND 0x3f
                DB      32H,59H,31H             ; 1BB5: LD (0x3159),A
                DB      2AH,5AH,31H             ; 1BB8: LD HL,(0x315a)
                DB      23H                     ; 1BBB: INC HL
                DB      22H,5AH,31H             ; 1BBC: LD (0x315a),HL
                DB      C9H                     ; 1BBF: RET

L1BC0:
                DB      AFH                     ; 1BC0: XOR A
                DB      32H,5EH,31H             ; 1BC1: LD (0x315e),A
                DB      32H,B0H,32H             ; 1BC4: LD (0x32b0),A
                DB      3EH,59H                 ; 1BC7: LD A,0x59
                DB      CDH,2BH,0EH             ; 1BC9: CALL L0E2B
                DB      C3H,D8H,02H             ; 1BCC: JP L02D8
                DB      C9H                     ; 1BCF: RET

L1BD0:
                DB      3CH                     ; 1BD0: INC A
                DB      32H,5FH,31H             ; 1BD1: LD (0x315f),A
                DB      3AH,59H,31H             ; 1BD4: LD A,(0x3159)
                DB      3DH                     ; 1BD7: DEC A
                DB      47H                     ; 1BD8: LD B,A
                DB      3AH,AFH,32H             ; 1BD9: LD A,(0x32af)
                DB      B8H                     ; 1BDC: CP B
                DB      C2H,DEH,02H             ; 1BDD: JP nz,L02DE
                DB      CDH,F4H,02H             ; 1BE0: CALL L02F4
                DB      CDH,C0H,1BH             ; 1BE3: CALL L1BC0
                DB      C9H                     ; 1BE6: RET

L1BE7:
                DB      3EH,01H                 ; 1BE7: LD A,1
                DB      CDH,91H,1CH             ; 1BE9: CALL L1C91
                DB      C3H,81H,01H             ; 1BEC: JP L0181
                DB      C9H                     ; 1BEF: RET

L1BF0:
                DB      3EH,04H                 ; 1BF0: LD A,4
                DB      CDH,91H,1CH             ; 1BF2: CALL L1C91
                DB      C3H,8AH,01H             ; 1BF5: JP L018A
                DB      C9H                     ; 1BF8: RET

L1BF9:
                DB      F5H                     ; 1BF9: PUSH AF
                DB      C5H                     ; 1BFA: PUSH BC
                DB      D5H                     ; 1BFB: PUSH DE
                DB      E5H                     ; 1BFC: PUSH HL
                DB      01H,F6H,FFH             ; 1BFD: LD BC,0xfff6
                DB      11H,FFH,FFH             ; 1C00: LD DE,0xffff

L1C03:
                DB      09H                     ; 1C03: ADD HL,BC
                DB      13H                     ; 1C04: INC DE
                DB      DAH,03H,1CH             ; 1C05: JP c,L1C03
                DB      01H,0AH,00H             ; 1C08: LD BC,10
                DB      09H                     ; 1C0B: ADD HL,BC
                DB      EBH                     ; 1C0C: EX DE,HL
                DB      7CH                     ; 1C0D: LD A,H
                DB      B5H                     ; 1C0E: OR L
                DB      C4H,F9H,1BH             ; 1C0F: CALL nz,L1BF9
                DB      7BH                     ; 1C12: LD A,E
                DB      C6H,30H                 ; 1C13: ADD A,0x30
                DB      5FH                     ; 1C15: LD E,A
                DB      0EH,02H                 ; 1C16: LD C,2
                DB      CDH,05H,00H             ; 1C18: CALL 0x0005
                DB      E1H                     ; 1C1B: POP HL
                DB      D1H                     ; 1C1C: POP DE
                DB      C1H                     ; 1C1D: POP BC
                DB      F1H                     ; 1C1E: POP AF
                DB      C9H                     ; 1C1F: RET

L1C20:
                DB      E1H                     ; 1C20: POP HL
                DB      E5H                     ; 1C21: PUSH HL
                DB      22H,4AH,30H             ; 1C22: LD (0x304a),HL
                DB      21H,00H,00H             ; 1C25: LD HL,0
                DB      39H                     ; 1C28: ADD HL,SP
                DB      22H,48H,30H             ; 1C29: LD (0x3048),HL
                DB      EBH                     ; 1C2C: EX DE,HL
                DB      22H,4CH,30H             ; 1C2D: LD (0x304c),HL
                DB      EBH                     ; 1C30: EX DE,HL
                DB      21H,52H,30H             ; 1C31: LD HL,0x3052
                DB      22H,D7H,30H             ; 1C34: LD (0x30d7),HL
                DB      22H,D9H,30H             ; 1C37: LD (0x30d9),HL
                DB      AFH                     ; 1C3A: XOR A
                DB      32H,45H,30H             ; 1C3B: LD (0x3045),A
                DB      32H,46H,30H             ; 1C3E: LD (0x3046),A
                DB      3EH,FFH                 ; 1C41: LD A,0xff
                DB      32H,47H,30H             ; 1C43: LD (0x3047),A
                DB      11H,C6H,2FH             ; 1C46: LD DE,0x2fc6
                DB      CDH,D0H,21H             ; 1C49: CALL L21D0
                DB      2AH,4CH,30H             ; 1C4C: LD HL,(0x304c)
                DB      EBH                     ; 1C4F: EX DE,HL
                DB      CDH,D0H,21H             ; 1C50: CALL L21D0
                DB      C9H                     ; 1C53: RET

L1C54:
                DB      2AH,48H,30H             ; 1C54: LD HL,(0x3048)
                DB      F9H                     ; 1C57: LD SP,HL
                DB      21H,52H,30H             ; 1C58: LD HL,0x3052
                DB      22H,D9H,30H             ; 1C5B: LD (0x30d9),HL
                DB      3EH,FFH                 ; 1C5E: LD A,0xff
                DB      32H,47H,30H             ; 1C60: LD (0x3047),A
                DB      2AH,4AH,30H             ; 1C63: LD HL,(0x304a)
                DB      E9H                     ; 1C66: JP (HL)

L1C67:
                DB      2AH,48H,30H             ; 1C67: LD HL,(0x3048)
                DB      F9H                     ; 1C6A: LD SP,HL
                DB      21H,52H,30H             ; 1C6B: LD HL,0x3052
                DB      22H,D7H,30H             ; 1C6E: LD (0x30d7),HL
                DB      22H,D9H,30H             ; 1C71: LD (0x30d9),HL
                DB      AFH                     ; 1C74: XOR A
                DB      32H,45H,30H             ; 1C75: LD (0x3045),A
                DB      32H,46H,30H             ; 1C78: LD (0x3046),A
                DB      3EH,FFH                 ; 1C7B: LD A,0xff
                DB      32H,47H,30H             ; 1C7D: LD (0x3047),A
                DB      11H,C6H,2FH             ; 1C80: LD DE,0x2fc6
                DB      CDH,D0H,21H             ; 1C83: CALL L21D0
                DB      2AH,4CH,30H             ; 1C86: LD HL,(0x304c)
                DB      EBH                     ; 1C89: EX DE,HL
                DB      CDH,D0H,21H             ; 1C8A: CALL L21D0
                DB      2AH,4AH,30H             ; 1C8D: LD HL,(0x304a)
                DB      E9H                     ; 1C90: JP (HL)

L1C91:
                DB      32H,44H,30H             ; 1C91: LD (0x3044),A
                DB      CDH,B4H,20H             ; 1C94: CALL L20B4
                DB      FEH,04H                 ; 1C97: CP 4
                DB      CAH,0FH,1DH             ; 1C99: JP z,L1D0F
                DB      FEH,01H                 ; 1C9C: CP 1
                DB      CAH,71H,1DH             ; 1C9E: JP z,L1D71
                DB      FEH,02H                 ; 1CA1: CP 2
                DB      CAH,C6H,1EH             ; 1CA3: JP z,L1EC6
                DB      FEH,10H                 ; 1CA6: CP 0x10
                DB      CAH,C6H,1EH             ; 1CA8: JP z,L1EC6
                DB      FEH,03H                 ; 1CAB: CP 3
                DB      CAH,87H,20H             ; 1CAD: JP z,L2087
                DB      FEH,05H                 ; 1CB0: CP 5
                DB      CAH,BCH,1CH             ; 1CB2: JP z,L1CBC
                DB      11H,29H,2FH             ; 1CB5: LD DE,0x2f29
                DB      CDH,D0H,21H             ; 1CB8: CALL L21D0
                DB      C9H                     ; 1CBB: RET

L1CBC:
                DB      EBH                     ; 1CBC: EX DE,HL
                DB      22H,4EH,30H             ; 1CBD: LD (0x304e),HL
                DB      06H,00H                 ; 1CC0: LD B,0

L1CC2:
                DB      CDH,70H,21H             ; 1CC2: CALL L2170
                DB      B7H                     ; 1CC5: OR A
                DB      F2H,03H,1DH             ; 1CC6: JP p,L1D03
                DB      E6H,7FH                 ; 1CC9: AND 0x7f
                DB      FEH,1BH                 ; 1CCB: CP 0x1b
                DB      C2H,ECH,1CH             ; 1CCD: JP nz,L1CEC
                DB      0EH,02H                 ; 1CD0: LD C,2
                DB      1EH,07H                 ; 1CD2: LD E,7
                DB      CDH,05H,00H             ; 1CD4: CALL 0x0005
                DB      AFH                     ; 1CD7: XOR A
                DB      32H,45H,30H             ; 1CD8: LD (0x3045),A
                DB      2AH,D7H,30H             ; 1CDB: LD HL,(0x30d7)
                DB      2BH                     ; 1CDE: DEC HL
                DB      22H,D7H,30H             ; 1CDF: LD (0x30d7),HL
                DB      22H,D9H,30H             ; 1CE2: LD (0x30d9),HL
                DB      21H,46H,30H             ; 1CE5: LD HL,0x3046
                DB      35H                     ; 1CE8: DEC (HL)
                DB      C3H,C2H,1CH             ; 1CE9: JP L1CC2

L1CEC:
                DB      FEH,3FH                 ; 1CEC: CP 0x3f
                DB      CAH,FEH,1CH             ; 1CEE: JP z,L1CFE
                DB      FEH,0CH                 ; 1CF1: CP 12
                DB      CCH,C9H,21H             ; 1CF3: CALL z,L21C9
                DB      78H                     ; 1CF6: LD A,B
                DB      2AH,4EH,30H             ; 1CF7: LD HL,(0x304e)
                DB      EBH                     ; 1CFA: EX DE,HL
                DB      C3H,A3H,1BH             ; 1CFB: JP L1BA3

L1CFE:
                DB      21H,45H,30H             ; 1CFE: LD HL,0x3045
                DB      36H,00H                 ; 1D01: LD (HL),0

L1D03:
                DB      04H                     ; 1D03: INC B
                DB      2AH,4EH,30H             ; 1D04: LD HL,(0x304e)
                DB      77H                     ; 1D07: LD (HL),A
                DB      23H                     ; 1D08: INC HL
                DB      22H,4EH,30H             ; 1D09: LD (0x304e),HL
                DB      C3H,C2H,1CH             ; 1D0C: JP L1CC2

L1D0F:
                DB      CDH,70H,21H             ; 1D0F: CALL L2170
                DB      B7H                     ; 1D12: OR A
                DB      F0H                     ; 1D13: RET p
                DB      E6H,7FH                 ; 1D14: AND 0x7f
                DB      FEH,1BH                 ; 1D16: CP 0x1b
                DB      C2H,37H,1DH             ; 1D18: JP nz,L1D37
                DB      0EH,02H                 ; 1D1B: LD C,2
                DB      1EH,07H                 ; 1D1D: LD E,7
                DB      CDH,05H,00H             ; 1D1F: CALL 0x0005
                DB      AFH                     ; 1D22: XOR A
                DB      32H,45H,30H             ; 1D23: LD (0x3045),A
                DB      2AH,D7H,30H             ; 1D26: LD HL,(0x30d7)
                DB      2BH                     ; 1D29: DEC HL
                DB      22H,D7H,30H             ; 1D2A: LD (0x30d7),HL
                DB      22H,D9H,30H             ; 1D2D: LD (0x30d9),HL
                DB      21H,46H,30H             ; 1D30: LD HL,0x3046
                DB      35H                     ; 1D33: DEC (HL)
                DB      C3H,0FH,1DH             ; 1D34: JP L1D0F

L1D37:
                DB      FEH,3FH                 ; 1D37: CP 0x3f
                DB      C2H,69H,1DH             ; 1D39: JP nz,L1D69
                DB      11H,A8H,2FH             ; 1D3C: LD DE,0x2fa8
                DB      CDH,D0H,21H             ; 1D3F: CALL L21D0
                DB      11H,C6H,2FH             ; 1D42: LD DE,0x2fc6
                DB      CDH,D0H,21H             ; 1D45: CALL L21D0
                DB      2AH,4CH,30H             ; 1D48: LD HL,(0x304c)
                DB      EBH                     ; 1D4B: EX DE,HL
                DB      CDH,D0H,21H             ; 1D4C: CALL L21D0
                DB      2AH,D9H,30H             ; 1D4F: LD HL,(0x30d9)
                DB      3EH,24H                 ; 1D52: LD A,0x24
                DB      77H                     ; 1D54: LD (HL),A
                DB      2AH,D7H,30H             ; 1D55: LD HL,(0x30d7)
                DB      2BH                     ; 1D58: DEC HL
                DB      22H,D7H,30H             ; 1D59: LD (0x30d7),HL
                DB      11H,52H,30H             ; 1D5C: LD DE,0x3052
                DB      CDH,D0H,21H             ; 1D5F: CALL L21D0
                DB      AFH                     ; 1D62: XOR A
                DB      32H,45H,30H             ; 1D63: LD (0x3045),A
                DB      C3H,54H,1CH             ; 1D66: JP L1C54

L1D69:
                DB      FEH,0CH                 ; 1D69: CP 12
                DB      CCH,C9H,21H             ; 1D6B: CALL z,L21C9
                DB      C3H,A3H,1BH             ; 1D6E: JP L1BA3

L1D71:
                DB      22H,50H,30H             ; 1D71: LD (L3050),HL
                DB      EBH                     ; 1D74: EX DE,HL
                DB      22H,4EH,30H             ; 1D75: LD (0x304e),HL
                DB      46H                     ; 1D78: LD B,(HL)
                DB      23H                     ; 1D79: INC HL
                DB      22H,DBH,30H             ; 1D7A: LD (0x30db),HL
                DB      2AH,D9H,30H             ; 1D7D: LD HL,(0x30d9)
                DB      22H,DDH,30H             ; 1D80: LD (0x30dd),HL

L1D83:
                DB      78H                     ; 1D83: LD A,B
                DB      B7H                     ; 1D84: OR A
                DB      C8H                     ; 1D85: RET z
                DB      2AH,DBH,30H             ; 1D86: LD HL,(0x30db)
                DB      5EH                     ; 1D89: LD E,(HL)
                DB      23H                     ; 1D8A: INC HL

L1D8B:
                DB      1DH                     ; 1D8B: DEC E
                DB      7BH                     ; 1D8C: LD A,E
                DB      FEH,FFH                 ; 1D8D: CP 0xff
                DB      FAH,72H,1EH             ; 1D8F: JP m,L1E72
                DB      CDH,70H,21H             ; 1D92: CALL L2170
                DB      B7H                     ; 1D95: OR A
                DB      F2H,60H,1EH             ; 1D96: JP p,L1E60
                DB      E6H,7FH                 ; 1D99: AND 0x7f
                DB      FEH,3FH                 ; 1D9B: CP 0x3f
                DB      C2H,D2H,1DH             ; 1D9D: JP nz,L1DD2
                DB      AFH                     ; 1DA0: XOR A
                DB      32H,45H,30H             ; 1DA1: LD (0x3045),A
                DB      21H,46H,30H             ; 1DA4: LD HL,0x3046
                DB      35H                     ; 1DA7: DEC (HL)
                DB      2AH,50H,30H             ; 1DA8: LD HL,(L3050)
                DB      EBH                     ; 1DAB: EX DE,HL
                DB      CDH,D0H,21H             ; 1DAC: CALL L21D0
                DB      11H,C6H,2FH             ; 1DAF: LD DE,0x2fc6
                DB      CDH,D0H,21H             ; 1DB2: CALL L21D0
                DB      2AH,4CH,30H             ; 1DB5: LD HL,(0x304c)
                DB      EBH                     ; 1DB8: EX DE,HL
                DB      CDH,D0H,21H             ; 1DB9: CALL L21D0
                DB      2AH,D9H,30H             ; 1DBC: LD HL,(0x30d9)
                DB      3EH,24H                 ; 1DBF: LD A,0x24
                DB      77H                     ; 1DC1: LD (HL),A
                DB      2AH,D7H,30H             ; 1DC2: LD HL,(0x30d7)
                DB      2BH                     ; 1DC5: DEC HL
                DB      22H,D7H,30H             ; 1DC6: LD (0x30d7),HL
                DB      11H,52H,30H             ; 1DC9: LD DE,0x3052
                DB      CDH,D0H,21H             ; 1DCC: CALL L21D0
                DB      C3H,54H,1CH             ; 1DCF: JP L1C54

L1DD2:
                DB      FEH,1BH                 ; 1DD2: CP 0x1b
                DB      C2H,41H,1EH             ; 1DD4: JP nz,L1E41
                DB      AFH                     ; 1DD7: XOR A
                DB      32H,45H,30H             ; 1DD8: LD (0x3045),A
                DB      D5H                     ; 1DDB: PUSH DE
                DB      C5H                     ; 1DDC: PUSH BC
                DB      E5H                     ; 1DDD: PUSH HL
                DB      CDH,8DH,1EH             ; 1DDE: CALL L1E8D
                DB      C3H,00H,1EH             ; 1DE1: JP L1E00
                DB      0EH,02H                 ; 1DE4: LD C,2
                DB      1EH,07H                 ; 1DE6: LD E,7
                DB      CDH,05H,00H             ; 1DE8: CALL 0x0005
                DB      2AH,D7H,30H             ; 1DEB: LD HL,(0x30d7)
                DB      2BH                     ; 1DEE: DEC HL
                DB      22H,D7H,30H             ; 1DEF: LD (0x30d7),HL
                DB      22H,D9H,30H             ; 1DF2: LD (0x30d9),HL
                DB      21H,46H,30H             ; 1DF5: LD HL,0x3046
                DB      35H                     ; 1DF8: DEC (HL)
                DB      E1H                     ; 1DF9: POP HL
                DB      C1H                     ; 1DFA: POP BC
                DB      D1H                     ; 1DFB: POP DE
                DB      1CH                     ; 1DFC: INC E
                DB      C3H,8BH,1DH             ; 1DFD: JP L1D8B

L1E00:
                DB      2AH,D7H,30H             ; 1E00: LD HL,(0x30d7)
                DB      2BH                     ; 1E03: DEC HL
                DB      EBH                     ; 1E04: EX DE,HL
                DB      E1H                     ; 1E05: POP HL
                DB      E5H                     ; 1E06: PUSH HL

L1E07:
                DB      7EH                     ; 1E07: LD A,(HL)
                DB      FEH,24H                 ; 1E08: CP 0x24
                DB      CAH,1CH,1EH             ; 1E0A: JP z,L1E1C
                DB      23H                     ; 1E0D: INC HL
                DB      EBH                     ; 1E0E: EX DE,HL
                DB      77H                     ; 1E0F: LD (HL),A
                DB      23H                     ; 1E10: INC HL
                DB      EBH                     ; 1E11: EX DE,HL
                DB      3AH,46H,30H             ; 1E12: LD A,(0x3046)
                DB      3CH                     ; 1E15: INC A
                DB      32H,46H,30H             ; 1E16: LD (0x3046),A
                DB      C3H,07H,1EH             ; 1E19: JP L1E07

L1E1C:
                DB      3AH,46H,30H             ; 1E1C: LD A,(0x3046)
                DB      3CH                     ; 1E1F: INC A
                DB      32H,46H,30H             ; 1E20: LD (0x3046),A
                DB      EBH                     ; 1E23: EX DE,HL
                DB      3EH,20H                 ; 1E24: LD A,0x20
                DB      77H                     ; 1E26: LD (HL),A
                DB      23H                     ; 1E27: INC HL
                DB      22H,D7H,30H             ; 1E28: LD (0x30d7),HL
                DB      22H,D9H,30H             ; 1E2B: LD (0x30d9),HL
                DB      E1H                     ; 1E2E: POP HL
                DB      E5H                     ; 1E2F: PUSH HL
                DB      EBH                     ; 1E30: EX DE,HL
                DB      CDH,D0H,21H             ; 1E31: CALL L21D0
                DB      0EH,02H                 ; 1E34: LD C,2
                DB      1EH,20H                 ; 1E36: LD E,0x20
                DB      CDH,05H,00H             ; 1E38: CALL 0x0005
                DB      E1H                     ; 1E3B: POP HL
                DB      C1H                     ; 1E3C: POP BC
                DB      D1H                     ; 1E3D: POP DE
                DB      C3H,54H,1EH             ; 1E3E: JP L1E54

L1E41:
                DB      E5H                     ; 1E41: PUSH HL
                DB      D5H                     ; 1E42: PUSH DE
                DB      CDH,8DH,1EH             ; 1E43: CALL L1E8D
                DB      C3H,52H,1EH             ; 1E46: JP L1E52
                DB      11H,4FH,2FH             ; 1E49: LD DE,0x2f4f
                DB      CDH,D0H,21H             ; 1E4C: CALL L21D0
                DB      C3H,67H,1CH             ; 1E4F: JP L1C67

L1E52:
                DB      D1H                     ; 1E52: POP DE
                DB      E1H                     ; 1E53: POP HL

L1E54:
                DB      1CH                     ; 1E54: INC E
                DB      16H,00H                 ; 1E55: LD D,0
                DB      19H                     ; 1E57: ADD HL,DE
                DB      23H                     ; 1E58: INC HL
                DB      5EH                     ; 1E59: LD E,(HL)
                DB      23H                     ; 1E5A: INC HL
                DB      56H                     ; 1E5B: LD D,(HL)
                DB      7BH                     ; 1E5C: LD A,E
                DB      C3H,A3H,1BH             ; 1E5D: JP L1BA3

L1E60:
                DB      FEH,61H                 ; 1E60: CP 0x61
                DB      FAH,6CH,1EH             ; 1E62: JP m,L1E6C
                DB      FEH,7BH                 ; 1E65: CP 0x7b
                DB      F2H,6CH,1EH             ; 1E67: JP p,L1E6C
                DB      E6H,5FH                 ; 1E6A: AND 0x5f

L1E6C:
                DB      56H                     ; 1E6C: LD D,(HL)
                DB      23H                     ; 1E6D: INC HL
                DB      BAH                     ; 1E6E: CP D
                DB      CAH,8BH,1DH             ; 1E6F: JP z,L1D8B

L1E72:
                DB      16H,00H                 ; 1E72: LD D,0
                DB      7BH                     ; 1E74: LD A,E
                DB      B7H                     ; 1E75: OR A
                DB      F2H,7BH,1EH             ; 1E76: JP p,L1E7B
                DB      16H,FFH                 ; 1E79: LD D,0xff

L1E7B:
                DB      19H                     ; 1E7B: ADD HL,DE
                DB      11H,03H,00H             ; 1E7C: LD DE,3
                DB      19H                     ; 1E7F: ADD HL,DE
                DB      22H,DBH,30H             ; 1E80: LD (0x30db),HL
                DB      05H                     ; 1E83: DEC B
                DB      2AH,DDH,30H             ; 1E84: LD HL,(0x30dd)
                DB      22H,D9H,30H             ; 1E87: LD (0x30d9),HL
                DB      C3H,83H,1DH             ; 1E8A: JP L1D83

L1E8D:
                DB      05H                     ; 1E8D: DEC B
                DB      F8H                     ; 1E8E: RET m
                DB      1CH                     ; 1E8F: INC E
                DB      4BH                     ; 1E90: LD C,E
                DB      7BH                     ; 1E91: LD A,E
                DB      B7H                     ; 1E92: OR A
                DB      C8H                     ; 1E93: RET z
                DB      16H,00H                 ; 1E94: LD D,0
                DB      19H                     ; 1E96: ADD HL,DE
                DB      1EH,03H                 ; 1E97: LD E,3
                DB      19H                     ; 1E99: ADD HL,DE
                DB      46H                     ; 1E9A: LD B,(HL)
                DB      23H                     ; 1E9B: INC HL
                DB      EBH                     ; 1E9C: EX DE,HL
                DB      2AH,DBH,30H             ; 1E9D: LD HL,(0x30db)
                DB      7EH                     ; 1EA0: LD A,(HL)
                DB      91H                     ; 1EA1: SUB C
                DB      4FH                     ; 1EA2: LD C,A
                DB      B8H                     ; 1EA3: CP B
                DB      CAH,A8H,1EH             ; 1EA4: JP z,L1EA8
                DB      F0H                     ; 1EA7: RET p

L1EA8:
                DB      2AH,DDH,30H             ; 1EA8: LD HL,(0x30dd)

L1EAB:
                DB      0DH                     ; 1EAB: DEC C
                DB      FAH,A3H,1BH             ; 1EAC: JP m,L1BA3
                DB      EBH                     ; 1EAF: EX DE,HL
                DB      46H                     ; 1EB0: LD B,(HL)
                DB      23H                     ; 1EB1: INC HL
                DB      EBH                     ; 1EB2: EX DE,HL
                DB      7EH                     ; 1EB3: LD A,(HL)
                DB      23H                     ; 1EB4: INC HL
                DB      FEH,61H                 ; 1EB5: CP 0x61
                DB      FAH,C1H,1EH             ; 1EB7: JP m,L1EC1
                DB      FEH,7BH                 ; 1EBA: CP 0x7b
                DB      F2H,C1H,1EH             ; 1EBC: JP p,L1EC1
                DB      E6H,5FH                 ; 1EBF: AND 0x5f

L1EC1:
                DB      B8H                     ; 1EC1: CP B
                DB      C0H                     ; 1EC2: RET nz
                DB      C3H,ABH,1EH             ; 1EC3: JP L1EAB

L1EC6:
                DB      32H,D6H,30H             ; 1EC6: LD (0x30d6),A
                DB      EBH                     ; 1EC9: EX DE,HL
                DB      22H,D2H,30H             ; 1ECA: LD (0x30d2),HL
                DB      1EH,00H                 ; 1ECD: LD E,0
                DB      36H,00H                 ; 1ECF: LD (HL),0
                DB      23H                     ; 1ED1: INC HL
                DB      22H,D4H,30H             ; 1ED2: LD (0x30d4),HL
                DB      AFH                     ; 1ED5: XOR A

L1ED6:
                DB      36H,20H                 ; 1ED6: LD (HL),0x20
                DB      23H                     ; 1ED8: INC HL
                DB      3CH                     ; 1ED9: INC A
                DB      FEH,0CH                 ; 1EDA: CP 12
                DB      FAH,D6H,1EH             ; 1EDC: JP m,L1ED6

L1EDF:
                DB      CDH,70H,21H             ; 1EDF: CALL L2170
                DB      B7H                     ; 1EE2: OR A
                DB      F2H,E5H,1FH             ; 1EE3: JP p,L1FE5
                DB      E6H,7FH                 ; 1EE6: AND 0x7f
                DB      FEH,3FH                 ; 1EE8: CP 0x3f
                DB      C2H,03H,1FH             ; 1EEA: JP nz,L1F03
                DB      21H,45H,30H             ; 1EED: LD HL,0x3045
                DB      36H,00H                 ; 1EF0: LD (HL),0
                DB      2AH,D7H,30H             ; 1EF2: LD HL,(0x30d7)
                DB      23H                     ; 1EF5: INC HL
                DB      22H,D7H,30H             ; 1EF6: LD (0x30d7),HL
                DB      2AH,D9H,30H             ; 1EF9: LD HL,(0x30d9)
                DB      23H                     ; 1EFC: INC HL
                DB      22H,D9H,30H             ; 1EFD: LD (0x30d9),HL
                DB      C3H,64H,20H             ; 1F00: JP L2064

L1F03:
                DB      FEH,1BH                 ; 1F03: CP 0x1b
                DB      C2H,D7H,1FH             ; 1F05: JP nz,L1FD7
                DB      AFH                     ; 1F08: XOR A
                DB      32H,45H,30H             ; 1F09: LD (0x3045),A
                DB      2AH,D7H,30H             ; 1F0C: LD HL,(0x30d7)
                DB      2BH                     ; 1F0F: DEC HL
                DB      22H,D7H,30H             ; 1F10: LD (0x30d7),HL
                DB      22H,D9H,30H             ; 1F13: LD (0x30d9),HL
                DB      21H,46H,30H             ; 1F16: LD HL,0x3046
                DB      35H                     ; 1F19: DEC (HL)
                DB      7BH                     ; 1F1A: LD A,E
                DB      32H,ABH,32H             ; 1F1B: LD (L32AB),A
                DB      FEH,09H                 ; 1F1E: CP 9
                DB      FAH,24H,1FH             ; 1F20: JP m,L1F24
                DB      3DH                     ; 1F23: DEC A

L1F24:
                DB      2AH,D4H,30H             ; 1F24: LD HL,(0x30d4)

L1F27:
                DB      FEH,0BH                 ; 1F27: CP 11
                DB      F2H,33H,1FH             ; 1F29: JP p,L1F33
                DB      36H,3FH                 ; 1F2C: LD (HL),0x3f
                DB      23H                     ; 1F2E: INC HL
                DB      3CH                     ; 1F2F: INC A
                DB      C3H,27H,1FH             ; 1F30: JP L1F27

L1F33:
                DB      0EH,11H                 ; 1F33: LD C,0x11
                DB      2AH,D2H,30H             ; 1F35: LD HL,(0x30d2)
                DB      EBH                     ; 1F38: EX DE,HL
                DB      CDH,05H,00H             ; 1F39: CALL 0x0005
                DB      FEH,FFH                 ; 1F3C: CP 0xff
                DB      CAH,CDH,1FH             ; 1F3E: JP z,L1FCD
                DB      21H,D0H,32H             ; 1F41: LD HL,0x32d0
                DB      CDH,8CH,20H             ; 1F44: CALL L208C
                DB      21H,E0H,32H             ; 1F47: LD HL,0x32e0
                DB      CDH,8CH,20H             ; 1F4A: CALL L208C
                DB      0EH,12H                 ; 1F4D: LD C,0x12
                DB      2AH,D2H,30H             ; 1F4F: LD HL,(0x30d2)
                DB      EBH                     ; 1F52: EX DE,HL
                DB      CDH,05H,00H             ; 1F53: CALL 0x0005
                DB      FEH,FFH                 ; 1F56: CP 0xff
                DB      CAH,61H,1FH             ; 1F58: JP z,L1F61
                DB      21H,E0H,32H             ; 1F5B: LD HL,0x32e0
                DB      CDH,8CH,20H             ; 1F5E: CALL L208C

L1F61:
                DB      11H,D0H,32H             ; 1F61: LD DE,0x32d0
                DB      21H,E0H,32H             ; 1F64: LD HL,0x32e0
                DB      3AH,ABH,32H             ; 1F67: LD A,(L32AB)
                DB      FEH,09H                 ; 1F6A: CP 9
                DB      FAH,70H,1FH             ; 1F6C: JP m,L1F70
                DB      3DH                     ; 1F6F: DEC A

L1F70:
                DB      0EH,00H                 ; 1F70: LD C,0

L1F72:
                DB      B9H                     ; 1F72: CP C
                DB      CAH,7CH,1FH             ; 1F73: JP z,L1F7C
                DB      13H                     ; 1F76: INC DE
                DB      23H                     ; 1F77: INC HL
                DB      0CH                     ; 1F78: INC C
                DB      C3H,72H,1FH             ; 1F79: JP L1F72

L1F7C:
                DB      79H                     ; 1F7C: LD A,C
                DB      FEH,0BH                 ; 1F7D: CP 11
                DB      CAH,A8H,1FH             ; 1F7F: JP z,L1FA8
                DB      FEH,08H                 ; 1F82: CP 8
                DB      C2H,94H,1FH             ; 1F84: JP nz,L1F94
                DB      3AH,ABH,32H             ; 1F87: LD A,(L32AB)
                DB      FEH,09H                 ; 1F8A: CP 9
                DB      CAH,94H,1FH             ; 1F8C: JP z,L1F94
                DB      3EH,2EH                 ; 1F8F: LD A,0x2e
                DB      CDH,A5H,20H             ; 1F91: CALL L20A5

L1F94:
                DB      1AH                     ; 1F94: LD A,(DE)
                DB      13H                     ; 1F95: INC DE
                DB      46H                     ; 1F96: LD B,(HL)
                DB      23H                     ; 1F97: INC HL
                DB      B8H                     ; 1F98: CP B
                DB      C2H,A8H,1FH             ; 1F99: JP nz,L1FA8
                DB      0CH                     ; 1F9C: INC C
                DB      FEH,20H                 ; 1F9D: CP 0x20
                DB      CAH,7CH,1FH             ; 1F9F: JP z,L1F7C
                DB      CDH,A5H,20H             ; 1FA2: CALL L20A5
                DB      C3H,7CH,1FH             ; 1FA5: JP L1F7C

L1FA8:
                DB      79H                     ; 1FA8: LD A,C
                DB      32H,ABH,32H             ; 1FA9: LD (L32AB),A
                DB      3EH,24H                 ; 1FAC: LD A,0x24
                DB      CDH,A5H,20H             ; 1FAE: CALL L20A5
                DB      2AH,D9H,30H             ; 1FB1: LD HL,(0x30d9)
                DB      EBH                     ; 1FB4: EX DE,HL
                DB      0EH,09H                 ; 1FB5: LD C,9
                DB      CDH,05H,00H             ; 1FB7: CALL 0x0005
                DB      2AH,D7H,30H             ; 1FBA: LD HL,(0x30d7)
                DB      2BH                     ; 1FBD: DEC HL
                DB      22H,D7H,30H             ; 1FBE: LD (0x30d7),HL
                DB      21H,46H,30H             ; 1FC1: LD HL,0x3046
                DB      35H                     ; 1FC4: DEC (HL)
                DB      3AH,ABH,32H             ; 1FC5: LD A,(L32AB)
                DB      FEH,0BH                 ; 1FC8: CP 11
                DB      CAH,54H,1CH             ; 1FCA: JP z,L1C54

L1FCD:
                DB      0EH,02H                 ; 1FCD: LD C,2
                DB      1EH,07H                 ; 1FCF: LD E,7
                DB      CDH,05H,00H             ; 1FD1: CALL 0x0005
                DB      C3H,54H,1CH             ; 1FD4: JP L1C54

L1FD7:
                DB      7BH                     ; 1FD7: LD A,E
                DB      FEH,00H                 ; 1FD8: CP 0
                DB      CAH,70H,20H             ; 1FDA: JP z,L2070
                DB      FEH,0DH                 ; 1FDD: CP 13
                DB      F2H,70H,20H             ; 1FDF: JP p,L2070
                DB      C3H,A3H,1BH             ; 1FE2: JP L1BA3

L1FE5:
                DB      FEH,2EH                 ; 1FE5: CP 0x2e
                DB      C2H,06H,20H             ; 1FE7: JP nz,L2006
                DB      1CH                     ; 1FEA: INC E
                DB      7BH                     ; 1FEB: LD A,E
                DB      FEH,01H                 ; 1FEC: CP 1
                DB      CAH,70H,20H             ; 1FEE: JP z,L2070
                DB      FEH,0AH                 ; 1FF1: CP 10
                DB      F2H,70H,20H             ; 1FF3: JP p,L2070
                DB      0EH,09H                 ; 1FF6: LD C,9
                DB      06H,00H                 ; 1FF8: LD B,0
                DB      2AH,D2H,30H             ; 1FFA: LD HL,(0x30d2)
                DB      09H                     ; 1FFD: ADD HL,BC
                DB      22H,D4H,30H             ; 1FFE: LD (0x30d4),HL
                DB      1EH,09H                 ; 2001: LD E,9
                DB      C3H,DFH,1EH             ; 2003: JP L1EDF

L2006:
                DB      FEH,3AH                 ; 2006: CP 0x3a
                DB      C2H,23H,20H             ; 2008: JP nz,L2023
                DB      1CH                     ; 200B: INC E
                DB      7BH                     ; 200C: LD A,E
                DB      FEH,02H                 ; 200D: CP 2
                DB      C2H,70H,20H             ; 200F: JP nz,L2070
                DB      2AH,D4H,30H             ; 2012: LD HL,(0x30d4)
                DB      2BH                     ; 2015: DEC HL
                DB      7EH                     ; 2016: LD A,(HL)
                DB      D6H,40H                 ; 2017: SUB 0x40
                DB      22H,D4H,30H             ; 2019: LD (0x30d4),HL
                DB      2BH                     ; 201C: DEC HL
                DB      77H                     ; 201D: LD (HL),A
                DB      1EH,00H                 ; 201E: LD E,0
                DB      C3H,DFH,1EH             ; 2020: JP L1EDF

L2023:
                DB      FEH,2AH                 ; 2023: CP 0x2a
                DB      C2H,53H,20H             ; 2025: JP nz,L2053
                DB      3AH,D6H,30H             ; 2028: LD A,(0x30d6)
                DB      FEH,00H                 ; 202B: CP 0
                DB      CAH,81H,20H             ; 202D: JP z,L2081
                DB      7BH                     ; 2030: LD A,E
                DB      FEH,08H                 ; 2031: CP 8
                DB      CAH,70H,20H             ; 2033: JP z,L2070
                DB      F2H,3EH,20H             ; 2036: JP p,L203E
                DB      06H,08H                 ; 2039: LD B,8
                DB      C3H,40H,20H             ; 203B: JP L2040

L203E:
                DB      06H,0CH                 ; 203E: LD B,12

L2040:
                DB      2AH,D4H,30H             ; 2040: LD HL,(0x30d4)
                DB      3EH,3FH                 ; 2043: LD A,0x3f
                DB      77H                     ; 2045: LD (HL),A
                DB      23H                     ; 2046: INC HL
                DB      22H,D4H,30H             ; 2047: LD (0x30d4),HL
                DB      1CH                     ; 204A: INC E
                DB      7BH                     ; 204B: LD A,E
                DB      B8H                     ; 204C: CP B
                DB      FAH,40H,20H             ; 204D: JP m,L2040
                DB      C3H,DFH,1EH             ; 2050: JP L1EDF

L2053:
                DB      FEH,30H                 ; 2053: CP 0x30
                DB      FAH,70H,20H             ; 2055: JP m,L2070
                DB      FEH,7BH                 ; 2058: CP 0x7b
                DB      F2H,70H,20H             ; 205A: JP p,L2070
                DB      FEH,41H                 ; 205D: CP 0x41
                DB      FAH,64H,20H             ; 205F: JP m,L2064
                DB      E6H,5FH                 ; 2062: AND 0x5f

L2064:
                DB      2AH,D4H,30H             ; 2064: LD HL,(0x30d4)
                DB      77H                     ; 2067: LD (HL),A
                DB      23H                     ; 2068: INC HL
                DB      22H,D4H,30H             ; 2069: LD (0x30d4),HL
                DB      1CH                     ; 206C: INC E
                DB      C3H,DFH,1EH             ; 206D: JP L1EDF

L2070:
                DB      3AH,44H,30H             ; 2070: LD A,(0x3044)
                DB      FEH,10H                 ; 2073: CP 0x10
                DB      CAH,A8H,1BH             ; 2075: JP z,L1BA8
                DB      11H,5CH,2FH             ; 2078: LD DE,0x2f5c

L207B:
                DB      0EH,09H                 ; 207B: LD C,9
                DB      CDH,05H,00H             ; 207D: CALL 0x0005
                DB      C9H                     ; 2080: RET

L2081:
                DB      11H,7FH,2FH             ; 2081: LD DE,0x2f7f
                DB      C3H,7BH,20H             ; 2084: JP L207B

L2087:
                DB      3EH,00H                 ; 2087: LD A,0
                DB      C3H,C6H,1EH             ; 2089: JP L1EC6

L208C:
                DB      F5H                     ; 208C: PUSH AF
                DB      11H,80H,00H             ; 208D: LD DE,0x80
                DB      07H                     ; 2090: RLCA
                DB      07H                     ; 2091: RLCA
                DB      07H                     ; 2092: RLCA
                DB      07H                     ; 2093: RLCA
                DB      07H                     ; 2094: RLCA
                DB      83H                     ; 2095: ADD A,E
                DB      C6H,01H                 ; 2096: ADD A,1
                DB      5FH                     ; 2098: LD E,A
                DB      06H,0BH                 ; 2099: LD B,11

L209B:
                DB      1AH                     ; 209B: LD A,(DE)
                DB      13H                     ; 209C: INC DE
                DB      77H                     ; 209D: LD (HL),A
                DB      23H                     ; 209E: INC HL
                DB      05H                     ; 209F: DEC B
                DB      C2H,9BH,20H             ; 20A0: JP nz,L209B
                DB      F1H                     ; 20A3: POP AF
                DB      C9H                     ; 20A4: RET

L20A5:
                DB      E5H                     ; 20A5: PUSH HL
                DB      2AH,D7H,30H             ; 20A6: LD HL,(0x30d7)
                DB      77H                     ; 20A9: LD (HL),A
                DB      23H                     ; 20AA: INC HL
                DB      22H,D7H,30H             ; 20AB: LD (0x30d7),HL
                DB      21H,46H,30H             ; 20AE: LD HL,0x3046
                DB      34H                     ; 20B1: INC (HL)
                DB      E1H                     ; 20B2: POP HL
                DB      C9H                     ; 20B3: RET

L20B4:
                DB      F5H                     ; 20B4: PUSH AF
                DB      D5H                     ; 20B5: PUSH DE
                DB      E5H                     ; 20B6: PUSH HL
                DB      3AH,45H,30H             ; 20B7: LD A,(0x3045)
                DB      B7H                     ; 20BA: OR A
                DB      C2H,6CH,21H             ; 20BB: JP nz,L216C

L20BE:
                DB      21H,46H,30H             ; 20BE: LD HL,0x3046
                DB      34H                     ; 20C1: INC (HL)
                DB      0EH,01H                 ; 20C2: LD C,1
                DB      CDH,05H,00H             ; 20C4: CALL 0x0005
                DB      2AH,D7H,30H             ; 20C7: LD HL,(0x30d7)
                DB      77H                     ; 20CA: LD (HL),A
                DB      23H                     ; 20CB: INC HL
                DB      22H,D7H,30H             ; 20CC: LD (0x30d7),HL
                DB      FEH,15H                 ; 20CF: CP 0x15
                DB      CAH,D9H,20H             ; 20D1: JP z,L20D9
                DB      FEH,18H                 ; 20D4: CP 0x18
                DB      C2H,F6H,20H             ; 20D6: JP nz,L20F6

L20D9:
                DB      11H,E7H,2CH             ; 20D9: LD DE,0x2ce7
                DB      CDH,D0H,21H             ; 20DC: CALL L21D0
                DB      0EH,09H                 ; 20DF: LD C,9
                DB      2AH,4CH,30H             ; 20E1: LD HL,(0x304c)
                DB      EBH                     ; 20E4: EX DE,HL
                DB      CDH,05H,00H             ; 20E5: CALL 0x0005
                DB      21H,52H,30H             ; 20E8: LD HL,0x3052
                DB      22H,D7H,30H             ; 20EB: LD (0x30d7),HL
                DB      21H,46H,30H             ; 20EE: LD HL,0x3046
                DB      36H,00H                 ; 20F1: LD (HL),0
                DB      C3H,54H,1CH             ; 20F3: JP L1C54

L20F6:
                DB      FEH,08H                 ; 20F6: CP 8
                DB      CAH,0CH,21H             ; 20F8: JP z,L210C
                DB      FEH,7FH                 ; 20FB: CP 0x7f
                DB      C2H,33H,21H             ; 20FD: JP nz,L2133
                DB      11H,E0H,2CH             ; 2100: LD DE,0x2ce0
                DB      CDH,D0H,21H             ; 2103: CALL L21D0
                DB      11H,E0H,2CH             ; 2106: LD DE,0x2ce0
                DB      CDH,D0H,21H             ; 2109: CALL L21D0

L210C:
                DB      3AH,46H,30H             ; 210C: LD A,(0x3046)
                DB      3DH                     ; 210F: DEC A
                DB      3DH                     ; 2110: DEC A
                DB      B7H                     ; 2111: OR A
                DB      F2H,1FH,21H             ; 2112: JP p,L211F
                DB      0EH,02H                 ; 2115: LD C,2
                DB      1EH,07H                 ; 2117: LD E,7
                DB      CDH,05H,00H             ; 2119: CALL 0x0005
                DB      C3H,D9H,20H             ; 211C: JP L20D9

L211F:
                DB      32H,46H,30H             ; 211F: LD (0x3046),A
                DB      11H,E4H,2CH             ; 2122: LD DE,L2CE4
                DB      CDH,D0H,21H             ; 2125: CALL L21D0
                DB      2AH,D7H,30H             ; 2128: LD HL,(0x30d7)
                DB      2BH                     ; 212B: DEC HL
                DB      2BH                     ; 212C: DEC HL
                DB      22H,D7H,30H             ; 212D: LD (0x30d7),HL
                DB      C3H,54H,1CH             ; 2130: JP L1C54

L2133:
                DB      FEH,3FH                 ; 2133: CP 0x3f
                DB      CAH,57H,21H             ; 2135: JP z,L2157
                DB      FEH,1BH                 ; 2138: CP 0x1b
                DB      CAH,57H,21H             ; 213A: JP z,L2157
                DB      FEH,0DH                 ; 213D: CP 13
                DB      CAH,4FH,21H             ; 213F: JP z,L214F
                DB      FEH,0AH                 ; 2142: CP 10
                DB      CAH,4FH,21H             ; 2144: JP z,L214F
                DB      FEH,0CH                 ; 2147: CP 12
                DB      C2H,5FH,21H             ; 2149: JP nz,L215F
                DB      CDH,C9H,21H             ; 214C: CALL L21C9

L214F:
                DB      3AH,46H,30H             ; 214F: LD A,(0x3046)
                DB      FEH,01H                 ; 2152: CP 1
                DB      CAH,67H,1CH             ; 2154: JP z,L1C67

L2157:
                DB      3EH,FFH                 ; 2157: LD A,0xff
                DB      32H,45H,30H             ; 2159: LD (0x3045),A
                DB      C3H,6CH,21H             ; 215C: JP L216C

L215F:
                DB      FEH,20H                 ; 215F: CP 0x20
                DB      CAH,BEH,20H             ; 2161: JP z,L20BE
                DB      FEH,09H                 ; 2164: CP 9
                DB      CAH,BEH,20H             ; 2166: JP z,L20BE
                DB      C3H,BEH,20H             ; 2169: JP L20BE

L216C:
                DB      E1H                     ; 216C: POP HL
                DB      D1H                     ; 216D: POP DE
                DB      F1H                     ; 216E: POP AF
                DB      C9H                     ; 216F: RET

L2170:
                DB      E5H                     ; 2170: PUSH HL
                DB      C5H                     ; 2171: PUSH BC

L2172:
                DB      3AH,45H,30H             ; 2172: LD A,(0x3045)
                DB      B7H                     ; 2175: OR A
                DB      CCH,B4H,20H             ; 2176: CALL z,L20B4
                DB      2AH,D9H,30H             ; 2179: LD HL,(0x30d9)
                DB      7EH                     ; 217C: LD A,(HL)
                DB      23H                     ; 217D: INC HL
                DB      22H,D9H,30H             ; 217E: LD (0x30d9),HL
                DB      FEH,20H                 ; 2181: CP 0x20
                DB      CAH,8BH,21H             ; 2183: JP z,L218B
                DB      FEH,09H                 ; 2186: CP 9
                DB      C2H,9EH,21H             ; 2188: JP nz,L219E

L218B:
                DB      3AH,47H,30H             ; 218B: LD A,(0x3047)
                DB      B7H                     ; 218E: OR A
                DB      C2H,72H,21H             ; 218F: JP nz,L2172
                DB      3EH,FFH                 ; 2192: LD A,0xff
                DB      32H,47H,30H             ; 2194: LD (0x3047),A
                DB      3EH,20H                 ; 2197: LD A,0x20
                DB      C1H                     ; 2199: POP BC
                DB      E1H                     ; 219A: POP HL
                DB      C3H,C6H,21H             ; 219B: JP L21C6

L219E:
                DB      F5H                     ; 219E: PUSH AF
                DB      AFH                     ; 219F: XOR A
                DB      32H,47H,30H             ; 21A0: LD (0x3047),A
                DB      F1H                     ; 21A3: POP AF
                DB      C1H                     ; 21A4: POP BC
                DB      E1H                     ; 21A5: POP HL
                DB      FEH,1BH                 ; 21A6: CP 0x1b
                DB      CAH,C6H,21H             ; 21A8: JP z,L21C6
                DB      FEH,3FH                 ; 21AB: CP 0x3f
                DB      CAH,BDH,21H             ; 21AD: JP z,L21BD
                DB      FEH,0DH                 ; 21B0: CP 13
                DB      CAH,BDH,21H             ; 21B2: JP z,L21BD
                DB      FEH,0AH                 ; 21B5: CP 10
                DB      CAH,BDH,21H             ; 21B7: JP z,L21BD
                DB      FEH,0CH                 ; 21BA: CP 12
                DB      C0H                     ; 21BC: RET nz

L21BD:
                DB      E5H                     ; 21BD: PUSH HL
                DB      2AH,D9H,30H             ; 21BE: LD HL,(0x30d9)
                DB      2BH                     ; 21C1: DEC HL
                DB      22H,D9H,30H             ; 21C2: LD (0x30d9),HL
                DB      E1H                     ; 21C5: POP HL

L21C6:
                DB      F6H,80H                 ; 21C6: OR 0x80
                DB      C9H                     ; 21C8: RET

L21C9:
                DB      11H,EAH,2CH             ; 21C9: LD DE,0x2cea
                DB      CDH,D0H,21H             ; 21CC: CALL L21D0
                DB      C9H                     ; 21CF: RET

L21D0:
                DB      0EH,09H                 ; 21D0: LD C,9
                DB      C3H,05H,00H             ; 21D2: JP 0x0005
                DB      0DH                     ; 21D5: DEC C
                DB      0AH                     ; 21D6: LD A,(BC)
                DB      4EH                     ; 21D7: LD C,(HL)
                DB      75H                     ; 21D8: LD (HL),L
                DB      6DH                     ; 21D9: LD L,L
                DB      62H                     ; 21DA: LD H,D
                DB      65H                     ; 21DB: LD H,L
                DB      72H                     ; 21DC: LD (HL),D
                DB      20H,6FH                 ; 21DD: JR nz,L224E
                DB      66H                     ; 21DF: LD H,(HL)
                DB      20H,70H                 ; 21E0: JR nz,L2252
                DB      61H                     ; 21E2: LD H,C
                DB      63H                     ; 21E3: LD H,E
                DB      6BH                     ; 21E4: LD L,E
                DB      65H                     ; 21E5: LD H,L
                DB      74H                     ; 21E6: LD (HL),H
                DB      73H                     ; 21E7: LD (HL),E
                DB      3AH,0DH,0AH             ; 21E8: LD A,(0x0a0d)
                DB      4EH                     ; 21EB: LD C,(HL)
                DB      75H                     ; 21EC: LD (HL),L
                DB      6DH                     ; 21ED: LD L,L
                DB      62H                     ; 21EE: LD H,D
                DB      65H                     ; 21EF: LD H,L
                DB      72H                     ; 21F0: LD (HL),D
                DB      20H,6FH                 ; 21F1: JR nz,L2262
                DB      66H                     ; 21F3: LD H,(HL)
                DB      20H,72H                 ; 21F4: JR nz,L2268
                DB      65H                     ; 21F6: LD H,L
                DB      74H                     ; 21F7: LD (HL),H
                DB      72H                     ; 21F8: LD (HL),D
                DB      69H                     ; 21F9: LD L,C
                DB      65H                     ; 21FA: LD H,L
                DB      73H                     ; 21FB: LD (HL),E
                DB      3AH,0DH,0AH             ; 21FC: LD A,(0x0a0d)
                DB      46H                     ; 21FF: LD B,(HL)
                DB      69H                     ; 2200: LD L,C
                DB      6CH                     ; 2201: LD L,H
                DB      65H                     ; 2202: LD H,L
                DB      20H,6EH                 ; 2203: JR nz,L2273
                DB      61H                     ; 2205: LD H,C
                DB      6DH                     ; 2206: LD L,L
                DB      65H                     ; 2207: LD H,L
                DB      3AH,24H,4BH             ; 2208: LD A,(0x4b24)
                DB      65H                     ; 220B: LD H,L
                DB      72H                     ; 220C: LD (HL),D
                DB      6DH                     ; 220D: LD L,L
                DB      69H                     ; 220E: LD L,C
                DB      74H                     ; 220F: LD (HL),H
                DB      2DH                     ; 2210: DEC L
                DB      38H,30H                 ; 2211: JR c,L2243
                DB      20H,20H                 ; 2213: JR nz,L2235
                DB      78H                     ; 2215: LD A,B
                DB      3AH,3EH,24H             ; 2216: LD A,(0x243e)
                DB      44H                     ; 2219: LD B,H
                DB      65H                     ; 221A: LD H,L
                DB      6CH                     ; 221B: LD L,H
                DB      65H                     ; 221C: LD H,L
                DB      74H                     ; 221D: LD (HL),H
                DB      65H                     ; 221E: LD H,L
                DB      20H,69H                 ; 221F: JR nz,L228A
                DB      74H                     ; 2221: LD (HL),H
                DB      3FH                     ; 2222: CCF
                DB      20H,24H                 ; 2223: JR nz,L2249
                DB      0DH                     ; 2225: DEC C
                DB      0AH                     ; 2226: LD A,(BC)
                DB      24H                     ; 2227: INC H
                DB      0DH                     ; 2228: DEC C
                DB      0AH                     ; 2229: LD A,(BC)
                DB      3FH                     ; 222A: CCF
                DB      55H                     ; 222B: LD D,L
                DB      6EH                     ; 222C: LD L,(HL)
                DB      72H                     ; 222D: LD (HL),D
                DB      65H                     ; 222E: LD H,L
                DB      63H                     ; 222F: LD H,E
                DB      6FH                     ; 2230: LD L,A
                DB      67H                     ; 2231: LD H,A
                DB      6EH                     ; 2232: LD L,(HL)
                DB      69H                     ; 2233: LD L,C
                DB      7AH                     ; 2234: LD A,D

L2235:
                DB      65H                     ; 2235: LD H,L
                DB      64H                     ; 2236: LD H,H
                DB      20H,63H                 ; 2237: JR nz,L229C
                DB      6FH                     ; 2239: LD L,A
                DB      6DH                     ; 223A: LD L,L
                DB      6DH                     ; 223B: LD L,L
                DB      61H                     ; 223C: LD H,C
                DB      6EH                     ; 223D: LD L,(HL)
                DB      64H                     ; 223E: LD H,H
                DB      24H                     ; 223F: INC H
                DB      0DH                     ; 2240: DEC C
                DB      0AH                     ; 2241: LD A,(BC)
                DB      3FH                     ; 2242: CCF

L2243:
                DB      49H                     ; 2243: LD C,C
                DB      6CH                     ; 2244: LD L,H
                DB      6CH                     ; 2245: LD L,H
                DB      65H                     ; 2246: LD H,L
                DB      67H                     ; 2247: LD H,A
                DB      61H                     ; 2248: LD H,C

L2249:
                DB      6CH                     ; 2249: LD L,H
                DB      20H,63H                 ; 224A: JR nz,L22AF
                DB      68H                     ; 224C: LD L,B
                DB      61H                     ; 224D: LD H,C

L224E:
                DB      72H                     ; 224E: LD (HL),D
                DB      61H                     ; 224F: LD H,C
                DB      63H                     ; 2250: LD H,E
                DB      74H                     ; 2251: LD (HL),H

L2252:
                DB      65H                     ; 2252: LD H,L
                DB      72H                     ; 2253: LD (HL),D
                DB      24H                     ; 2254: INC H
                DB      0DH                     ; 2255: DEC C
                DB      0AH                     ; 2256: LD A,(BC)
                DB      3FH                     ; 2257: CCF
                DB      4EH                     ; 2258: LD C,(HL)
                DB      6FH                     ; 2259: LD L,A
                DB      74H                     ; 225A: LD (HL),H
                DB      20H,63H                 ; 225B: JR nz,L22C0
                DB      6FH                     ; 225D: LD L,A
                DB      6EH                     ; 225E: LD L,(HL)
                DB      66H                     ; 225F: LD H,(HL)
                DB      69H                     ; 2260: LD L,C
                DB      72H                     ; 2261: LD (HL),D

L2262:
                DB      6DH                     ; 2262: LD L,L
                DB      65H                     ; 2263: LD H,L
                DB      64H                     ; 2264: LD H,H
                DB      24H                     ; 2265: INC H
                DB      3FH                     ; 2266: CCF
                DB      55H                     ; 2267: LD D,L

L2268:
                DB      6EH                     ; 2268: LD L,(HL)
                DB      61H                     ; 2269: LD H,C
                DB      62H                     ; 226A: LD H,D
                DB      6CH                     ; 226B: LD L,H
                DB      65H                     ; 226C: LD H,L
                DB      20H,74H                 ; 226D: JR nz,L22E3
                DB      6FH                     ; 226F: LD L,A
                DB      20H,72H                 ; 2270: JR nz,L22E4
                DB      65H                     ; 2272: LD H,L

L2273:
                DB      63H                     ; 2273: LD H,E
                DB      65H                     ; 2274: LD H,L
                DB      69H                     ; 2275: LD L,C
                DB      76H                     ; 2276: HALT
                DB      65H                     ; 2277: LD H,L
                DB      20H,69H                 ; 2278: JR nz,L22E3
                DB      6EH                     ; 227A: LD L,(HL)
                DB      69H                     ; 227B: LD L,C
                DB      74H                     ; 227C: LD (HL),H
                DB      69H                     ; 227D: LD L,C
                DB      61H                     ; 227E: LD H,C
                DB      74H                     ; 227F: LD (HL),H
                DB      65H                     ; 2280: LD H,L
                DB      0DH                     ; 2281: DEC C
                DB      0AH                     ; 2282: LD A,(BC)
                DB      24H                     ; 2283: INC H
                DB      3FH                     ; 2284: CCF
                DB      55H                     ; 2285: LD D,L
                DB      6EH                     ; 2286: LD L,(HL)
                DB      61H                     ; 2287: LD H,C
                DB      62H                     ; 2288: LD H,D
                DB      6CH                     ; 2289: LD L,H

L228A:
                DB      65H                     ; 228A: LD H,L
                DB      20H,74H                 ; 228B: JR nz,L2301
                DB      6FH                     ; 228D: LD L,A
                DB      20H,72H                 ; 228E: JR nz,L2302
                DB      65H                     ; 2290: LD H,L
                DB      63H                     ; 2291: LD H,E
                DB      65H                     ; 2292: LD H,L
                DB      69H                     ; 2293: LD L,C
                DB      76H                     ; 2294: HALT
                DB      65H                     ; 2295: LD H,L
                DB      20H,66H                 ; 2296: JR nz,L22FE
                DB      69H                     ; 2298: LD L,C
                DB      6CH                     ; 2299: LD L,H
                DB      65H                     ; 229A: LD H,L
                DB      20H,6EH                 ; 229B: JR nz,L230B
                DB      61H                     ; 229D: LD H,C
                DB      6DH                     ; 229E: LD L,L
                DB      65H                     ; 229F: LD H,L
                DB      0DH                     ; 22A0: DEC C
                DB      0AH                     ; 22A1: LD A,(BC)
                DB      24H                     ; 22A2: INC H
                DB      3FH                     ; 22A3: CCF
                DB      55H                     ; 22A4: LD D,L
                DB      6EH                     ; 22A5: LD L,(HL)
                DB      61H                     ; 22A6: LD H,C
                DB      62H                     ; 22A7: LD H,D
                DB      6CH                     ; 22A8: LD L,H
                DB      65H                     ; 22A9: LD H,L
                DB      20H,74H                 ; 22AA: JR nz,L2320
                DB      6FH                     ; 22AC: LD L,A
                DB      20H,72H                 ; 22AD: JR nz,L2321

L22AF:
                DB      65H                     ; 22AF: LD H,L
                DB      63H                     ; 22B0: LD H,E
                DB      65H                     ; 22B1: LD H,L
                DB      69H                     ; 22B2: LD L,C
                DB      76H                     ; 22B3: HALT
                DB      65H                     ; 22B4: LD H,L
                DB      20H,65H                 ; 22B5: JR nz,L231C
                DB      6EH                     ; 22B7: LD L,(HL)
                DB      64H                     ; 22B8: LD H,H
                DB      20H,6FH                 ; 22B9: JR nz,L232A
                DB      66H                     ; 22BB: LD H,(HL)
                DB      20H,66H                 ; 22BC: JR nz,L2324
                DB      69H                     ; 22BE: LD L,C
                DB      6CH                     ; 22BF: LD L,H

L22C0:
                DB      65H                     ; 22C0: LD H,L
                DB      0DH                     ; 22C1: DEC C
                DB      0AH                     ; 22C2: LD A,(BC)
                DB      24H                     ; 22C3: INC H
                DB      3FH                     ; 22C4: CCF
                DB      55H                     ; 22C5: LD D,L
                DB      6EH                     ; 22C6: LD L,(HL)
                DB      61H                     ; 22C7: LD H,C
                DB      62H                     ; 22C8: LD H,D
                DB      6CH                     ; 22C9: LD L,H
                DB      65H                     ; 22CA: LD H,L
                DB      20H,74H                 ; 22CB: JR nz,L2341
                DB      6FH                     ; 22CD: LD L,A
                DB      20H,72H                 ; 22CE: JR nz,L2342
                DB      65H                     ; 22D0: LD H,L
                DB      63H                     ; 22D1: LD H,E
                DB      65H                     ; 22D2: LD H,L
                DB      69H                     ; 22D3: LD L,C
                DB      76H                     ; 22D4: HALT
                DB      65H                     ; 22D5: LD H,L
                DB      20H,64H                 ; 22D6: JR nz,L233C
                DB      61H                     ; 22D8: LD H,C
                DB      74H                     ; 22D9: LD (HL),H
                DB      61H                     ; 22DA: LD H,C
                DB      0DH                     ; 22DB: DEC C
                DB      0AH                     ; 22DC: LD A,(BC)
                DB      24H                     ; 22DD: INC H
                DB      3FH                     ; 22DE: CCF
                DB      44H                     ; 22DF: LD B,H
                DB      69H                     ; 22E0: LD L,C
                DB      73H                     ; 22E1: LD (HL),E
                DB      6BH                     ; 22E2: LD L,E

L22E3:
                DB      20H,66H                 ; 22E3: JR nz,L234B
                DB      75H                     ; 22E5: LD (HL),L
                DB      6CH                     ; 22E6: LD L,H
                DB      6CH                     ; 22E7: LD L,H
                DB      0DH                     ; 22E8: DEC C
                DB      0AH                     ; 22E9: LD A,(BC)
                DB      24H                     ; 22EA: INC H
                DB      3FH                     ; 22EB: CCF
                DB      55H                     ; 22EC: LD D,L
                DB      6EH                     ; 22ED: LD L,(HL)
                DB      61H                     ; 22EE: LD H,C
                DB      62H                     ; 22EF: LD H,D
                DB      6CH                     ; 22F0: LD L,H
                DB      65H                     ; 22F1: LD H,L
                DB      20H,74H                 ; 22F2: JR nz,L2368
                DB      6FH                     ; 22F4: LD L,A
                DB      20H,72H                 ; 22F5: JR nz,L2369
                DB      65H                     ; 22F7: LD H,L
                DB      63H                     ; 22F8: LD H,E
                DB      65H                     ; 22F9: LD H,L
                DB      69H                     ; 22FA: LD L,C
                DB      76H                     ; 22FB: HALT
                DB      65H                     ; 22FC: LD H,L
                DB      20H,61H                 ; 22FD: JR nz,L2360
                DB      6EH                     ; 22FF: LD L,(HL)
                DB      20H,61H                 ; 2300: JR nz,L2363

L2302:
                DB      63H                     ; 2302: LD H,E
                DB      6BH                     ; 2303: LD L,E
                DB      6EH                     ; 2304: LD L,(HL)
                DB      6FH                     ; 2305: LD L,A
                DB      77H                     ; 2306: LD (HL),A
                DB      6CH                     ; 2307: LD L,H
                DB      65H                     ; 2308: LD H,L
                DB      64H                     ; 2309: LD H,H
                DB      67H                     ; 230A: LD H,A

L230B:
                DB      65H                     ; 230B: LD H,L
                DB      6DH                     ; 230C: LD L,L
                DB      65H                     ; 230D: LD H,L
                DB      6EH                     ; 230E: LD L,(HL)
                DB      74H                     ; 230F: LD (HL),H
                DB      20H,66H                 ; 2310: JR nz,L2378
                DB      72H                     ; 2312: LD (HL),D
                DB      6FH                     ; 2313: LD L,A
                DB      6DH                     ; 2314: LD L,L
                DB      20H,74H                 ; 2315: JR nz,L238B
                DB      68H                     ; 2317: LD L,B
                DB      65H                     ; 2318: LD H,L
                DB      20H,68H                 ; 2319: JR nz,L2383
                DB      6FH                     ; 231B: LD L,A

L231C:
                DB      73H                     ; 231C: LD (HL),E
                DB      74H                     ; 231D: LD (HL),H
                DB      0DH                     ; 231E: DEC C
                DB      0AH                     ; 231F: LD A,(BC)

L2320:
                DB      24H                     ; 2320: INC H

L2321:
                DB      0DH                     ; 2321: DEC C
                DB      0AH                     ; 2322: LD A,(BC)
                DB      3FH                     ; 2323: CCF

L2324:
                DB      55H                     ; 2324: LD D,L
                DB      6EH                     ; 2325: LD L,(HL)
                DB      61H                     ; 2326: LD H,C
                DB      62H                     ; 2327: LD H,D
                DB      6CH                     ; 2328: LD L,H
                DB      65H                     ; 2329: LD H,L

L232A:
                DB      20H,74H                 ; 232A: JR nz,L23A0
                DB      6FH                     ; 232C: LD L,A
                DB      20H,66H                 ; 232D: JR nz,L2395
                DB      69H                     ; 232F: LD L,C
                DB      6EH                     ; 2330: LD L,(HL)
                DB      64H                     ; 2331: LD H,H
                DB      20H,66H                 ; 2332: JR nz,L239A
                DB      69H                     ; 2334: LD L,C
                DB      6CH                     ; 2335: LD L,H
                DB      65H                     ; 2336: LD H,L
                DB      0DH                     ; 2337: DEC C
                DB      0AH                     ; 2338: LD A,(BC)
                DB      24H                     ; 2339: INC H
                DB      3FH                     ; 233A: CCF
                DB      55H                     ; 233B: LD D,L

L233C:
                DB      6EH                     ; 233C: LD L,(HL)
                DB      61H                     ; 233D: LD H,C
                DB      62H                     ; 233E: LD H,D
                DB      6CH                     ; 233F: LD L,H
                DB      65H                     ; 2340: LD H,L

L2341:
                DB      20H,74H                 ; 2341: JR nz,L23B7
                DB      6FH                     ; 2343: LD L,A
                DB      20H,72H                 ; 2344: JR nz,L23B8
                DB      65H                     ; 2346: LD H,L
                DB      6EH                     ; 2347: LD L,(HL)
                DB      61H                     ; 2348: LD H,C
                DB      6DH                     ; 2349: LD L,L
                DB      65H                     ; 234A: LD H,L

L234B:
                DB      20H,66H                 ; 234B: JR nz,L23B3
                DB      69H                     ; 234D: LD L,C
                DB      6CH                     ; 234E: LD L,H
                DB      65H                     ; 234F: LD H,L
                DB      24H                     ; 2350: INC H
                DB      0DH                     ; 2351: DEC C
                DB      0AH                     ; 2352: LD A,(BC)
                DB      3FH                     ; 2353: CCF
                DB      44H                     ; 2354: LD B,H
                DB      69H                     ; 2355: LD L,C
                DB      73H                     ; 2356: LD (HL),E
                DB      6BH                     ; 2357: LD L,E
                DB      20H,66H                 ; 2358: JR nz,L23C0
                DB      75H                     ; 235A: LD (HL),L
                DB      6CH                     ; 235B: LD L,H
                DB      6CH                     ; 235C: LD L,H
                DB      24H                     ; 235D: INC H
                DB      0DH                     ; 235E: DEC C
                DB      0AH                     ; 235F: LD A,(BC)

L2360:
                DB      3FH                     ; 2360: CCF
                DB      55H                     ; 2361: LD D,L
                DB      6EH                     ; 2362: LD L,(HL)

L2363:
                DB      61H                     ; 2363: LD H,C
                DB      62H                     ; 2364: LD H,D
                DB      6CH                     ; 2365: LD L,H
                DB      65H                     ; 2366: LD H,L
                DB      20H,74H                 ; 2367: JR nz,L23DD

L2369:
                DB      6FH                     ; 2369: LD L,A
                DB      20H,74H                 ; 236A: JR nz,L23E0
                DB      65H                     ; 236C: LD H,L
                DB      6CH                     ; 236D: LD L,H
                DB      6CH                     ; 236E: LD L,H
                DB      20H,68H                 ; 236F: JR nz,L23D9
                DB      6FH                     ; 2371: LD L,A
                DB      73H                     ; 2372: LD (HL),E
                DB      74H                     ; 2373: LD (HL),H
                DB      20H,74H                 ; 2374: JR nz,L23EA
                DB      68H                     ; 2376: LD L,B
                DB      61H                     ; 2377: LD H,C

L2378:
                DB      74H                     ; 2378: LD (HL),H
                DB      20H,74H                 ; 2379: JR nz,L23EF
                DB      68H                     ; 237B: LD L,B
                DB      65H                     ; 237C: LD H,L
                DB      20H,73H                 ; 237D: JR nz,L23F2
                DB      65H                     ; 237F: LD H,L
                DB      73H                     ; 2380: LD (HL),E
                DB      73H                     ; 2381: LD (HL),E
                DB      69H                     ; 2382: LD L,C

L2383:
                DB      6FH                     ; 2383: LD L,A
                DB      6EH                     ; 2384: LD L,(HL)
                DB      20H,69H                 ; 2385: JR nz,L23F0
                DB      73H                     ; 2387: LD (HL),E
                DB      20H,66H                 ; 2388: JR nz,L23F0
                DB      69H                     ; 238A: LD L,C

L238B:
                DB      6EH                     ; 238B: LD L,(HL)
                DB      69H                     ; 238C: LD L,C
                DB      73H                     ; 238D: LD (HL),E
                DB      68H                     ; 238E: LD L,B
                DB      65H                     ; 238F: LD H,L
                DB      64H                     ; 2390: LD H,H
                DB      24H                     ; 2391: INC H
                DB      0DH                     ; 2392: DEC C
                DB      0AH                     ; 2393: LD A,(BC)
                DB      3FH                     ; 2394: CCF

L2395:
                DB      55H                     ; 2395: LD D,L
                DB      6EH                     ; 2396: LD L,(HL)
                DB      61H                     ; 2397: LD H,C
                DB      62H                     ; 2398: LD H,D
                DB      6CH                     ; 2399: LD L,H

L239A:
                DB      65H                     ; 239A: LD H,L
                DB      20H,74H                 ; 239B: JR nz,L2411
                DB      6FH                     ; 239D: LD L,A
                DB      20H,74H                 ; 239E: JR nz,L2414

L23A0:
                DB      65H                     ; 23A0: LD H,L
                DB      6CH                     ; 23A1: LD L,H
                DB      6CH                     ; 23A2: LD L,H
                DB      20H,68H                 ; 23A3: JR nz,L240D
                DB      6FH                     ; 23A5: LD L,A
                DB      73H                     ; 23A6: LD (HL),E
                DB      74H                     ; 23A7: LD (HL),H
                DB      20H,74H                 ; 23A8: JR nz,L241E
                DB      6FH                     ; 23AA: LD L,A
                DB      20H,6CH                 ; 23AB: JR nz,L2419
                DB      6FH                     ; 23AD: LD L,A
                DB      67H                     ; 23AE: LD H,A
                DB      6FH                     ; 23AF: LD L,A
                DB      75H                     ; 23B0: LD (HL),L
                DB      74H                     ; 23B1: LD (HL),H
                DB      24H                     ; 23B2: INC H

L23B3:
                DB      07H                     ; 23B3: RLCA
                DB      43H                     ; 23B4: LD B,E
                DB      6FH                     ; 23B5: LD L,A
                DB      6DH                     ; 23B6: LD L,L

L23B7:
                DB      70H                     ; 23B7: LD (HL),B

L23B8:
                DB      6CH                     ; 23B8: LD L,H
                DB      65H                     ; 23B9: LD H,L
                DB      74H                     ; 23BA: LD (HL),H
                DB      65H                     ; 23BB: LD H,L
                DB      64H                     ; 23BC: LD H,H
                DB      24H                     ; 23BD: INC H
                DB      07H                     ; 23BE: RLCA
                DB      46H                     ; 23BF: LD B,(HL)

L23C0:
                DB      61H                     ; 23C0: LD H,C
                DB      69H                     ; 23C1: LD L,C
                DB      6CH                     ; 23C2: LD L,H
                DB      65H                     ; 23C3: LD H,L
                DB      64H                     ; 23C4: LD H,H
                DB      24H                     ; 23C5: INC H
                DB      25H                     ; 23C6: DEC H
                DB      52H                     ; 23C7: LD D,D
                DB      65H                     ; 23C8: LD H,L
                DB      6EH                     ; 23C9: LD L,(HL)
                DB      61H                     ; 23CA: LD H,C
                DB      6DH                     ; 23CB: LD L,L
                DB      69H                     ; 23CC: LD L,C
                DB      6EH                     ; 23CD: LD L,(HL)
                DB      67H                     ; 23CE: LD H,A
                DB      20H,66H                 ; 23CF: JR nz,L2437
                DB      69H                     ; 23D1: LD L,C
                DB      6CH                     ; 23D2: LD L,H
                DB      65H                     ; 23D3: LD H,L
                DB      20H,74H                 ; 23D4: JR nz,L244A
                DB      6FH                     ; 23D6: LD L,A
                DB      20H,24H                 ; 23D7: JR nz,L23FD

L23D9:
                DB      0DH                     ; 23D9: DEC C
                DB      0AH                     ; 23DA: LD A,(BC)
                DB      5BH                     ; 23DB: LD E,E
                DB      43H                     ; 23DC: LD B,E

L23DD:
                DB      6CH                     ; 23DD: LD L,H
                DB      6FH                     ; 23DE: LD L,A
                DB      73H                     ; 23DF: LD (HL),E

L23E0:
                DB      69H                     ; 23E0: LD L,C
                DB      6EH                     ; 23E1: LD L,(HL)
                DB      67H                     ; 23E2: LD H,A
                DB      20H,74H                 ; 23E3: JR nz,L2459
                DB      68H                     ; 23E5: LD L,B
                DB      65H                     ; 23E6: LD H,L
                DB      20H,6CH                 ; 23E7: JR nz,L2455
                DB      6FH                     ; 23E9: LD L,A

L23EA:
                DB      67H                     ; 23EA: LD H,A
                DB      20H,66H                 ; 23EB: JR nz,L2453
                DB      69H                     ; 23ED: LD L,C
                DB      6CH                     ; 23EE: LD L,H

L23EF:
                DB      65H                     ; 23EF: LD H,L

L23F0:
                DB      5DH                     ; 23F0: LD E,L
                DB      24H                     ; 23F1: INC H

L23F2:
                DB      0DH                     ; 23F2: DEC C
                DB      0AH                     ; 23F3: LD A,(BC)
                DB      5BH                     ; 23F4: LD E,E
                DB      43H                     ; 23F5: LD B,E
                DB      6FH                     ; 23F6: LD L,A
                DB      6EH                     ; 23F7: LD L,(HL)
                DB      6EH                     ; 23F8: LD L,(HL)
                DB      65H                     ; 23F9: LD H,L
                DB      63H                     ; 23FA: LD H,E
                DB      74H                     ; 23FB: LD (HL),H
                DB      65H                     ; 23FC: LD H,L

L23FD:
                DB      64H                     ; 23FD: LD H,H
                DB      20H,74H                 ; 23FE: JR nz,L2474
                DB      6FH                     ; 2400: LD L,A
                DB      20H,72H                 ; 2401: JR nz,L2475
                DB      65H                     ; 2403: LD H,L
                DB      6DH                     ; 2404: LD L,L
                DB      6FH                     ; 2405: LD L,A
                DB      74H                     ; 2406: LD (HL),H
                DB      65H                     ; 2407: LD H,L
                DB      20H,68H                 ; 2408: JR nz,L2472
                DB      6FH                     ; 240A: LD L,A
                DB      73H                     ; 240B: LD (HL),E
                DB      74H                     ; 240C: LD (HL),H

L240D:
                DB      2CH                     ; 240D: INC L
                DB      20H,74H                 ; 240E: JR nz,L2484
                DB      79H                     ; 2410: LD A,C

L2411:
                DB      70H                     ; 2411: LD (HL),B
                DB      65H                     ; 2412: LD H,L
                DB      20H,24H                 ; 2413: JR nz,L2439
                DB      43H                     ; 2415: LD B,E
                DB      20H,74H                 ; 2416: JR nz,L248C
                DB      6FH                     ; 2418: LD L,A

L2419:
                DB      20H,72H                 ; 2419: JR nz,L248D
                DB      65H                     ; 241B: LD H,L
                DB      74H                     ; 241C: LD (HL),H
                DB      75H                     ; 241D: LD (HL),L

L241E:
                DB      72H                     ; 241E: LD (HL),D
                DB      6EH                     ; 241F: LD L,(HL)
                DB      5DH                     ; 2420: LD E,L
                DB      0DH                     ; 2421: DEC C
                DB      0AH                     ; 2422: LD A,(BC)
                DB      24H                     ; 2423: INC H
                DB      0DH                     ; 2424: DEC C
                DB      0AH                     ; 2425: LD A,(BC)
                DB      5BH                     ; 2426: LD E,E
                DB      43H                     ; 2427: LD B,E
                DB      6FH                     ; 2428: LD L,A
                DB      6EH                     ; 2429: LD L,(HL)
                DB      6EH                     ; 242A: LD L,(HL)
                DB      65H                     ; 242B: LD H,L
                DB      63H                     ; 242C: LD H,E
                DB      74H                     ; 242D: LD (HL),H
                DB      69H                     ; 242E: LD L,C
                DB      6FH                     ; 242F: LD L,A
                DB      6EH                     ; 2430: LD L,(HL)
                DB      20H,63H                 ; 2431: JR nz,L2496
                DB      6CH                     ; 2433: LD L,H
                DB      6FH                     ; 2434: LD L,A
                DB      73H                     ; 2435: LD (HL),E
                DB      65H                     ; 2436: LD H,L

L2437:
                DB      64H                     ; 2437: LD H,H
                DB      2CH                     ; 2438: INC L

L2439:
                DB      20H,62H                 ; 2439: JR nz,L249D
                DB      61H                     ; 243B: LD H,C
                DB      63H                     ; 243C: LD H,E
                DB      6BH                     ; 243D: LD L,E
                DB      20H,61H                 ; 243E: JR nz,L24A1
                DB      74H                     ; 2440: LD (HL),H
                DB      20H,6DH                 ; 2441: JR nz,L24B0
                DB      69H                     ; 2443: LD L,C
                DB      63H                     ; 2444: LD H,E
                DB      72H                     ; 2445: LD (HL),D
                DB      6FH                     ; 2446: LD L,A
                DB      5DH                     ; 2447: LD E,L
                DB      24H                     ; 2448: INC H
                DB      43H                     ; 2449: LD B,E

L244A:
                DB      6FH                     ; 244A: LD L,A
                DB      6EH                     ; 244B: LD L,(HL)
                DB      74H                     ; 244C: LD (HL),H
                DB      72H                     ; 244D: LD (HL),D
                DB      6FH                     ; 244E: LD L,A
                DB      6CH                     ; 244F: LD L,H
                DB      2DH                     ; 2450: DEC L
                DB      24H                     ; 2451: INC H
                DB      20H,28H                 ; 2452: JR nz,L247C
                DB      54H                     ; 2454: LD D,H

L2455:
                DB      79H                     ; 2455: LD A,C
                DB      70H                     ; 2456: LD (HL),B
                DB      65H                     ; 2457: LD H,L
                DB      20H,4CH                 ; 2458: JR nz,L24A6
                DB      65H                     ; 245A: LD H,L
                DB      66H                     ; 245B: LD H,(HL)
                DB      74H                     ; 245C: LD (HL),H
                DB      20H,41H                 ; 245D: JR nz,L24A0
                DB      72H                     ; 245F: LD (HL),D
                DB      72H                     ; 2460: LD (HL),D
                DB      6FH                     ; 2461: LD L,A
                DB      77H                     ; 2462: LD (HL),A
                DB      20H,74H                 ; 2463: JR nz,L24D9
                DB      6FH                     ; 2465: LD L,A
                DB      20H,73H                 ; 2466: JR nz,L24DB
                DB      65H                     ; 2468: LD H,L
                DB      6EH                     ; 2469: LD L,(HL)
                DB      64H                     ; 246A: LD H,H
                DB      20H,43H                 ; 246B: JR nz,L24B0
                DB      54H                     ; 246D: LD D,H
                DB      52H                     ; 246E: LD D,D
                DB      4CH                     ; 246F: LD C,H
                DB      2DH                     ; 2470: DEC L
                DB      53H                     ; 2471: LD D,E

L2472:
                DB      29H                     ; 2472: ADD HL,HL
                DB      0DH                     ; 2473: DEC C

L2474:
                DB      0AH                     ; 2474: LD A,(BC)

L2475:
                DB      24H                     ; 2475: INC H
                DB      20H,28H                 ; 2476: JR nz,L24A0
                DB      4EH                     ; 2478: LD C,(HL)
                DB      6FH                     ; 2479: LD L,A
                DB      74H                     ; 247A: LD (HL),H
                DB      20H,69H                 ; 247B: JR nz,L24E6
                DB      6DH                     ; 247D: LD L,L
                DB      70H                     ; 247E: LD (HL),B
                DB      6CH                     ; 247F: LD L,H
                DB      65H                     ; 2480: LD H,L
                DB      6DH                     ; 2481: LD L,L
                DB      65H                     ; 2482: LD H,L
                DB      6EH                     ; 2483: LD L,(HL)

L2484:
                DB      74H                     ; 2484: LD (HL),H
                DB      65H                     ; 2485: LD H,L
                DB      64H                     ; 2486: LD H,H
                DB      29H                     ; 2487: ADD HL,HL
                DB      0DH                     ; 2488: DEC C
                DB      0AH                     ; 2489: LD A,(BC)
                DB      24H                     ; 248A: INC H
                DB      07H                     ; 248B: RLCA

L248C:
                DB      49H                     ; 248C: LD C,C

L248D:
                DB      6EH                     ; 248D: LD L,(HL)
                DB      74H                     ; 248E: LD (HL),H
                DB      65H                     ; 248F: LD H,L
                DB      72H                     ; 2490: LD (HL),D
                DB      72H                     ; 2491: LD (HL),D
                DB      75H                     ; 2492: LD (HL),L
                DB      70H                     ; 2493: LD (HL),B
                DB      74H                     ; 2494: LD (HL),H
                DB      65H                     ; 2495: LD H,L

L2496:
                DB      64H                     ; 2496: LD H,H
                DB      24H                     ; 2497: INC H
                DB      09H                     ; 2498: ADD HL,BC
                DB      09H                     ; 2499: ADD HL,BC
                DB      20H,20H                 ; 249A: JR nz,L24BC
                DB      20H,20H                 ; 249C: JR nz,L24BE
                DB      44H                     ; 249E: LD B,H
                DB      69H                     ; 249F: LD L,C

L24A0:
                DB      72H                     ; 24A0: LD (HL),D

L24A1:
                DB      65H                     ; 24A1: LD H,L
                DB      63H                     ; 24A2: LD H,E
                DB      74H                     ; 24A3: LD (HL),H
                DB      6FH                     ; 24A4: LD L,A
                DB      72H                     ; 24A5: LD (HL),D

L24A6:
                DB      79H                     ; 24A6: LD A,C
                DB      20H,66H                 ; 24A7: JR nz,L250F
                DB      6FH                     ; 24A9: LD L,A
                DB      72H                     ; 24AA: LD (HL),D
                DB      20H,64H                 ; 24AB: JR nz,L2511
                DB      72H                     ; 24AD: LD (HL),D
                DB      69H                     ; 24AE: LD L,C
                DB      76H                     ; 24AF: HALT

L24B0:
                DB      65H                     ; 24B0: LD H,L
                DB      20H,78H                 ; 24B1: JR nz,L252B
                DB      3AH,0DH,0AH             ; 24B3: LD A,(0x0a0d)
                DB      24H                     ; 24B6: INC H
                DB      0DH                     ; 24B7: DEC C
                DB      0AH                     ; 24B8: LD A,(BC)
                DB      09H                     ; 24B9: ADD HL,BC
                DB      09H                     ; 24BA: ADD HL,BC
                DB      44H                     ; 24BB: LD B,H

L24BC:
                DB      72H                     ; 24BC: LD (HL),D
                DB      69H                     ; 24BD: LD L,C

L24BE:
                DB      76H                     ; 24BE: HALT
                DB      65H                     ; 24BF: LD H,L
                DB      20H,24H                 ; 24C0: JR nz,L24E6
                DB      20H,20H                 ; 24C2: JR nz,L24E4
                DB      68H                     ; 24C4: LD L,B
                DB      61H                     ; 24C5: LD H,C
                DB      73H                     ; 24C6: LD (HL),E
                DB      20H,24H                 ; 24C7: JR nz,L24ED
                DB      4BH                     ; 24C9: LD C,E
                DB      20H,62H                 ; 24CA: JR nz,L252E
                DB      79H                     ; 24CC: LD A,C
                DB      74H                     ; 24CD: LD (HL),H
                DB      65H                     ; 24CE: LD H,L
                DB      73H                     ; 24CF: LD (HL),E
                DB      20H,66H                 ; 24D0: JR nz,L2538
                DB      72H                     ; 24D2: LD (HL),D
                DB      65H                     ; 24D3: LD H,L
                DB      65H                     ; 24D4: LD H,L
                DB      0DH                     ; 24D5: DEC C
                DB      0AH                     ; 24D6: LD A,(BC)
                DB      24H                     ; 24D7: INC H
                DB      0DH                     ; 24D8: DEC C

L24D9:
                DB      0AH                     ; 24D9: LD A,(BC)
                DB      46H                     ; 24DA: LD B,(HL)

L24DB:
                DB      69H                     ; 24DB: LD L,C
                DB      6CH                     ; 24DC: LD L,H
                DB      65H                     ; 24DD: LD H,L
                DB      28H,73H                 ; 24DE: JR z,L2553
                DB      29H                     ; 24E0: ADD HL,HL
                DB      20H,65H                 ; 24E1: JR nz,L2548
                DB      72H                     ; 24E3: LD (HL),D

L24E4:
                DB      61H                     ; 24E4: LD H,C
                DB      73H                     ; 24E5: LD (HL),E

L24E6:
                DB      65H                     ; 24E6: LD H,L
                DB      64H                     ; 24E7: LD H,H
                DB      24H                     ; 24E8: INC H
                DB      0DH                     ; 24E9: DEC C
                DB      0AH                     ; 24EA: LD A,(BC)
                DB      0DH                     ; 24EB: DEC C
                DB      0AH                     ; 24EC: LD A,(BC)

L24ED:
                DB      5BH                     ; 24ED: LD E,E
                DB      54H                     ; 24EE: LD D,H
                DB      72H                     ; 24EF: LD (HL),D
                DB      61H                     ; 24F0: LD H,C
                DB      6EH                     ; 24F1: LD L,(HL)
                DB      73H                     ; 24F2: LD (HL),E
                DB      6DH                     ; 24F3: LD L,L
                DB      69H                     ; 24F4: LD L,C
                DB      74H                     ; 24F5: LD (HL),H
                DB      74H                     ; 24F6: LD (HL),H
                DB      69H                     ; 24F7: LD L,C
                DB      6EH                     ; 24F8: LD L,(HL)
                DB      67H                     ; 24F9: LD H,A
                DB      20H,66H                 ; 24FA: JR nz,L2562
                DB      69H                     ; 24FC: LD L,C
                DB      6CH                     ; 24FD: LD L,H
                DB      65H                     ; 24FE: LD H,L
                DB      20H,74H                 ; 24FF: JR nz,L2575
                DB      6FH                     ; 2501: LD L,A
                DB      20H,68H                 ; 2502: JR nz,L256C
                DB      6FH                     ; 2504: LD L,A
                DB      73H                     ; 2505: LD (HL),E
                DB      74H                     ; 2506: LD (HL),H
                DB      3AH,0DH,0AH             ; 2507: LD A,(0x0a0d)
                DB      20H,31H                 ; 250A: JR nz,L253D
                DB      2EH,20H                 ; 250C: LD L,0x20
                DB      54H                     ; 250E: LD D,H

L250F:
                DB      79H                     ; 250F: LD A,C
                DB      70H                     ; 2510: LD (HL),B

L2511:
                DB      65H                     ; 2511: LD H,L
                DB      20H,61H                 ; 2512: JR nz,L2575
                DB      6EH                     ; 2514: LD L,(HL)
                DB      79H                     ; 2515: LD A,C
                DB      20H,63H                 ; 2516: JR nz,L257B
                DB      68H                     ; 2518: LD L,B
                DB      61H                     ; 2519: LD H,C
                DB      72H                     ; 251A: LD (HL),D
                DB      61H                     ; 251B: LD H,C
                DB      63H                     ; 251C: LD H,E
                DB      74H                     ; 251D: LD (HL),H
                DB      65H                     ; 251E: LD H,L
                DB      72H                     ; 251F: LD (HL),D
                DB      20H,74H                 ; 2520: JR nz,L2596
                DB      6FH                     ; 2522: LD L,A
                DB      20H,73H                 ; 2523: JR nz,L2598
                DB      65H                     ; 2525: LD H,L
                DB      6EH                     ; 2526: LD L,(HL)
                DB      64H                     ; 2527: LD H,H
                DB      20H,61H                 ; 2528: JR nz,L258B
                DB      20H,6CH                 ; 252A: JR nz,L2598
                DB      69H                     ; 252C: LD L,C
                DB      6EH                     ; 252D: LD L,(HL)

L252E:
                DB      65H                     ; 252E: LD H,L
                DB      2EH,0DH                 ; 252F: LD L,13
                DB      0AH                     ; 2531: LD A,(BC)
                DB      20H,32H                 ; 2532: JR nz,L2566
                DB      2EH,20H                 ; 2534: LD L,0x20
                DB      54H                     ; 2536: LD D,H
                DB      79H                     ; 2537: LD A,C

L2538:
                DB      70H                     ; 2538: LD (HL),B
                DB      65H                     ; 2539: LD H,L
                DB      20H,52H                 ; 253A: JR nz,L258E
                DB      45H                     ; 253C: LD B,L

L253D:
                DB      54H                     ; 253D: LD D,H
                DB      55H                     ; 253E: LD D,L
                DB      52H                     ; 253F: LD D,D
                DB      4EH                     ; 2540: LD C,(HL)
                DB      20H,74H                 ; 2541: JR nz,L25B7
                DB      6FH                     ; 2543: LD L,A
                DB      20H,74H                 ; 2544: JR nz,L25BA
                DB      65H                     ; 2546: LD H,L
                DB      72H                     ; 2547: LD (HL),D

L2548:
                DB      6DH                     ; 2548: LD L,L
                DB      69H                     ; 2549: LD L,C
                DB      6EH                     ; 254A: LD L,(HL)
                DB      61H                     ; 254B: LD H,C
                DB      74H                     ; 254C: LD (HL),H
                DB      65H                     ; 254D: LD H,L
                DB      20H,74H                 ; 254E: JR nz,L25C4
                DB      68H                     ; 2550: LD L,B
                DB      65H                     ; 2551: LD H,L
                DB      20H,6CH                 ; 2552: JR nz,L25C0
                DB      69H                     ; 2554: LD L,C
                DB      6EH                     ; 2555: LD L,(HL)
                DB      65H                     ; 2556: LD H,L
                DB      20H,61H                 ; 2557: JR nz,L25BA
                DB      6EH                     ; 2559: LD L,(HL)
                DB      64H                     ; 255A: LD H,H
                DB      20H,74H                 ; 255B: JR nz,L25D1
                DB      6FH                     ; 255D: LD L,A
                DB      20H,67H                 ; 255E: JR nz,L25C7
                DB      65H                     ; 2560: LD H,L
                DB      74H                     ; 2561: LD (HL),H

L2562:
                DB      20H,74H                 ; 2562: JR nz,L25D8
                DB      68H                     ; 2564: LD L,B
                DB      65H                     ; 2565: LD H,L

L2566:
                DB      20H,6EH                 ; 2566: JR nz,L25D6
                DB      65H                     ; 2568: LD H,L
                DB      78H                     ; 2569: LD A,B
                DB      74H                     ; 256A: LD (HL),H
                DB      20H,6CH                 ; 256B: JR nz,L25D9
                DB      69H                     ; 256D: LD L,C
                DB      6EH                     ; 256E: LD L,(HL)
                DB      65H                     ; 256F: LD H,L
                DB      20H,28H                 ; 2570: JR nz,L259A
                DB      67H                     ; 2572: LD H,A
                DB      6FH                     ; 2573: LD L,A
                DB      20H,62H                 ; 2574: JR nz,L25D8
                DB      61H                     ; 2576: LD H,C
                DB      63H                     ; 2577: LD H,E
                DB      6BH                     ; 2578: LD L,E
                DB      20H,74H                 ; 2579: JR nz,L25EF

L257B:
                DB      6FH                     ; 257B: LD L,A
                DB      20H,31H                 ; 257C: JR nz,L25AF
                DB      2EH,29H                 ; 257E: LD L,0x29
                DB      0DH                     ; 2580: DEC C
                DB      0AH                     ; 2581: LD A,(BC)
                DB      20H,20H                 ; 2582: JR nz,L25A4
                DB      20H,20H                 ; 2584: JR nz,L25A6
                DB      28H,59H                 ; 2586: JR z,L25E1
                DB      6FH                     ; 2588: LD L,A
                DB      75H                     ; 2589: LD (HL),L
                DB      20H,6DH                 ; 258A: JR nz,L25F9
                DB      61H                     ; 258C: LD H,C
                DB      79H                     ; 258D: LD A,C

L258E:
                DB      20H,73H                 ; 258E: JR nz,L2603
                DB      65H                     ; 2590: LD H,L
                DB      6EH                     ; 2591: LD L,(HL)
                DB      64H                     ; 2592: LD H,H
                DB      20H,6FH                 ; 2593: JR nz,L2604
                DB      74H                     ; 2595: LD (HL),H

L2596:
                DB      68H                     ; 2596: LD L,B
                DB      65H                     ; 2597: LD H,L

L2598:
                DB      72H                     ; 2598: LD (HL),D
                DB      20H,63H                 ; 2599: JR nz,L25FE
                DB      68H                     ; 259B: LD L,B
                DB      61H                     ; 259C: LD H,C
                DB      72H                     ; 259D: LD (HL),D
                DB      61H                     ; 259E: LD H,C
                DB      63H                     ; 259F: LD H,E
                DB      74H                     ; 25A0: LD (HL),H
                DB      65H                     ; 25A1: LD H,L
                DB      72H                     ; 25A2: LD (HL),D
                DB      73H                     ; 25A3: LD (HL),E

L25A4:
                DB      20H,62H                 ; 25A4: JR nz,L2608

L25A6:
                DB      65H                     ; 25A6: LD H,L
                DB      66H                     ; 25A7: LD H,(HL)
                DB      6FH                     ; 25A8: LD L,A
                DB      72H                     ; 25A9: LD (HL),D
                DB      65H                     ; 25AA: LD H,L
                DB      20H,52H                 ; 25AB: JR nz,L25FF
                DB      45H                     ; 25AD: LD B,L
                DB      54H                     ; 25AE: LD D,H

L25AF:
                DB      55H                     ; 25AF: LD D,L
                DB      52H                     ; 25B0: LD D,D
                DB      4EH                     ; 25B1: LD C,(HL)
                DB      2EH,29H                 ; 25B2: LD L,0x29
                DB      2CH                     ; 25B4: INC L
                DB      0DH                     ; 25B5: DEC C
                DB      0AH                     ; 25B6: LD A,(BC)

L25B7:
                DB      20H,20H                 ; 25B7: JR nz,L25D9
                DB      20H,6FH                 ; 25B9: JR nz,L262A
                DB      72H                     ; 25BB: LD (HL),D
                DB      20H,74H                 ; 25BC: JR nz,L2632
                DB      79H                     ; 25BE: LD A,C
                DB      70H                     ; 25BF: LD (HL),B

L25C0:
                DB      65H                     ; 25C0: LD H,L
                DB      20H,24H                 ; 25C1: JR nz,L25E7
                DB      52H                     ; 25C3: LD D,D

L25C4:
                DB      20H,74H                 ; 25C4: JR nz,L263A
                DB      6FH                     ; 25C6: LD L,A

L25C7:
                DB      20H,73H                 ; 25C7: JR nz,L263C
                DB      65H                     ; 25C9: LD H,L
                DB      6EH                     ; 25CA: LD L,(HL)
                DB      64H                     ; 25CB: LD H,H
                DB      20H,74H                 ; 25CC: JR nz,L2642
                DB      68H                     ; 25CE: LD L,B
                DB      65H                     ; 25CF: LD H,L
                DB      20H,73H                 ; 25D0: JR nz,L2645
                DB      61H                     ; 25D2: LD H,C
                DB      6DH                     ; 25D3: LD L,L
                DB      65H                     ; 25D4: LD H,L
                DB      20H,6CH                 ; 25D5: JR nz,L2643
                DB      69H                     ; 25D7: LD L,C

L25D8:
                DB      6EH                     ; 25D8: LD L,(HL)

L25D9:
                DB      65H                     ; 25D9: LD H,L
                DB      20H,61H                 ; 25DA: JR nz,L263D
                DB      67H                     ; 25DC: LD H,A
                DB      61H                     ; 25DD: LD H,C
                DB      69H                     ; 25DE: LD L,C
                DB      6EH                     ; 25DF: LD L,(HL)
                DB      2CH                     ; 25E0: INC L

L25E1:
                DB      0DH                     ; 25E1: DEC C
                DB      0AH                     ; 25E2: LD A,(BC)
                DB      20H,20H                 ; 25E3: JR nz,L2605
                DB      20H,6FH                 ; 25E5: JR nz,L2656

L25E7:
                DB      72H                     ; 25E7: LD (HL),D
                DB      20H,74H                 ; 25E8: JR nz,L265E
                DB      79H                     ; 25EA: LD A,C
                DB      70H                     ; 25EB: LD (HL),B
                DB      65H                     ; 25EC: LD H,L
                DB      20H,24H                 ; 25ED: JR nz,L2613

L25EF:
                DB      43H                     ; 25EF: LD B,E
                DB      20H,74H                 ; 25F0: JR nz,L2666
                DB      6FH                     ; 25F2: LD L,A
                DB      20H,61H                 ; 25F3: JR nz,L2656
                DB      62H                     ; 25F5: LD H,D
                DB      6FH                     ; 25F6: LD L,A
                DB      72H                     ; 25F7: LD (HL),D
                DB      74H                     ; 25F8: LD (HL),H

L25F9:
                DB      20H,74H                 ; 25F9: JR nz,L266F
                DB      72H                     ; 25FB: LD (HL),D
                DB      61H                     ; 25FC: LD H,C
                DB      6EH                     ; 25FD: LD L,(HL)

L25FE:
                DB      73H                     ; 25FE: LD (HL),E

L25FF:
                DB      6DH                     ; 25FF: LD L,L
                DB      69H                     ; 2600: LD L,C
                DB      73H                     ; 2601: LD (HL),E
                DB      73H                     ; 2602: LD (HL),E

L2603:
                DB      69H                     ; 2603: LD L,C

L2604:
                DB      6FH                     ; 2604: LD L,A

L2605:
                DB      6EH                     ; 2605: LD L,(HL)
                DB      2EH,5DH                 ; 2606: LD L,0x5d

L2608:
                DB      0DH                     ; 2608: DEC C
                DB      0AH                     ; 2609: LD A,(BC)
                DB      24H                     ; 260A: INC H
                DB      0DH                     ; 260B: DEC C
                DB      0AH                     ; 260C: LD A,(BC)
                DB      5BH                     ; 260D: LD E,E
                DB      54H                     ; 260E: LD D,H
                DB      72H                     ; 260F: LD (HL),D
                DB      61H                     ; 2610: LD H,C
                DB      6EH                     ; 2611: LD L,(HL)
                DB      73H                     ; 2612: LD (HL),E

L2613:
                DB      6DH                     ; 2613: LD L,L
                DB      69H                     ; 2614: LD L,C
                DB      73H                     ; 2615: LD (HL),E
                DB      73H                     ; 2616: LD (HL),E
                DB      69H                     ; 2617: LD L,C
                DB      6FH                     ; 2618: LD L,A
                DB      6EH                     ; 2619: LD L,(HL)
                DB      20H,64H                 ; 261A: JR nz,L2680
                DB      6FH                     ; 261C: LD L,A
                DB      6EH                     ; 261D: LD L,(HL)
                DB      65H                     ; 261E: LD H,L
                DB      2EH,20H                 ; 261F: LD L,0x20
                DB      43H                     ; 2621: LD B,E
                DB      6FH                     ; 2622: LD L,A
                DB      6EH                     ; 2623: LD L,(HL)
                DB      6EH                     ; 2624: LD L,(HL)
                DB      65H                     ; 2625: LD H,L
                DB      63H                     ; 2626: LD H,E
                DB      74H                     ; 2627: LD (HL),H
                DB      65H                     ; 2628: LD H,L
                DB      64H                     ; 2629: LD H,H

L262A:
                DB      20H,6EH                 ; 262A: JR nz,L269A
                DB      6FH                     ; 262C: LD L,A
                DB      72H                     ; 262D: LD (HL),D
                DB      6DH                     ; 262E: LD L,L
                DB      61H                     ; 262F: LD H,C
                DB      6CH                     ; 2630: LD L,H
                DB      6CH                     ; 2631: LD L,H

L2632:
                DB      79H                     ; 2632: LD A,C
                DB      20H,74H                 ; 2633: JR nz,L26A9
                DB      6FH                     ; 2635: LD L,A
                DB      20H,72H                 ; 2636: JR nz,L26AA
                DB      65H                     ; 2638: LD H,L
                DB      6DH                     ; 2639: LD L,L

L263A:
                DB      6FH                     ; 263A: LD L,A
                DB      74H                     ; 263B: LD (HL),H

L263C:
                DB      65H                     ; 263C: LD H,L

L263D:
                DB      20H,68H                 ; 263D: JR nz,L26A7
                DB      6FH                     ; 263F: LD L,A
                DB      73H                     ; 2640: LD (HL),E
                DB      74H                     ; 2641: LD (HL),H

L2642:
                DB      2CH                     ; 2642: INC L

L2643:
                DB      0DH                     ; 2643: DEC C
                DB      0AH                     ; 2644: LD A,(BC)

L2645:
                DB      20H,74H                 ; 2645: JR nz,L26BB
                DB      79H                     ; 2647: LD A,C
                DB      70H                     ; 2648: LD (HL),B
                DB      65H                     ; 2649: LD H,L
                DB      20H,24H                 ; 264A: JR nz,L2670
                DB      53H                     ; 264C: LD D,E
                DB      65H                     ; 264D: LD H,L
                DB      6EH                     ; 264E: LD L,(HL)
                DB      64H                     ; 264F: LD H,H
                DB      69H                     ; 2650: LD L,C
                DB      6EH                     ; 2651: LD L,(HL)
                DB      67H                     ; 2652: LD H,A
                DB      2EH,2EH                 ; 2653: LD L,0x2e
                DB      2EH,24H                 ; 2655: LD L,0x24
                DB      52H                     ; 2657: LD D,D
                DB      65H                     ; 2658: LD H,L
                DB      63H                     ; 2659: LD H,E
                DB      65H                     ; 265A: LD H,L
                DB      69H                     ; 265B: LD L,C
                DB      76H                     ; 265C: HALT
                DB      69H                     ; 265D: LD L,C

L265E:
                DB      6EH                     ; 265E: LD L,(HL)
                DB      67H                     ; 265F: LD H,A
                DB      2EH,2EH                 ; 2660: LD L,0x2e
                DB      2EH,24H                 ; 2662: LD L,0x24
                DB      07H                     ; 2664: RLCA
                DB      57H                     ; 2665: LD D,A

L2666:
                DB      61H                     ; 2666: LD H,C
                DB      72H                     ; 2667: LD (HL),D
                DB      6EH                     ; 2668: LD L,(HL)
                DB      69H                     ; 2669: LD L,C
                DB      6EH                     ; 266A: LD L,(HL)
                DB      67H                     ; 266B: LD H,A
                DB      3AH,20H,65H             ; 266C: LD A,(0x6520)

L266F:
                DB      69H                     ; 266F: LD L,C

L2670:
                DB      67H                     ; 2670: LD H,A
                DB      68H                     ; 2671: LD L,B
                DB      74H                     ; 2672: LD (HL),H
                DB      68H                     ; 2673: LD L,B
                DB      20H,62H                 ; 2674: JR nz,L26D8
                DB      69H                     ; 2676: LD L,C
                DB      74H                     ; 2677: LD (HL),H
                DB      20H,63H                 ; 2678: JR nz,L26DD
                DB      61H                     ; 267A: LD H,C
                DB      6EH                     ; 267B: LD L,(HL)
                DB      6EH                     ; 267C: LD L,(HL)
                DB      6FH                     ; 267D: LD L,A
                DB      74H                     ; 267E: LD (HL),H
                DB      20H,62H                 ; 267F: JR nz,L26E3
                DB      65H                     ; 2681: LD H,L
                DB      20H,73H                 ; 2682: JR nz,L26F7
                DB      65H                     ; 2684: LD H,L
                DB      6EH                     ; 2685: LD L,(HL)
                DB      74H                     ; 2686: LD (HL),H
                DB      24H                     ; 2687: INC H
                DB      0DH                     ; 2688: DEC C
                DB      0AH                     ; 2689: LD A,(BC)
                DB      2BH                     ; 268A: DEC HL
                DB      2BH                     ; 268B: DEC HL
                DB      20H,42H                 ; 268C: JR nz,L26D0
                DB      61H                     ; 268E: LD H,C
                DB      64H                     ; 268F: LD H,H
                DB      20H,64H                 ; 2690: JR nz,L26F6
                DB      72H                     ; 2692: LD (HL),D
                DB      69H                     ; 2693: LD L,C
                DB      76H                     ; 2694: HALT
                DB      65H                     ; 2695: LD H,L
                DB      20H,6EH                 ; 2696: JR nz,L2706
                DB      61H                     ; 2698: LD H,C
                DB      6DH                     ; 2699: LD L,L

L269A:
                DB      65H                     ; 269A: LD H,L
                DB      24H                     ; 269B: INC H
                DB      0DH                     ; 269C: DEC C
                DB      0AH                     ; 269D: LD A,(BC)
                DB      20H,43H                 ; 269E: JR nz,L26E3
                DB      6FH                     ; 26A0: LD L,A
                DB      6EH                     ; 26A1: LD L,(HL)
                DB      66H                     ; 26A2: LD H,(HL)
                DB      69H                     ; 26A3: LD L,C
                DB      72H                     ; 26A4: LD (HL),D
                DB      6DH                     ; 26A5: LD L,L
                DB      20H,77H                 ; 26A6: JR nz,L271F
                DB      69H                     ; 26A8: LD L,C

L26A9:
                DB      74H                     ; 26A9: LD (HL),H

L26AA:
                DB      68H                     ; 26AA: LD L,B
                DB      20H,63H                 ; 26AB: JR nz,L2710
                DB      61H                     ; 26AD: LD H,C
                DB      72H                     ; 26AE: LD (HL),D
                DB      72H                     ; 26AF: LD (HL),D
                DB      69H                     ; 26B0: LD L,C
                DB      61H                     ; 26B1: LD H,C
                DB      67H                     ; 26B2: LD H,A
                DB      65H                     ; 26B3: LD H,L
                DB      20H,72H                 ; 26B4: JR nz,L2728
                DB      65H                     ; 26B6: LD H,L
                DB      74H                     ; 26B7: LD (HL),H
                DB      75H                     ; 26B8: LD (HL),L
                DB      72H                     ; 26B9: LD (HL),D
                DB      6EH                     ; 26BA: LD L,(HL)

L26BB:
                DB      20H,24H                 ; 26BB: JR nz,L26E1
                DB      20H,49H                 ; 26BD: JR nz,L2708
                DB      6EH                     ; 26BF: LD L,(HL)
                DB      70H                     ; 26C0: LD (HL),B
                DB      75H                     ; 26C1: LD (HL),L
                DB      74H                     ; 26C2: LD (HL),H
                DB      20H,66H                 ; 26C3: JR nz,L272B
                DB      69H                     ; 26C5: LD L,C
                DB      6CH                     ; 26C6: LD L,H
                DB      65H                     ; 26C7: LD H,L
                DB      20H,73H                 ; 26C8: JR nz,L273D
                DB      70H                     ; 26CA: LD (HL),B
                DB      65H                     ; 26CB: LD H,L
                DB      63H                     ; 26CC: LD H,E
                DB      20H,28H                 ; 26CD: JR nz,L26F7
                DB      70H                     ; 26CF: LD (HL),B

L26D0:
                DB      6FH                     ; 26D0: LD L,A
                DB      73H                     ; 26D1: LD (HL),E
                DB      73H                     ; 26D2: LD (HL),E
                DB      69H                     ; 26D3: LD L,C
                DB      62H                     ; 26D4: LD H,D
                DB      6CH                     ; 26D5: LD L,H
                DB      79H                     ; 26D6: LD A,C
                DB      20H,77H                 ; 26D7: JR nz,L2750
                DB      69H                     ; 26D9: LD L,C
                DB      6CH                     ; 26DA: LD L,H
                DB      64H                     ; 26DB: LD H,H
                DB      29H                     ; 26DC: ADD HL,HL

L26DD:
                DB      20H,24H                 ; 26DD: JR nz,L2703
                DB      0DH                     ; 26DF: DEC C
                DB      0AH                     ; 26E0: LD A,(BC)

L26E1:
                DB      54H                     ; 26E1: LD D,H
                DB      79H                     ; 26E2: LD A,C

L26E3:
                DB      70H                     ; 26E3: LD (HL),B
                DB      65H                     ; 26E4: LD H,L
                DB      20H,74H                 ; 26E5: JR nz,L275B
                DB      68H                     ; 26E7: LD L,B
                DB      65H                     ; 26E8: LD H,L
                DB      20H,6EH                 ; 26E9: JR nz,L2759
                DB      65H                     ; 26EB: LD H,L
                DB      77H                     ; 26EC: LD (HL),A
                DB      20H,65H                 ; 26ED: JR nz,L2754
                DB      73H                     ; 26EF: LD (HL),E
                DB      63H                     ; 26F0: LD H,E
                DB      61H                     ; 26F1: LD H,C
                DB      70H                     ; 26F2: LD (HL),B
                DB      65H                     ; 26F3: LD H,L
                DB      20H,63H                 ; 26F4: JR nz,L2759

L26F6:
                DB      68H                     ; 26F6: LD L,B

L26F7:
                DB      61H                     ; 26F7: LD H,C
                DB      72H                     ; 26F8: LD (HL),D
                DB      61H                     ; 26F9: LD H,C
                DB      63H                     ; 26FA: LD H,E
                DB      74H                     ; 26FB: LD (HL),H
                DB      65H                     ; 26FC: LD H,L
                DB      72H                     ; 26FD: LD (HL),D
                DB      3AH,20H,20H             ; 26FE: LD A,(0x2020)
                DB      24H                     ; 2701: INC H
                DB      0DH                     ; 2702: DEC C

L2703:
                DB      0AH                     ; 2703: LD A,(BC)
                DB      42H                     ; 2704: LD B,D
                DB      59H                     ; 2705: LD E,C

L2706:
                DB      45H                     ; 2706: LD B,L
                DB      20H,74H                 ; 2707: JR nz,L277D
                DB      6FH                     ; 2709: LD L,A
                DB      20H,68H                 ; 270A: JR nz,L2774
                DB      6FH                     ; 270C: LD L,A
                DB      73H                     ; 270D: LD (HL),E
                DB      74H                     ; 270E: LD (HL),H
                DB      20H,28H                 ; 270F: JR nz,L2739
                DB      4CH                     ; 2711: LD C,H
                DB      4FH                     ; 2712: LD C,A
                DB      47H                     ; 2713: LD B,A
                DB      4FH                     ; 2714: LD C,A
                DB      55H                     ; 2715: LD D,L
                DB      54H                     ; 2716: LD D,H
                DB      29H                     ; 2717: ADD HL,HL
                DB      20H,61H                 ; 2718: JR nz,L277B
                DB      6EH                     ; 271A: LD L,(HL)
                DB      64H                     ; 271B: LD H,H
                DB      20H,65H                 ; 271C: JR nz,L2783
                DB      78H                     ; 271E: LD A,B

L271F:
                DB      69H                     ; 271F: LD L,C
                DB      74H                     ; 2720: LD (HL),H
                DB      20H,74H                 ; 2721: JR nz,L2797
                DB      6FH                     ; 2723: LD L,A
                DB      20H,43H                 ; 2724: JR nz,L2769
                DB      50H                     ; 2726: LD D,B
                DB      2FH                     ; 2727: CPL

L2728:
                DB      4DH                     ; 2728: LD C,L
                DB      0DH                     ; 2729: DEC C
                DB      0AH                     ; 272A: LD A,(BC)

L272B:
                DB      43H                     ; 272B: LD B,E
                DB      4FH                     ; 272C: LD C,A
                DB      4EH                     ; 272D: LD C,(HL)
                DB      4EH                     ; 272E: LD C,(HL)
                DB      45H                     ; 272F: LD B,L
                DB      43H                     ; 2730: LD B,E
                DB      54H                     ; 2731: LD D,H
                DB      20H,74H                 ; 2732: JR nz,L27A8
                DB      6FH                     ; 2734: LD L,A
                DB      20H,68H                 ; 2735: JR nz,L279F
                DB      6FH                     ; 2737: LD L,A
                DB      73H                     ; 2738: LD (HL),E

L2739:
                DB      74H                     ; 2739: LD (HL),H
                DB      20H,6FH                 ; 273A: JR nz,L27AB
                DB      6EH                     ; 273C: LD L,(HL)

L273D:
                DB      20H,73H                 ; 273D: JR nz,L27B2
                DB      65H                     ; 273F: LD H,L
                DB      6CH                     ; 2740: LD L,H
                DB      65H                     ; 2741: LD H,L
                DB      63H                     ; 2742: LD H,E
                DB      74H                     ; 2743: LD (HL),H
                DB      65H                     ; 2744: LD H,L
                DB      64H                     ; 2745: LD H,H
                DB      20H,70H                 ; 2746: JR nz,L27B8
                DB      6FH                     ; 2748: LD L,A
                DB      72H                     ; 2749: LD (HL),D
                DB      74H                     ; 274A: LD (HL),H
                DB      0DH                     ; 274B: DEC C
                DB      0AH                     ; 274C: LD A,(BC)
                DB      45H                     ; 274D: LD B,L
                DB      52H                     ; 274E: LD D,D
                DB      41H                     ; 274F: LD B,C

L2750:
                DB      20H,61H                 ; 2750: JR nz,L27B3
                DB      20H,43H                 ; 2752: JR nz,L2797

L2754:
                DB      50H                     ; 2754: LD D,B
                DB      2FH                     ; 2755: CPL
                DB      4DH                     ; 2756: LD C,L
                DB      20H,66H                 ; 2757: JR nz,L27BF

L2759:
                DB      69H                     ; 2759: LD L,C
                DB      6CH                     ; 275A: LD L,H

L275B:
                DB      65H                     ; 275B: LD H,L
                DB      0DH                     ; 275C: DEC C
                DB      0AH                     ; 275D: LD A,(BC)
                DB      45H                     ; 275E: LD B,L
                DB      58H                     ; 275F: LD E,B
                DB      49H                     ; 2760: LD C,C
                DB      54H                     ; 2761: LD D,H
                DB      20H,74H                 ; 2762: JR nz,L27D8
                DB      6FH                     ; 2764: LD L,A
                DB      20H,43H                 ; 2765: JR nz,L27AA
                DB      50H                     ; 2767: LD D,B
                DB      2FH                     ; 2768: CPL

L2769:
                DB      4DH                     ; 2769: LD C,L
                DB      0DH                     ; 276A: DEC C
                DB      0AH                     ; 276B: LD A,(BC)
                DB      46H                     ; 276C: LD B,(HL)
                DB      49H                     ; 276D: LD C,C
                DB      4EH                     ; 276E: LD C,(HL)
                DB      49H                     ; 276F: LD C,C
                DB      53H                     ; 2770: LD D,E
                DB      48H                     ; 2771: LD C,B
                DB      20H,72H                 ; 2772: JR nz,L27E6

L2774:
                DB      75H                     ; 2774: LD (HL),L
                DB      6EH                     ; 2775: LD L,(HL)
                DB      6EH                     ; 2776: LD L,(HL)
                DB      69H                     ; 2777: LD L,C
                DB      6EH                     ; 2778: LD L,(HL)
                DB      67H                     ; 2779: LD H,A
                DB      20H,4BH                 ; 277A: JR nz,L27C7
                DB      65H                     ; 277C: LD H,L

L277D:
                DB      72H                     ; 277D: LD (HL),D
                DB      6DH                     ; 277E: LD L,L
                DB      69H                     ; 277F: LD L,C
                DB      74H                     ; 2780: LD (HL),H
                DB      20H,6FH                 ; 2781: JR nz,L27F2

L2783:
                DB      6EH                     ; 2783: LD L,(HL)
                DB      20H,74H                 ; 2784: JR nz,L27FA
                DB      68H                     ; 2786: LD L,B
                DB      65H                     ; 2787: LD H,L
                DB      20H,68H                 ; 2788: JR nz,L27F2
                DB      6FH                     ; 278A: LD L,A
                DB      73H                     ; 278B: LD (HL),E
                DB      74H                     ; 278C: LD (HL),H
                DB      0DH                     ; 278D: DEC C
                DB      0AH                     ; 278E: LD A,(BC)
                DB      48H                     ; 278F: LD C,B
                DB      45H                     ; 2790: LD B,L
                DB      4CH                     ; 2791: LD C,H
                DB      50H                     ; 2792: LD D,B
                DB      20H,62H                 ; 2793: JR nz,L27F7
                DB      79H                     ; 2795: LD A,C
                DB      20H,67H                 ; 2796: JR nz,L27FF
                DB      69H                     ; 2798: LD L,C
                DB      76H                     ; 2799: HALT
                DB      69H                     ; 279A: LD L,C
                DB      6EH                     ; 279B: LD L,(HL)
                DB      67H                     ; 279C: LD H,A
                DB      20H,74H                 ; 279D: JR nz,L2813

L279F:
                DB      68H                     ; 279F: LD L,B
                DB      69H                     ; 27A0: LD L,C
                DB      73H                     ; 27A1: LD (HL),E
                DB      20H,6DH                 ; 27A2: JR nz,L2811
                DB      65H                     ; 27A4: LD H,L
                DB      73H                     ; 27A5: LD (HL),E
                DB      73H                     ; 27A6: LD (HL),E
                DB      61H                     ; 27A7: LD H,C

L27A8:
                DB      67H                     ; 27A8: LD H,A
                DB      65H                     ; 27A9: LD H,L

L27AA:
                DB      0DH                     ; 27AA: DEC C

L27AB:
                DB      0AH                     ; 27AB: LD A,(BC)
                DB      44H                     ; 27AC: LD B,H
                DB      49H                     ; 27AD: LD C,C
                DB      52H                     ; 27AE: LD D,D
                DB      20H,6FH                 ; 27AF: JR nz,L2820
                DB      66H                     ; 27B1: LD H,(HL)

L27B2:
                DB      20H,63H                 ; 27B2: JR nz,L2817
                DB      75H                     ; 27B4: LD (HL),L
                DB      72H                     ; 27B5: LD (HL),D
                DB      72H                     ; 27B6: LD (HL),D
                DB      65H                     ; 27B7: LD H,L

L27B8:
                DB      6EH                     ; 27B8: LD L,(HL)
                DB      74H                     ; 27B9: LD (HL),H
                DB      20H,75H                 ; 27BA: JR nz,L2831
                DB      73H                     ; 27BC: LD (HL),E
                DB      65H                     ; 27BD: LD H,L
                DB      64H                     ; 27BE: LD H,H

L27BF:
                DB      20H,4DH                 ; 27BF: JR nz,L280E
                DB      69H                     ; 27C1: LD L,C
                DB      63H                     ; 27C2: LD H,E
                DB      72H                     ; 27C3: LD (HL),D
                DB      6FH                     ; 27C4: LD L,A
                DB      2DH                     ; 27C5: DEC L
                DB      64H                     ; 27C6: LD H,H

L27C7:
                DB      69H                     ; 27C7: LD L,C
                DB      73H                     ; 27C8: LD (HL),E
                DB      6BH                     ; 27C9: LD L,E
                DB      0DH                     ; 27CA: DEC C
                DB      0AH                     ; 27CB: LD A,(BC)
                DB      4CH                     ; 27CC: LD C,H
                DB      4FH                     ; 27CD: LD C,A
                DB      47H                     ; 27CE: LD B,A
                DB      20H,74H                 ; 27CF: JR nz,L2845
                DB      68H                     ; 27D1: LD L,B
                DB      65H                     ; 27D2: LD H,L
                DB      20H,74H                 ; 27D3: JR nz,L2849
                DB      65H                     ; 27D5: LD H,L
                DB      72H                     ; 27D6: LD (HL),D
                DB      6DH                     ; 27D7: LD L,L

L27D8:
                DB      69H                     ; 27D8: LD L,C
                DB      6EH                     ; 27D9: LD L,(HL)
                DB      61H                     ; 27DA: LD H,C
                DB      6CH                     ; 27DB: LD L,H
                DB      20H,73H                 ; 27DC: JR nz,L2851
                DB      65H                     ; 27DE: LD H,L
                DB      73H                     ; 27DF: LD (HL),E
                DB      73H                     ; 27E0: LD (HL),E
                DB      69H                     ; 27E1: LD L,C
                DB      6FH                     ; 27E2: LD L,A
                DB      6EH                     ; 27E3: LD L,(HL)
                DB      20H,74H                 ; 27E4: JR nz,L285A

L27E6:
                DB      6FH                     ; 27E6: LD L,A
                DB      20H,61H                 ; 27E7: JR nz,L284A
                DB      20H,66H                 ; 27E9: JR nz,L2851
                DB      69H                     ; 27EB: LD L,C
                DB      6CH                     ; 27EC: LD L,H
                DB      65H                     ; 27ED: LD H,L
                DB      0DH                     ; 27EE: DEC C
                DB      0AH                     ; 27EF: LD A,(BC)
                DB      4CH                     ; 27F0: LD C,H
                DB      4FH                     ; 27F1: LD C,A

L27F2:
                DB      47H                     ; 27F2: LD B,A
                DB      4FH                     ; 27F3: LD C,A
                DB      55H                     ; 27F4: LD D,L
                DB      54H                     ; 27F5: LD D,H
                DB      20H,74H                 ; 27F6: JR nz,L286C
                DB      68H                     ; 27F8: LD L,B
                DB      65H                     ; 27F9: LD H,L

L27FA:
                DB      20H,68H                 ; 27FA: JR nz,L2864
                DB      6FH                     ; 27FC: LD L,A
                DB      73H                     ; 27FD: LD (HL),E
                DB      74H                     ; 27FE: LD (HL),H

L27FF:
                DB      0DH                     ; 27FF: DEC C
                DB      0AH                     ; 2800: LD A,(BC)
                DB      52H                     ; 2801: LD D,D
                DB      45H                     ; 2802: LD B,L
                DB      43H                     ; 2803: LD B,E
                DB      45H                     ; 2804: LD B,L
                DB      49H                     ; 2805: LD C,C
                DB      56H                     ; 2806: LD D,(HL)
                DB      45H                     ; 2807: LD B,L
                DB      20H,66H                 ; 2808: JR nz,L2870
                DB      69H                     ; 280A: LD L,C
                DB      6CH                     ; 280B: LD L,H
                DB      65H                     ; 280C: LD H,L
                DB      20H,66H                 ; 280D: JR nz,L2875
                DB      72H                     ; 280F: LD (HL),D
                DB      6FH                     ; 2810: LD L,A

L2811:
                DB      6DH                     ; 2811: LD L,L
                DB      20H,68H                 ; 2812: JR nz,L287C
                DB      6FH                     ; 2814: LD L,A
                DB      73H                     ; 2815: LD (HL),E
                DB      74H                     ; 2816: LD (HL),H

L2817:
                DB      0DH                     ; 2817: DEC C
                DB      0AH                     ; 2818: LD A,(BC)
                DB      53H                     ; 2819: LD D,E
                DB      45H                     ; 281A: LD B,L
                DB      4EH                     ; 281B: LD C,(HL)
                DB      44H                     ; 281C: LD B,H
                DB      20H,66H                 ; 281D: JR nz,L2885
                DB      69H                     ; 281F: LD L,C

L2820:
                DB      6CH                     ; 2820: LD L,H
                DB      65H                     ; 2821: LD H,L
                DB      20H,74H                 ; 2822: JR nz,L2898
                DB      6FH                     ; 2824: LD L,A
                DB      20H,68H                 ; 2825: JR nz,L288F
                DB      6FH                     ; 2827: LD L,A
                DB      73H                     ; 2828: LD (HL),E
                DB      74H                     ; 2829: LD (HL),H
                DB      0DH                     ; 282A: DEC C
                DB      0AH                     ; 282B: LD A,(BC)
                DB      53H                     ; 282C: LD D,E
                DB      45H                     ; 282D: LD B,L
                DB      54H                     ; 282E: LD D,H
                DB      20H,61H                 ; 282F: JR nz,L2892

L2831:
                DB      20H,70H                 ; 2831: JR nz,L28A3
                DB      61H                     ; 2833: LD H,C
                DB      72H                     ; 2834: LD (HL),D
                DB      61H                     ; 2835: LD H,C
                DB      6DH                     ; 2836: LD L,L
                DB      65H                     ; 2837: LD H,L
                DB      74H                     ; 2838: LD (HL),H
                DB      65H                     ; 2839: LD H,L
                DB      72H                     ; 283A: LD (HL),D
                DB      0DH                     ; 283B: DEC C
                DB      0AH                     ; 283C: LD A,(BC)
                DB      53H                     ; 283D: LD D,E
                DB      48H                     ; 283E: LD C,B
                DB      4FH                     ; 283F: LD C,A
                DB      57H                     ; 2840: LD D,A
                DB      20H,74H                 ; 2841: JR nz,L28B7
                DB      68H                     ; 2843: LD L,B
                DB      65H                     ; 2844: LD H,L

L2845:
                DB      20H,70H                 ; 2845: JR nz,L28B7
                DB      61H                     ; 2847: LD H,C
                DB      72H                     ; 2848: LD (HL),D

L2849:
                DB      61H                     ; 2849: LD H,C

L284A:
                DB      6DH                     ; 284A: LD L,L
                DB      65H                     ; 284B: LD H,L
                DB      74H                     ; 284C: LD (HL),H
                DB      65H                     ; 284D: LD H,L
                DB      72H                     ; 284E: LD (HL),D
                DB      73H                     ; 284F: LD (HL),E
                DB      0DH                     ; 2850: DEC C

L2851:
                DB      0AH                     ; 2851: LD A,(BC)
                DB      53H                     ; 2852: LD D,E
                DB      54H                     ; 2853: LD D,H
                DB      41H                     ; 2854: LD B,C
                DB      54H                     ; 2855: LD D,H
                DB      55H                     ; 2856: LD D,L
                DB      53H                     ; 2857: LD D,E
                DB      20H,6FH                 ; 2858: JR nz,L28C9

L285A:
                DB      66H                     ; 285A: LD H,(HL)
                DB      20H,4BH                 ; 285B: JR nz,L28A8
                DB      65H                     ; 285D: LD H,L
                DB      72H                     ; 285E: LD (HL),D
                DB      6DH                     ; 285F: LD L,L
                DB      69H                     ; 2860: LD L,C
                DB      74H                     ; 2861: LD (HL),H
                DB      0DH                     ; 2862: DEC C
                DB      0AH                     ; 2863: LD A,(BC)

L2864:
                DB      54H                     ; 2864: LD D,H
                DB      52H                     ; 2865: LD D,D
                DB      41H                     ; 2866: LD B,C
                DB      4EH                     ; 2867: LD C,(HL)
                DB      53H                     ; 2868: LD D,E
                DB      4DH                     ; 2869: LD C,L
                DB      49H                     ; 286A: LD C,C
                DB      54H                     ; 286B: LD D,H

L286C:
                DB      20H,66H                 ; 286C: JR nz,L28D4
                DB      69H                     ; 286E: LD L,C
                DB      6CH                     ; 286F: LD L,H

L2870:
                DB      65H                     ; 2870: LD H,L
                DB      20H,74H                 ; 2871: JR nz,L28E7
                DB      6FH                     ; 2873: LD L,A
                DB      20H,68H                 ; 2874: JR nz,L28DE
                DB      6FH                     ; 2876: LD L,A
                DB      73H                     ; 2877: LD (HL),E
                DB      74H                     ; 2878: LD (HL),H
                DB      20H,28H                 ; 2879: JR nz,L28A3
                DB      69H                     ; 287B: LD L,C

L287C:
                DB      6EH                     ; 287C: LD L,(HL)
                DB      20H,63H                 ; 287D: JR nz,L28E2
                DB      6FH                     ; 287F: LD L,A
                DB      6EH                     ; 2880: LD L,(HL)
                DB      6EH                     ; 2881: LD L,(HL)
                DB      65H                     ; 2882: LD H,L
                DB      63H                     ; 2883: LD H,E
                DB      74H                     ; 2884: LD (HL),H

L2885:
                DB      20H,73H                 ; 2885: JR nz,L28FA
                DB      74H                     ; 2887: LD (HL),H
                DB      61H                     ; 2888: LD H,C
                DB      74H                     ; 2889: LD (HL),H
                DB      65H                     ; 288A: LD H,L
                DB      29H                     ; 288B: ADD HL,HL
                DB      24H                     ; 288C: INC H
                DB      0DH                     ; 288D: DEC C
                DB      0AH                     ; 288E: LD A,(BC)

L288F:
                DB      42H                     ; 288F: LD B,D
                DB      41H                     ; 2890: LD B,C
                DB      75H                     ; 2891: LD (HL),L

L2892:
                DB      64H                     ; 2892: LD H,H
                DB      20H,28H                 ; 2893: JR nz,L28BD
                DB      72H                     ; 2895: LD (HL),D
                DB      61H                     ; 2896: LD H,C
                DB      74H                     ; 2897: LD (HL),H

L2898:
                DB      65H                     ; 2898: LD H,L
                DB      29H                     ; 2899: ADD HL,HL
                DB      0DH                     ; 289A: DEC C
                DB      0AH                     ; 289B: LD A,(BC)
                DB      42H                     ; 289C: LD B,D
                DB      4CH                     ; 289D: LD C,H
                DB      6FH                     ; 289E: LD L,A
                DB      63H                     ; 289F: LD H,E
                DB      6BH                     ; 28A0: LD L,E
                DB      2DH                     ; 28A1: DEC L
                DB      63H                     ; 28A2: LD H,E

L28A3:
                DB      68H                     ; 28A3: LD L,B
                DB      65H                     ; 28A4: LD H,L
                DB      63H                     ; 28A5: LD H,E
                DB      6BH                     ; 28A6: LD L,E
                DB      2DH                     ; 28A7: DEC L

L28A8:
                DB      74H                     ; 28A8: LD (HL),H
                DB      79H                     ; 28A9: LD A,C
                DB      70H                     ; 28AA: LD (HL),B
                DB      65H                     ; 28AB: LD H,L
                DB      20H,28H                 ; 28AC: JR nz,L28D6
                DB      66H                     ; 28AE: LD H,(HL)
                DB      6FH                     ; 28AF: LD L,A
                DB      72H                     ; 28B0: LD (HL),D
                DB      20H,65H                 ; 28B1: JR nz,L2918
                DB      72H                     ; 28B3: LD (HL),D
                DB      72H                     ; 28B4: LD (HL),D
                DB      6FH                     ; 28B5: LD L,A
                DB      72H                     ; 28B6: LD (HL),D

L28B7:
                DB      20H,64H                 ; 28B7: JR nz,L291D
                DB      65H                     ; 28B9: LD H,L
                DB      74H                     ; 28BA: LD (HL),H
                DB      65H                     ; 28BB: LD H,L
                DB      63H                     ; 28BC: LD H,E

L28BD:
                DB      74H                     ; 28BD: LD (HL),H
                DB      69H                     ; 28BE: LD L,C
                DB      6FH                     ; 28BF: LD L,A
                DB      6EH                     ; 28C0: LD L,(HL)
                DB      29H                     ; 28C1: ADD HL,HL
                DB      0DH                     ; 28C2: DEC C
                DB      0AH                     ; 28C3: LD A,(BC)
                DB      44H                     ; 28C4: LD B,H
                DB      65H                     ; 28C5: LD H,L
                DB      66H                     ; 28C6: LD H,(HL)
                DB      61H                     ; 28C7: LD H,C
                DB      75H                     ; 28C8: LD (HL),L

L28C9:
                DB      6CH                     ; 28C9: LD L,H
                DB      74H                     ; 28CA: LD (HL),H
                DB      2DH                     ; 28CB: DEC L
                DB      64H                     ; 28CC: LD H,H
                DB      69H                     ; 28CD: LD L,C
                DB      73H                     ; 28CE: LD (HL),E
                DB      6BH                     ; 28CF: LD L,E
                DB      20H,28H                 ; 28D0: JR nz,L28FA
                DB      74H                     ; 28D2: LD (HL),H
                DB      6FH                     ; 28D3: LD L,A

L28D4:
                DB      20H,72H                 ; 28D4: JR nz,L2948

L28D6:
                DB      65H                     ; 28D6: LD H,L
                DB      63H                     ; 28D7: LD H,E
                DB      65H                     ; 28D8: LD H,L
                DB      69H                     ; 28D9: LD L,C
                DB      76H                     ; 28DA: HALT
                DB      65H                     ; 28DB: LD H,L
                DB      20H,64H                 ; 28DC: JR nz,L2942

L28DE:
                DB      61H                     ; 28DE: LD H,C
                DB      74H                     ; 28DF: LD (HL),H
                DB      61H                     ; 28E0: LD H,C
                DB      29H                     ; 28E1: ADD HL,HL

L28E2:
                DB      0DH                     ; 28E2: DEC C
                DB      0AH                     ; 28E3: LD A,(BC)
                DB      45H                     ; 28E4: LD B,L
                DB      73H                     ; 28E5: LD (HL),E
                DB      63H                     ; 28E6: LD H,E

L28E7:
                DB      61H                     ; 28E7: LD H,C
                DB      70H                     ; 28E8: LD (HL),B
                DB      65H                     ; 28E9: LD H,L
                DB      20H,28H                 ; 28EA: JR nz,L2914
                DB      63H                     ; 28EC: LD H,E
                DB      68H                     ; 28ED: LD L,B
                DB      61H                     ; 28EE: LD H,C
                DB      72H                     ; 28EF: LD (HL),D
                DB      61H                     ; 28F0: LD H,C
                DB      63H                     ; 28F1: LD H,E
                DB      74H                     ; 28F2: LD (HL),H
                DB      65H                     ; 28F3: LD H,L
                DB      72H                     ; 28F4: LD (HL),D
                DB      20H,64H                 ; 28F5: JR nz,L295B
                DB      75H                     ; 28F7: LD (HL),L
                DB      72H                     ; 28F8: LD (HL),D
                DB      69H                     ; 28F9: LD L,C

L28FA:
                DB      6EH                     ; 28FA: LD L,(HL)
                DB      67H                     ; 28FB: LD H,A
                DB      20H,43H                 ; 28FC: JR nz,L2941
                DB      4FH                     ; 28FE: LD C,A
                DB      4EH                     ; 28FF: LD C,(HL)
                DB      4EH                     ; 2900: LD C,(HL)
                DB      45H                     ; 2901: LD B,L
                DB      43H                     ; 2902: LD B,E
                DB      54H                     ; 2903: LD D,H
                DB      29H                     ; 2904: ADD HL,HL
                DB      0DH                     ; 2905: DEC C
                DB      0AH                     ; 2906: LD A,(BC)
                DB      46H                     ; 2907: LD B,(HL)
                DB      69H                     ; 2908: LD L,C
                DB      6CH                     ; 2909: LD L,H
                DB      65H                     ; 290A: LD H,L
                DB      2DH                     ; 290B: DEC L
                DB      6DH                     ; 290C: LD L,L
                DB      6FH                     ; 290D: LD L,A
                DB      64H                     ; 290E: LD H,H
                DB      65H                     ; 290F: LD H,L
                DB      20H,28H                 ; 2910: JR nz,L293A
                DB      66H                     ; 2912: LD H,(HL)
                DB      6FH                     ; 2913: LD L,A

L2914:
                DB      72H                     ; 2914: LD (HL),D
                DB      20H,6FH                 ; 2915: JR nz,L2986
                DB      75H                     ; 2917: LD (HL),L

L2918:
                DB      74H                     ; 2918: LD (HL),H
                DB      67H                     ; 2919: LD H,A
                DB      6FH                     ; 291A: LD L,A
                DB      69H                     ; 291B: LD L,C
                DB      6EH                     ; 291C: LD L,(HL)

L291D:
                DB      67H                     ; 291D: LD H,A
                DB      20H,66H                 ; 291E: JR nz,L2986
                DB      69H                     ; 2920: LD L,C
                DB      6CH                     ; 2921: LD L,H
                DB      65H                     ; 2922: LD H,L
                DB      73H                     ; 2923: LD (HL),E
                DB      29H                     ; 2924: ADD HL,HL
                DB      0DH                     ; 2925: DEC C
                DB      0AH                     ; 2926: LD A,(BC)
                DB      49H                     ; 2927: LD C,C
                DB      62H                     ; 2928: LD H,D
                DB      6DH                     ; 2929: LD L,L
                DB      20H,28H                 ; 292A: JR nz,L2954
                DB      70H                     ; 292C: LD (HL),B
                DB      61H                     ; 292D: LD H,C
                DB      72H                     ; 292E: LD (HL),D
                DB      69H                     ; 292F: LD L,C
                DB      74H                     ; 2930: LD (HL),H
                DB      79H                     ; 2931: LD A,C
                DB      20H,61H                 ; 2932: JR nz,L2995
                DB      6EH                     ; 2934: LD L,(HL)
                DB      64H                     ; 2935: LD H,H
                DB      20H,74H                 ; 2936: JR nz,L29AC
                DB      75H                     ; 2938: LD (HL),L
                DB      72H                     ; 2939: LD (HL),D

L293A:
                DB      6EH                     ; 293A: LD L,(HL)
                DB      20H,61H                 ; 293B: JR nz,L299E
                DB      72H                     ; 293D: LD (HL),D
                DB      6FH                     ; 293E: LD L,A
                DB      75H                     ; 293F: LD (HL),L
                DB      6EH                     ; 2940: LD L,(HL)

L2941:
                DB      64H                     ; 2941: LD H,H

L2942:
                DB      20H,68H                 ; 2942: JR nz,L29AC
                DB      61H                     ; 2944: LD H,C
                DB      6EH                     ; 2945: LD L,(HL)
                DB      64H                     ; 2946: LD H,H
                DB      6CH                     ; 2947: LD L,H

L2948:
                DB      69H                     ; 2948: LD L,C
                DB      6EH                     ; 2949: LD L,(HL)
                DB      67H                     ; 294A: LD H,A
                DB      29H                     ; 294B: ADD HL,HL
                DB      0DH                     ; 294C: DEC C
                DB      0AH                     ; 294D: LD A,(BC)
                DB      4CH                     ; 294E: LD C,H
                DB      6FH                     ; 294F: LD L,A
                DB      63H                     ; 2950: LD H,E
                DB      61H                     ; 2951: LD H,C
                DB      6CH                     ; 2952: LD L,H
                DB      2DH                     ; 2953: DEC L

L2954:
                DB      65H                     ; 2954: LD H,L
                DB      63H                     ; 2955: LD H,E
                DB      68H                     ; 2956: LD L,B
                DB      6FH                     ; 2957: LD L,A
                DB      20H,28H                 ; 2958: JR nz,L2982
                DB      68H                     ; 295A: LD L,B

L295B:
                DB      61H                     ; 295B: LD H,C
                DB      6CH                     ; 295C: LD L,H
                DB      66H                     ; 295D: LD H,(HL)
                DB      2DH                     ; 295E: DEC L
                DB      64H                     ; 295F: LD H,H
                DB      75H                     ; 2960: LD (HL),L
                DB      70H                     ; 2961: LD (HL),B
                DB      6CH                     ; 2962: LD L,H
                DB      65H                     ; 2963: LD H,L
                DB      78H                     ; 2964: LD A,B
                DB      29H                     ; 2965: ADD HL,HL
                DB      0DH                     ; 2966: DEC C
                DB      0AH                     ; 2967: LD A,(BC)
                DB      50H                     ; 2968: LD D,B
                DB      41H                     ; 2969: LD B,C
                DB      72H                     ; 296A: LD (HL),D
                DB      69H                     ; 296B: LD L,C
                DB      74H                     ; 296C: LD (HL),H
                DB      79H                     ; 296D: LD A,C
                DB      20H,28H                 ; 296E: JR nz,L2998
                DB      66H                     ; 2970: LD H,(HL)
                DB      6FH                     ; 2971: LD L,A
                DB      72H                     ; 2972: LD (HL),D
                DB      20H,63H                 ; 2973: JR nz,L29D8
                DB      6FH                     ; 2975: LD L,A
                DB      6DH                     ; 2976: LD L,L
                DB      6DH                     ; 2977: LD L,L
                DB      75H                     ; 2978: LD (HL),L
                DB      6EH                     ; 2979: LD L,(HL)
                DB      69H                     ; 297A: LD L,C
                DB      63H                     ; 297B: LD H,E
                DB      61H                     ; 297C: LD H,C
                DB      74H                     ; 297D: LD (HL),H
                DB      69H                     ; 297E: LD L,C
                DB      6FH                     ; 297F: LD L,A
                DB      6EH                     ; 2980: LD L,(HL)
                DB      20H,6CH                 ; 2981: JR nz,L29EF
                DB      69H                     ; 2983: LD L,C
                DB      6EH                     ; 2984: LD L,(HL)
                DB      65H                     ; 2985: LD H,L

L2986:
                DB      29H                     ; 2986: ADD HL,HL
                DB      0DH                     ; 2987: DEC C
                DB      0AH                     ; 2988: LD A,(BC)
                DB      50H                     ; 2989: LD D,B
                DB      4FH                     ; 298A: LD C,A
                DB      72H                     ; 298B: LD (HL),D
                DB      74H                     ; 298C: LD (HL),H
                DB      20H,28H                 ; 298D: JR nz,L29B7
                DB      74H                     ; 298F: LD (HL),H
                DB      6FH                     ; 2990: LD L,A
                DB      20H,63H                 ; 2991: JR nz,L29F6
                DB      6FH                     ; 2993: LD L,A
                DB      6DH                     ; 2994: LD L,L

L2995:
                DB      6DH                     ; 2995: LD L,L
                DB      75H                     ; 2996: LD (HL),L
                DB      6EH                     ; 2997: LD L,(HL)

L2998:
                DB      69H                     ; 2998: LD L,C
                DB      63H                     ; 2999: LD H,E
                DB      61H                     ; 299A: LD H,C
                DB      74H                     ; 299B: LD (HL),H
                DB      65H                     ; 299C: LD H,L
                DB      20H,6FH                 ; 299D: JR nz,L2A0E
                DB      6EH                     ; 299F: LD L,(HL)
                DB      29H                     ; 29A0: ADD HL,HL
                DB      0DH                     ; 29A1: DEC C
                DB      0AH                     ; 29A2: LD A,(BC)
                DB      50H                     ; 29A3: LD D,B
                DB      52H                     ; 29A4: LD D,D
                DB      69H                     ; 29A5: LD L,C
                DB      6EH                     ; 29A6: LD L,(HL)
                DB      74H                     ; 29A7: LD (HL),H
                DB      65H                     ; 29A8: LD H,L
                DB      72H                     ; 29A9: LD (HL),D
                DB      20H,63H                 ; 29AA: JR nz,L2A0F

L29AC:
                DB      6FH                     ; 29AC: LD L,A
                DB      70H                     ; 29AD: LD (HL),B
                DB      79H                     ; 29AE: LD A,C
                DB      20H,28H                 ; 29AF: JR nz,L29D9
                DB      20H,4FH                 ; 29B1: JR nz,L2A02
                DB      4EH                     ; 29B3: LD C,(HL)
                DB      20H,2FH                 ; 29B4: JR nz,L29E5
                DB      20H,4FH                 ; 29B6: JR nz,L2A07
                DB      46H                     ; 29B8: LD B,(HL)
                DB      46H                     ; 29B9: LD B,(HL)
                DB      20H,29H                 ; 29BA: JR nz,L29E5
                DB      0DH                     ; 29BC: DEC C
                DB      0AH                     ; 29BD: LD A,(BC)
                DB      54H                     ; 29BE: LD D,H
                DB      49H                     ; 29BF: LD C,C
                DB      4DH                     ; 29C0: LD C,L
                DB      45H                     ; 29C1: LD B,L
                DB      52H                     ; 29C2: LD D,D
                DB      20H,28H                 ; 29C3: JR nz,L29ED
                DB      20H,4FH                 ; 29C5: JR nz,L2A16
                DB      6EH                     ; 29C7: LD L,(HL)
                DB      20H,2FH                 ; 29C8: JR nz,L29F9
                DB      20H,4FH                 ; 29CA: JR nz,L2A1B
                DB      46H                     ; 29CC: LD B,(HL)
                DB      46H                     ; 29CD: LD B,(HL)
                DB      20H,29H                 ; 29CE: JR nz,L29F9
                DB      0DH                     ; 29D0: DEC C
                DB      0AH                     ; 29D1: LD A,(BC)
                DB      56H                     ; 29D2: LD D,(HL)
                DB      74H                     ; 29D3: LD (HL),H
                DB      35H                     ; 29D4: DEC (HL)
                DB      32H,2DH,65H             ; 29D5: LD (0x652d),A

L29D8:
                DB      6DH                     ; 29D8: LD L,L

L29D9:
                DB      75H                     ; 29D9: LD (HL),L
                DB      6CH                     ; 29DA: LD L,H
                DB      61H                     ; 29DB: LD H,C
                DB      74H                     ; 29DC: LD (HL),H
                DB      69H                     ; 29DD: LD L,C
                DB      6FH                     ; 29DE: LD L,A
                DB      6EH                     ; 29DF: LD L,(HL)
                DB      0DH                     ; 29E0: DEC C
                DB      0AH                     ; 29E1: LD A,(BC)
                DB      57H                     ; 29E2: LD D,A
                DB      61H                     ; 29E3: LD H,C
                DB      72H                     ; 29E4: LD (HL),D

L29E5:
                DB      6EH                     ; 29E5: LD L,(HL)
                DB      69H                     ; 29E6: LD L,C
                DB      6EH                     ; 29E7: LD L,(HL)
                DB      67H                     ; 29E8: LD H,A
                DB      20H,28H                 ; 29E9: JR nz,L2A13
                DB      66H                     ; 29EB: LD H,(HL)
                DB      6FH                     ; 29EC: LD L,A

L29ED:
                DB      72H                     ; 29ED: LD (HL),D
                DB      20H,66H                 ; 29EE: JR nz,L2A56
                DB      69H                     ; 29F0: LD L,C
                DB      6CH                     ; 29F1: LD L,H
                DB      65H                     ; 29F2: LD H,L
                DB      6EH                     ; 29F3: LD L,(HL)
                DB      61H                     ; 29F4: LD H,C
                DB      6DH                     ; 29F5: LD L,L

L29F6:
                DB      65H                     ; 29F6: LD H,L
                DB      20H,63H                 ; 29F7: JR nz,L2A5C

L29F9:
                DB      6FH                     ; 29F9: LD L,A
                DB      6EH                     ; 29FA: LD L,(HL)
                DB      66H                     ; 29FB: LD H,(HL)
                DB      6CH                     ; 29FC: LD L,H
                DB      69H                     ; 29FD: LD L,C
                DB      63H                     ; 29FE: LD H,E
                DB      74H                     ; 29FF: LD (HL),H
                DB      73H                     ; 2A00: LD (HL),E
                DB      29H                     ; 2A01: ADD HL,HL

L2A02:
                DB      24H                     ; 2A02: INC H
                DB      0DH                     ; 2A03: DEC C
                DB      0AH                     ; 2A04: LD A,(BC)
                DB      50H                     ; 2A05: LD D,B
                DB      41H                     ; 2A06: LD B,C

L2A07:
                DB      44H                     ; 2A07: LD B,H
                DB      2DH                     ; 2A08: DEC L
                DB      43H                     ; 2A09: LD B,E
                DB      48H                     ; 2A0A: LD C,B
                DB      41H                     ; 2A0B: LD B,C
                DB      52H                     ; 2A0C: LD D,D
                DB      0DH                     ; 2A0D: DEC C

L2A0E:
                DB      0AH                     ; 2A0E: LD A,(BC)

L2A0F:
                DB      50H                     ; 2A0F: LD D,B
                DB      41H                     ; 2A10: LD B,C
                DB      44H                     ; 2A11: LD B,H
                DB      44H                     ; 2A12: LD B,H

L2A13:
                DB      49H                     ; 2A13: LD C,C
                DB      4EH                     ; 2A14: LD C,(HL)
                DB      47H                     ; 2A15: LD B,A

L2A16:
                DB      24H                     ; 2A16: INC H
                DB      0DH                     ; 2A17: DEC C
                DB      0AH                     ; 2A18: LD A,(BC)
                DB      31H,2DH,43H             ; 2A19: LD SP,0x432d
                DB      48H                     ; 2A1C: LD C,B
                DB      41H                     ; 2A1D: LD B,C
                DB      52H                     ; 2A1E: LD D,D
                DB      41H                     ; 2A1F: LD B,C
                DB      43H                     ; 2A20: LD B,E
                DB      54H                     ; 2A21: LD D,H
                DB      45H                     ; 2A22: LD B,L
                DB      52H                     ; 2A23: LD D,D
                DB      2DH                     ; 2A24: DEC L
                DB      43H                     ; 2A25: LD B,E
                DB      48H                     ; 2A26: LD C,B
                DB      45H                     ; 2A27: LD B,L
                DB      43H                     ; 2A28: LD B,E
                DB      4BH                     ; 2A29: LD C,E
                DB      53H                     ; 2A2A: LD D,E
                DB      55H                     ; 2A2B: LD D,L
                DB      4DH                     ; 2A2C: LD C,L
                DB      0DH                     ; 2A2D: DEC C
                DB      0AH                     ; 2A2E: LD A,(BC)
                DB      32H,2DH,43H             ; 2A2F: LD (0x432d),A
                DB      48H                     ; 2A32: LD C,B
                DB      41H                     ; 2A33: LD B,C
                DB      52H                     ; 2A34: LD D,D
                DB      41H                     ; 2A35: LD B,C
                DB      43H                     ; 2A36: LD B,E
                DB      54H                     ; 2A37: LD D,H
                DB      45H                     ; 2A38: LD B,L
                DB      52H                     ; 2A39: LD D,D
                DB      2DH                     ; 2A3A: DEC L
                DB      43H                     ; 2A3B: LD B,E
                DB      48H                     ; 2A3C: LD C,B
                DB      45H                     ; 2A3D: LD B,L
                DB      43H                     ; 2A3E: LD B,E
                DB      4BH                     ; 2A3F: LD C,E
                DB      53H                     ; 2A40: LD D,E
                DB      55H                     ; 2A41: LD D,L
                DB      4DH                     ; 2A42: LD C,L
                DB      0DH                     ; 2A43: DEC C
                DB      0AH                     ; 2A44: LD A,(BC)
                DB      33H                     ; 2A45: INC SP
                DB      2DH                     ; 2A46: DEC L
                DB      43H                     ; 2A47: LD B,E
                DB      48H                     ; 2A48: LD C,B
                DB      41H                     ; 2A49: LD B,C
                DB      52H                     ; 2A4A: LD D,D
                DB      41H                     ; 2A4B: LD B,C
                DB      43H                     ; 2A4C: LD B,E
                DB      54H                     ; 2A4D: LD D,H
                DB      45H                     ; 2A4E: LD B,L
                DB      52H                     ; 2A4F: LD D,D
                DB      2DH                     ; 2A50: DEC L
                DB      43H                     ; 2A51: LD B,E
                DB      52H                     ; 2A52: LD D,D
                DB      43H                     ; 2A53: LD B,E
                DB      2DH                     ; 2A54: DEC L
                DB      43H                     ; 2A55: LD B,E

L2A56:
                DB      43H                     ; 2A56: LD B,E
                DB      49H                     ; 2A57: LD C,C
                DB      54H                     ; 2A58: LD D,H
                DB      54H                     ; 2A59: LD D,H
                DB      24H                     ; 2A5A: INC H
                DB      0DH                     ; 2A5B: DEC C

L2A5C:
                DB      0AH                     ; 2A5C: LD A,(BC)
                DB      45H                     ; 2A5D: LD B,L
                DB      56H                     ; 2A5E: LD D,(HL)
                DB      45H                     ; 2A5F: LD B,L
                DB      4EH                     ; 2A60: LD C,(HL)
                DB      09H                     ; 2A61: ADD HL,BC
                DB      4DH                     ; 2A62: LD C,L
                DB      41H                     ; 2A63: LD B,C
                DB      52H                     ; 2A64: LD D,D
                DB      4BH                     ; 2A65: LD C,E
                DB      09H                     ; 2A66: ADD HL,BC
                DB      4EH                     ; 2A67: LD C,(HL)
                DB      4FH                     ; 2A68: LD C,A
                DB      4EH                     ; 2A69: LD C,(HL)
                DB      45H                     ; 2A6A: LD B,L
                DB      09H                     ; 2A6B: ADD HL,BC
                DB      4FH                     ; 2A6C: LD C,A
                DB      44H                     ; 2A6D: LD B,H
                DB      44H                     ; 2A6E: LD B,H
                DB      09H                     ; 2A6F: ADD HL,BC
                DB      53H                     ; 2A70: LD D,E
                DB      50H                     ; 2A71: LD D,B
                DB      41H                     ; 2A72: LD B,C
                DB      43H                     ; 2A73: LD B,E
                DB      45H                     ; 2A74: LD B,L
                DB      24H                     ; 2A75: INC H
                DB      0DH                     ; 2A76: DEC C
                DB      0AH                     ; 2A77: LD A,(BC)
                DB      4FH                     ; 2A78: LD C,A
                DB      46H                     ; 2A79: LD B,(HL)
                DB      46H                     ; 2A7A: LD B,(HL)
                DB      09H                     ; 2A7B: ADD HL,BC
                DB      4FH                     ; 2A7C: LD C,A
                DB      4EH                     ; 2A7D: LD C,(HL)
                DB      24H                     ; 2A7E: INC H
                DB      0DH                     ; 2A7F: DEC C
                DB      0AH                     ; 2A80: LD A,(BC)
                DB      4EH                     ; 2A81: LD C,(HL)
                DB      4FH                     ; 2A82: LD C,A
                DB      09H                     ; 2A83: ADD HL,BC
                DB      59H                     ; 2A84: LD E,C
                DB      45H                     ; 2A85: LD B,L
                DB      53H                     ; 2A86: LD D,E
                DB      24H                     ; 2A87: INC H
                DB      0DH                     ; 2A88: DEC C
                DB      0AH                     ; 2A89: LD A,(BC)
                DB      52H                     ; 2A8A: LD D,D
                DB      20H,53H                 ; 2A8B: JR nz,L2AE0
                DB      65H                     ; 2A8D: LD H,L
                DB      6EH                     ; 2A8E: LD L,(HL)
                DB      64H                     ; 2A8F: LD H,H
                DB      20H,74H                 ; 2A90: JR nz,L2B06
                DB      68H                     ; 2A92: LD L,B
                DB      65H                     ; 2A93: LD H,L
                DB      20H,73H                 ; 2A94: JR nz,L2B09
                DB      61H                     ; 2A96: LD H,C
                DB      6DH                     ; 2A97: LD L,L
                DB      65H                     ; 2A98: LD H,L
                DB      20H,6CH                 ; 2A99: JR nz,L2B07
                DB      69H                     ; 2A9B: LD L,C
                DB      6EH                     ; 2A9C: LD L,(HL)
                DB      65H                     ; 2A9D: LD H,L
                DB      20H,61H                 ; 2A9E: JR nz,L2B01
                DB      67H                     ; 2AA0: LD H,A
                DB      61H                     ; 2AA1: LD H,C
                DB      69H                     ; 2AA2: LD L,C
                DB      6EH                     ; 2AA3: LD L,(HL)
                DB      24H                     ; 2AA4: INC H
                DB      0DH                     ; 2AA5: DEC C
                DB      0AH                     ; 2AA6: LD A,(BC)
                DB      3FH                     ; 2AA7: CCF
                DB      20H,20H                 ; 2AA8: JR nz,L2ACA
                DB      54H                     ; 2AAA: LD D,H
                DB      68H                     ; 2AAB: LD L,B
                DB      69H                     ; 2AAC: LD L,C
                DB      73H                     ; 2AAD: LD (HL),E
                DB      20H,6DH                 ; 2AAE: JR nz,L2B1D
                DB      65H                     ; 2AB0: LD H,L
                DB      73H                     ; 2AB1: LD (HL),E
                DB      73H                     ; 2AB2: LD (HL),E
                DB      61H                     ; 2AB3: LD H,C
                DB      67H                     ; 2AB4: LD H,A
                DB      65H                     ; 2AB5: LD H,L
                DB      0DH                     ; 2AB6: DEC C
                DB      0AH                     ; 2AB7: LD A,(BC)
                DB      43H                     ; 2AB8: LD B,E
                DB      20H,20H                 ; 2AB9: JR nz,L2ADB
                DB      43H                     ; 2ABB: LD B,E
                DB      6CH                     ; 2ABC: LD L,H
                DB      6FH                     ; 2ABD: LD L,A
                DB      73H                     ; 2ABE: LD (HL),E
                DB      65H                     ; 2ABF: LD H,L
                DB      20H,74H                 ; 2AC0: JR nz,L2B36
                DB      68H                     ; 2AC2: LD L,B
                DB      65H                     ; 2AC3: LD H,L
                DB      20H,63H                 ; 2AC4: JR nz,L2B29
                DB      6FH                     ; 2AC6: LD L,A
                DB      6EH                     ; 2AC7: LD L,(HL)
                DB      6EH                     ; 2AC8: LD L,(HL)
                DB      65H                     ; 2AC9: LD H,L

L2ACA:
                DB      63H                     ; 2ACA: LD H,E
                DB      74H                     ; 2ACB: LD (HL),H
                DB      69H                     ; 2ACC: LD L,C
                DB      6FH                     ; 2ACD: LD L,A
                DB      6EH                     ; 2ACE: LD L,(HL)
                DB      0DH                     ; 2ACF: DEC C
                DB      0AH                     ; 2AD0: LD A,(BC)
                DB      30H,20H                 ; 2AD1: JR nc,L2AF3
                DB      20H,28H                 ; 2AD3: JR nz,L2AFD
                DB      7AH                     ; 2AD5: LD A,D
                DB      65H                     ; 2AD6: LD H,L
                DB      72H                     ; 2AD7: LD (HL),D
                DB      6FH                     ; 2AD8: LD L,A
                DB      29H                     ; 2AD9: ADD HL,HL
                DB      20H,54H                 ; 2ADA: JR nz,L2B30
                DB      72H                     ; 2ADC: LD (HL),D
                DB      61H                     ; 2ADD: LD H,C
                DB      6EH                     ; 2ADE: LD L,(HL)
                DB      73H                     ; 2ADF: LD (HL),E

L2AE0:
                DB      6DH                     ; 2AE0: LD L,L
                DB      69H                     ; 2AE1: LD L,C
                DB      74H                     ; 2AE2: LD (HL),H
                DB      20H,61H                 ; 2AE3: JR nz,L2B46
                DB      20H,4EH                 ; 2AE5: JR nz,L2B35
                DB      55H                     ; 2AE7: LD D,L
                DB      4CH                     ; 2AE8: LD C,H
                DB      4CH                     ; 2AE9: LD C,H
                DB      0DH                     ; 2AEA: DEC C
                DB      0AH                     ; 2AEB: LD A,(BC)
                DB      53H                     ; 2AEC: LD D,E
                DB      20H,20H                 ; 2AED: JR nz,L2B0F
                DB      53H                     ; 2AEF: LD D,E
                DB      74H                     ; 2AF0: LD (HL),H
                DB      61H                     ; 2AF1: LD H,C
                DB      74H                     ; 2AF2: LD (HL),H

L2AF3:
                DB      75H                     ; 2AF3: LD (HL),L
                DB      73H                     ; 2AF4: LD (HL),E
                DB      20H,6FH                 ; 2AF5: JR nz,L2B66
                DB      66H                     ; 2AF7: LD H,(HL)
                DB      20H,74H                 ; 2AF8: JR nz,L2B6E
                DB      68H                     ; 2AFA: LD L,B
                DB      65H                     ; 2AFB: LD H,L
                DB      20H,63H                 ; 2AFC: JR nz,L2B61
                DB      6FH                     ; 2AFE: LD L,A
                DB      6EH                     ; 2AFF: LD L,(HL)
                DB      6EH                     ; 2B00: LD L,(HL)

L2B01:
                DB      65H                     ; 2B01: LD H,L
                DB      63H                     ; 2B02: LD H,E
                DB      74H                     ; 2B03: LD (HL),H
                DB      69H                     ; 2B04: LD L,C
                DB      6FH                     ; 2B05: LD L,A

L2B06:
                DB      6EH                     ; 2B06: LD L,(HL)

L2B07:
                DB      0DH                     ; 2B07: DEC C
                DB      0AH                     ; 2B08: LD A,(BC)

L2B09:
                DB      54H                     ; 2B09: LD D,H
                DB      79H                     ; 2B0A: LD A,C
                DB      70H                     ; 2B0B: LD (HL),B
                DB      69H                     ; 2B0C: LD L,C
                DB      6EH                     ; 2B0D: LD L,(HL)
                DB      67H                     ; 2B0E: LD H,A

L2B0F:
                DB      20H,61H                 ; 2B0F: JR nz,L2B72
                DB      6EH                     ; 2B11: LD L,(HL)
                DB      6FH                     ; 2B12: LD L,A
                DB      74H                     ; 2B13: LD (HL),H
                DB      68H                     ; 2B14: LD L,B
                DB      65H                     ; 2B15: LD H,L
                DB      72H                     ; 2B16: LD (HL),D
                DB      20H,24H                 ; 2B17: JR nz,L2B3D
                DB      20H,77H                 ; 2B19: JR nz,L2B92
                DB      69H                     ; 2B1B: LD L,C
                DB      6CH                     ; 2B1C: LD L,H

L2B1D:
                DB      6CH                     ; 2B1D: LD L,H
                DB      20H,73H                 ; 2B1E: JR nz,L2B93
                DB      65H                     ; 2B20: LD H,L
                DB      6EH                     ; 2B21: LD L,(HL)
                DB      64H                     ; 2B22: LD H,H
                DB      20H,69H                 ; 2B23: JR nz,L2B8E
                DB      74H                     ; 2B25: LD (HL),H
                DB      20H,74H                 ; 2B26: JR nz,L2B9C
                DB      6FH                     ; 2B28: LD L,A

L2B29:
                DB      20H,74H                 ; 2B29: JR nz,L2B9F
                DB      68H                     ; 2B2B: LD L,B
                DB      65H                     ; 2B2C: LD H,L
                DB      20H,68H                 ; 2B2D: JR nz,L2B97
                DB      6FH                     ; 2B2F: LD L,A

L2B30:
                DB      73H                     ; 2B30: LD (HL),E
                DB      74H                     ; 2B31: LD (HL),H
                DB      0DH                     ; 2B32: DEC C
                DB      0AH                     ; 2B33: LD A,(BC)
                DB      0DH                     ; 2B34: DEC C

L2B35:
                DB      0AH                     ; 2B35: LD A,(BC)

L2B36:
                DB      43H                     ; 2B36: LD B,E
                DB      6FH                     ; 2B37: LD L,A
                DB      6DH                     ; 2B38: LD L,L
                DB      6DH                     ; 2B39: LD L,L
                DB      61H                     ; 2B3A: LD H,C
                DB      6EH                     ; 2B3B: LD L,(HL)
                DB      64H                     ; 2B3C: LD H,H

L2B3D:
                DB      3EH,24H                 ; 2B3D: LD A,0x24
                DB      20H,6FH                 ; 2B3F: JR nz,L2BB0
                DB      6EH                     ; 2B41: LD L,(HL)
                DB      24H                     ; 2B42: INC H
                DB      20H,6FH                 ; 2B43: JR nz,L2BB4
                DB      66H                     ; 2B45: LD H,(HL)

L2B46:
                DB      66H                     ; 2B46: LD H,(HL)
                DB      24H                     ; 2B47: INC H
                DB      0DH                     ; 2B48: DEC C
                DB      0AH                     ; 2B49: LD A,(BC)
                DB      54H                     ; 2B4A: LD D,H
                DB      72H                     ; 2B4B: LD (HL),D
                DB      61H                     ; 2B4C: LD H,C
                DB      6EH                     ; 2B4D: LD L,(HL)
                DB      73H                     ; 2B4E: LD (HL),E
                DB      6DH                     ; 2B4F: LD L,L
                DB      69H                     ; 2B50: LD L,C
                DB      74H                     ; 2B51: LD (HL),H
                DB      74H                     ; 2B52: LD (HL),H
                DB      69H                     ; 2B53: LD L,C
                DB      6EH                     ; 2B54: LD L,(HL)
                DB      67H                     ; 2B55: LD H,A
                DB      20H,61H                 ; 2B56: JR nz,L2BB9
                DB      20H,66H                 ; 2B58: JR nz,L2BC0
                DB      69H                     ; 2B5A: LD L,C
                DB      6CH                     ; 2B5B: LD L,H
                DB      65H                     ; 2B5C: LD H,L
                DB      24H                     ; 2B5D: INC H
                DB      0DH                     ; 2B5E: DEC C
                DB      0AH                     ; 2B5F: LD A,(BC)
                DB      4CH                     ; 2B60: LD C,H

L2B61:
                DB      6FH                     ; 2B61: LD L,A
                DB      63H                     ; 2B62: LD H,E
                DB      61H                     ; 2B63: LD H,C
                DB      6CH                     ; 2B64: LD L,H
                DB      20H,65H                 ; 2B65: JR nz,L2BCC
                DB      63H                     ; 2B67: LD H,E
                DB      68H                     ; 2B68: LD L,B
                DB      6FH                     ; 2B69: LD L,A
                DB      24H                     ; 2B6A: INC H
                DB      20H,64H                 ; 2B6B: JR nz,L2BD1
                DB      65H                     ; 2B6D: LD H,L

L2B6E:
                DB      66H                     ; 2B6E: LD H,(HL)
                DB      61H                     ; 2B6F: LD H,C
                DB      75H                     ; 2B70: LD (HL),L
                DB      6CH                     ; 2B71: LD L,H

L2B72:
                DB      74H                     ; 2B72: LD (HL),H
                DB      24H                     ; 2B73: INC H
                DB      20H,41H                 ; 2B74: JR nz,L2BB7
                DB      53H                     ; 2B76: LD D,E
                DB      43H                     ; 2B77: LD B,E
                DB      49H                     ; 2B78: LD C,C
                DB      49H                     ; 2B79: LD C,C
                DB      24H                     ; 2B7A: INC H
                DB      20H,62H                 ; 2B7B: JR nz,L2BDF
                DB      69H                     ; 2B7D: LD L,C
                DB      6EH                     ; 2B7E: LD L,(HL)
                DB      61H                     ; 2B7F: LD H,C
                DB      72H                     ; 2B80: LD (HL),D
                DB      79H                     ; 2B81: LD A,C
                DB      24H                     ; 2B82: INC H
                DB      0DH                     ; 2B83: DEC C
                DB      0AH                     ; 2B84: LD A,(BC)
                DB      41H                     ; 2B85: LD B,C
                DB      53H                     ; 2B86: LD D,E
                DB      43H                     ; 2B87: LD B,E
                DB      49H                     ; 2B88: LD C,C
                DB      49H                     ; 2B89: LD C,C
                DB      09H                     ; 2B8A: ADD HL,BC
                DB      42H                     ; 2B8B: LD B,D
                DB      49H                     ; 2B8C: LD C,C
                DB      4EH                     ; 2B8D: LD C,(HL)

L2B8E:
                DB      41H                     ; 2B8E: LD B,C
                DB      52H                     ; 2B8F: LD D,D
                DB      59H                     ; 2B90: LD E,C
                DB      09H                     ; 2B91: ADD HL,BC

L2B92:
                DB      44H                     ; 2B92: LD B,H

L2B93:
                DB      45H                     ; 2B93: LD B,L
                DB      46H                     ; 2B94: LD B,(HL)
                DB      41H                     ; 2B95: LD B,C
                DB      55H                     ; 2B96: LD D,L

L2B97:
                DB      4CH                     ; 2B97: LD C,H
                DB      54H                     ; 2B98: LD D,H
                DB      24H                     ; 2B99: INC H
                DB      0DH                     ; 2B9A: DEC C
                DB      0AH                     ; 2B9B: LD A,(BC)

L2B9C:
                DB      56H                     ; 2B9C: LD D,(HL)
                DB      54H                     ; 2B9D: LD D,H
                DB      35H                     ; 2B9E: DEC (HL)

L2B9F:
                DB      32H,20H,65H             ; 2B9F: LD (0x6520),A
                DB      6DH                     ; 2BA2: LD L,L
                DB      75H                     ; 2BA3: LD (HL),L
                DB      6CH                     ; 2BA4: LD L,H
                DB      61H                     ; 2BA5: LD H,C
                DB      74H                     ; 2BA6: LD (HL),H
                DB      69H                     ; 2BA7: LD L,C
                DB      6FH                     ; 2BA8: LD L,A
                DB      6EH                     ; 2BA9: LD L,(HL)
                DB      24H                     ; 2BAA: INC H
                DB      0DH                     ; 2BAB: DEC C
                DB      0AH                     ; 2BAC: LD A,(BC)
                DB      46H                     ; 2BAD: LD B,(HL)
                DB      69H                     ; 2BAE: LD L,C
                DB      6CH                     ; 2BAF: LD L,H

L2BB0:
                DB      65H                     ; 2BB0: LD H,L
                DB      20H,4DH                 ; 2BB1: JR nz,L2C00
                DB      6FH                     ; 2BB3: LD L,A

L2BB4:
                DB      64H                     ; 2BB4: LD H,H
                DB      65H                     ; 2BB5: LD H,L
                DB      24H                     ; 2BB6: INC H

L2BB7:
                DB      0DH                     ; 2BB7: DEC C
                DB      0AH                     ; 2BB8: LD A,(BC)

L2BB9:
                DB      49H                     ; 2BB9: LD C,C
                DB      42H                     ; 2BBA: LD B,D
                DB      4DH                     ; 2BBB: LD C,L
                DB      20H,66H                 ; 2BBC: JR nz,L2C24
                DB      6CH                     ; 2BBE: LD L,H
                DB      61H                     ; 2BBF: LD H,C

L2BC0:
                DB      67H                     ; 2BC0: LD H,A
                DB      24H                     ; 2BC1: INC H
                DB      0DH                     ; 2BC2: DEC C
                DB      0AH                     ; 2BC3: LD A,(BC)
                DB      46H                     ; 2BC4: LD B,(HL)
                DB      69H                     ; 2BC5: LD L,C
                DB      6CH                     ; 2BC6: LD L,H
                DB      65H                     ; 2BC7: LD H,L
                DB      20H,77H                 ; 2BC8: JR nz,L2C41
                DB      61H                     ; 2BCA: LD H,C
                DB      72H                     ; 2BCB: LD (HL),D

L2BCC:
                DB      6EH                     ; 2BCC: LD L,(HL)
                DB      69H                     ; 2BCD: LD L,C
                DB      6EH                     ; 2BCE: LD L,(HL)
                DB      67H                     ; 2BCF: LD H,A
                DB      24H                     ; 2BD0: INC H

L2BD1:
                DB      0DH                     ; 2BD1: DEC C
                DB      0AH                     ; 2BD2: LD A,(BC)
                DB      50H                     ; 2BD3: LD D,B
                DB      72H                     ; 2BD4: LD (HL),D
                DB      69H                     ; 2BD5: LD L,C
                DB      6EH                     ; 2BD6: LD L,(HL)
                DB      74H                     ; 2BD7: LD (HL),H
                DB      65H                     ; 2BD8: LD H,L
                DB      72H                     ; 2BD9: LD (HL),D
                DB      20H,63H                 ; 2BDA: JR nz,L2C3F
                DB      6FH                     ; 2BDC: LD L,A
                DB      70H                     ; 2BDD: LD (HL),B
                DB      79H                     ; 2BDE: LD A,C

L2BDF:
                DB      24H                     ; 2BDF: INC H
                DB      0DH                     ; 2BE0: DEC C
                DB      0AH                     ; 2BE1: LD A,(BC)
                DB      45H                     ; 2BE2: LD B,L
                DB      73H                     ; 2BE3: LD (HL),E
                DB      63H                     ; 2BE4: LD H,E
                DB      61H                     ; 2BE5: LD H,C
                DB      70H                     ; 2BE6: LD (HL),B
                DB      65H                     ; 2BE7: LD H,L
                DB      20H,63H                 ; 2BE8: JR nz,L2C4D
                DB      68H                     ; 2BEA: LD L,B
                DB      61H                     ; 2BEB: LD H,C
                DB      72H                     ; 2BEC: LD (HL),D
                DB      3AH,20H,24H             ; 2BED: LD A,(0x2420)
                DB      0DH                     ; 2BF0: DEC C
                DB      0AH                     ; 2BF1: LD A,(BC)
                DB      50H                     ; 2BF2: LD D,B
                DB      61H                     ; 2BF3: LD H,C
                DB      72H                     ; 2BF4: LD (HL),D
                DB      69H                     ; 2BF5: LD L,C
                DB      74H                     ; 2BF6: LD (HL),H
                DB      79H                     ; 2BF7: LD A,C
                DB      3AH,20H,24H             ; 2BF8: LD A,(0x2420)
                DB      0DH                     ; 2BFB: DEC C
                DB      0AH                     ; 2BFC: LD A,(BC)
                DB      42H                     ; 2BFD: LD B,D
                DB      6CH                     ; 2BFE: LD L,H
                DB      6FH                     ; 2BFF: LD L,A

L2C00:
                DB      63H                     ; 2C00: LD H,E
                DB      6BH                     ; 2C01: LD L,E
                DB      20H,63H                 ; 2C02: JR nz,L2C67
                DB      68H                     ; 2C04: LD L,B
                DB      65H                     ; 2C05: LD H,L
                DB      63H                     ; 2C06: LD H,E
                DB      6BH                     ; 2C07: LD L,E
                DB      20H,74H                 ; 2C08: JR nz,L2C7E
                DB      79H                     ; 2C0A: LD A,C
                DB      70H                     ; 2C0B: LD (HL),B
                DB      65H                     ; 2C0C: LD H,L
                DB      3AH,20H,24H             ; 2C0D: LD A,(0x2420)
                DB      2DH                     ; 2C10: DEC L
                DB      63H                     ; 2C11: LD H,E
                DB      68H                     ; 2C12: LD L,B
                DB      61H                     ; 2C13: LD H,C
                DB      72H                     ; 2C14: LD (HL),D
                DB      61H                     ; 2C15: LD H,C
                DB      63H                     ; 2C16: LD H,E
                DB      74H                     ; 2C17: LD (HL),H
                DB      65H                     ; 2C18: LD H,L
                DB      72H                     ; 2C19: LD (HL),D
                DB      24H                     ; 2C1A: INC H
                DB      6EH                     ; 2C1B: LD L,(HL)
                DB      6FH                     ; 2C1C: LD L,A
                DB      6EH                     ; 2C1D: LD L,(HL)
                DB      65H                     ; 2C1E: LD H,L
                DB      24H                     ; 2C1F: INC H
                DB      6DH                     ; 2C20: LD L,L
                DB      61H                     ; 2C21: LD H,C
                DB      72H                     ; 2C22: LD (HL),D
                DB      6BH                     ; 2C23: LD L,E

L2C24:
                DB      24H                     ; 2C24: INC H
                DB      73H                     ; 2C25: LD (HL),E
                DB      70H                     ; 2C26: LD (HL),B
                DB      61H                     ; 2C27: LD H,C
                DB      63H                     ; 2C28: LD H,E
                DB      65H                     ; 2C29: LD H,L
                DB      24H                     ; 2C2A: INC H
                DB      6FH                     ; 2C2B: LD L,A
                DB      64H                     ; 2C2C: LD H,H
                DB      64H                     ; 2C2D: LD H,H
                DB      24H                     ; 2C2E: INC H
                DB      65H                     ; 2C2F: LD H,L
                DB      76H                     ; 2C30: HALT
                DB      65H                     ; 2C31: LD H,L
                DB      6EH                     ; 2C32: LD L,(HL)
                DB      24H                     ; 2C33: INC H
                DB      53H                     ; 2C34: LD D,E
                DB      70H                     ; 2C35: LD (HL),B
                DB      65H                     ; 2C36: LD H,L
                DB      65H                     ; 2C37: LD H,L
                DB      64H                     ; 2C38: LD H,H
                DB      20H,24H                 ; 2C39: JR nz,L2C5F
                DB      69H                     ; 2C3B: LD L,C
                DB      73H                     ; 2C3C: LD (HL),E
                DB      20H,69H                 ; 2C3D: JR nz,L2CA8

L2C3F:
                DB      6EH                     ; 2C3F: LD L,(HL)
                DB      64H                     ; 2C40: LD H,H

L2C41:
                DB      65H                     ; 2C41: LD H,L
                DB      74H                     ; 2C42: LD (HL),H
                DB      65H                     ; 2C43: LD H,L
                DB      72H                     ; 2C44: LD (HL),D
                DB      6DH                     ; 2C45: LD L,L
                DB      69H                     ; 2C46: LD L,C
                DB      6EH                     ; 2C47: LD L,(HL)
                DB      61H                     ; 2C48: LD H,C
                DB      74H                     ; 2C49: LD (HL),H
                DB      65H                     ; 2C4A: LD H,L
                DB      20H,28H                 ; 2C4B: JR nz,L2C75

L2C4D:
                DB      6EH                     ; 2C4D: LD L,(HL)
                DB      6FH                     ; 2C4E: LD L,A
                DB      74H                     ; 2C4F: LD (HL),H
                DB      20H,53H                 ; 2C50: JR nz,L2CA5
                DB      45H                     ; 2C52: LD B,L
                DB      54H                     ; 2C53: LD D,H
                DB      29H                     ; 2C54: ADD HL,HL
                DB      24H                     ; 2C55: INC H
                DB      54H                     ; 2C56: LD D,H
                DB      69H                     ; 2C57: LD L,C
                DB      6DH                     ; 2C58: LD L,L
                DB      65H                     ; 2C59: LD H,L
                DB      72H                     ; 2C5A: LD (HL),D
                DB      24H                     ; 2C5B: INC H
                DB      0DH                     ; 2C5C: DEC C
                DB      0AH                     ; 2C5D: LD A,(BC)
                DB      20H,20H                 ; 2C5E: JR nz,L2C80
                DB      20H,20H                 ; 2C60: JR nz,L2C82
                DB      35H                     ; 2C62: DEC (HL)
                DB      30H,09H                 ; 2C63: JR nc,L2C6E
                DB      20H,37H                 ; 2C65: JR nz,L2C9E

L2C67:
                DB      35H                     ; 2C67: DEC (HL)
                DB      20H,20H                 ; 2C68: JR nz,L2C8A
                DB      20H,31H                 ; 2C6A: JR nz,L2C9D
                DB      31H,30H,20H             ; 2C6C: LD SP,0x2030
                DB      31H,33H,34H             ; 2C6F: LD SP,0x3433
                DB      2EH,35H                 ; 2C72: LD L,0x35
                DB      20H,20H                 ; 2C74: JR nz,L2C96
                DB      20H,31H                 ; 2C76: JR nz,L2CA9
                DB      35H                     ; 2C78: DEC (HL)
                DB      30H,09H                 ; 2C79: JR nc,L2C84
                DB      33H                     ; 2C7B: INC SP
                DB      30H,30H                 ; 2C7C: JR nc,L2CAE

L2C7E:
                DB      20H,20H                 ; 2C7E: JR nz,L2CA0

L2C80:
                DB      20H,36H                 ; 2C80: JR nz,L2CB8

L2C82:
                DB      30H,30H                 ; 2C82: JR nc,L2CB4

L2C84:
                DB      20H,20H                 ; 2C84: JR nz,L2CA6
                DB      31H,32H,30H             ; 2C86: LD SP,L3032
                DB      30H,0DH                 ; 2C89: JR nc,L2C98
                DB      0AH                     ; 2C8B: LD A,(BC)
                DB      20H,20H                 ; 2C8C: JR nz,L2CAE
                DB      31H,38H,30H             ; 2C8E: LD SP,0x3038
                DB      30H,20H                 ; 2C91: JR nc,L2CB3
                DB      20H,32H                 ; 2C93: JR nz,L2CC7
                DB      30H,30H                 ; 2C95: JR nc,L2CC7
                DB      30H,20H                 ; 2C97: JR nc,L2CB9
                DB      20H,32H                 ; 2C99: JR nz,L2CCD
                DB      34H                     ; 2C9B: INC (HL)
                DB      30H,30H                 ; 2C9C: JR nc,L2CCE

L2C9E:
                DB      20H,20H                 ; 2C9E: JR nz,L2CC0

L2CA0:
                DB      33H                     ; 2CA0: INC SP
                DB      36H,30H                 ; 2CA1: LD (HL),0x30
                DB      30H,20H                 ; 2CA3: JR nc,L2CC5

L2CA5:
                DB      20H,34H                 ; 2CA5: JR nz,L2CDB
                DB      38H,30H                 ; 2CA7: JR c,L2CD9

L2CA9:
                DB      30H,20H                 ; 2CA9: JR nc,L2CCB
                DB      20H,37H                 ; 2CAB: JR nz,L2CE4
                DB      32H,30H,30H             ; 2CAD: LD (0x3030),A
                DB      20H,20H                 ; 2CB0: JR nz,L2CD2
                DB      39H                     ; 2CB2: ADD HL,SP

L2CB3:
                DB      36H,30H                 ; 2CB3: LD (HL),0x30
                DB      30H,20H                 ; 2CB5: JR nc,L2CD7
                DB      31H,39H,32H             ; 2CB7: LD SP,0x3239
                DB      30H,30H                 ; 2CBA: JR nc,L2CEC
                DB      24H                     ; 2CBC: INC H
                DB      1AH                     ; 2CBD: LD A,(DE)
                DB      0DH                     ; 2CBE: DEC C
                DB      0AH                     ; 2CBF: LD A,(BC)

L2CC0:
                DB      09H                     ; 2CC0: ADD HL,BC
                DB      09H                     ; 2CC1: ADD HL,BC
                DB      4BH                     ; 2CC2: LD C,E
                DB      65H                     ; 2CC3: LD H,L
                DB      72H                     ; 2CC4: LD (HL),D

L2CC5:
                DB      6DH                     ; 2CC5: LD L,L
                DB      69H                     ; 2CC6: LD L,C

L2CC7:
                DB      74H                     ; 2CC7: LD (HL),H
                DB      2DH                     ; 2CC8: DEC L
                DB      38H,30H                 ; 2CC9: JR c,L2CFB

L2CCB:
                DB      20H,56H                 ; 2CCB: JR nz,L2D23

L2CCD:
                DB      33H                     ; 2CCD: INC SP

L2CCE:
                DB      2EH,39H                 ; 2CCE: LD L,0x39
                DB      41H                     ; 2CD0: LD B,C
                DB      20H,5BH                 ; 2CD1: JR nz,L2D2E
                DB      4BH                     ; 2CD3: LD C,E
                DB      61H                     ; 2CD4: LD H,C
                DB      79H                     ; 2CD5: LD A,C
                DB      70H                     ; 2CD6: LD (HL),B

L2CD7:
                DB      72H                     ; 2CD7: LD (HL),D
                DB      6FH                     ; 2CD8: LD L,A

L2CD9:
                DB      20H,49H                 ; 2CD9: JR nz,L2D24

L2CDB:
                DB      49H                     ; 2CDB: LD C,C
                DB      5DH                     ; 2CDC: LD E,L
                DB      0DH                     ; 2CDD: DEC C
                DB      0AH                     ; 2CDE: LD A,(BC)
                DB      24H                     ; 2CDF: INC H
                DB      08H                     ; 2CE0: EX AF,AF'
                DB      20H,08H                 ; 2CE1: JR nz,L2CEB
                DB      24H                     ; 2CE3: INC H

L2CE4:
                DB      20H,08H                 ; 2CE4: JR nz,L2CEE
                DB      24H                     ; 2CE6: INC H
                DB      0DH                     ; 2CE7: DEC C
                DB      18H,24H                 ; 2CE8: JR L2D0E
                DB      1AH                     ; 2CEA: LD A,(DE)

L2CEB:
                DB      24H                     ; 2CEB: INC H

L2CEC:
                DB      1BH                     ; 2CEC: DEC DE
                DB      3DH                     ; 2CED: DEC A

L2CEE:
                DB      23H                     ; 2CEE: INC HL
                DB      35H                     ; 2CEF: DEC (HL)
                DB      24H                     ; 2CF0: INC H
                DB      1BH                     ; 2CF1: DEC DE
                DB      3DH                     ; 2CF2: DEC A
                DB      23H                     ; 2CF3: INC HL
                DB      35H                     ; 2CF4: DEC (HL)
                DB      0AH                     ; 2CF5: LD A,(BC)
                DB      24H                     ; 2CF6: INC H
                DB      1BH                     ; 2CF7: DEC DE
                DB      3DH                     ; 2CF8: DEC A
                DB      25H                     ; 2CF9: DEC H
                DB      2BH                     ; 2CFA: DEC HL

L2CFB:
                DB      18H,24H                 ; 2CFB: JR L2D21
                DB      1BH                     ; 2CFD: DEC DE
                DB      3DH                     ; 2CFE: DEC A
                DB      23H                     ; 2CFF: INC HL
                DB      54H                     ; 2D00: LD D,H
                DB      24H                     ; 2D01: INC H
                DB      1BH                     ; 2D02: DEC DE
                DB      3DH                     ; 2D03: DEC A
                DB      27H                     ; 2D04: DAA
                DB      20H,24H                 ; 2D05: JR nz,L2D2B
                DB      1BH                     ; 2D07: DEC DE
                DB      3DH                     ; 2D08: DEC A
                DB      26H,20H                 ; 2D09: LD H,0x20
                DB      24H                     ; 2D0B: INC H
                DB      0DH                     ; 2D0C: DEC C
                DB      1BH                     ; 2D0D: DEC DE

L2D0E:
                DB      3DH                     ; 2D0E: DEC A
                DB      24H                     ; 2D0F: INC H
                DB      0BH                     ; 2D10: DEC BC
                DB      24H                     ; 2D11: INC H
                DB      00H                     ; 2D12: NOP
                DB      00H                     ; 2D13: NOP
                DB      0AH                     ; 2D14: LD A,(BC)
                DB      24H                     ; 2D15: INC H
                DB      00H                     ; 2D16: NOP
                DB      00H                     ; 2D17: NOP
                DB      0CH                     ; 2D18: INC C
                DB      24H                     ; 2D19: INC H
                DB      00H                     ; 2D1A: NOP
                DB      00H                     ; 2D1B: NOP
                DB      08H                     ; 2D1C: EX AF,AF'
                DB      24H                     ; 2D1D: INC H
                DB      00H                     ; 2D1E: NOP
                DB      00H                     ; 2D1F: NOP
                DB      1AH                     ; 2D20: LD A,(DE)

L2D21:
                DB      24H                     ; 2D21: INC H
                DB      00H                     ; 2D22: NOP

L2D23:
                DB      00H                     ; 2D23: NOP

L2D24:
                DB      1BH                     ; 2D24: DEC DE
                DB      47H                     ; 2D25: LD B,A
                DB      24H                     ; 2D26: INC H
                DB      00H                     ; 2D27: NOP
                DB      1BH                     ; 2D28: DEC DE
                DB      41H                     ; 2D29: LD B,C
                DB      24H                     ; 2D2A: INC H

L2D2B:
                DB      00H                     ; 2D2B: NOP
                DB      1EH,24H                 ; 2D2C: LD E,0x24

L2D2E:
                DB      00H                     ; 2D2E: NOP
                DB      00H                     ; 2D2F: NOP
                DB      0BH                     ; 2D30: DEC BC
                DB      24H                     ; 2D31: INC H
                DB      00H                     ; 2D32: NOP
                DB      00H                     ; 2D33: NOP
                DB      17H                     ; 2D34: RLA
                DB      24H                     ; 2D35: INC H
                DB      00H                     ; 2D36: NOP
                DB      00H                     ; 2D37: NOP
                DB      18H,24H                 ; 2D38: JR L2D5E
                DB      00H                     ; 2D3A: NOP
                DB      00H                     ; 2D3B: NOP
                DB      10H,03H                 ; 2D3C: DJNZ L2D41
                DB      42H                     ; 2D3E: LD B,D
                DB      59H                     ; 2D3F: LD E,C
                DB      45H                     ; 2D40: LD B,L

L2D41:
                DB      24H                     ; 2D41: INC H
                DB      21H,21H,07H             ; 2D42: LD HL,0x721
                DB      43H                     ; 2D45: LD B,E
                DB      4FH                     ; 2D46: LD C,A
                DB      4EH                     ; 2D47: LD C,(HL)
                DB      4EH                     ; 2D48: LD C,(HL)
                DB      45H                     ; 2D49: LD B,L
                DB      43H                     ; 2D4A: LD B,E
                DB      54H                     ; 2D4B: LD D,H
                DB      24H                     ; 2D4C: INC H
                DB      00H                     ; 2D4D: NOP
                DB      00H                     ; 2D4E: NOP
                DB      03H                     ; 2D4F: INC BC
                DB      44H                     ; 2D50: LD B,H
                DB      49H                     ; 2D51: LD C,C
                DB      52H                     ; 2D52: LD D,D
                DB      24H                     ; 2D53: INC H
                DB      24H                     ; 2D54: INC H
                DB      24H                     ; 2D55: INC H
                DB      03H                     ; 2D56: INC BC
                DB      45H                     ; 2D57: LD B,L
                DB      52H                     ; 2D58: LD D,D
                DB      41H                     ; 2D59: LD B,C
                DB      24H                     ; 2D5A: INC H
                DB      27H                     ; 2D5B: DAA
                DB      27H                     ; 2D5C: DAA
                DB      04H                     ; 2D5D: INC B

L2D5E:
                DB      45H                     ; 2D5E: LD B,L
                DB      58H                     ; 2D5F: LD E,B
                DB      49H                     ; 2D60: LD C,C
                DB      54H                     ; 2D61: LD D,H
                DB      24H                     ; 2D62: INC H
                DB      03H                     ; 2D63: INC BC
                DB      03H                     ; 2D64: INC BC
                DB      06H,46H                 ; 2D65: LD B,0x46
                DB      49H                     ; 2D67: LD C,C
                DB      4EH                     ; 2D68: LD C,(HL)
                DB      49H                     ; 2D69: LD C,C
                DB      53H                     ; 2D6A: LD D,E
                DB      48H                     ; 2D6B: LD C,B
                DB      24H                     ; 2D6C: INC H
                DB      1BH                     ; 2D6D: DEC DE
                DB      1BH                     ; 2D6E: DEC DE
                DB      03H                     ; 2D6F: INC BC
                DB      47H                     ; 2D70: LD B,A
                DB      45H                     ; 2D71: LD B,L
                DB      54H                     ; 2D72: LD D,H
                DB      24H                     ; 2D73: INC H
                DB      0CH                     ; 2D74: INC C
                DB      0CH                     ; 2D75: INC C
                DB      04H                     ; 2D76: INC B
                DB      48H                     ; 2D77: LD C,B
                DB      45H                     ; 2D78: LD B,L
                DB      4CH                     ; 2D79: LD C,H
                DB      50H                     ; 2D7A: LD D,B
                DB      24H                     ; 2D7B: INC H
                DB      06H,06H                 ; 2D7C: LD B,6
                DB      03H                     ; 2D7E: INC BC
                DB      4CH                     ; 2D7F: LD C,H
                DB      4FH                     ; 2D80: LD C,A
                DB      47H                     ; 2D81: LD B,A
                DB      24H                     ; 2D82: INC H
                DB      09H                     ; 2D83: ADD HL,BC
                DB      09H                     ; 2D84: ADD HL,BC
                DB      06H,4CH                 ; 2D85: LD B,0x4c
                DB      4FH                     ; 2D87: LD C,A
                DB      47H                     ; 2D88: LD B,A
                DB      4FH                     ; 2D89: LD C,A
                DB      55H                     ; 2D8A: LD D,L
                DB      54H                     ; 2D8B: LD D,H
                DB      24H                     ; 2D8C: INC H
                DB      1EH,1EH                 ; 2D8D: LD E,0x1e
                DB      07H                     ; 2D8F: RLCA
                DB      52H                     ; 2D90: LD D,D
                DB      45H                     ; 2D91: LD B,L
                DB      43H                     ; 2D92: LD B,E
                DB      45H                     ; 2D93: LD B,L
                DB      49H                     ; 2D94: LD C,C
                DB      56H                     ; 2D95: LD D,(HL)
                DB      45H                     ; 2D96: LD B,L
                DB      24H                     ; 2D97: INC H
                DB      0CH                     ; 2D98: INC C
                DB      0CH                     ; 2D99: INC C
                DB      04H                     ; 2D9A: INC B
                DB      53H                     ; 2D9B: LD D,E
                DB      45H                     ; 2D9C: LD B,L
                DB      4EH                     ; 2D9D: LD C,(HL)
                DB      44H                     ; 2D9E: LD B,H
                DB      24H                     ; 2D9F: INC H
                DB      0FH                     ; 2DA0: RRCA
                DB      0FH                     ; 2DA1: RRCA
                DB      03H                     ; 2DA2: INC BC
                DB      53H                     ; 2DA3: LD D,E
                DB      45H                     ; 2DA4: LD B,L
                DB      54H                     ; 2DA5: LD D,H
                DB      24H                     ; 2DA6: INC H
                DB      12H                     ; 2DA7: LD (DE),A
                DB      12H                     ; 2DA8: LD (DE),A
                DB      04H                     ; 2DA9: INC B
                DB      53H                     ; 2DAA: LD D,E
                DB      48H                     ; 2DAB: LD C,B
                DB      4FH                     ; 2DAC: LD C,A
                DB      57H                     ; 2DAD: LD D,A
                DB      24H                     ; 2DAE: INC H
                DB      15H                     ; 2DAF: DEC D
                DB      15H                     ; 2DB0: DEC D
                DB      06H,53H                 ; 2DB1: LD B,0x53
                DB      54H                     ; 2DB3: LD D,H
                DB      41H                     ; 2DB4: LD B,C
                DB      54H                     ; 2DB5: LD D,H
                DB      55H                     ; 2DB6: LD D,L
                DB      53H                     ; 2DB7: LD D,E
                DB      24H                     ; 2DB8: INC H
                DB      18H,18H                 ; 2DB9: JR L2DD3
                DB      08H                     ; 2DBB: EX AF,AF'
                DB      54H                     ; 2DBC: LD D,H
                DB      52H                     ; 2DBD: LD D,D
                DB      41H                     ; 2DBE: LD B,C
                DB      4EH                     ; 2DBF: LD C,(HL)
                DB      53H                     ; 2DC0: LD D,E
                DB      4DH                     ; 2DC1: LD C,L
                DB      49H                     ; 2DC2: LD C,C
                DB      54H                     ; 2DC3: LD D,H
                DB      24H                     ; 2DC4: INC H
                DB      2AH,2AH,0DH             ; 2DC5: LD HL,(0x0d2a)
                DB      04H                     ; 2DC8: INC B
                DB      42H                     ; 2DC9: LD B,D
                DB      41H                     ; 2DCA: LD B,C
                DB      55H                     ; 2DCB: LD D,L
                DB      44H                     ; 2DCC: LD B,H
                DB      24H                     ; 2DCD: INC H
                DB      21H,21H,10H             ; 2DCE: LD HL,0x1021
                DB      42H                     ; 2DD1: LD B,D
                DB      4CH                     ; 2DD2: LD C,H

L2DD3:
                DB      4FH                     ; 2DD3: LD C,A
                DB      43H                     ; 2DD4: LD B,E
                DB      4BH                     ; 2DD5: LD C,E
                DB      2DH                     ; 2DD6: DEC L
                DB      43H                     ; 2DD7: LD B,E
                DB      48H                     ; 2DD8: LD C,B
                DB      45H                     ; 2DD9: LD B,L
                DB      43H                     ; 2DDA: LD B,E
                DB      4BH                     ; 2DDB: LD C,E
                DB      2DH                     ; 2DDC: DEC L
                DB      54H                     ; 2DDD: LD D,H
                DB      59H                     ; 2DDE: LD E,C
                DB      50H                     ; 2DDF: LD D,B
                DB      45H                     ; 2DE0: LD B,L
                DB      24H                     ; 2DE1: INC H
                DB      18H,18H                 ; 2DE2: JR L2DFC
                DB      0CH                     ; 2DE4: INC C
                DB      44H                     ; 2DE5: LD B,H
                DB      45H                     ; 2DE6: LD B,L
                DB      46H                     ; 2DE7: LD B,(HL)
                DB      41H                     ; 2DE8: LD B,C
                DB      55H                     ; 2DE9: LD D,L
                DB      4CH                     ; 2DEA: LD C,H
                DB      54H                     ; 2DEB: LD D,H
                DB      2DH                     ; 2DEC: DEC L
                DB      44H                     ; 2DED: LD B,H
                DB      49H                     ; 2DEE: LD C,C
                DB      53H                     ; 2DEF: LD D,E
                DB      4BH                     ; 2DF0: LD C,E
                DB      24H                     ; 2DF1: INC H
                DB      24H                     ; 2DF2: INC H
                DB      24H                     ; 2DF3: INC H
                DB      06H,45H                 ; 2DF4: LD B,0x45
                DB      53H                     ; 2DF6: LD D,E
                DB      43H                     ; 2DF7: LD B,E
                DB      41H                     ; 2DF8: LD B,C
                DB      50H                     ; 2DF9: LD D,B
                DB      45H                     ; 2DFA: LD B,L
                DB      24H                     ; 2DFB: INC H

L2DFC:
                DB      00H                     ; 2DFC: NOP
                DB      00H                     ; 2DFD: NOP
                DB      09H                     ; 2DFE: ADD HL,BC
                DB      46H                     ; 2DFF: LD B,(HL)
                DB      49H                     ; 2E00: LD C,C
                DB      4CH                     ; 2E01: LD C,H
                DB      45H                     ; 2E02: LD B,L
                DB      2DH                     ; 2E03: DEC L
                DB      4DH                     ; 2E04: LD C,L
                DB      4FH                     ; 2E05: LD C,A
                DB      44H                     ; 2E06: LD B,H
                DB      45H                     ; 2E07: LD B,L
                DB      24H                     ; 2E08: INC H
                DB      12H                     ; 2E09: LD (DE),A
                DB      12H                     ; 2E0A: LD (DE),A
                DB      03H                     ; 2E0B: INC BC
                DB      49H                     ; 2E0C: LD C,C
                DB      42H                     ; 2E0D: LD B,D
                DB      4DH                     ; 2E0E: LD C,L
                DB      24H                     ; 2E0F: INC H
                DB      03H                     ; 2E10: INC BC
                DB      03H                     ; 2E11: INC BC
                DB      0AH                     ; 2E12: LD A,(BC)
                DB      4CH                     ; 2E13: LD C,H
                DB      4FH                     ; 2E14: LD C,A
                DB      43H                     ; 2E15: LD B,E
                DB      41H                     ; 2E16: LD B,C
                DB      4CH                     ; 2E17: LD C,H
                DB      2DH                     ; 2E18: DEC L
                DB      45H                     ; 2E19: LD B,L
                DB      43H                     ; 2E1A: LD B,E
                DB      48H                     ; 2E1B: LD C,B
                DB      4FH                     ; 2E1C: LD C,A
                DB      24H                     ; 2E1D: INC H
                DB      06H,06H                 ; 2E1E: LD B,6
                DB      06H,50H                 ; 2E20: LD B,0x50
                DB      41H                     ; 2E22: LD B,C
                DB      52H                     ; 2E23: LD D,D
                DB      49H                     ; 2E24: LD C,C
                DB      54H                     ; 2E25: LD D,H
                DB      59H                     ; 2E26: LD E,C
                DB      24H                     ; 2E27: INC H
                DB      15H                     ; 2E28: DEC D
                DB      15H                     ; 2E29: DEC D
                DB      04H                     ; 2E2A: INC B
                DB      50H                     ; 2E2B: LD D,B
                DB      4FH                     ; 2E2C: LD C,A
                DB      52H                     ; 2E2D: LD D,D
                DB      54H                     ; 2E2E: LD D,H
                DB      24H                     ; 2E2F: INC H
                DB      1EH,1EH                 ; 2E30: LD E,0x1e
                DB      07H                     ; 2E32: RLCA
                DB      50H                     ; 2E33: LD D,B
                DB      52H                     ; 2E34: LD D,D
                DB      49H                     ; 2E35: LD C,C
                DB      4EH                     ; 2E36: LD C,(HL)
                DB      54H                     ; 2E37: LD D,H
                DB      45H                     ; 2E38: LD B,L
                DB      52H                     ; 2E39: LD D,D
                DB      24H                     ; 2E3A: INC H
                DB      27H                     ; 2E3B: DAA
                DB      27H                     ; 2E3C: DAA
                DB      05H                     ; 2E3D: DEC B
                DB      54H                     ; 2E3E: LD D,H
                DB      49H                     ; 2E3F: LD C,C
                DB      4DH                     ; 2E40: LD C,L
                DB      45H                     ; 2E41: LD B,L
                DB      52H                     ; 2E42: LD D,D
                DB      24H                     ; 2E43: INC H
                DB      2AH,2AH,0EH             ; 2E44: LD HL,(0x0e2a)
                DB      56H                     ; 2E47: LD D,(HL)
                DB      54H                     ; 2E48: LD D,H
                DB      35H                     ; 2E49: DEC (HL)
                DB      32H,2DH,45H             ; 2E4A: LD (0x452d),A
                DB      4DH                     ; 2E4D: LD C,L
                DB      55H                     ; 2E4E: LD D,L
                DB      4CH                     ; 2E4F: LD C,H
                DB      41H                     ; 2E50: LD B,C
                DB      54H                     ; 2E51: LD D,H
                DB      49H                     ; 2E52: LD C,C
                DB      4FH                     ; 2E53: LD C,A
                DB      4EH                     ; 2E54: LD C,(HL)
                DB      24H                     ; 2E55: INC H
                DB      1BH                     ; 2E56: DEC DE
                DB      1BH                     ; 2E57: DEC DE
                DB      07H                     ; 2E58: RLCA
                DB      57H                     ; 2E59: LD D,A
                DB      41H                     ; 2E5A: LD B,C
                DB      52H                     ; 2E5B: LD D,D
                DB      4EH                     ; 2E5C: LD C,(HL)
                DB      49H                     ; 2E5D: LD C,C
                DB      4EH                     ; 2E5E: LD C,(HL)
                DB      47H                     ; 2E5F: LD B,A
                DB      24H                     ; 2E60: INC H
                DB      0FH                     ; 2E61: RRCA
                DB      0FH                     ; 2E62: RRCA
                DB      02H                     ; 2E63: LD (BC),A
                DB      08H                     ; 2E64: EX AF,AF'
                DB      50H                     ; 2E65: LD D,B
                DB      41H                     ; 2E66: LD B,C
                DB      44H                     ; 2E67: LD B,H
                DB      2DH                     ; 2E68: DEC L
                DB      43H                     ; 2E69: LD B,E
                DB      48H                     ; 2E6A: LD C,B
                DB      41H                     ; 2E6B: LD B,C
                DB      52H                     ; 2E6C: LD D,D
                DB      24H                     ; 2E6D: INC H
                DB      00H                     ; 2E6E: NOP
                DB      00H                     ; 2E6F: NOP
                DB      07H                     ; 2E70: RLCA
                DB      50H                     ; 2E71: LD D,B
                DB      41H                     ; 2E72: LD B,C
                DB      44H                     ; 2E73: LD B,H
                DB      44H                     ; 2E74: LD B,H
                DB      49H                     ; 2E75: LD C,C
                DB      4EH                     ; 2E76: LD C,(HL)
                DB      47H                     ; 2E77: LD B,A
                DB      24H                     ; 2E78: INC H
                DB      03H                     ; 2E79: INC BC
                DB      03H                     ; 2E7A: INC BC
                DB      03H                     ; 2E7B: INC BC
                DB      14H                     ; 2E7C: INC D
                DB      31H,2DH,43H             ; 2E7D: LD SP,0x432d
                DB      48H                     ; 2E80: LD C,B
                DB      41H                     ; 2E81: LD B,C
                DB      52H                     ; 2E82: LD D,D
                DB      41H                     ; 2E83: LD B,C
                DB      43H                     ; 2E84: LD B,E
                DB      54H                     ; 2E85: LD D,H
                DB      45H                     ; 2E86: LD B,L
                DB      52H                     ; 2E87: LD D,D
                DB      2DH                     ; 2E88: DEC L
                DB      43H                     ; 2E89: LD B,E
                DB      48H                     ; 2E8A: LD C,B
                DB      45H                     ; 2E8B: LD B,L
                DB      43H                     ; 2E8C: LD B,E
                DB      4BH                     ; 2E8D: LD C,E
                DB      53H                     ; 2E8E: LD D,E
                DB      55H                     ; 2E8F: LD D,L
                DB      4DH                     ; 2E90: LD C,L
                DB      24H                     ; 2E91: INC H
                DB      31H,31H,14H             ; 2E92: LD SP,0x1431
                DB      32H,2DH,43H             ; 2E95: LD (0x432d),A
                DB      48H                     ; 2E98: LD C,B
                DB      41H                     ; 2E99: LD B,C
                DB      52H                     ; 2E9A: LD D,D
                DB      41H                     ; 2E9B: LD B,C
                DB      43H                     ; 2E9C: LD B,E
                DB      54H                     ; 2E9D: LD D,H
                DB      45H                     ; 2E9E: LD B,L
                DB      52H                     ; 2E9F: LD D,D
                DB      2DH                     ; 2EA0: DEC L
                DB      43H                     ; 2EA1: LD B,E
                DB      48H                     ; 2EA2: LD C,B
                DB      45H                     ; 2EA3: LD B,L
                DB      43H                     ; 2EA4: LD B,E
                DB      4BH                     ; 2EA5: LD C,E
                DB      53H                     ; 2EA6: LD D,E
                DB      55H                     ; 2EA7: LD D,L
                DB      4DH                     ; 2EA8: LD C,L
                DB      24H                     ; 2EA9: INC H
                DB      32H,32H,15H             ; 2EAA: LD (0x1532),A
                DB      33H                     ; 2EAD: INC SP
                DB      2DH                     ; 2EAE: DEC L
                DB      43H                     ; 2EAF: LD B,E
                DB      48H                     ; 2EB0: LD C,B
                DB      41H                     ; 2EB1: LD B,C
                DB      52H                     ; 2EB2: LD D,D
                DB      41H                     ; 2EB3: LD B,C
                DB      43H                     ; 2EB4: LD B,E
                DB      54H                     ; 2EB5: LD D,H
                DB      45H                     ; 2EB6: LD B,L
                DB      52H                     ; 2EB7: LD D,D
                DB      2DH                     ; 2EB8: DEC L
                DB      43H                     ; 2EB9: LD B,E
                DB      52H                     ; 2EBA: LD D,D
                DB      43H                     ; 2EBB: LD B,E
                DB      2DH                     ; 2EBC: DEC L
                DB      43H                     ; 2EBD: LD B,E
                DB      43H                     ; 2EBE: LD B,E
                DB      49H                     ; 2EBF: LD C,C
                DB      54H                     ; 2EC0: LD D,H
                DB      54H                     ; 2EC1: LD D,H
                DB      24H                     ; 2EC2: INC H
                DB      33H                     ; 2EC3: INC SP
                DB      33H                     ; 2EC4: INC SP
                DB      05H                     ; 2EC5: DEC B
                DB      04H                     ; 2EC6: INC B
                DB      45H                     ; 2EC7: LD B,L
                DB      56H                     ; 2EC8: LD D,(HL)
                DB      45H                     ; 2EC9: LD B,L
                DB      4EH                     ; 2ECA: LD C,(HL)
                DB      24H                     ; 2ECB: INC H
                DB      00H                     ; 2ECC: NOP
                DB      00H                     ; 2ECD: NOP
                DB      04H                     ; 2ECE: INC B
                DB      4DH                     ; 2ECF: LD C,L
                DB      41H                     ; 2ED0: LD B,C
                DB      52H                     ; 2ED1: LD D,D
                DB      4BH                     ; 2ED2: LD C,E
                DB      24H                     ; 2ED3: INC H
                DB      03H                     ; 2ED4: INC BC
                DB      03H                     ; 2ED5: INC BC
                DB      04H                     ; 2ED6: INC B
                DB      4EH                     ; 2ED7: LD C,(HL)
                DB      4FH                     ; 2ED8: LD C,A
                DB      4EH                     ; 2ED9: LD C,(HL)
                DB      45H                     ; 2EDA: LD B,L
                DB      24H                     ; 2EDB: INC H
                DB      06H,06H                 ; 2EDC: LD B,6
                DB      03H                     ; 2EDE: INC BC
                DB      4FH                     ; 2EDF: LD C,A
                DB      44H                     ; 2EE0: LD B,H
                DB      44H                     ; 2EE1: LD B,H
                DB      24H                     ; 2EE2: INC H
                DB      09H                     ; 2EE3: ADD HL,BC
                DB      09H                     ; 2EE4: ADD HL,BC
                DB      05H                     ; 2EE5: DEC B
                DB      53H                     ; 2EE6: LD D,E
                DB      50H                     ; 2EE7: LD D,B
                DB      41H                     ; 2EE8: LD B,C
                DB      43H                     ; 2EE9: LD B,E
                DB      45H                     ; 2EEA: LD B,L
                DB      24H                     ; 2EEB: INC H
                DB      0CH                     ; 2EEC: INC C
                DB      0CH                     ; 2EED: INC C
                DB      02H                     ; 2EEE: LD (BC),A
                DB      02H                     ; 2EEF: LD (BC),A
                DB      4FH                     ; 2EF0: LD C,A
                DB      4EH                     ; 2EF1: LD C,(HL)
                DB      24H                     ; 2EF2: INC H
                DB      01H,01H,03H             ; 2EF3: LD BC,0x301
                DB      4FH                     ; 2EF6: LD C,A
                DB      46H                     ; 2EF7: LD B,(HL)
                DB      46H                     ; 2EF8: LD B,(HL)
                DB      24H                     ; 2EF9: INC H
                DB      00H                     ; 2EFA: NOP
                DB      00H                     ; 2EFB: NOP
                DB      03H                     ; 2EFC: INC BC
                DB      05H                     ; 2EFD: DEC B
                DB      41H                     ; 2EFE: LD B,C
                DB      53H                     ; 2EFF: LD D,E
                DB      43H                     ; 2F00: LD B,E
                DB      49H                     ; 2F01: LD C,C
                DB      49H                     ; 2F02: LD C,C
                DB      24H                     ; 2F03: INC H
                DB      01H,01H,06H             ; 2F04: LD BC,0x601
                DB      42H                     ; 2F07: LD B,D
                DB      49H                     ; 2F08: LD C,C
                DB      4EH                     ; 2F09: LD C,(HL)
                DB      41H                     ; 2F0A: LD B,C
                DB      52H                     ; 2F0B: LD D,D
                DB      59H                     ; 2F0C: LD E,C
                DB      24H                     ; 2F0D: INC H
                DB      02H                     ; 2F0E: LD (BC),A
                DB      02H                     ; 2F0F: LD (BC),A
                DB      07H                     ; 2F10: RLCA
                DB      44H                     ; 2F11: LD B,H
                DB      45H                     ; 2F12: LD B,L
                DB      46H                     ; 2F13: LD B,(HL)
                DB      41H                     ; 2F14: LD B,C
                DB      55H                     ; 2F15: LD D,L
                DB      4CH                     ; 2F16: LD C,H
                DB      54H                     ; 2F17: LD D,H
                DB      24H                     ; 2F18: INC H
                DB      00H                     ; 2F19: NOP
                DB      00H                     ; 2F1A: NOP
                DB      02H                     ; 2F1B: LD (BC),A
                DB      02H                     ; 2F1C: LD (BC),A
                DB      4EH                     ; 2F1D: LD C,(HL)
                DB      4FH                     ; 2F1E: LD C,A
                DB      24H                     ; 2F1F: INC H
                DB      00H                     ; 2F20: NOP
                DB      00H                     ; 2F21: NOP
                DB      03H                     ; 2F22: INC BC
                DB      59H                     ; 2F23: LD E,C
                DB      45H                     ; 2F24: LD B,L
                DB      53H                     ; 2F25: LD D,E
                DB      24H                     ; 2F26: INC H
                DB      01H,01H,0DH             ; 2F27: LD BC,0xd01
                DB      0AH                     ; 2F2A: LD A,(BC)
                DB      3FH                     ; 2F2B: CCF
                DB      50H                     ; 2F2C: LD D,B
                DB      72H                     ; 2F2D: LD (HL),D
                DB      6FH                     ; 2F2E: LD L,A
                DB      67H                     ; 2F2F: LD H,A
                DB      72H                     ; 2F30: LD (HL),D
                DB      61H                     ; 2F31: LD H,C
                DB      6DH                     ; 2F32: LD L,L
                DB      20H,65H                 ; 2F33: JR nz,L2F9A
                DB      72H                     ; 2F35: LD (HL),D
                DB      72H                     ; 2F36: LD (HL),D
                DB      6FH                     ; 2F37: LD L,A
                DB      72H                     ; 2F38: LD (HL),D
                DB      3AH,20H,20H             ; 2F39: LD A,(0x2020)
                DB      49H                     ; 2F3C: LD C,C
                DB      6EH                     ; 2F3D: LD L,(HL)
                DB      76H                     ; 2F3E: HALT
                DB      61H                     ; 2F3F: LD H,C
                DB      6CH                     ; 2F40: LD L,H
                DB      69H                     ; 2F41: LD L,C
                DB      64H                     ; 2F42: LD H,H
                DB      20H,43H                 ; 2F43: JR nz,L2F88
                DB      4FH                     ; 2F45: LD C,A
                DB      4DH                     ; 2F46: LD C,L
                DB      4EH                     ; 2F47: LD C,(HL)
                DB      44H                     ; 2F48: LD B,H
                DB      20H,63H                 ; 2F49: JR nz,L2FAE
                DB      61H                     ; 2F4B: LD H,C
                DB      6CH                     ; 2F4C: LD L,H
                DB      6CH                     ; 2F4D: LD L,H
                DB      24H                     ; 2F4E: INC H
                DB      0DH                     ; 2F4F: DEC C
                DB      0AH                     ; 2F50: LD A,(BC)
                DB      3FH                     ; 2F51: CCF
                DB      41H                     ; 2F52: LD B,C
                DB      6DH                     ; 2F53: LD L,L
                DB      62H                     ; 2F54: LD H,D
                DB      69H                     ; 2F55: LD L,C
                DB      67H                     ; 2F56: LD H,A
                DB      75H                     ; 2F57: LD (HL),L
                DB      6FH                     ; 2F58: LD L,A
                DB      75H                     ; 2F59: LD (HL),L
                DB      73H                     ; 2F5A: LD (HL),E
                DB      24H                     ; 2F5B: INC H
                DB      0DH                     ; 2F5C: DEC C
                DB      0AH                     ; 2F5D: LD A,(BC)
                DB      3FH                     ; 2F5E: CCF
                DB      49H                     ; 2F5F: LD C,C
                DB      6CH                     ; 2F60: LD L,H
                DB      6CH                     ; 2F61: LD L,H
                DB      65H                     ; 2F62: LD H,L
                DB      67H                     ; 2F63: LD H,A
                DB      61H                     ; 2F64: LD H,C
                DB      6CH                     ; 2F65: LD L,H
                DB      20H,43H                 ; 2F66: JR nz,L2FAB
                DB      50H                     ; 2F68: LD D,B
                DB      2FH                     ; 2F69: CPL
                DB      4DH                     ; 2F6A: LD C,L
                DB      20H,66H                 ; 2F6B: JR nz,L2FD3
                DB      69H                     ; 2F6D: LD L,C
                DB      6CH                     ; 2F6E: LD L,H
                DB      65H                     ; 2F6F: LD H,L
                DB      20H,73H                 ; 2F70: JR nz,L2FE5
                DB      70H                     ; 2F72: LD (HL),B
                DB      65H                     ; 2F73: LD H,L
                DB      63H                     ; 2F74: LD H,E
                DB      69H                     ; 2F75: LD L,C
                DB      66H                     ; 2F76: LD H,(HL)
                DB      69H                     ; 2F77: LD L,C
                DB      63H                     ; 2F78: LD H,E
                DB      61H                     ; 2F79: LD H,C
                DB      74H                     ; 2F7A: LD (HL),H
                DB      69H                     ; 2F7B: LD L,C
                DB      6FH                     ; 2F7C: LD L,A
                DB      6EH                     ; 2F7D: LD L,(HL)
                DB      24H                     ; 2F7E: INC H
                DB      0DH                     ; 2F7F: DEC C
                DB      0AH                     ; 2F80: LD A,(BC)
                DB      3FH                     ; 2F81: CCF
                DB      22H,2AH,22H             ; 2F82: LD (0x222a),HL
                DB      20H,6EH                 ; 2F85: JR nz,L2FF5
                DB      6FH                     ; 2F87: LD L,A

L2F88:
                DB      74H                     ; 2F88: LD (HL),H
                DB      20H,61H                 ; 2F89: JR nz,L2FEC
                DB      6CH                     ; 2F8B: LD L,H
                DB      6CH                     ; 2F8C: LD L,H
                DB      6FH                     ; 2F8D: LD L,A
                DB      77H                     ; 2F8E: LD (HL),A
                DB      65H                     ; 2F8F: LD H,L
                DB      64H                     ; 2F90: LD H,H
                DB      20H,69H                 ; 2F91: JR nz,L2FFC
                DB      6EH                     ; 2F93: LD L,(HL)
                DB      20H,66H                 ; 2F94: JR nz,L2FFC
                DB      69H                     ; 2F96: LD L,C
                DB      6CH                     ; 2F97: LD L,H
                DB      65H                     ; 2F98: LD H,L
                DB      20H,73H                 ; 2F99: JR nz,L300E
                DB      70H                     ; 2F9B: LD (HL),B
                DB      65H                     ; 2F9C: LD H,L
                DB      63H                     ; 2F9D: LD H,E
                DB      69H                     ; 2F9E: LD L,C
                DB      66H                     ; 2F9F: LD H,(HL)
                DB      69H                     ; 2FA0: LD L,C
                DB      63H                     ; 2FA1: LD H,E
                DB      61H                     ; 2FA2: LD H,C
                DB      74H                     ; 2FA3: LD (HL),H
                DB      69H                     ; 2FA4: LD L,C
                DB      6FH                     ; 2FA5: LD L,A
                DB      6EH                     ; 2FA6: LD L,(HL)
                DB      24H                     ; 2FA7: INC H
                DB      20H,43H                 ; 2FA8: JR nz,L2FED
                DB      6FH                     ; 2FAA: LD L,A

L2FAB:
                DB      6EH                     ; 2FAB: LD L,(HL)
                DB      66H                     ; 2FAC: LD H,(HL)
                DB      69H                     ; 2FAD: LD L,C

L2FAE:
                DB      72H                     ; 2FAE: LD (HL),D
                DB      6DH                     ; 2FAF: LD L,L
                DB      20H,77H                 ; 2FB0: JR nz,L3029
                DB      69H                     ; 2FB2: LD L,C
                DB      74H                     ; 2FB3: LD (HL),H
                DB      68H                     ; 2FB4: LD L,B
                DB      20H,63H                 ; 2FB5: JR nz,L301A
                DB      61H                     ; 2FB7: LD H,C
                DB      72H                     ; 2FB8: LD (HL),D
                DB      72H                     ; 2FB9: LD (HL),D
                DB      69H                     ; 2FBA: LD L,C
                DB      61H                     ; 2FBB: LD H,C
                DB      67H                     ; 2FBC: LD H,A
                DB      65H                     ; 2FBD: LD H,L
                DB      20H,72H                 ; 2FBE: JR nz,L3032
                DB      65H                     ; 2FC0: LD H,L
                DB      74H                     ; 2FC1: LD (HL),H
                DB      75H                     ; 2FC2: LD (HL),L
                DB      72H                     ; 2FC3: LD (HL),D
                DB      6EH                     ; 2FC4: LD L,(HL)
                DB      24H                     ; 2FC5: INC H
                DB      0DH                     ; 2FC6: DEC C
                DB      0AH                     ; 2FC7: LD A,(BC)
                DB      24H                     ; 2FC8: INC H
                DB      10H,03H                 ; 2FC9: DJNZ L2FCE
                DB      31H,31H,30H             ; 2FCB: LD SP,0x3031

L2FCE:
                DB      24H                     ; 2FCE: INC H
                DB      02H                     ; 2FCF: LD (BC),A
                DB      02H                     ; 2FD0: LD (BC),A
                DB      04H                     ; 2FD1: INC B
                DB      31H,32H,30H             ; 2FD2: LD SP,L3032
                DB      30H,24H                 ; 2FD5: JR nc,L2FFB
                DB      07H                     ; 2FD7: RLCA
                DB      07H                     ; 2FD8: RLCA
                DB      05H                     ; 2FD9: DEC B
                DB      31H,33H,34H             ; 2FDA: LD SP,0x3433
                DB      2EH,35H                 ; 2FDD: LD L,0x35
                DB      24H                     ; 2FDF: INC H
                DB      03H                     ; 2FE0: INC BC
                DB      03H                     ; 2FE1: INC BC
                DB      03H                     ; 2FE2: INC BC
                DB      31H,35H,30H             ; 2FE3: LD SP,0x3035
                DB      24H                     ; 2FE6: INC H
                DB      04H                     ; 2FE7: INC B
                DB      04H                     ; 2FE8: INC B
                DB      04H                     ; 2FE9: INC B
                DB      31H,38H,30H             ; 2FEA: LD SP,0x3038

L2FED:
                DB      30H,24H                 ; 2FED: JR nc,L3013
                DB      08H                     ; 2FEF: EX AF,AF'
                DB      08H                     ; 2FF0: EX AF,AF'
                DB      05H                     ; 2FF1: DEC B
                DB      31H,39H,32H             ; 2FF2: LD SP,0x3239

L2FF5:
                DB      30H,30H                 ; 2FF5: JR nc,L3027
                DB      24H                     ; 2FF7: INC H
                DB      0FH                     ; 2FF8: RRCA
                DB      0FH                     ; 2FF9: RRCA
                DB      04H                     ; 2FFA: INC B

L2FFB:
                DB      32H,30H,30H             ; 2FFB: LD (0x3030),A
                DB      30H,24H                 ; 2FFE: JR nc,L3024
                DB      09H                     ; 3000: ADD HL,BC
                DB      09H                     ; 3001: ADD HL,BC
                DB      04H                     ; 3002: INC B
                DB      32H,34H,30H             ; 3003: LD (0x3034),A
                DB      30H,24H                 ; 3006: JR nc,L302C
                DB      0AH                     ; 3008: LD A,(BC)
                DB      0AH                     ; 3009: LD A,(BC)
                DB      03H                     ; 300A: INC BC
                DB      33H                     ; 300B: INC SP
                DB      30H,30H                 ; 300C: JR nc,L303E

L300E:
                DB      24H                     ; 300E: INC H
                DB      05H                     ; 300F: DEC B
                DB      05H                     ; 3010: DEC B
                DB      04H                     ; 3011: INC B
                DB      33H                     ; 3012: INC SP

L3013:
                DB      36H,30H                 ; 3013: LD (HL),0x30
                DB      30H,24H                 ; 3015: JR nc,L303B
                DB      0BH                     ; 3017: DEC BC
                DB      0BH                     ; 3018: DEC BC
                DB      04H                     ; 3019: INC B

L301A:
                DB      34H                     ; 301A: INC (HL)
                DB      38H,30H                 ; 301B: JR c,L304D
                DB      30H,24H                 ; 301D: JR nc,L3043
                DB      0CH                     ; 301F: INC C
                DB      0CH                     ; 3020: INC C
                DB      02H                     ; 3021: LD (BC),A
                DB      35H                     ; 3022: DEC (HL)
                DB      30H,24H                 ; 3023: JR nc,L3049
                DB      00H                     ; 3025: NOP
                DB      00H                     ; 3026: NOP

L3027:
                DB      03H                     ; 3027: INC BC
                DB      36H,30H                 ; 3028: LD (HL),0x30
                DB      30H,24H                 ; 302A: JR nc,L3050

L302C:
                DB      06H,06H                 ; 302C: LD B,6
                DB      04H                     ; 302E: INC B
                DB      37H                     ; 302F: SCF
                DB      32H,30H,30H             ; 3030: LD (0x3030),A
                DB      24H                     ; 3033: INC H
                DB      0DH                     ; 3034: DEC C
                DB      0DH                     ; 3035: DEC C
                DB      02H                     ; 3036: LD (BC),A
                DB      37H                     ; 3037: SCF
                DB      35H                     ; 3038: DEC (HL)
                DB      24H                     ; 3039: INC H
                DB      01H,01H,04H             ; 303A: LD BC,0x401
                DB      39H                     ; 303D: ADD HL,SP

L303E:
                DB      36H,30H                 ; 303E: LD (HL),0x30
                DB      30H,24H                 ; 3040: JR nc,L3066
                DB      0EH,0EH                 ; 3042: LD C,14
                DB      43H                     ; 3044: LD B,E
                DB      4FH                     ; 3045: LD C,A
                DB      4DH                     ; 3046: LD C,L
                DB      4EH                     ; 3047: LD C,(HL)
                DB      44H                     ; 3048: LD B,H

L3049:
                DB      20H,63H                 ; 3049: JR nz,L30AE
                DB      61H                     ; 304B: LD H,C
                DB      6CH                     ; 304C: LD L,H

L304D:
                DB      6CH                     ; 304D: LD L,H
                DB      24H                     ; 304E: INC H
                DB      0DH                     ; 304F: DEC C

L3050:
                DB      0AH                     ; 3050: LD A,(BC)
                DB      3FH                     ; 3051: CCF
                DB      41H                     ; 3052: LD B,C
                DB      6DH                     ; 3053: LD L,L
                DB      62H                     ; 3054: LD H,D
                DB      69H                     ; 3055: LD L,C
                DB      67H                     ; 3056: LD H,A
                DB      75H                     ; 3057: LD (HL),L
                DB      6FH                     ; 3058: LD L,A
                DB      75H                     ; 3059: LD (HL),L
                DB      73H                     ; 305A: LD (HL),E
                DB      24H                     ; 305B: INC H
                DB      0DH                     ; 305C: DEC C
                DB      0AH                     ; 305D: LD A,(BC)
                DB      3FH                     ; 305E: CCF
                DB      49H                     ; 305F: LD C,C
                DB      6CH                     ; 3060: LD L,H
                DB      6CH                     ; 3061: LD L,H
                DB      65H                     ; 3062: LD H,L
                DB      67H                     ; 3063: LD H,A
                DB      61H                     ; 3064: LD H,C
                DB      6CH                     ; 3065: LD L,H

L3066:
                DB      20H,43H                 ; 3066: JR nz,L30AB
                DB      50H                     ; 3068: LD D,B
                DB      2FH                     ; 3069: CPL
                DB      4DH                     ; 306A: LD C,L
                DB      20H,66H                 ; 306B: JR nz,L30D3
                DB      69H                     ; 306D: LD L,C
                DB      6CH                     ; 306E: LD L,H
                DB      65H                     ; 306F: LD H,L
                DB      20H,73H                 ; 3070: JR nz,L30E5
                DB      70H                     ; 3072: LD (HL),B
                DB      65H                     ; 3073: LD H,L
                DB      63H                     ; 3074: LD H,E
                DB      69H                     ; 3075: LD L,C
                DB      66H                     ; 3076: LD H,(HL)
                DB      69H                     ; 3077: LD L,C
                DB      63H                     ; 3078: LD H,E
                DB      61H                     ; 3079: LD H,C
                DB      74H                     ; 307A: LD (HL),H
                DB      69H                     ; 307B: LD L,C
                DB      6FH                     ; 307C: LD L,A
                DB      6EH                     ; 307D: LD L,(HL)
                DB      24H                     ; 307E: INC H
                DB      0DH                     ; 307F: DEC C
                DB      0AH                     ; 3080: LD A,(BC)
                DB      3FH                     ; 3081: CCF
                DB      22H,2AH,22H             ; 3082: LD (0x222a),HL
                DB      20H,6EH                 ; 3085: JR nz,L30F5
                DB      6FH                     ; 3087: LD L,A
                DB      74H                     ; 3088: LD (HL),H
                DB      20H,61H                 ; 3089: JR nz,L30EC
                DB      6CH                     ; 308B: LD L,H
                DB      6CH                     ; 308C: LD L,H
                DB      6FH                     ; 308D: LD L,A
                DB      77H                     ; 308E: LD (HL),A
                DB      65H                     ; 308F: LD H,L
                DB      64H                     ; 3090: LD H,H
                DB      20H,69H                 ; 3091: JR nz,L30FC
                DB      6EH                     ; 3093: LD L,(HL)
                DB      20H,66H                 ; 3094: JR nz,L30FC
                DB      69H                     ; 3096: LD L,C
                DB      6CH                     ; 3097: LD L,H
                DB      65H                     ; 3098: LD H,L
                DB      20H,73H                 ; 3099: JR nz,L310E
                DB      70H                     ; 309B: LD (HL),B
                DB      65H                     ; 309C: LD H,L
                DB      63H                     ; 309D: LD H,E
                DB      69H                     ; 309E: LD L,C
                DB      66H                     ; 309F: LD H,(HL)
                DB      69H                     ; 30A0: LD L,C
                DB      63H                     ; 30A1: LD H,E
                DB      61H                     ; 30A2: LD H,C
                DB      74H                     ; 30A3: LD (HL),H
                DB      69H                     ; 30A4: LD L,C
                DB      6FH                     ; 30A5: LD L,A
                DB      6EH                     ; 30A6: LD L,(HL)
                DB      24H                     ; 30A7: INC H
                DB      20H,43H                 ; 30A8: JR nz,L30ED
                DB      6FH                     ; 30AA: LD L,A

L30AB:
                DB      6EH                     ; 30AB: LD L,(HL)
                DB      66H                     ; 30AC: LD H,(HL)
                DB      69H                     ; 30AD: LD L,C

L30AE:
                DB      72H                     ; 30AE: LD (HL),D
                DB      6DH                     ; 30AF: LD L,L
                DB      20H,77H                 ; 30B0: JR nz,L3129
                DB      69H                     ; 30B2: LD L,C
                DB      74H                     ; 30B3: LD (HL),H
                DB      68H                     ; 30B4: LD L,B
                DB      20H,63H                 ; 30B5: JR nz,L311A
                DB      61H                     ; 30B7: LD H,C
                DB      72H                     ; 30B8: LD (HL),D
                DB      72H                     ; 30B9: LD (HL),D
                DB      69H                     ; 30BA: LD L,C
                DB      61H                     ; 30BB: LD H,C
                DB      67H                     ; 30BC: LD H,A
                DB      65H                     ; 30BD: LD H,L
                DB      20H,72H                 ; 30BE: JR nz,L3132
                DB      65H                     ; 30C0: LD H,L
                DB      74H                     ; 30C1: LD (HL),H
                DB      75H                     ; 30C2: LD (HL),L
                DB      72H                     ; 30C3: LD (HL),D
                DB      6EH                     ; 30C4: LD L,(HL)
                DB      24H                     ; 30C5: INC H
                DB      0DH                     ; 30C6: DEC C
                DB      0AH                     ; 30C7: LD A,(BC)
                DB      24H                     ; 30C8: INC H
                DB      10H,03H                 ; 30C9: DJNZ L30CE
                DB      31H,31H,30H             ; 30CB: LD SP,0x3031

L30CE:
                DB      24H                     ; 30CE: INC H
                DB      02H                     ; 30CF: LD (BC),A
                DB      02H                     ; 30D0: LD (BC),A
                DB      04H                     ; 30D1: INC B
                DB      31H,32H,30H             ; 30D2: LD SP,L3032
                DB      30H,24H                 ; 30D5: JR nc,L30FB
                DB      07H                     ; 30D7: RLCA
                DB      07H                     ; 30D8: RLCA
                DB      05H                     ; 30D9: DEC B
                DB      31H,33H,34H             ; 30DA: LD SP,0x3433
                DB      2EH,35H                 ; 30DD: LD L,0x35
                DB      24H                     ; 30DF: INC H
                DB      03H                     ; 30E0: INC BC
                DB      03H                     ; 30E1: INC BC
                DB      03H                     ; 30E2: INC BC
                DB      31H,35H,30H             ; 30E3: LD SP,0x3035
                DB      24H                     ; 30E6: INC H
                DB      04H                     ; 30E7: INC B
                DB      04H                     ; 30E8: INC B
                DB      04H                     ; 30E9: INC B
                DB      31H,38H,30H             ; 30EA: LD SP,0x3038

L30ED:
                DB      30H,24H                 ; 30ED: JR nc,L3113
                DB      08H                     ; 30EF: EX AF,AF'
                DB      08H                     ; 30F0: EX AF,AF'
                DB      05H                     ; 30F1: DEC B
                DB      31H,39H,32H             ; 30F2: LD SP,0x3239

L30F5:
                DB      30H,30H                 ; 30F5: JR nc,L3127
                DB      24H                     ; 30F7: INC H
                DB      0FH                     ; 30F8: RRCA
                DB      0FH                     ; 30F9: RRCA
                DB      04H                     ; 30FA: INC B

L30FB:
                DB      32H,30H,30H             ; 30FB: LD (0x3030),A
                DB      30H,24H                 ; 30FE: JR nc,L3124
                DB      09H                     ; 3100: ADD HL,BC
                DB      09H                     ; 3101: ADD HL,BC
                DB      04H                     ; 3102: INC B
                DB      32H,34H,30H             ; 3103: LD (0x3034),A
                DB      30H,24H                 ; 3106: JR nc,L312C
                DB      0AH                     ; 3108: LD A,(BC)
                DB      0AH                     ; 3109: LD A,(BC)
                DB      03H                     ; 310A: INC BC
                DB      33H                     ; 310B: INC SP
                DB      30H,30H                 ; 310C: JR nc,L313E

L310E:
                DB      24H                     ; 310E: INC H
                DB      05H                     ; 310F: DEC B
                DB      05H                     ; 3110: DEC B
                DB      04H                     ; 3111: INC B
                DB      33H                     ; 3112: INC SP

L3113:
                DB      36H,30H                 ; 3113: LD (HL),0x30
                DB      30H,24H                 ; 3115: JR nc,L313B
                DB      0BH                     ; 3117: DEC BC
                DB      0BH                     ; 3118: DEC BC
                DB      04H                     ; 3119: INC B

L311A:
                DB      34H                     ; 311A: INC (HL)
                DB      38H,30H                 ; 311B: JR c,L314D
                DB      30H,24H                 ; 311D: JR nc,L3143
                DB      0CH                     ; 311F: INC C
                DB      0CH                     ; 3120: INC C
                DB      02H                     ; 3121: LD (BC),A
                DB      35H                     ; 3122: DEC (HL)
                DB      30H,24H                 ; 3123: JR nc,L3149
                DB      00H                     ; 3125: NOP
                DB      00H                     ; 3126: NOP

L3127:
                DB      00H                     ; 3127: NOP
                DB      00H                     ; 3128: NOP

L3129:
                DB      00H                     ; 3129: NOP
                DB      00H                     ; 312A: NOP
                DB      26H,00H                 ; 312B: LD H,0
                DB      00H                     ; 312D: NOP
                DB      00H                     ; 312E: NOP
                DB      00H                     ; 312F: NOP
                DB      01H,01H,00H             ; 3130: LD BC,1
                DB      01H,06H,1CH             ; 3133: LD BC,0x1c06
                DB      00H                     ; 3136: NOP
                DB      00H                     ; 3137: NOP
                DB      35H                     ; 3138: DEC (HL)
                DB      24H                     ; 3139: INC H
                DB      01H,01H,04H             ; 313A: LD BC,0x401
                DB      39H                     ; 313D: ADD HL,SP

L313E:
                DB      36H,30H                 ; 313E: LD (HL),0x30
                DB      30H,24H                 ; 3140: JR nc,L3166
                DB      0EH,0EH                 ; 3142: LD C,14
                DB      43H                     ; 3144: LD B,E
                DB      4FH                     ; 3145: LD C,A
                DB      4DH                     ; 3146: LD C,L
                DB      4EH                     ; 3147: LD C,(HL)
                DB      44H                     ; 3148: LD B,H

L3149:
                DB      20H,5EH                 ; 3149: JR nz,L31A9
                DB      08H                     ; 314B: EX AF,AF'
                DB      05H                     ; 314C: DEC B

L314D:
                DB      00H                     ; 314D: NOP
                DB      00H                     ; 314E: NOP
                DB      00H                     ; 314F: NOP
                DB      00H                     ; 3150: NOP
                DB      0DH                     ; 3151: DEC C
                DB      0DH                     ; 3152: DEC C
                DB      23H                     ; 3153: INC HL
                DB      23H                     ; 3154: INC HL
                DB      31H,31H,31H             ; 3155: LD SP,0x3131
                DB      6FH                     ; 3158: LD L,A
                DB      75H                     ; 3159: LD (HL),L
                DB      73H                     ; 315A: LD (HL),E
                DB      24H                     ; 315B: INC H
                DB      0DH                     ; 315C: DEC C
                DB      0AH                     ; 315D: LD A,(BC)
                DB      3FH                     ; 315E: CCF
                DB      49H                     ; 315F: LD C,C
                DB      6CH                     ; 3160: LD L,H
                DB      6CH                     ; 3161: LD L,H
                DB      65H                     ; 3162: LD H,L
                DB      67H                     ; 3163: LD H,A
                DB      61H                     ; 3164: LD H,C
                DB      6CH                     ; 3165: LD L,H

L3166:
                DB      20H,43H                 ; 3166: JR nz,L31AB
                DB      50H                     ; 3168: LD D,B
                DB      2FH                     ; 3169: CPL
                DB      4DH                     ; 316A: LD C,L
                DB      20H,66H                 ; 316B: JR nz,L31D3
                DB      69H                     ; 316D: LD L,C
                DB      6CH                     ; 316E: LD L,H
                DB      65H                     ; 316F: LD H,L
                DB      20H,73H                 ; 3170: JR nz,L31E5
                DB      70H                     ; 3172: LD (HL),B
                DB      65H                     ; 3173: LD H,L
                DB      63H                     ; 3174: LD H,E
                DB      69H                     ; 3175: LD L,C
                DB      66H                     ; 3176: LD H,(HL)
                DB      69H                     ; 3177: LD L,C
                DB      63H                     ; 3178: LD H,E
                DB      61H                     ; 3179: LD H,C
                DB      74H                     ; 317A: LD (HL),H
                DB      69H                     ; 317B: LD L,C
                DB      6FH                     ; 317C: LD L,A
                DB      6EH                     ; 317D: LD L,(HL)
                DB      24H                     ; 317E: INC H
                DB      0DH                     ; 317F: DEC C
                DB      0AH                     ; 3180: LD A,(BC)
                DB      3FH                     ; 3181: CCF
                DB      22H,2AH,22H             ; 3182: LD (0x222a),HL
                DB      20H,6EH                 ; 3185: JR nz,L31F5
                DB      6FH                     ; 3187: LD L,A
                DB      74H                     ; 3188: LD (HL),H
                DB      20H,61H                 ; 3189: JR nz,L31EC
                DB      6CH                     ; 318B: LD L,H
                DB      6CH                     ; 318C: LD L,H
                DB      6FH                     ; 318D: LD L,A
                DB      77H                     ; 318E: LD (HL),A
                DB      65H                     ; 318F: LD H,L
                DB      64H                     ; 3190: LD H,H
                DB      20H,69H                 ; 3191: JR nz,L31FC
                DB      6EH                     ; 3193: LD L,(HL)
                DB      20H,66H                 ; 3194: JR nz,L31FC
                DB      69H                     ; 3196: LD L,C
                DB      6CH                     ; 3197: LD L,H
                DB      65H                     ; 3198: LD H,L
                DB      20H,73H                 ; 3199: JR nz,L320E
                DB      70H                     ; 319B: LD (HL),B
                DB      65H                     ; 319C: LD H,L
                DB      63H                     ; 319D: LD H,E
                DB      69H                     ; 319E: LD L,C
                DB      66H                     ; 319F: LD H,(HL)
                DB      69H                     ; 31A0: LD L,C
                DB      63H                     ; 31A1: LD H,E
                DB      61H                     ; 31A2: LD H,C
                DB      74H                     ; 31A3: LD (HL),H
                DB      69H                     ; 31A4: LD L,C
                DB      6FH                     ; 31A5: LD L,A
                DB      6EH                     ; 31A6: LD L,(HL)
                DB      24H                     ; 31A7: INC H
                DB      20H,43H                 ; 31A8: JR nz,L31ED
                DB      6FH                     ; 31AA: LD L,A

L31AB:
                DB      6EH                     ; 31AB: LD L,(HL)
                DB      66H                     ; 31AC: LD H,(HL)
                DB      69H                     ; 31AD: LD L,C
                DB      72H                     ; 31AE: LD (HL),D
                DB      6DH                     ; 31AF: LD L,L
                DB      20H,77H                 ; 31B0: JR nz,L3229
                DB      69H                     ; 31B2: LD L,C
                DB      74H                     ; 31B3: LD (HL),H
                DB      68H                     ; 31B4: LD L,B
                DB      20H,63H                 ; 31B5: JR nz,L321A
                DB      61H                     ; 31B7: LD H,C
                DB      72H                     ; 31B8: LD (HL),D
                DB      72H                     ; 31B9: LD (HL),D
                DB      69H                     ; 31BA: LD L,C
                DB      61H                     ; 31BB: LD H,C
                DB      67H                     ; 31BC: LD H,A
                DB      65H                     ; 31BD: LD H,L
                DB      20H,72H                 ; 31BE: JR nz,L3232
                DB      65H                     ; 31C0: LD H,L
                DB      74H                     ; 31C1: LD (HL),H
                DB      75H                     ; 31C2: LD (HL),L
                DB      72H                     ; 31C3: LD (HL),D
                DB      6EH                     ; 31C4: LD L,(HL)
                DB      24H                     ; 31C5: INC H
                DB      0DH                     ; 31C6: DEC C
                DB      0AH                     ; 31C7: LD A,(BC)
                DB      24H                     ; 31C8: INC H
                DB      10H,03H                 ; 31C9: DJNZ L31CE
                DB      31H,31H,30H             ; 31CB: LD SP,0x3031

L31CE:
                DB      24H                     ; 31CE: INC H
                DB      02H                     ; 31CF: LD (BC),A
                DB      02H                     ; 31D0: LD (BC),A
                DB      04H                     ; 31D1: INC B
                DB      31H,32H,30H             ; 31D2: LD SP,L3032
                DB      30H,24H                 ; 31D5: JR nc,L31FB
                DB      07H                     ; 31D7: RLCA
                DB      07H                     ; 31D8: RLCA
                DB      05H                     ; 31D9: DEC B
                DB      31H,33H,34H             ; 31DA: LD SP,0x3433
                DB      2EH,35H                 ; 31DD: LD L,0x35
                DB      24H                     ; 31DF: INC H
                DB      03H                     ; 31E0: INC BC
                DB      03H                     ; 31E1: INC BC
                DB      03H                     ; 31E2: INC BC
                DB      31H,35H,30H             ; 31E3: LD SP,0x3035
                DB      24H                     ; 31E6: INC H
                DB      04H                     ; 31E7: INC B
                DB      04H                     ; 31E8: INC B
                DB      04H                     ; 31E9: INC B
                DB      31H,38H,30H             ; 31EA: LD SP,0x3038

L31ED:
                DB      30H,24H                 ; 31ED: JR nc,L3213
                DB      08H                     ; 31EF: EX AF,AF'
                DB      08H                     ; 31F0: EX AF,AF'
                DB      05H                     ; 31F1: DEC B
                DB      31H,39H,32H             ; 31F2: LD SP,0x3239

L31F5:
                DB      30H,30H                 ; 31F5: JR nc,L3227
                DB      24H                     ; 31F7: INC H
                DB      0FH                     ; 31F8: RRCA
                DB      0FH                     ; 31F9: RRCA
                DB      04H                     ; 31FA: INC B

L31FB:
                DB      32H,30H,30H             ; 31FB: LD (0x3030),A
                DB      30H,24H                 ; 31FE: JR nc,L3224
                DB      09H                     ; 3200: ADD HL,BC
                DB      09H                     ; 3201: ADD HL,BC
                DB      04H                     ; 3202: INC B
                DB      32H,34H,30H             ; 3203: LD (0x3034),A
                DB      30H,24H                 ; 3206: JR nc,L322C
                DB      0AH                     ; 3208: LD A,(BC)
                DB      0AH                     ; 3209: LD A,(BC)
                DB      03H                     ; 320A: INC BC
                DB      33H                     ; 320B: INC SP
                DB      30H,30H                 ; 320C: JR nc,L323E

L320E:
                DB      24H                     ; 320E: INC H
                DB      05H                     ; 320F: DEC B
                DB      05H                     ; 3210: DEC B
                DB      04H                     ; 3211: INC B
                DB      33H                     ; 3212: INC SP

L3213:
                DB      36H,30H                 ; 3213: LD (HL),0x30
                DB      30H,24H                 ; 3215: JR nc,L323B
                DB      0BH                     ; 3217: DEC BC
                DB      0BH                     ; 3218: DEC BC
                DB      04H                     ; 3219: INC B

L321A:
                DB      34H                     ; 321A: INC (HL)
                DB      38H,30H                 ; 321B: JR c,L324D
                DB      30H,24H                 ; 321D: JR nc,L3243
                DB      0CH                     ; 321F: INC C
                DB      0CH                     ; 3220: INC C
                DB      02H                     ; 3221: LD (BC),A
                DB      35H                     ; 3222: DEC (HL)
                DB      30H,0DH                 ; 3223: JR nc,L3232
                DB      24H                     ; 3225: INC H
                DB      00H                     ; 3226: NOP

L3227:
                DB      00H                     ; 3227: NOP
                DB      00H                     ; 3228: NOP

L3229:
                DB      00H                     ; 3229: NOP
                DB      00H                     ; 322A: NOP
                DB      26H,00H                 ; 322B: LD H,0
                DB      00H                     ; 322D: NOP
                DB      00H                     ; 322E: NOP
                DB      00H                     ; 322F: NOP
                DB      01H,01H,00H             ; 3230: LD BC,1
                DB      01H,06H,1CH             ; 3233: LD BC,0x1c06
                DB      00H                     ; 3236: NOP
                DB      00H                     ; 3237: NOP
                DB      35H                     ; 3238: DEC (HL)
                DB      24H                     ; 3239: INC H
                DB      01H,01H,04H             ; 323A: LD BC,0x401
                DB      39H                     ; 323D: ADD HL,SP

L323E:
                DB      36H,30H                 ; 323E: LD (HL),0x30
                DB      30H,24H                 ; 3240: JR nc,L3266
                DB      0EH,0EH                 ; 3242: LD C,14
                DB      43H                     ; 3244: LD B,E
                DB      4FH                     ; 3245: LD C,A
                DB      4DH                     ; 3246: LD C,L
                DB      4EH                     ; 3247: LD C,(HL)
                DB      44H                     ; 3248: LD B,H
                DB      20H,5EH                 ; 3249: JR nz,L32A9
                DB      08H                     ; 324B: EX AF,AF'
                DB      05H                     ; 324C: DEC B

L324D:
                DB      00H                     ; 324D: NOP
                DB      00H                     ; 324E: NOP
                DB      00H                     ; 324F: NOP
                DB      00H                     ; 3250: NOP
                DB      0DH                     ; 3251: DEC C
                DB      0DH                     ; 3252: DEC C
                DB      23H                     ; 3253: INC HL
                DB      23H                     ; 3254: INC HL
                DB      31H,31H,31H             ; 3255: LD SP,0x3131
                DB      6FH                     ; 3258: LD L,A
                DB      75H                     ; 3259: LD (HL),L
                DB      73H                     ; 325A: LD (HL),E
                DB      24H                     ; 325B: INC H
                DB      0DH                     ; 325C: DEC C
                DB      0AH                     ; 325D: LD A,(BC)
                DB      3FH                     ; 325E: CCF
                DB      49H                     ; 325F: LD C,C
                DB      6CH                     ; 3260: LD L,H
                DB      6CH                     ; 3261: LD L,H
                DB      65H                     ; 3262: LD H,L
                DB      67H                     ; 3263: LD H,A
                DB      61H                     ; 3264: LD H,C
                DB      6CH                     ; 3265: LD L,H

L3266:
                DB      20H,43H                 ; 3266: JR nz,L32AB
                DB      50H                     ; 3268: LD D,B
                DB      2FH                     ; 3269: CPL
                DB      4DH                     ; 326A: LD C,L
                DB      20H,66H                 ; 326B: JR nz,L32D3
                DB      69H                     ; 326D: LD L,C
                DB      6CH                     ; 326E: LD L,H
                DB      65H                     ; 326F: LD H,L
                DB      20H,73H                 ; 3270: JR nz,L32E5
                DB      70H                     ; 3272: LD (HL),B
                DB      65H                     ; 3273: LD H,L
                DB      63H                     ; 3274: LD H,E
                DB      69H                     ; 3275: LD L,C
                DB      66H                     ; 3276: LD H,(HL)
                DB      69H                     ; 3277: LD L,C
                DB      63H                     ; 3278: LD H,E
                DB      61H                     ; 3279: LD H,C
                DB      74H                     ; 327A: LD (HL),H
                DB      69H                     ; 327B: LD L,C
                DB      6FH                     ; 327C: LD L,A
                DB      6EH                     ; 327D: LD L,(HL)
                DB      24H                     ; 327E: INC H
                DB      0DH                     ; 327F: DEC C
                DB      0AH                     ; 3280: LD A,(BC)
                DB      3FH                     ; 3281: CCF
                DB      22H,2AH,22H             ; 3282: LD (0x222a),HL
                DB      20H,6EH                 ; 3285: JR nz,L32F5
                DB      6FH                     ; 3287: LD L,A
                DB      74H                     ; 3288: LD (HL),H
                DB      20H,61H                 ; 3289: JR nz,L32EC
                DB      6CH                     ; 328B: LD L,H
                DB      6CH                     ; 328C: LD L,H
                DB      6FH                     ; 328D: LD L,A
                DB      77H                     ; 328E: LD (HL),A
                DB      65H                     ; 328F: LD H,L
                DB      64H                     ; 3290: LD H,H
                DB      20H,69H                 ; 3291: JR nz,L32FC
                DB      6EH                     ; 3293: LD L,(HL)
                DB      20H,66H                 ; 3294: JR nz,L32FC
                DB      69H                     ; 3296: LD L,C
                DB      6CH                     ; 3297: LD L,H
                DB      65H                     ; 3298: LD H,L
                DB      20H,73H                 ; 3299: JR nz,L330E
                DB      70H                     ; 329B: LD (HL),B
                DB      65H                     ; 329C: LD H,L
                DB      63H                     ; 329D: LD H,E
                DB      69H                     ; 329E: LD L,C
                DB      66H                     ; 329F: LD H,(HL)
                DB      69H                     ; 32A0: LD L,C
                DB      63H                     ; 32A1: LD H,E
                DB      61H                     ; 32A2: LD H,C
                DB      74H                     ; 32A3: LD (HL),H
                DB      69H                     ; 32A4: LD L,C
                DB      6FH                     ; 32A5: LD L,A
                DB      6EH                     ; 32A6: LD L,(HL)
                DB      24H                     ; 32A7: INC H
                DB      20H,43H                 ; 32A8: JR nz,L32ED
                DB      6FH                     ; 32AA: LD L,A

L32AB:
                DB      6EH                     ; 32AB: LD L,(HL)
                DB      66H                     ; 32AC: LD H,(HL)
                DB      69H                     ; 32AD: LD L,C
                DB      72H                     ; 32AE: LD (HL),D
                DB      6DH                     ; 32AF: LD L,L
                DB      20H,77H                 ; 32B0: JR nz,L3329
                DB      69H                     ; 32B2: LD L,C
                DB      74H                     ; 32B3: LD (HL),H
                DB      68H                     ; 32B4: LD L,B
                DB      20H,63H                 ; 32B5: JR nz,L331A
                DB      61H                     ; 32B7: LD H,C
                DB      72H                     ; 32B8: LD (HL),D
                DB      72H                     ; 32B9: LD (HL),D
                DB      69H                     ; 32BA: LD L,C
                DB      61H                     ; 32BB: LD H,C
                DB      67H                     ; 32BC: LD H,A
                DB      65H                     ; 32BD: LD H,L
                DB      20H,72H                 ; 32BE: JR nz,L3332
                DB      65H                     ; 32C0: LD H,L
                DB      74H                     ; 32C1: LD (HL),H
                DB      75H                     ; 32C2: LD (HL),L
                DB      72H                     ; 32C3: LD (HL),D
                DB      6EH                     ; 32C4: LD L,(HL)
                DB      24H                     ; 32C5: INC H
                DB      0DH                     ; 32C6: DEC C
                DB      0AH                     ; 32C7: LD A,(BC)
                DB      24H                     ; 32C8: INC H
                DB      10H,03H                 ; 32C9: DJNZ L32CE
                DB      31H,31H,30H             ; 32CB: LD SP,0x3031

L32CE:
                DB      24H                     ; 32CE: INC H
                DB      02H                     ; 32CF: LD (BC),A
                DB      02H                     ; 32D0: LD (BC),A
                DB      04H                     ; 32D1: INC B
                DB      31H,32H,30H             ; 32D2: LD SP,L3032
                DB      30H,24H                 ; 32D5: JR nc,L32FB
                DB      07H                     ; 32D7: RLCA
                DB      07H                     ; 32D8: RLCA
                DB      05H                     ; 32D9: DEC B
                DB      31H,33H,34H             ; 32DA: LD SP,0x3433
                DB      2EH,35H                 ; 32DD: LD L,0x35
                DB      24H                     ; 32DF: INC H
                DB      03H                     ; 32E0: INC BC
                DB      03H                     ; 32E1: INC BC
                DB      03H                     ; 32E2: INC BC
                DB      31H,35H,30H             ; 32E3: LD SP,0x3035
                DB      24H                     ; 32E6: INC H
                DB      04H                     ; 32E7: INC B
                DB      04H                     ; 32E8: INC B
                DB      04H                     ; 32E9: INC B
                DB      31H,38H,30H             ; 32EA: LD SP,0x3038

L32ED:
                DB      30H,24H                 ; 32ED: JR nc,L3313
                DB      08H                     ; 32EF: EX AF,AF'
                DB      08H                     ; 32F0: EX AF,AF'
                DB      05H                     ; 32F1: DEC B
                DB      31H,39H,32H             ; 32F2: LD SP,0x3239

L32F5:
                DB      30H,30H                 ; 32F5: JR nc,L3327
                DB      24H                     ; 32F7: INC H
                DB      0FH                     ; 32F8: RRCA
                DB      0FH                     ; 32F9: RRCA
                DB      04H                     ; 32FA: INC B

L32FB:
                DB      32H,30H,30H             ; 32FB: LD (0x3030),A
                DB      30H,24H                 ; 32FE: JR nc,L3324
                DB      09H                     ; 3300: ADD HL,BC
                DB      09H                     ; 3301: ADD HL,BC
                DB      04H                     ; 3302: INC B
                DB      32H,34H,30H             ; 3303: LD (0x3034),A
                DB      30H,24H                 ; 3306: JR nc,L332C
                DB      0AH                     ; 3308: LD A,(BC)
                DB      0AH                     ; 3309: LD A,(BC)
                DB      03H                     ; 330A: INC BC
                DB      33H                     ; 330B: INC SP
                DB      30H,30H                 ; 330C: JR nc,L333E

L330E:
                DB      24H                     ; 330E: INC H
                DB      05H                     ; 330F: DEC B
                DB      05H                     ; 3310: DEC B
                DB      04H                     ; 3311: INC B
                DB      33H                     ; 3312: INC SP

L3313:
                DB      36H,30H                 ; 3313: LD (HL),0x30
                DB      30H,24H                 ; 3315: JR nc,L333B
                DB      0BH                     ; 3317: DEC BC
                DB      0BH                     ; 3318: DEC BC
                DB      04H                     ; 3319: INC B

L331A:
                DB      34H                     ; 331A: INC (HL)
                DB      38H,30H                 ; 331B: JR c,L334D
                DB      30H,24H                 ; 331D: JR nc,L3343
                DB      0CH                     ; 331F: INC C
                DB      0CH                     ; 3320: INC C
                DB      02H                     ; 3321: LD (BC),A
                DB      35H                     ; 3322: DEC (HL)
                DB      30H,0DH                 ; 3323: JR nc,L3332
                DB      24H                     ; 3325: INC H
                DB      00H                     ; 3326: NOP

L3327:
                DB      00H                     ; 3327: NOP
                DB      00H                     ; 3328: NOP

L3329:
                DB      00H                     ; 3329: NOP
                DB      00H                     ; 332A: NOP
                DB      26H,00H                 ; 332B: LD H,0
                DB      00H                     ; 332D: NOP
                DB      00H                     ; 332E: NOP
                DB      00H                     ; 332F: NOP
                DB      01H,01H,00H             ; 3330: LD BC,1
                DB      01H,06H,1CH             ; 3333: LD BC,0x1c06
                DB      00H                     ; 3336: NOP
                DB      00H                     ; 3337: NOP
                DB      35H                     ; 3338: DEC (HL)
                DB      24H                     ; 3339: INC H
                DB      01H,01H,04H             ; 333A: LD BC,0x401
                DB      39H                     ; 333D: ADD HL,SP

L333E:
                DB      36H,30H                 ; 333E: LD (HL),0x30
                DB      30H,24H                 ; 3340: JR nc,L3366
                DB      0EH,0EH                 ; 3342: LD C,14
                DB      43H                     ; 3344: LD B,E
                DB      4FH                     ; 3345: LD C,A
                DB      4DH                     ; 3346: LD C,L
                DB      4EH                     ; 3347: LD C,(HL)
                DB      44H                     ; 3348: LD B,H
                DB      20H,5EH                 ; 3349: JR nz,L33A9
                DB      08H                     ; 334B: EX AF,AF'
                DB      05H                     ; 334C: DEC B

L334D:
                DB      00H                     ; 334D: NOP
                DB      00H                     ; 334E: NOP
                DB      00H                     ; 334F: NOP
                DB      00H                     ; 3350: NOP
                DB      0DH                     ; 3351: DEC C
                DB      0DH                     ; 3352: DEC C
                DB      23H                     ; 3353: INC HL
                DB      23H                     ; 3354: INC HL
                DB      31H,31H,31H             ; 3355: LD SP,0x3131
                DB      6FH                     ; 3358: LD L,A
                DB      75H                     ; 3359: LD (HL),L
                DB      73H                     ; 335A: LD (HL),E
                DB      24H                     ; 335B: INC H
                DB      0DH                     ; 335C: DEC C
                DB      0AH                     ; 335D: LD A,(BC)
                DB      3FH                     ; 335E: CCF
                DB      49H                     ; 335F: LD C,C
                DB      6CH                     ; 3360: LD L,H
                DB      6CH                     ; 3361: LD L,H
                DB      65H                     ; 3362: LD H,L
                DB      67H                     ; 3363: LD H,A
                DB      61H                     ; 3364: LD H,C
                DB      6CH                     ; 3365: LD L,H

L3366:
                DB      20H,43H                 ; 3366: JR nz,L33AB
                DB      50H                     ; 3368: LD D,B
                DB      2FH                     ; 3369: CPL
                DB      4DH                     ; 336A: LD C,L
                DB      20H,66H                 ; 336B: JR nz,L33D3
                DB      69H                     ; 336D: LD L,C
                DB      6CH                     ; 336E: LD L,H
                DB      65H                     ; 336F: LD H,L
                DB      20H,73H                 ; 3370: JR nz,L33E5
                DB      70H                     ; 3372: LD (HL),B
                DB      65H                     ; 3373: LD H,L
                DB      63H                     ; 3374: LD H,E
                DB      69H                     ; 3375: LD L,C
                DB      66H                     ; 3376: LD H,(HL)
                DB      69H                     ; 3377: LD L,C
                DB      63H                     ; 3378: LD H,E
                DB      61H                     ; 3379: LD H,C
                DB      74H                     ; 337A: LD (HL),H
                DB      69H                     ; 337B: LD L,C
                DB      6FH                     ; 337C: LD L,A
                DB      6EH                     ; 337D: LD L,(HL)
                DB      24H                     ; 337E: INC H
                DB      0DH                     ; 337F: DEC C
                DB      0AH                     ; 3380: LD A,(BC)
                DB      3FH                     ; 3381: CCF
                DB      22H,2AH,22H             ; 3382: LD (0x222a),HL
                DB      20H,6EH                 ; 3385: JR nz,L33F5
                DB      6FH                     ; 3387: LD L,A
                DB      74H                     ; 3388: LD (HL),H
                DB      20H,61H                 ; 3389: JR nz,L33EC
                DB      6CH                     ; 338B: LD L,H
                DB      6CH                     ; 338C: LD L,H
                DB      6FH                     ; 338D: LD L,A
                DB      77H                     ; 338E: LD (HL),A
                DB      65H                     ; 338F: LD H,L
                DB      64H                     ; 3390: LD H,H
                DB      20H,69H                 ; 3391: JR nz,L33FC
                DB      6EH                     ; 3393: LD L,(HL)
                DB      20H,66H                 ; 3394: JR nz,L33FC
                DB      69H                     ; 3396: LD L,C
                DB      6CH                     ; 3397: LD L,H
                DB      65H                     ; 3398: LD H,L
                DB      20H,73H                 ; 3399: JR nz,L340E
                DB      70H                     ; 339B: LD (HL),B
                DB      65H                     ; 339C: LD H,L
                DB      63H                     ; 339D: LD H,E
                DB      69H                     ; 339E: LD L,C
                DB      66H                     ; 339F: LD H,(HL)
                DB      69H                     ; 33A0: LD L,C
                DB      63H                     ; 33A1: LD H,E
                DB      61H                     ; 33A2: LD H,C
                DB      74H                     ; 33A3: LD (HL),H
                DB      69H                     ; 33A4: LD L,C
                DB      6FH                     ; 33A5: LD L,A
                DB      6EH                     ; 33A6: LD L,(HL)
                DB      24H                     ; 33A7: INC H
                DB      20H,43H                 ; 33A8: JR nz,L33ED
                DB      6FH                     ; 33AA: LD L,A

L33AB:
                DB      6EH                     ; 33AB: LD L,(HL)
                DB      66H                     ; 33AC: LD H,(HL)
                DB      69H                     ; 33AD: LD L,C
                DB      72H                     ; 33AE: LD (HL),D
                DB      6DH                     ; 33AF: LD L,L
                DB      20H,77H                 ; 33B0: JR nz,L3429
                DB      69H                     ; 33B2: LD L,C
                DB      74H                     ; 33B3: LD (HL),H
                DB      68H                     ; 33B4: LD L,B
                DB      20H,63H                 ; 33B5: JR nz,L341A
                DB      61H                     ; 33B7: LD H,C
                DB      72H                     ; 33B8: LD (HL),D
                DB      72H                     ; 33B9: LD (HL),D
                DB      69H                     ; 33BA: LD L,C
                DB      61H                     ; 33BB: LD H,C
                DB      67H                     ; 33BC: LD H,A
                DB      65H                     ; 33BD: LD H,L
                DB      20H,72H                 ; 33BE: JR nz,L3432
                DB      65H                     ; 33C0: LD H,L
                DB      74H                     ; 33C1: LD (HL),H
                DB      75H                     ; 33C2: LD (HL),L
                DB      72H                     ; 33C3: LD (HL),D
                DB      6EH                     ; 33C4: LD L,(HL)
                DB      24H                     ; 33C5: INC H
                DB      0DH                     ; 33C6: DEC C
                DB      0AH                     ; 33C7: LD A,(BC)
                DB      24H                     ; 33C8: INC H
                DB      10H,03H                 ; 33C9: DJNZ L33CE
                DB      31H,31H,30H             ; 33CB: LD SP,0x3031

L33CE:
                DB      24H                     ; 33CE: INC H
                DB      02H                     ; 33CF: LD (BC),A
                DB      02H                     ; 33D0: LD (BC),A
                DB      04H                     ; 33D1: INC B
                DB      31H,32H,30H             ; 33D2: LD SP,L3032
                DB      30H,24H                 ; 33D5: JR nc,L33FB
                DB      07H                     ; 33D7: RLCA
                DB      07H                     ; 33D8: RLCA
                DB      05H                     ; 33D9: DEC B
                DB      31H,33H,34H             ; 33DA: LD SP,0x3433
                DB      2EH,35H                 ; 33DD: LD L,0x35
                DB      24H                     ; 33DF: INC H
                DB      03H                     ; 33E0: INC BC
                DB      03H                     ; 33E1: INC BC
                DB      03H                     ; 33E2: INC BC
                DB      31H,35H,30H             ; 33E3: LD SP,0x3035
                DB      24H                     ; 33E6: INC H
                DB      04H                     ; 33E7: INC B
                DB      04H                     ; 33E8: INC B
                DB      04H                     ; 33E9: INC B
                DB      31H,38H,30H             ; 33EA: LD SP,0x3038

L33ED:
                DB      30H,24H                 ; 33ED: JR nc,L3413
                DB      08H                     ; 33EF: EX AF,AF'
                DB      08H                     ; 33F0: EX AF,AF'
                DB      05H                     ; 33F1: DEC B
                DB      31H,39H,32H             ; 33F2: LD SP,0x3239

L33F5:
                DB      30H,30H                 ; 33F5: JR nc,L3427
                DB      24H                     ; 33F7: INC H
                DB      0FH                     ; 33F8: RRCA
                DB      0FH                     ; 33F9: RRCA
                DB      04H                     ; 33FA: INC B

L33FB:
                DB      32H,30H,30H             ; 33FB: LD (0x3030),A
                DB      30H,24H                 ; 33FE: JR nc,L3424
                DB      09H                     ; 3400: ADD HL,BC
                DB      09H                     ; 3401: ADD HL,BC
                DB      04H                     ; 3402: INC B
                DB      32H,34H,30H             ; 3403: LD (0x3034),A
                DB      30H,24H                 ; 3406: JR nc,L342C
                DB      0AH                     ; 3408: LD A,(BC)
                DB      0AH                     ; 3409: LD A,(BC)
                DB      03H                     ; 340A: INC BC
                DB      33H                     ; 340B: INC SP
                DB      30H,30H                 ; 340C: JR nc,L343E

L340E:
                DB      24H                     ; 340E: INC H
                DB      05H                     ; 340F: DEC B
                DB      05H                     ; 3410: DEC B
                DB      04H                     ; 3411: INC B
                DB      33H                     ; 3412: INC SP

L3413:
                DB      36H,30H                 ; 3413: LD (HL),0x30
                DB      30H,24H                 ; 3415: JR nc,L343B
                DB      0BH                     ; 3417: DEC BC
                DB      0BH                     ; 3418: DEC BC
                DB      04H                     ; 3419: INC B

L341A:
                DB      34H                     ; 341A: INC (HL)
                DB      38H,30H                 ; 341B: JR c,L344D
                DB      30H,24H                 ; 341D: JR nc,L3443
                DB      0CH                     ; 341F: INC C
                DB      0CH                     ; 3420: INC C
                DB      02H                     ; 3421: LD (BC),A
                DB      35H                     ; 3422: DEC (HL)
                DB      30H,0DH                 ; 3423: JR nc,L3432
                DB      24H                     ; 3425: INC H
                DB      00H                     ; 3426: NOP

L3427:
                DB      00H                     ; 3427: NOP
                DB      00H                     ; 3428: NOP

L3429:
                DB      00H                     ; 3429: NOP
                DB      00H                     ; 342A: NOP
                DB      26H,00H                 ; 342B: LD H,0
                DB      00H                     ; 342D: NOP
                DB      00H                     ; 342E: NOP
                DB      00H                     ; 342F: NOP
                DB      01H,01H,00H             ; 3430: LD BC,1
                DB      01H,06H,1CH             ; 3433: LD BC,0x1c06
                DB      00H                     ; 3436: NOP
                DB      00H                     ; 3437: NOP
                DB      35H                     ; 3438: DEC (HL)
                DB      24H                     ; 3439: INC H
                DB      01H,01H,04H             ; 343A: LD BC,0x401
                DB      39H                     ; 343D: ADD HL,SP

L343E:
                DB      36H,30H                 ; 343E: LD (HL),0x30
                DB      30H,24H                 ; 3440: JR nc,L3466
                DB      0EH,0EH                 ; 3442: LD C,14
                DB      43H                     ; 3444: LD B,E
                DB      4FH                     ; 3445: LD C,A
                DB      4DH                     ; 3446: LD C,L
                DB      4EH                     ; 3447: LD C,(HL)
                DB      44H                     ; 3448: LD B,H
                DB      20H,5EH                 ; 3449: JR nz,L34A9
                DB      08H                     ; 344B: EX AF,AF'
                DB      05H                     ; 344C: DEC B

L344D:
                DB      00H                     ; 344D: NOP
                DB      00H                     ; 344E: NOP
                DB      00H                     ; 344F: NOP
                DB      00H                     ; 3450: NOP
                DB      0DH                     ; 3451: DEC C
                DB      0DH                     ; 3452: DEC C
                DB      23H                     ; 3453: INC HL
                DB      23H                     ; 3454: INC HL
                DB      31H,31H,31H             ; 3455: LD SP,0x3131
                DB      6FH                     ; 3458: LD L,A
                DB      75H                     ; 3459: LD (HL),L
                DB      73H                     ; 345A: LD (HL),E
                DB      24H                     ; 345B: INC H
                DB      0DH                     ; 345C: DEC C
                DB      0AH                     ; 345D: LD A,(BC)
                DB      3FH                     ; 345E: CCF
                DB      49H                     ; 345F: LD C,C
                DB      6CH                     ; 3460: LD L,H
                DB      6CH                     ; 3461: LD L,H
                DB      65H                     ; 3462: LD H,L
                DB      67H                     ; 3463: LD H,A
                DB      61H                     ; 3464: LD H,C
                DB      6CH                     ; 3465: LD L,H

L3466:
                DB      20H,43H                 ; 3466: JR nz,L34AB
                DB      50H                     ; 3468: LD D,B
                DB      2FH                     ; 3469: CPL
                DB      4DH                     ; 346A: LD C,L
                DB      20H,66H                 ; 346B: JR nz,L34D3
                DB      69H                     ; 346D: LD L,C
                DB      6CH                     ; 346E: LD L,H
                DB      65H                     ; 346F: LD H,L
                DB      20H,73H                 ; 3470: JR nz,L34E5
                DB      70H                     ; 3472: LD (HL),B
                DB      65H                     ; 3473: LD H,L
                DB      63H                     ; 3474: LD H,E
                DB      69H                     ; 3475: LD L,C
                DB      66H                     ; 3476: LD H,(HL)
                DB      69H                     ; 3477: LD L,C
                DB      63H                     ; 3478: LD H,E
                DB      61H                     ; 3479: LD H,C
                DB      74H                     ; 347A: LD (HL),H
                DB      69H                     ; 347B: LD L,C
                DB      6FH                     ; 347C: LD L,A
                DB      6EH                     ; 347D: LD L,(HL)
                DB      24H                     ; 347E: INC H
                DB      0DH                     ; 347F: DEC C
                DB      0AH                     ; 3480: LD A,(BC)
                DB      3FH                     ; 3481: CCF
                DB      22H,2AH,22H             ; 3482: LD (0x222a),HL
                DB      20H,6EH                 ; 3485: JR nz,L34F5
                DB      6FH                     ; 3487: LD L,A
                DB      74H                     ; 3488: LD (HL),H
                DB      20H,61H                 ; 3489: JR nz,L34EC
                DB      6CH                     ; 348B: LD L,H
                DB      6CH                     ; 348C: LD L,H
                DB      6FH                     ; 348D: LD L,A
                DB      77H                     ; 348E: LD (HL),A
                DB      65H                     ; 348F: LD H,L
                DB      64H                     ; 3490: LD H,H
                DB      20H,69H                 ; 3491: JR nz,L34FC
                DB      6EH                     ; 3493: LD L,(HL)
                DB      20H,66H                 ; 3494: JR nz,L34FC
                DB      69H                     ; 3496: LD L,C
                DB      6CH                     ; 3497: LD L,H
                DB      65H                     ; 3498: LD H,L
                DB      20H,73H                 ; 3499: JR nz,0x350e
                DB      70H                     ; 349B: LD (HL),B
                DB      65H                     ; 349C: LD H,L
                DB      63H                     ; 349D: LD H,E
                DB      69H                     ; 349E: LD L,C
                DB      66H                     ; 349F: LD H,(HL)
                DB      69H                     ; 34A0: LD L,C
                DB      63H                     ; 34A1: LD H,E
                DB      61H                     ; 34A2: LD H,C
                DB      74H                     ; 34A3: LD (HL),H
                DB      69H                     ; 34A4: LD L,C
                DB      6FH                     ; 34A5: LD L,A
                DB      6EH                     ; 34A6: LD L,(HL)
                DB      24H                     ; 34A7: INC H
                DB      20H,43H                 ; 34A8: JR nz,L34ED
                DB      6FH                     ; 34AA: LD L,A

L34AB:
                DB      6EH                     ; 34AB: LD L,(HL)
                DB      66H                     ; 34AC: LD H,(HL)
                DB      69H                     ; 34AD: LD L,C
                DB      72H                     ; 34AE: LD (HL),D
                DB      6DH                     ; 34AF: LD L,L
                DB      20H,77H                 ; 34B0: JR nz,0x3529
                DB      69H                     ; 34B2: LD L,C
                DB      74H                     ; 34B3: LD (HL),H
                DB      68H                     ; 34B4: LD L,B
                DB      20H,63H                 ; 34B5: JR nz,0x351a
                DB      61H                     ; 34B7: LD H,C
                DB      72H                     ; 34B8: LD (HL),D
                DB      72H                     ; 34B9: LD (HL),D
                DB      69H                     ; 34BA: LD L,C
                DB      61H                     ; 34BB: LD H,C
                DB      67H                     ; 34BC: LD H,A
                DB      65H                     ; 34BD: LD H,L
                DB      20H,72H                 ; 34BE: JR nz,0x3532
                DB      65H                     ; 34C0: LD H,L
                DB      74H                     ; 34C1: LD (HL),H
                DB      75H                     ; 34C2: LD (HL),L
                DB      72H                     ; 34C3: LD (HL),D
                DB      6EH                     ; 34C4: LD L,(HL)
                DB      24H                     ; 34C5: INC H
                DB      0DH                     ; 34C6: DEC C
                DB      0AH                     ; 34C7: LD A,(BC)
                DB      24H                     ; 34C8: INC H
                DB      10H,03H                 ; 34C9: DJNZ L34CE
                DB      31H,31H,30H             ; 34CB: LD SP,0x3031

L34CE:
                DB      24H                     ; 34CE: INC H
                DB      02H                     ; 34CF: LD (BC),A
                DB      FFH                     ; 34D0: RST 0x38
                DB      04H                     ; 34D1: INC B
                DB      31H,32H,30H             ; 34D2: LD SP,L3032
                DB      30H,24H                 ; 34D5: JR nc,L34FB
                DB      07H                     ; 34D7: RLCA
                DB      07H                     ; 34D8: RLCA
                DB      05H                     ; 34D9: DEC B
                DB      31H,33H,34H             ; 34DA: LD SP,0x3433
                DB      2EH,35H                 ; 34DD: LD L,0x35
                DB      24H                     ; 34DF: INC H
                DB      03H                     ; 34E0: INC BC
                DB      03H                     ; 34E1: INC BC
                DB      00H                     ; 34E2: NOP
                DB      00H                     ; 34E3: NOP
                DB      18H,04H                 ; 34E4: JR L34EA
                DB      44H                     ; 34E6: LD B,H
                DB      01H,00H,03H             ; 34E7: LD BC,0x300

L34EA:
                DB      C1H                     ; 34EA: POP BC
                DB      05H                     ; 34EB: DEC B

L34EC:
                DB      EAH,00H,00H             ; 34EC: JP pe,0x0000
                DB      00H                     ; 34EF: NOP
                DB      00H                     ; 34F0: NOP
                DB      00H                     ; 34F1: NOP
                DB      00H                     ; 34F2: NOP
                DB      00H                     ; 34F3: NOP
                DB      00H                     ; 34F4: NOP

L34F5:
                DB      00H                     ; 34F5: NOP
                DB      00H                     ; 34F6: NOP
                DB      00H                     ; 34F7: NOP
                DB      00H                     ; 34F8: NOP
                DB      00H                     ; 34F9: NOP
                DB      00H                     ; 34FA: NOP

L34FB:
                DB      00H                     ; 34FB: NOP

L34FC:
                DB      00H                     ; 34FC: NOP
                DB      00H                     ; 34FD: NOP
                DB      00H                     ; 34FE: NOP
                DB      00H                     ; 34FF: NOP

;------------------------------------------------------------------------------
; Printable-string index
;------------------------------------------------------------------------------
; 01B6H  "!>12V1"
; 01D5H  "\"Z1\"\\12Y12^1"
; 01EDH  ">R2`1"
; 0283H  "<2^1>12V1"
; 0297H  ":^12_1"
; 02C1H  ":W12V1>F2`1"
; 02D8H  ">A2`1"
; 02F9H  "!*\\1#\"\\1"
; 0316H  " w#:L1"
; 031DH  " w#:N1"
; 0324H  " w#:P1"
; 032EH  "w#:R1"
; 0334H  " w#:T1w#6Y:41"
; 0346H  ":+1w#:W1w#>"
; 0358H  " 2I1:"
; 0366H  " 2M1:"
; 0382H  " 2Q1:"
; 038CH  "#~2S1:"
; 03CBH  "#~G:U1"
; 03D5H  ">12W1"
; 0410H  "<2_1:Y1=G:"
; 0424H  "2^1!e1"
; 046AH  ":^12_1"
; 0473H  ">D2`1:X1"
; 049AH  ">C2`1"
; 04E9H  ":^12_1:"
; 04FEH  "2O:X1"
; 050CH  "2y2e1>Y"
; 0552H  "*<1:81="
; 0572H  "2X1:^12_1"
; 057EH  ">F2`1"
; 05B0H  "2Y12^12*1!"
; 05BCH  "\"Z1\"\\1"
; 05CEH  ">12V1>S2`1"
; 066CH  "<2^1>12V1:U12W1!e1"
; 0683H  "2:Z12"
; 06ADH  ":^12_1"
; 06B4H  "2^1:W12V1>F2`1"
; 06D1H  ":Y1<G:"
; 06DCH  "2^1>F2`1"
; 0706H  "2X1!e1\"B1!]"
; 071FH  ">.*B1w#\"B1"
; 0740H  "*B1w#\"B1"
; 074FH  "2*B1>$w"
; 0761H  "!:Y12"
; 0782H  ":^12_1"
; 07A6H  ">Z2`1"
; 07ACH  "2H1>D2`1"
; 07BDH  ":Y1<G:"
; 07E6H  "<2^1!e1\"B1!&2\"D1"
; 07F8H  "*D1~#\"D1O:,1"
; 082AH  "*B1w#\"B1"
; 083FH  "2:Y12"
; 0863H  ":^12_1"
; 0885H  "2X1:X1"
; 088FH  ">Z2`1"
; 08A4H  ">Z2`1"
; 08B2H  ":Y1<G:"
; 08DBH  "<2^1:Y12"
; 08F0H  ">D2e1>"
; 0914H  ":^12_1"
; 093BH  "2X1>F2`1"
; 0944H  ">B2`1"
; 0952H  ":Y1<G:"
; 097BH  "<2^1:Y12"
; 09A3H  ":^12_1"
; 09AAH  "2^1>C2`1"
; 09BBH  ":Y1<G:"
; 09D5H  "2!e1\":1:T1G"
; 09E9H  ":+1O!"
; 0A01H  "*:1~#\":1"
; 0A17H  "2~#\":1"
; 0A21H  "~#\":1!"
; 0A40H  "*<1w#\"<1"
; 0A6EH  ":S1O:$1"
; 0A85H  "1G:I1"
; 0A8FH  "2!&2\"D1"
; 0AA5H  "2:81="
; 0AC4H  "*<1~#\"<1W"
; 0AE5H  "2*D1:+1w#\"D1"
; 0B17H  "25*D1q#\"D1"
; 0B43H  "*<1:81W"
; 0B65H  "25*D1q#\"D1"
; 0B7BH  "w#\"D1"
; 0B84H  "*<1+\"<1!814x"
; 0BA3H  "!81:$1"
; 0C8EH  "2#12h"
; 0CA5H  "!e1\"B1!]"
; 0CD6H  "\"B1!e"
; 0CF1H  "\"B1*@1w#\"@1:"
; 0D0AH  "2*B1~#\"B1"
; 0D2BH  "#\"B1*@1w#\"@1:"
; 0D43H  "*B16$"
; 0E2DH  "2!a1>"
; 0E33H  "w#:V1"
; 0EBAH  " w#:Q1w#"
; 0EDDH  "2:O1_"
; 0F83H  "*(1#\"(1|"
; 0F94H  "@G:41"
; 0FC0H  "2b1O:V1"
; 100EH  "2!e1\"B1:"
; 102BH  "*B1w#\"B1"
; 10ECH  "1\"F1*F1w#\"F1G"
; 112FH  "*F1~#\"F1"
; 11B6H  ">A2`1"
; 1204H  "2^1>12V1:^1"
; 1229H  "2!e16F>G"
; 125AH  "2^1>12V1:^1"
; 127DH  "2!e16L>G"
; 1340H  "271281"
; 135BH  "*<1:81"
; 13A5H  "2#1\"<1"
; 13ACH  "x281y291:912F0!R0\""
; 13D1H  "=2F0*"
; 142AH  "\"<1:>1"
; 14C2H  "271:01"
; 1567H  "!*<16"
; 163BH  "*<1s#\"<1}"
; 16D4H  ":%12%1"
; 16DFH  ":%1=_"
; 17D9H  "241x2.12'1"
; 1919H  "!:U1_"
; 1975H  "?+:'1"
; 1A52H  "!:%1=_"
; 1B42H  "4##^#V"
; 1BA9H  ":Y1G:"
; 1BB4H  "?2Y1*Z1#\"Z1"
; 1BD0H  "<2_1:Y1=G:"
; 1C3BH  "2E02F0>"
; 1C60H  "2G0*J0"
; 1C75H  "2E02F0>"
; 1CE4H  "0!F05"
; 1CF5H  "!x*N0"
; 1D04H  "*N0w#\"N0"
; 1D2FH  "0!F05"
; 1D51H  "0>$w*"
; 1D75H  "\"N0F#\""
; 1DA1H  "2E0!F05*P0"
; 1DBEH  "0>$w*"
; 1DF4H  "0!F05"
; 1E12H  ":F0<2F0"
; 1E1CH  ":F0<2F0"
; 1E24H  "> w#\""
; 1E58H  "#^#V{"
; 1F15H  "0!F05{2"
; 1FC0H  "0!F05:"
; 2042H  "0>?w#\""
; 20ADH  "0!F04"
; 20BCH  "l!!F04"
; 20EDH  "0!F06"
; 210BH  "!:F0=="
; 2194H  "2G0> "
; 21D7H  "Number of packets:"
; 21EBH  "Number of retries:"
; 21FFH  "File name:$Kermit-80  x:>$Delete it? $"
; 222AH  "?Unrecognized command$"
; 2242H  "?Illegal character$"
; 2257H  "?Not confirmed$?Unable to receive initiate"
; 2283H  "$?Unable to receive file name"
; 22A2H  "$?Unable to receive end of file"
; 22C3H  "$?Unable to receive data"
; 22DDH  "$?Disk full"
; 22EAH  "$?Unable to receive an acknowledgement from the host"
; 2323H  "?Unable to find file"
; 2339H  "$?Unable to rename file$"
; 2353H  "?Disk full$"
; 2360H  "?Unable to tell host that the session is finished$"
; 2394H  "?Unable to tell host to logout$"
; 23B4H  "Completed$"
; 23BFH  "Failed$%Renaming file to $"
; 23DBH  "[Closing the log file]$"
; 23F4H  "[Connected to remote host, type $C to return]"
; 2426H  "[Connection closed, back at micro]$Control-$ (Type Left Arrow to send CTRL-S)"
; 2475H  "$ (Not implemented)"
; 248CH  "Interrupted$"
; 249AH  "    Directory for drive x:"
; 24BBH  "Drive $  has $K bytes free"
; 24DAH  "File(s) erased$"
; 24EDH  "[Transmitting file to host:"
; 250AH  " 1. Type any character to send a line."
; 2532H  " 2. Type RETURN to terminate the line and to get the next line (go back to 1.)"
; 2582H  "    (You may send other characters before RETURN.),"
; 25B7H  "   or type $R to send the same line again,"
; 25E3H  "   or type $C to abort transmission.]"
; 260DH  "[Transmission done. Connected normally to remote host,"
; 2645H  " type $Sending...$Receiving...$"
; 2665H  "Warning: eighth bit cannot be sent$"
; 268AH  "++ Bad drive name$"
; 269EH  " Confirm with carriage return $ Input file spec (possibly wild) $"
; 26E1H  "Type the new escape character:  $"
; 2704H  "BYE to host (LOGOUT) and exit to CP/M"
; 272BH  "CONNECT to host on selected port"
; 274DH  "ERA a CP/M file"
; 275EH  "EXIT to CP/M"
; 276CH  "FINISH running Kermit on the host"
; 278FH  "HELP by giving this message"
; 27ACH  "DIR of current used Micro-disk"
; 27CCH  "LOG the terminal session to a file"
; 27F0H  "LOGOUT the host"
; 2801H  "RECEIVE file from host"
; 2819H  "SEND file to host"
; 282CH  "SET a parameter"
; 283DH  "SHOW the parameters"
; 2852H  "STATUS of Kermit"
; 2864H  "TRANSMIT file to host (in connect state)$"
; 288FH  "BAud (rate)"
; 289CH  "BLock-check-type (for error detection)"
; 28C4H  "Default-disk (to receive data)"
; 28E4H  "Escape (character during CONNECT)"
; 2907H  "File-mode (for outgoing files)"
; 2927H  "Ibm (parity and turn around handling)"
; 294EH  "Local-echo (half-duplex)"
; 2968H  "PArity (for communication line)"
; 2989H  "POrt (to communicate on)"
; 29A3H  "PRinter copy ( ON / OFF )"
; 29BEH  "TIMER ( On / OFF )"
; 29D2H  "Vt52-emulation"
; 29E2H  "Warning (for filename conflicts)$"
; 2A05H  "PAD-CHAR"
; 2A0FH  "PADDING$"
; 2A19H  "1-CHARACTER-CHECKSUM"
; 2A2FH  "2-CHARACTER-CHECKSUM"
; 2A45H  "3-CHARACTER-CRC-CCITT$"
; 2A70H  "SPACE$"
; 2A8AH  "R Send the same line again$"
; 2AA7H  "?  This message"
; 2AB8H  "C  Close the connection"
; 2AD1H  "0  (zero) Transmit a NULL"
; 2AECH  "S  Status of the connection"
; 2B09H  "Typing another $ will send it to the host"
; 2B36H  "Command>$ on$ off$"
; 2B4AH  "Transmitting a file$"
; 2B60H  "Local echo$ default$ ASCII$ binary$"
; 2B85H  "ASCII"
; 2B8BH  "BINARY"
; 2B92H  "DEFAULT$"
; 2B9CH  "VT52 emulation$"
; 2BADH  "File Mode$"
; 2BB9H  "IBM flag$"
; 2BC4H  "File warning$"
; 2BD3H  "Printer copy$"
; 2BE2H  "Escape char: $"
; 2BF2H  "Parity: $"
; 2BFDH  "Block check type: $-character$none$mark$space$odd$even$Speed $is indeterminate (not SET)$Timer$"
; 2C5EH  "    50"
; 2C65H  " 75   110 134.5   150"
; 2C7BH  "300   600  1200"
; 2C8CH  "  1800  2000  2400  3600  4800  7200  9600 19200$"
; 2CC2H  "Kermit-80 V3.9A [Kaypro II]"
; 2D3EH  "BYE$!!"
; 2D45H  "CONNECT$"
; 2D50H  "DIR$$$"
; 2D57H  "ERA$''"
; 2D5EH  "EXIT$"
; 2D66H  "FINISH$"
; 2D77H  "HELP$"
; 2D86H  "LOGOUT$"
; 2D90H  "RECEIVE$"
; 2D9BH  "SEND$"
; 2DAAH  "SHOW$"
; 2DB2H  "STATUS$"
; 2DBCH  "TRANSMIT$**"
; 2DC9H  "BAUD$!!"
; 2DD1H  "BLOCK-CHECK-TYPE$"
; 2DE5H  "DEFAULT-DISK$$$"
; 2DF5H  "ESCAPE$"
; 2DFFH  "FILE-MODE$"
; 2E13H  "LOCAL-ECHO$"
; 2E21H  "PARITY$"
; 2E2BH  "PORT$"
; 2E33H  "PRINTER$''"
; 2E3EH  "TIMER$**"
; 2E47H  "VT52-EMULATION$"
; 2E59H  "WARNING$"
; 2E65H  "PAD-CHAR$"
; 2E71H  "PADDING$"
; 2E7DH  "1-CHARACTER-CHECKSUM$11"
; 2E95H  "2-CHARACTER-CHECKSUM$22"
; 2EADH  "3-CHARACTER-CRC-CCITT$33"
; 2EC7H  "EVEN$"
; 2ECFH  "MARK$"
; 2ED7H  "NONE$"
; 2EE6H  "SPACE$"
; 2EFEH  "ASCII$"
; 2F07H  "BINARY$"
; 2F11H  "DEFAULT$"
; 2F2BH  "?Program error:  Invalid COMND call$"
; 2F51H  "?Ambiguous$"
; 2F5EH  "?Illegal CP/M file specification$"
; 2F81H  "?\"*\" not allowed in file specification$ Confirm with carriage return$"
; 2FD2H  "1200$"
; 2FDAH  "134.5$"
; 2FEAH  "1800$"
; 2FF2H  "19200$"
; 2FFBH  "2000$"
; 3003H  "2400$"
; 3012H  "3600$"
; 301AH  "4800$"
; 302FH  "7200$"
; 303DH  "9600$"
; 3044H  "COMND call$"
; 3051H  "?Ambiguous$"
; 305EH  "?Illegal CP/M file specification$"
; 3081H  "?\"*\" not allowed in file specification$ Confirm with carriage return$"
; 30D2H  "1200$"
; 30DAH  "134.5$"
; 30EAH  "1800$"
; 30F2H  "19200$"
; 30FBH  "2000$"
; 3103H  "2400$"
; 3112H  "3600$"
; 311AH  "4800$"
; 313DH  "9600$"
; 3144H  "COMND ^"
; 3153H  "##111ous$"
; 315EH  "?Illegal CP/M file specification$"
; 3181H  "?\"*\" not allowed in file specification$ Confirm with carriage return$"
; 31D2H  "1200$"
; 31DAH  "134.5$"
; 31EAH  "1800$"
; 31F2H  "19200$"
; 31FBH  "2000$"
; 3203H  "2400$"
; 3212H  "3600$"
; 321AH  "4800$"
; 323DH  "9600$"
; 3244H  "COMND ^"
; 3253H  "##111ous$"
; 325EH  "?Illegal CP/M file specification$"
; 3281H  "?\"*\" not allowed in file specification$ Confirm with carriage return$"
; 32D2H  "1200$"
; 32DAH  "134.5$"
; 32EAH  "1800$"
; 32F2H  "19200$"
; 32FBH  "2000$"
; 3303H  "2400$"
; 3312H  "3600$"
; 331AH  "4800$"
; 333DH  "9600$"
; 3344H  "COMND ^"
; 3353H  "##111ous$"
; 335EH  "?Illegal CP/M file specification$"
; 3381H  "?\"*\" not allowed in file specification$ Confirm with carriage return$"
; 33D2H  "1200$"
; 33DAH  "134.5$"
; 33EAH  "1800$"
; 33F2H  "19200$"
; 33FBH  "2000$"
; 3403H  "2400$"
; 3412H  "3600$"
; 341AH  "4800$"
; 343DH  "9600$"
; 3444H  "COMND ^"
; 3453H  "##111ous$"
; 345EH  "?Illegal CP/M file specification$"
; 3481H  "?\"*\" not allowed in file specification$ Confirm with carriage return$"
; 34D2H  "1200$"
; 34DAH  "134.5$"

IMAGE_END       EQU     3500H
IMAGE_SIZE      EQU     3400H

                END     CPM_ENTRY
