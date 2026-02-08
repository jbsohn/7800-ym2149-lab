        processor 6502

; -------------------------
; YM2149 write-only ports
; -------------------------
AY_ADDR = $0460
AY_DATA = $0461

; -------------------------
; Notes (YM2149 tone period = f_clk / (16 * f_out))
; f_clk ≈ 1.789772 MHz
; C4 ~ 261.6 Hz -> period ≈ 1,789,772 / (16*261.6) ≈ 427
; E4 ~ 329.6 Hz -> period ≈ 339
; G4 ~ 392.0 Hz -> period ≈ 285
; -------------------------
NOTE_C_LO = <427
NOTE_C_HI = >427
NOTE_E_LO = <339
NOTE_E_HI = >339
NOTE_G_LO = <285
NOTE_G_HI = >285

        ORG $8000

        ; -------------------------
        ; A78 HEADER (v4)
        ; -------------------------
        include "a78_ym2149_header.asm"

RESET:
        SEI
        CLD
        LDX #$FF
        TXS

        ; -------------------------
        ; YM2149 init
        ; -------------------------
        ; Disable noise, enable tone A only
        LDA #$07
        STA AY_ADDR
        LDA #%00111110
        STA AY_DATA

        ; Set volume A to max (fixed volume)
        LDA #$08
        STA AY_ADDR
        LDA #$0F
        STA AY_DATA

MAIN_LOOP:
        ; C4
        LDA #$00
        STA AY_ADDR
        LDA #NOTE_C_LO
        STA AY_DATA
        LDA #$01
        STA AY_ADDR
        LDA #NOTE_C_HI
        STA AY_DATA
        JSR DELAY

        ; E4
        LDA #$00
        STA AY_ADDR
        LDA #NOTE_E_LO
        STA AY_DATA
        LDA #$01
        STA AY_ADDR
        LDA #NOTE_E_HI
        STA AY_DATA
        JSR DELAY

        ; G4
        LDA #$00
        STA AY_ADDR
        LDA #NOTE_G_LO
        STA AY_DATA
        LDA #$01
        STA AY_ADDR
        LDA #NOTE_G_HI
        STA AY_DATA
        JSR DELAY

        JMP MAIN_LOOP

; -------------------------
; Delay loop
; -------------------------
DELAY:
        LDY #$60
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
