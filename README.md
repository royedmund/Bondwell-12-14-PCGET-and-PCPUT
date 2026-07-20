XMODEM Transfer Utilities for the Bondwell 12/14 Z80 CP/M 2.2 and 3.0 (CP/M PLUS)

These two utilities allow you to transfer files between a Bondwell CP/M system and any other computer that supports XMODEM send and receive.

PCGET and PCPUT are based on the work of DeRamp https://deramp.com and were adapted from the Kaypro 10 versions for the Bondwell 12/14 serial ports.

Bondwell serial port addresses:

A SIO0: 40H data, 41H status/control

B SIO1: 42H data, 43H status/control

----------------------------------
Also working on KERMIT for the Bondwell 12/14

The current KERMBW.COM is very buggy.
VT52 support only with a fixed 9600 baud rate with 8 bits and parity set to none.
----------------------------------
Standalone VT100 Terminal

VT100C.COM - VT100 terminal SIO0 9600N8

VT100DG.COM - VT100 terminal emulation test with limited DEC Special Graphics. Using the new Character ROM (2732 Eprom)

Now I’m creating a new character ROM that includes the DEC Special Graphics character set for slightly better VT100 compatibility. I’m also adding support for inverse characters in the terminal code. 
Double-height and double-width characters will not be possible without hardware modifications, so they will not be implemented. Underlining and bold text will also not be supported because of the current hardware and character ROM limitations.
----------------------------------

