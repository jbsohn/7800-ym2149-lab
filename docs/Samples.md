# Samples & Building Guide

This guide covers the sample applications included with the Lokey-YM repository and provides instructions on how to build them using **ca65** and **ld65**.

---

## 1. Prerequisites

To build the samples and cartridge ROMs, you need the following:

* **Assembler & Linker**: **ca65** and **ld65** from the `cc65` toolchain suite.
* **Header Tool**: **a78tool** ([`lokey-7800-tools`](file:///Users/john/Projects/lokey-7800-tools)).
* **Signing Tool**: **7800sign**.

---

## 2. Core Samples

The samples reside in `examples/`:

* **32-Pin Bank Switching Demo (`examples/bank.s`)**: Demonstrates hardware bank switching via the YM2149 IOA port across 14 switched banks (`$4000-$7FFF`) using ca65 macros, segment definitions, and `ld65` memory configurations (`examples/a7800_banked.cfg`).

---

## 3. Build Instructions

Builds are managed via the root `Makefile`.

### Build Commands

| Target | Command | Description |
| :--- | :--- | :--- |
| **Banked Demo** | `make bank` | Build the 32-pin YM-IOA bank switching demo (`build/bank.a78` + `build/bank.rom`). |
| **Logic Files** | `make logic` | Build PLD JEDEC fusemaps via `galette`. |
| **PCB Gerbers** | `make pcb` | Compile and autoroute 32-pin PCB layout. |
| **Cleanup** | `make clean` | Remove all generated build artifacts. |

### Build Results
All ROM build artifacts output to `build/`:
- **`.a78`**: Emulator ROM packaged with a 128-byte header via `a78tool`.
- **`.rom`**: Raw binary ROM image, signed for hardware via `7800sign`.

---

## 4. Hardware Deployment

### Signing for Real 7800 Hardware

Atari 7800 cartridges must be signed. `make bank` and `make rom` handle this automatically using `7800sign`:

```bash
7800sign -w build/bank.rom
7800sign -t build/bank.rom
```

For guidelines on ca65 assembly and linker configurations, see the **[ca65 Assembly Guidelines](Ca65AssemblyGuidelines.md)**.
