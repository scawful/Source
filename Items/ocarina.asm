; =========================================================
; Ocarina Multiple Song Select
;
; =========================================================

org $0994FE
  AddTravelBird:

org $098D11
  AddWeathervaneExplosion:

org $078021
  Player_DoSfx1:

; =========================================================
; Song of Healing 

; SFX2_Accomp
; SFX2 13 (Previous $3E)
org $1A8C60
  db $00

; SFX2_13
org $1A9750
Song_of_Healing:
{
  db $E0, $0D
  db $2A ; change this to change length of quarter note
  db $46
  db $A3, $A1, $9D
  db $A3, $A1, $9D
  db $A3, $A1
  db $15 ; make this half of whatever you made quarter note
  db $9C, $9A
  db $7F ; make this triple whatever you made quarter note (max value 7F)
  db $9C
  db $00
}

; =========================================================

; D F D - D F D - E F E - F E C
; D F d D F d e f e f e c
; SFX2_12
; org $1A977D

!Storms_Duration = $0F
!Storms_Params = $46

!Storms_Duration2 = $1E
!Storms_Params2 = $3C

; SFX1_18
org $1A8F93
Song_of_Storms:
{
  db $E0, $0D ; set sfx instrument - twee

  db !Storms_Duration
  db !Storms_Params ; duration 1/4
  db $9A ; play note D3
  db $9D ; play note F3
  db !Storms_Duration2
  db !Storms_Params ; duration 1/2
  db $9A ; play note D3

  db !Storms_Duration
  db !Storms_Params ; duration 1/4
  db $9A ; play note D3
  db $9D ; play note F3
  db !Storms_Duration2
  db !Storms_Params ; duration 1/2
  db $9A ; play note D3
  
  db !Storms_Duration
  db !Storms_Params2 ; duration 1/4
  db $9C ; play note E3
  db $9D ; play note F3
  db $9C ; play note E3

  db $9D ; play note F3
  db $9C ; play note E3
  db !Storms_Duration2
  db !Storms_Params2 ; duration 1/2
  db $98 ; play note C3

  db $00 ; end sfx
}
; =========================================================

org $07A3DB
LinkItem_FluteHook:
{
  JSR LinkItem_NewFlute
  RTS
}

; =========================================================

; Free Space Bank07
org $07FC69
ReturnFromFluteHook:
  RTS

; =========================================================

