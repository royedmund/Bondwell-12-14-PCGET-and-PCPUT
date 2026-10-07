# XMODEM Transfer Utilities for the Bondwell 12/14

## Quick start and file selection

For XMODEM transfers, copy the chosen `.COM` utility to your CP/M disk. The `PCGETBW` / `PCPUTBW` sources preserve the existing CP/M serial configuration; the `PCGET.ASM` variant explicitly initialises the SIO. Match the serial speed and format on both computers.

```text
A>PCGETBW FILE.EXT
A>PCPUTBW FILE.EXT
```

The default is Port A; append `B` to select Port B. Start XMODEM send on the other computer when using `PCGETBW`, or XMODEM receive when using `PCPUTBW`. The source implements 128-byte checksum XMODEM; choose a compatible mode in the host transfer tool. `PCGET` deletes an existing destination file before receiving, so choose the filename carefully.

## Repository layout

| Files | Purpose |
| --- | --- |
| `PCGET*` / `PCPUT*` | XMODEM transfer source, `.COM` executables and `.HEX` images |
| `VT100B.*`, `VT100C.*`, `VT100DG.*` | Separate experimental terminal versions; capabilities vary |
| `KERMTBW.COM` / `KERMTBW.HEX` | Experimental Kermit binaries; no Kermit assembly source is included |
| `CHAROM.BIN`, `CHAROM_DEC_SPECIAL.BIN`, `BOOTROM.BIN` | Supplied ROM images |
| PDFs, JPGs and `Kermit-80 Notes.TXT` | Hardware, character-set and protocol references |
| [readme](readme) | Earlier short transfer notes; this README is the main guide |

The flat layout suits CP/M file transfers and preserves existing links. No single reproducible build script covers all variants. Consult each assembly header for syntax and hardware assumptions; the presence of a `.COM` file alone does not prove it was rebuilt from the matching source. Retain DeRamp and other original attribution when redistributing.

---


XMODEM file transfer utilities for the Bondwell 12 and Bondwell 14 Z80 computers running CP/M 2.2 or CP/M 3.0 Plus.

These utilities allow files to be transferred between a Bondwell CP/M system and any other computer that supports XMODEM send and receive.

`PCGET` and `PCPUT` are based on the work of DeRamp:

https://deramp.com

They were adapted from the Kaypro 10 versions for use with the Bondwell 12/14 serial ports.

## Bondwell Serial Port Addresses

| Port | Device |  Data | Status/Control |
| ---- | ------ | ----: | -------------: |
| A    | SIO0   | `40H` |          `41H` |
| B    | SIO1   | `42H` |          `43H` |

## Kermit for the Bondwell 12/14

A Bondwell-compatible version of Kermit is also under development.

The current `KERMTBW.COM` release is experimental and still quite buggy.

Current limitations include:

* VT52 terminal emulation only
* Fixed 9600 baud rate
* 8 data bits
* No parity

## Standalone VT100 Terminal Emulation

This repository also contains experimental standalone VT100 terminal programs.

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

Because of limitations in the Bondwell video hardware and character ROM system, the following features will not be implemented:

* Double-height characters
* Double-width characters
* Underlined text
* Bold text

Many other VT100 features will remain unsupported because they would require hardware modifications or more advanced video attribute support.

This software should therefore be considered a limited VT100-compatible terminal implementation rather than a complete VT100 emulator.

---

## VT100B demo release

`VT100B` provides limited VT100 and ANSI terminal emulation for the Bondwell 12/14.

## Supported Features

* 80-column text display
* Cursor movement
* Direct cursor positioning
* Screen erase functions
* Line erase functions
* Scrolling
* Reverse index
* Save and restore cursor position
* Inverse video
* DEC Special Graphics
* G0 and G1 character-set switching
* Device status reports
* Cursor-position reports
* Normal cursor-key mode
* Application cursor-key mode
* Bondwell cursor-key translation
* Local exit using `Ctrl-] C`

## Known Issues

Some terminal applications, including Nano, may display control sequences as text. This issue is still being investigated.

`Ctrl+X` cannot currently be used to exit Nano because the Bondwell keyboard maps this control code to the down-arrow key.

As a temporary workaround, use:

```text
Ctrl-] X
```

Backspace support has improved but may still be unreliable at the CP/M command line.

## Unsupported Features

`VT100B` does not support:

* Double-width text
* Double-height text
* Underline
* Bold
* Blink
* Colour
* 132-column mode
* Programmable tab stops
* Scrolling regions
* Insert-character operations
* Delete-character operations
* Insert-line operations
* Delete-line operations
* Numeric keypad emulation
* Full VT52 mode
* Complete VTTEST compatibility

Unsupported escape sequences are generally consumed and ignored to reduce the number of unwanted control characters displayed on the screen.

`VT100B` should be considered an experimental demo release rather than a complete VT100 terminal implementation.
