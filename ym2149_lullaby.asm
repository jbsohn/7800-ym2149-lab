        processor 6502

; Simple YM2149 "lullaby" (3‑note motif) for Atari 7800
; Uses write‑only $0460/$0461, header v4 from a78_ym2149_header.asm

ay_addr = $0460
ay_data = $0461
speed_mult = 4

; Periods for NTSC 1.789772 MHz clock
; A4 440 Hz -> ~254
; G4 392 Hz -> ~285
; E4 330 Hz -> ~339
note_a_lo = <254
note_a_hi = >254
note_g_lo = <285
note_g_hi = >285
note_e_lo = <339
note_e_hi = >339

        org $8000
        include "a78_ym2149_header.asm"

reset:
        sei
        cld
        ldx #$ff
        txs

        ; Enable tone A only, no noise
        lda #$07
        sta ay_addr
        lda #%00111110
        sta ay_data

        ; Volume A = max
        lda #$08
        sta ay_addr
        lda #$0f
        sta ay_data

main:
        jsr note_a
        jsr note_g
        jsr note_e
        jsr note_g
        jmp main

note_a:
        lda #$00
        sta ay_addr
        lda #note_a_lo
        sta ay_data
        lda #$01
        sta ay_addr
        lda #note_a_hi
        sta ay_data
        jsr delay_tempo
        rts

note_g:
        lda #$00
        sta ay_addr
        lda #note_g_lo
        sta ay_data
        lda #$01
        sta ay_addr
        lda #note_g_hi
        sta ay_data
        jsr delay_tempo
        rts

note_e:
        lda #$00
        sta ay_addr
        lda #note_e_lo
        sta ay_data
        lda #$01
        sta ay_addr
        lda #note_e_hi
        sta ay_data
        jsr delay_tempo
        rts

delay:
        ldy #$e0
delay_y:
        ldx #$ff
delay_x:
        dex
        bne delay_x
        dey
        bne delay_y
        rts

delay_tempo:
        ldx #speed_mult
delay_tempo_loop:
        jsr delay
        dex
        bne delay_tempo_loop
        rts

        org $fffa
        .word reset
        .word reset
        .word reset
