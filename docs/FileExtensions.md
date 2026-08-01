# Atari 7800 YM2149 Project File Reference

This document describes the file extensions and build artifacts used within the **lokey-7800-ym2149** hardware, PLD logic, and 6502 driver repository.

> **Note:** Audio compilation formats (`.ysg`, `.yfx`, `.ysi`, `.ym`) are documented in [`lokey-ym2149-tools/docs/FileFormats.md`](file:///Users/john/Projects/lokey-ym2149-tools/docs/FileFormats.md). Emulator header packaging formats (`.a78`) are documented in [`lokey-7800-tools/docs/A78HeaderSpec.md`](file:///Users/john/Projects/lokey-7800-tools/docs/A78HeaderSpec.md).

---

## 1. Hardware & Assembly Source Files

| Extension | Name | Category | Description |
| :--- | :--- | :--- | :--- |
| **`.s`** | ca65 Assembly Source | 6502 Drivers | 6502 assembly source files for bank selection demos and drivers (e.g., `examples/bank.s`). |
| **`.inc`** | ca65 Include Header | 6502 Equates | Register equate definitions for Atari 7800 MARIA, TIA, and YM2149 (e.g., `../examples/maria.inc`, `ym2149.inc`). |
| **`.cfg`** | ld65 Linker Script | Linker Config | Memory layout definitions for fixed 32KB (`examples/a7800.cfg`) and 256KB banked ROMs (`examples/a7800_banked.cfg`). |
| **`.pld`** | CUPL Logic Source | PLD Logic | GAL/PLD logic equations for address decoding and YM bank switching (e.g., `pld/rom_ym_32pin.pld`). |
| **`.circuit.tsx`** | tscircuit Component | PCB Design | Code-driven React PCB layout definitions in `pcb/` (e.g., `28pin.circuit.tsx`, `32pin.circuit.tsx`). |
| **`.json`** | A78 Header Config | Tooling Config | Header configuration file consumed by `a78tool` (e.g., `header.json`, `examples/bank.json`). |

---

## 2. Build & Target Artifacts (`build/`)

| Extension | Name | Category | Description |
| :--- | :--- | :--- | :--- |
| **`.o`** | Object File | Assembly | Intermediate object file produced by `ca65`. |
| **`.bin`** | Raw Binary | ROM Image | Unsigned, unheadered binary image produced by `ld65`. |
| **`.rom`** | Signed Hardware ROM | Hardware | 32KB to 256KB binary ROM image **signed** for hardware via `7800sign`. |
| **`.a78`** | Emulator ROM | Emulation | Signed ROM payload combined with a 128-byte A78 emulator header via `a78tool`. |
| **`.jed`** | JEDEC Fusemap | Hardware | Compiled fusemap binary for ATF16V8B / ATF22V10 PLDs, generated from `.pld` via `galette`. |
