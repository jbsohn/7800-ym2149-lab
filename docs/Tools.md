# Toolchain & Architecture Guide

This document describes the compilation, conversion, verification, and packaging tools used across the Lokey 7800 YM project ecosystem.

---

## 1. Multi-Repository Toolchain Architecture

The tooling ecosystem is split across three dedicated repositories:

```
├── lokey-7800-ym2149 (This Repo)
│   ├── pcb/          <-- tscircuit React components & KiCad post-routing scripts
│   ├── pld/          <-- ATF16V8B / ATF22V10 PLD address decoding equations (galette)
│   └── examples/     <-- ca65 6502 assembly drivers & bank-selection demos
│
├── lokey-ym2149-tools (Generic YM2149 Tools)
│   ├── ym-core/      <-- Rust core library (delta compiler, YM parsers, audio engine)
│   └── lym/          <-- Unified CLI binary (song render/play, sfx render/play, mix)
│
└── lokey-7800-tools (Atari 7800 Developer Utilities)
    └── a78tool/      <-- Modern A78 ROM header utility (v1, v3, v4, mappers 0-255)
```

---

## 2. Music & Sound Effect Compilation (`lym`)

Generic YM2149 audio compilation tools reside in [`lokey-ym2149-tools`](file:///Users/john/Projects/lokey-ym2149-tools).

### Features & Capabilities
- **Song Compilation (`.ysg`)**: Compiles `.ym` (Atari ST) files into pattern-deduplicated, delta-encoded binary streams for 6502 replayers.
- **Sound Effects (`.yfx`)**: Compiles JSON, CSV, or AYFX (`.afx`) sound effects into fixed-width 5-byte VBI override streams.
- **Real-Time Auditioning & Mixing**: Auditions tracks via `cpal` audio backend and interactively mixes background music with key-triggered sound effects.

### Command Quick Reference
```bash
# Render YM track to compressed .ysg binary
lym song render --input ym-samples/ND-Loader.ym --output build/ND-Loader.ysg

# Play .ysg track locally
lym song play --input build/ND-Loader.ysg

# Render sound effect JSON to .yfx binary
lym sfx render --input tests/fixtures/test_sfx.json --output build/laser.yfx
```

---

## 3. Atari 7800 ROM Header Packaging (`a78tool`)

Atari 7800 header utilities reside in [`lokey-7800-tools`](file:///Users/john/Projects/lokey-7800-tools).

### Features & Capabilities
- Combines raw 6502 ROM binaries (`.bin`/`.rom`) with 128-byte `.a78` emulator headers.
- Supports v1, v3, and v4 header specifications.
- Handles YM2149 expansion flags (`--ym2149`), POKEY flags (`--pokey`), TV formats (NTSC/PAL), and custom mappers (`mapper 0` for linear 32KB, `mapper 1` for 32-pin YM-IOA bank switching).

### Command Quick Reference
```bash
# Generate .a78 emulator ROM with JSON configuration
a78tool generate -i build/game.bin -o build/game.a78 -c header.json

# Inspect .a78 header fields
a78tool inspect build/game.a78
```

---

## 4. Hardware Logic Compilation (`galette`)

PLD equations for ATF16V8B and ATF22V10 logic chips are compiled using `galette`:

```bash
galette pld/rom_ym_28pin.pld
galette pld/rom_ym_32pin.pld
```
This produces JEDEC fusemaps (`.jed`) ready for programming onto physical GAL/ATF chips.
