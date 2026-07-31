# Lokey 7800 YM

> **Status:** Physical v0.2 PCBs have arrived from the manufacturer — preparing for hand-assembly, soldering, and hardware validation.

## Project Overview

The Atari 7800 community's favorite audio upgrades have a supply problem: POKEY clones run \$10 USD - \$40 USD each — when they're in stock — and the YM2151 has been out of production for decades, commanding collector prices used. The **Lokey 7800 YM** takes a different route: the **YM2149 PSG** — the Atari ST's sound chip — is still manufactured today as the **KC89C72** clone for about $2 USD. One in-production chip brings three-channel sound to the 7800, and with it a direct bridge to four decades of Atari ST music and a tracker ecosystem that is still alive and composing. Original YM2149 chips are also plentiful as used or New-Old-Stock (NOS) parts.

### What's in a Name?

The **Lokey** name is a triple-layered nod to the project's roots:

- **POKEY**: A respectful "cousin" to Atari’s legendary sound chip.
- **Low-Key**: Reflecting our philosophy of a minimalist, stealthy, and cost-effective design.
- **Loki**: Inspired by the Norse god of mischief—bringing a bit of technical "trickery" to the Atari 7800 bus.

The project views the **Atari ST** as a potential **Creation System**.
With established trackers (like Protracker ST or Maxymiser), it offers a path for audio production, generating `.ym` chiptunes for use with our tools on the 7800.

The **Atari 7800** acts as the **Consumer** of these assets. By bridging the hardware gap, we hope to allow the 7800 to play music from the ST era or new compositions from modern trackers.

### Design Goals

- **In-Production Parts Only**: No POKEY or YM2151 unobtainium, and no expensive FPGAs. Every part on the BOM should be sourceable new today (e.g. the KC89C72 YM2149 clone).
- **No SMD**: Hand-solderable through-hole components only, so hobbyists without a hot air rework station can build and repair boards.
- **Low Cost**: Keep the total build cost minimal.
- **Time-Period Accurate**: Stay faithful to what would have been technically feasible/authentic to the Atari 7800/ST era, rather than leaning on modern shortcuts.

### Hardware & Development Status

