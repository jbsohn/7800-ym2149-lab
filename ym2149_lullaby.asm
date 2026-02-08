        processor 6502

; Simple YM2149 "lullaby" (3‑note motif) for Atari 7800
; Uses write‑only $0460/$0461, header v4 from a78_ym2149_header.asm

AY_ADDR = $0460
AY_DATA = $0461

; Periods for NTSC 1.789772 MHz clock
; A4 440 Hz -> ~254
; G4 392 Hz -> ~285
; E4 330 Hz -> ~339
NOTE_A_LO = <254
NOTE_A_HI = >254
NOTE_G_LO = <285
NOTE_G_HI = >285
NOTE_E_LO = <339
NOTE_E_HI = >339

        ORG $8000
        include "a78_ym2149_header.asm"

RESET:
        SEI
        CLD
        LDX #$FF
        TXS

        ; Enable tone A only, no noise
        LDA #$07
        STA AY_ADDR
        LDA #%00111110
        STA AY_DATA

        ; Volume A = max
        LDA #$08
        STA AY_ADDR
        LDA #$0F
        STA AY_DATA

MAIN:
        JSR NOTE_A
        JSR NOTE_G
        JSR NOTE_E
        JSR NOTE_G
        JMP MAIN

NOTE_A:
        LDA #$00
        STA AY_ADDR
        LDA #NOTE_A_LO
        STA AY_DATA
        LDA #$01
        STA AY_ADDR
        LDA #NOTE_A_HI
        STA AY_DATA
        JSR DELAY
        RTS

NOTE_G:
        LDA #$00
        STA AY_ADDR
        LDA #NOTE_G_LO
        STA AY_DATA
        LDA #$01
        STA AY_ADDR
        LDA #NOTE_G_HI
        STA AY_DATA
        JSR DELAY
        RTS

NOTE_E:
        LDA #$00
        STA AY_ADDR
        LDA #NOTE_E_LO
        STA AY_DATA
        LDA #$01
        STA AY_ADDR
        LDA #NOTE_E_HI
        STA AY_DATA
        JSR DELAY
        RTS

DELAY:
        LDY #$E0
DELAY_Y:
        LDX #$FF
DELAY_X:
        DEX
        BNE DELAY_X
        DEY
        BNE DELAY_Y
        RTS

        ORG $FFFA
        .word RESET
        .word RESET
        .word RESET
