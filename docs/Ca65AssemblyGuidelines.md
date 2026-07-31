# ca65 6502 Assembly Guidelines

This project uses **ca65** and **ld65** from the open-source `cc65` toolchain suite for all Atari 7800 6502 assembly development.

---

## 1. Toolchain & Build Commands

Compilation is a two-step process: assembling source files into `.o` objects, and linking them via `ld65` with a memory configuration file (`.cfg`):

```bash
# 1. Assemble source file to object file
ca65 -I include examples/bank.s -o build/bank.o

# 2. Link object file to 256KB banked ROM binary using linker script
ld65 -C examples/a7800_banked.cfg build/bank.o -o build/bank.bin

# 3. Sign ROM for Atari 7800 hardware
7800sign -w build/bank.rom && 7800sign -t build/bank.rom

# 4. Generate .a78 emulator ROM
a78tool generate -i build/bank.rom -o build/bank.a78 -c examples/bank.json
```

---

## 2. Includes & Directives

- Use `.include "file.inc"` to include register equates (`maria.inc`, `ym2149.inc`, `stella.inc`).
- Use `.zeropage` for zero-page RAM allocations and `.res <count>` to reserve bytes.
- Use `.segment "CODE"`, `.segment "RODATA"`, `.segment "FOOTER"`, and `.segment "VECTORS"`.

```ca65
.include "maria.inc"
.include "ym2149.inc"

.zeropage
bank_num: .res 1

.segment "CODE"

.export reset
reset:
    sei
    cld
    ldx #$FF
    txs
```

---

## 3. Macros & Segments

Macros use `.macro` ... `.endmacro`. Segments map directly to memory areas specified in `include/a7800.cfg` or `include/a7800_banked.cfg`.

```ca65
.macro NOTE_BANK segname, fine, coarse
.segment segname
    .byte fine, coarse
.endmacro
```

---

## 4. Vectors & Footer

Atari 7800 ROMs require the 2-byte encryption footer at `$FFF8` and vectors at `$FFFA-$FFFF`:

```ca65
.segment "FOOTER"
    .byte $FF, $83

.segment "VECTORS"
    .word reset
    .word reset
    .word reset
```