- **PCB Effort**: Physical v0.2 PCBs (28-pin and 32-pin) designed to fit standard Atari 7800 cartridge shells with mounting holes have arrived from the manufacturer and are awaiting assembly and hardware testing.
- **Reproducible Hardware Builds**: GitHub Actions rebuilds the PLD logic and both PCBs from source on every push. You can also build locally using the preconfigured **Docker Dev Container** (currently supported for building and routing PCBs).
- **Conversion Tools**: Generic YM2149 audio compilation tools (`lym`) live in [`lokey-ym2149-tools`](file:///Users/john/Projects/lokey-ym2149-tools). Atari 7800 ROM header generation (`a78tool`) lives in [`lokey-7800-tools`](file:///Users/john/Projects/lokey-7800-tools).
- **SDK Progress**: We provide ca65 6502 assembly drivers and bank-selection examples (`examples/`) to help developers integrate YM music into 7800 projects.
- **Custom Emulation**: For testing without hardware, we use forks of **a7800** and **js7800** that implement this specific memory mapping. _If this project gains momentum, we hope these changes might eventually be useful to the official upstream projects._

## Status: STABLE ALPHA

We have achieved playback on physical Atari 7800 consoles using a bitmask-compressed register engine (`.ysg`). The current implementation is designed to be efficient, leaving significant CPU time for other tasks.

## See it in Action

### Hardware Prototype

![Atari 7800 YM2149 Cartridge Prototype](docs/prototype.jpg)

### Web Emulator (Instant Play)

Test the bridge right now in your browser using our custom **js7800** fork.
👉 **[Play the YM2149 Demos in your Browser](https://jbsohn.github.io/js7800-ym-player/)**

### Real Hardware (ANCOOL1 Stress Test)

This video shows a physical Atari 7800 playing a full 92-second capture of the "ANCOOL1" track, filling 96% of a single 32KB ROM bank to prove bus stability and engine efficiency.

[![ANCOOL1 Stress Test on Atari 7800 Hardware](https://img.youtube.com/vi/LWzkfaaal2E/0.jpg)](https://www.youtube.com/shorts/LWzkfaaal2E)

## Repository Ecosystem & Documentation

This project is organized across 3 dedicated repositories:
1. **[lokey-7800-ym2149](file:///Users/john/Projects/lokey-7800-ym2149)** (This repo) - PCB hardware designs, PLD logic files, 6502 assembly players, and bank selection examples.
2. **[lokey-ym2149-tools](file:///Users/john/Projects/lokey-ym2149-tools)** - Generic YM2149/AY8910 audio tools, compiler library (`ym-core`), and CLI (`lym`).
3. **[lokey-7800-tools](file:///Users/john/Projects/lokey-7800-tools)** - Atari 7800 utilities including `a78tool` (A78 ROM header utility).

### Project Documentation

- **[Development Guide](CLAUDE.md)** - Technical standards and build process.
- **[AI Development Agents](AGENTS.md)** - Specialized instructions for subagent tasks.
- **[SDK Samples & Building](docs/Samples.md)** - Compile ROMs and set up the environment.
- **[ca65 Assembly Guidelines](docs/Ca65AssemblyGuidelines.md)** - Guidelines for ca65 6502 assembly and ld65 linker configurations.
- **[File Extension Reference](docs/FileExtensions.md)** - Guide to `.s`, `.inc`, `.cfg`, `.pld`, `.rom`, and `.a78` files.
- **[Hardware & Wiring](docs/Hardware.md)** - Shared memory mapping and connector/chip pinouts.
  - **[28-Pin Board](docs/Hardware-28pin.md)** - Single-YM2149, jumper-configured ROM board.
  - **[32-Pin Board](docs/Hardware-32pin.md)** - Bank-switched ROM board (fixed 32KB code + 16KB YM-IOA banked data window, 128KB-256KB).

- **[PCB Design (tscircuit)](docs/PCB.md)** - Code-to-PCB workflow.
- **[Emulator Support](docs/Emulation.md)** - Using `a7800` and `js7800` for development.
- **[Toolchain Architecture](docs/Tools.md)** - Overview of YM tools (`lym`) and header tools (`a78tool`).
- **[Musical Credits](file:///Users/john/Projects/lokey-ym2149-tools/docs/Musicians.md)** - Composers and attributions for test song fixtures in `lokey-ym2149-tools`.

---

## Technical Highlights

- **Hardware**: Uses **YM2149 PSG** mapped to `$0800`/`$0801` (Pokey800-compatible).
- **Compression**: Multi-stage **Pattern-Based Delta Masking** (`.ysg`) for maximum ROM efficiency.
- **Timing**: Automatic **Pitch Scaling** (1.79MHz vs 2.0MHz) ensures tracks stay in tune.
- **Diagnostics**: Built-in **Software Triad** visualizer for bare-metal debugging.

## Acknowledgements & Credits

- **Karri Kaksonen (karrika)**: For the excellent [Otaku-flash](https://github.com/karrika/Otaku-flash) project. We have integrated the **Stable Alpha** Atari 7800 cartridge footprints, symbols, and professional design rules from this MIT-licensed repository.
- **Simon Frankau ([galette](https://github.com/simon-frankau/galette))**: For the open-source **galette** logic assembler. It provides a modern, cross-platform toolchain for compiling ATF16V8B/ATF22V10 logic, saving us from legacy Windows tools.
- **Dan Boris (AtariHQ)**: For the indispensable [7800 Cartridge Technical Specifications](https://atarihq.com/danb/7800cart/a7800cart.shtml) and reference diagrams that made this hardware mapping possible.
- **Arnaud Carré (Leonard/OXG)**: For the excellent [StSound](https://github.com/arnaud-carre/StSound) project. The melodic assets used for hardware testing were sourced via this project's research.
- **Eagle & Ecernosoft**: For the insightful ideas and technical tips provided on the forums, including the Pokey800 mapping recommendation and the inspiration for the "Active Shunt" audio stage design.
- **Original Musicians & Composers**: For the timeless tracks used as benchmarks for this project. See **[Musical Credits](file:///Users/john/Projects/lokey-ym2149-tools/docs/Musicians.md)** for a full list of artists.
- **The Atari Community**: We are grateful to the dedicated fans keeping the 16-bit and 8-bit flames alive through archival and homebrew development.

## Contributing

This project is completely open source, and since this is a first-time PCB design, community feedback and contributions are highly welcome!

## License

This repository is licensed under the **MIT License**. See [LICENSE](LICENSE) for details.