LinkItem_NewFlute:
{
  ; Code for the flute item (with or without the bird activated)
  
  BIT $3A : BVC .y_button_not_held
  DEC $03F0 : LDA $03F0 : BNE ReturnFromFluteHook
  LDA $3A : AND.b #$BF : STA $3A

.y_button_not_held

  ; Check for Switch Swong 
  JSR UpdateFluteSong
  JSR Link_CheckNewY_ButtonPress : BCC ReturnFromFluteHook
  
  ; Success... play the flute.
  LDA.b #$80 : STA $03F0
  
  LDA $030F
  CMP.b #$01 : BEQ .song_of_soaring
  CMP.b #$02 : BEQ .song_of_healing
  CMP.b #$03 : BEQ .song_of_storms

.song_of_healing
  LDA.b #$13 : JSR Player_DoSfx2 
  LDA #$01 : STA $FE
  RTS

.song_of_storms
  ; Play the Song of Storms SFX
  ; LDA.b #$12 : JSR Player_DoSfx2 
  LDA.b #$18 : JSR Player_DoSfx1
  JSL OcarinaEffect_SummonStorms
  RTS

.song_of_soaring
  LDA.b #$3E : JSR Player_DoSfx2

  ; Are we indoors?
  LDA $1B : BNE .return
  
  ; Are we in the dark world? The flute doesn't work there.
  LDA $8A : AND.b #$40 : BNE .return
  
  ; Also doesn't work in special areas like Master Sword area.
  LDA $10 : CMP.b #$0B : BEQ .return
  
  LDX.b #$04

.next_ancillary_slot

  ; Is there already a travel bird effect in this slot?
  LDA $0C4A, X : CMP.b #$27 : BEQ .return
  
  ; If there isn't one, keep checking.
  DEX : BPL .next_ancillary_slot

  ; Paul's weathervane stuff Do we have a normal flute (without bird)?
  LDA $7EF34C : CMP.b #$02 : BNE .travel_bird_already_released
  
  REP #$20

  ; check the area, is it #$18 = 30?
  LDA $8A : CMP.w #$0018 : BNE .not_weathervane_trigger
  
  ; Y coordinate boundaries for setting it off.
  LDA $20
  
  CMP.w #$0760 : BCC .not_weathervane_trigger
  CMP.w #$07E0 : BCS .not_weathervane_trigger
  
  ; do if( (Ycoord >= 0x0760) && (Ycoord < 0x07e0
  LDA $22
  
  CMP.w #$01CF : BCC .not_weathervane_trigger
  CMP.w #$0230 : BCS .not_weathervane_trigger
  
  ; do if( (Xcoord >= 0x1cf) && (Xcoord < 0x0230)
  SEP #$20
  ; Apparently a special Overworld mode for doing this?
  LDA.b #$2D : STA $11
  
  ; Trigger the sequence to start the weathervane explosion.
  LDY.b #$00
  LDA.b #$37
  JSL AddWeathervaneExplosion

.not_weathervane_trigger

  SEP #$20
  BRA .return

.travel_bird_already_released

  LDY.b #$04
  LDA.b #$27
  JSL AddTravelBird
  STZ $03F8

.return

  RTS
}

; =========================================================

; $030F - Current Song RAM
; 00 - No Song
; 01 - Song of Healing
; 02 - Song of Soaring 
; 03 - Song of Storms

UpdateFluteSong:
{
  LDA $030F : BNE .songExists
  LDA #$01 : STA $030F  ; if this code is running, we have the flute song 1
.songExists
  LDA.b $F6
  BIT.b #$20 : BNE .left
  BIT.b #$10 : BNE .right

  RTS

.left
  ; LDA.b #$13 : JSR Player_DoSfx2
  DEC $030F
  LDA $030F
  BNE .notPressed

  LDA #$03
  STA $030F
  JMP .notPressed

.right
  ; R Button Pressed - Increment song
  INC $030F        ; increment $030F Song RAM
  LDA $030F        ; load incremented Song RAM
  CMP.b #$04       ; compare with 3
  BCC .notPressed    ; if less than 3, branch to .notFlute

  LDA #$01         ; load value 1
  STA $030F        ; set Song RAM to 1

.notPressed
  RTS
}
pushpc

; ZS OW
; Load the rain overlay by default for the song of storms
org $02B011
  LDX #$009F

org $3C8000
OcarinaEffect_SummonStorms:
{
  LDA.l $7EE00E : BEQ .summonStorms
  LDA #$FF : STA $8C
  LDA #$00 : STA $7EE00E
  STZ $1D
  STZ $9A
  RTL

.summonStorms
  ; LDA #$16 : STA $11
  LDA #$9F : STA $8C
  LDA.b #$01 : STA.b $1D
  LDA.b #$72 : STA.b $9A
  LDA #$01 : STA $7EE00E
  RTL
}

CheckRealTable:
{
  LDA $7EE00E : CMP #$00 : BEQ .continue
  JML $02A4CD+12 ; Jump to rain sound effect
.continue
  LDA.b $8A : ASL : TAX
  LDA.l Pool_OverlayTable, X
  CMP.b #$9F : BEQ .summonStorms
  RTL
.summonStorms
  JML RainAnimation_Overridden_rainOverlaySet
}

; ZS OW
org $02A4CD
RainAnimation_Overridden:
{
  JSL CheckRealTable
    LDA.b $8C : CMP.b #$9F : BEQ .rainOverlaySet
    ; Check the progress indicator
    LDA.l $7EF3C5 : CMP.b #$02 : BRA .skipMovement
  .rainOverlaySet

    ; If misery mire has been opened already, we're done.
    ;LDA.l $7EF2F0 : AND.b #$20 : BNE .skipMovement
    ; Check the frame counter.
    ; On the third frame do a flash of lightning.
    LDA.b $1A

    CMP.b #$03 : BEQ .lightning ; On the 0x03rd frame, cue the lightning.
      CMP.b #$05 : BEQ .normalLight ; On the 0x05th frame, normal light level.
        CMP.b #$24 : BEQ .thunder ; On the 0x24th frame, cue the thunder.
          CMP.b #$2C : BEQ .normalLight ; On the 0x2Cth frame, normal light level.
            CMP.b #$58 : BEQ .lightning ; On the 0x58th frame, cue the lightning.
              CMP.b #$5A : BNE .moveOverlay ; On the 0x5Ath frame, normal light level.

  .normalLight

    ; Keep the screen semi-dark.
    LDA.b #$72

    BRA .setBrightness

  .thunder

    ; Play the thunder sound when outdoors.
    LDX.b #$36 : STX.w $012E

  .lightning

    LDA.b #$32 ; Make the screen flash with lightning.

  .setBrightness

    STA.b $9A

  .moveOverlay

    ; Overlay is only moved every 4th frame.
    LDA.b $1A : AND.b #$03 : BNE .skipMovement
        LDA.w $0494 : INC A : AND.b #$03 : STA.w $0494 : TAX

        LDA.b $E1 : CLC : ADC.l $02A46D, X : STA.b $E1
        LDA.b $E7 : CLC : ADC.l $02A471, X : STA.b $E7

  .skipMovement

    RTL
}
warnpc $02A52D

pullpc