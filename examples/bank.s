; ============================================================
; bank.s -- 32-pin board YM-IOA bank select test (ca65):
; A chromatic scale, one note per bank, using every free bank.
; ============================================================

.include "maria.inc"
.include "ym2149.inc"

NUM_NOTES        = 14          ; C4 C#4 D4 D#4 E4 F4 F#4 G4 G#4 A4 A#4 B4 C5 C#5
NOTE_HOLD_FRAMES = 60          ; 1s per note at 60Hz NTSC

.zeropage
bank_num: .res 1

; --- Bank Data Segments (Banks 0..13) ---
.macro NOTE_BANK segname, fine, coarse
.segment segname
    .byte fine, coarse
.endmacro

NOTE_BANK "BANK0",  $AC, $01      ; bank  0: C4
NOTE_BANK "BANK1",  $94, $01      ; bank  1: C#4
NOTE_BANK "BANK2",  $7D, $01      ; bank  2: D4
NOTE_BANK "BANK3",  $68, $01      ; bank  3: D#4
NOTE_BANK "BANK4",  $53, $01      ; bank  4: E4
NOTE_BANK "BANK5",  $40, $01      ; bank  5: F4
NOTE_BANK "BANK6",  $2E, $01      ; bank  6: F#4
NOTE_BANK "BANK7",  $1D, $01      ; bank  7: G4
NOTE_BANK "BANK8",  $0D, $01      ; bank  8: G#4
NOTE_BANK "BANK9",  $FE, $00      ; bank  9: A4
NOTE_BANK "BANK10", $F0, $00      ; bank 10: A#4
NOTE_BANK "BANK11", $E2, $00      ; bank 11: B4
NOTE_BANK "BANK12", $D6, $00      ; bank 12: C5
NOTE_BANK "BANK13", $CA, $00      ; bank 13: C#5

.segment "CODE"

.export reset
reset:
        sei
        cld
        ldx #$FF
        txs

        ldx #NUM_REGS-1
init_loop:
        stx AY_ADDR
        lda #0
        sta AY_DATA
        dex
        bpl init_loop

        lda #AY_MIXER
        sta AY_ADDR
        lda #(AY_IOA_OUTPUT | %00111110)
        sta AY_DATA

        lda #8
        sta AY_ADDR
        lda #15
        sta AY_DATA

        lda #0
        sta bank_num

note_loop:
        lda #AY_IO_A
        sta AY_ADDR
        lda bank_num
        sta AY_DATA

        lda #0
        sta AY_ADDR
        lda $4000
        sta AY_DATA

        lda #1
        sta AY_ADDR
        lda $4001
        sta AY_DATA

        lda bank_num
        asl
        asl
        asl
        asl
        sta BKGRND

        ldy #NOTE_HOLD_FRAMES
hold_loop:
        jsr sync_vbi
        dey
        bne hold_loop

        inc bank_num
        lda bank_num
        cmp #NUM_NOTES
        bne note_loop
        lda #0
        sta bank_num
        jmp note_loop

sync_vbi:
v1:     bit MSTAT
        bmi v1
v2:     bit MSTAT
        bpl v2
        rts

.segment "FOOTER"
        .byte $FF, $83

.segment "VECTORS"
        .word reset
        .word reset
        .word reset
