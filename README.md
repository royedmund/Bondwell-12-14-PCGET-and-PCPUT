Here is a polished version for your GitHub `README.md`:

# XMODEM Transfer Utilities for the Bondwell 12/14

XMODEM file transfer utilities for the Bondwell 12 and Bondwell 14 Z80 computers running CP/M 2.2 or CP/M 3.0 Plus.

These utilities allow files to be transferred between a Bondwell CP/M system and any other computer that supports XMODEM send and receive.

`PCGET` and `PCPUT` are based on the work of DeRamp:

[https://deramp.com](https://deramp.com)

They were adapted from the Kaypro 10 versions for use with the Bondwell 12/14 serial ports.

## Bondwell Serial Port Addresses

| Port | Device |  Data | Status/Control |
| ---- | ------ | ----: | -------------: |
| A    | SIO0   | `40H` |          `41H` |
| B    | SIO1   | `42H` |          `43H` |

## Kermit for the Bondwell 12/14

A Bondwell-compatible version of Kermit is also under development.

The current `KERMBW.COM` is experimental and still quite buggy.

Current limitations include:

* VT52 terminal emulation only
* Fixed 9600 baud rate
* 8 data bits
* No parity

## Standalone VT100 Terminal Emulation

The repository also contains experimental standalone VT100 terminal programs.

### VT100C.COM

Standalone VT100 terminal using SIO0.

Serial settings:

* 9600 baud
* 8 data bits
* No parity
* 1 stop bit

### VT100DG.COM

Experimental VT100 terminal emulator with limited DEC Special Graphics support.

This version is intended for use with the new 2732 character ROM image.

## Enhanced Character ROM

A new character ROM has been created that includes the DEC Special Graphics character set for improved VT100 compatibility.

The terminal code is also being updated to support inverse characters.

Because of the limitations of the Bondwell video hardware and character ROM system, the following features will not be implemented:

* Double-height characters
* Double-width characters
* Underlined text
* Bold text

Many other VT100 features will also remain unsupported because they would require hardware modifications or more advanced video attribute support.

This software should therefore be considered a limited VT100-compatible terminal implementation rather than a complete VT100 emulator.

----------------------------------------------
## Demo release VT100B
## VT100B Compatibility

VT100B provides limited VT100/ANSI terminal emulation for the Bondwell 12/14.

### Supported

* 80-column text display
* Cursor movement and direct cursor positioning
* Screen and line erase functions
* Scrolling and reverse index
* Save and restore cursor position
* Inverse video
* DEC Special Graphics
* G0/G1 character-set switching
* Device status and cursor-position reports
* Normal and application cursor-key modes
* Bondwell cursor-key translation
* Local exit using `Ctrl-] C`

### Limitations

VT100B does not support:

* Double-width or double-height text
* Underline, bold, blink or colour
* 132-column mode
* Programmable tab stops
* Scrolling regions
* Insert/delete character or line operations
* Numeric keypad emulation
* Full VT52 mode
* Complete VTTEST compatibility

Unsupported sequences are generally consumed and ignored to reduce unwanted characters on screen.



