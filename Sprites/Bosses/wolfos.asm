; =========================================================
; Wolfos Sprite Properties
; =========================================================

!SPRID              = $A9 ; The sprite ID you are overwriting (HEX)
!NbrTiles           = 03  ; Number of tiles used in a frame
!Harmless           = 00  ; 00 = Sprite is Harmful,  01 = Sprite is Harmless
!HVelocity          = 00  ; Is your sprite going super fast? put 01 if it is
!Health             = 90  ; Number of Health the sprite have
!Damage             = 00  ; (08 is a whole heart), 04 is half heart
!DeathAnimation     = 00  ; 00 = normal death, 01 = no death animation
!ImperviousAll      = 00  ; 00 = Can be attack, 01 = attack will clink on it
!SmallShadow        = 00  ; 01 = small shadow, 00 = no shadow
!Shadow             = 00  ; 00 = don't draw shadow, 01 = draw a shadow 
!Palette            = 00  ; Unused in this template (can be 0 to 7)
!Hitbox             = 00  ; 00 to 31, can be viewed in sprite draw tool
!Persist            = 00  ; 01 = your sprite continue to live offscreen
!Statis             = 00  ; 00 = is sprite is alive?, (kill all enemies room)
!CollisionLayer     = 00  ; 01 = will check both layer for collision
!CanFall            = 00  ; 01 sprite can fall in hole, 01 = can't fall
!DeflectArrow       = 00  ; 01 = deflect arrows
!WaterSprite        = 00  ; 01 = can only walk shallow water
!Blockable          = 00  ; 01 = can be blocked by link's shield?
!Prize              = 00  ; 00-15 = the prize pack the sprite will drop from
!Sound              = 00  ; 01 = Play different sound when taking damage
!Interaction        = 00  ; ?? No documentation
!Statue             = 00  ; 01 = Sprite is statue
!DeflectProjectiles = 00  ; 01 = Sprite will deflect ALL projectiles
!ImperviousArrow    = 01  ; 01 = Impervious to arrows
!ImpervSwordHammer  = 00  ; 01 = Impervious to sword and hammer attacks
!Boss               = 00  ; 00 = normal sprite, 01 = sprite is a boss
%Set_Sprite_Properties(Sprite_Wolfos_Prep, Sprite_Wolfos_Long)

; =========================================================

Sprite_Wolfos_Long:
{
  PHB : PHK : PLB

  JSR Sprite_Wolfos_Draw
  JSR Sprite_Wolfos_CheckIfDefeated
  JSL Sprite_CheckActive   ; Check if game is not paused
  BCC .SpriteIsNotActive   ; Skip Main code is sprite is innactive

  JSR Sprite_Wolfos_Main ; Call the main sprite code

  .SpriteIsNotActive
  PLB ; Get back the databank we stored previously
  RTL ; Go back to original code
}

; =========================================================

Sprite_Wolfos_Prep:
{
  PHB : PHK : PLB
    
  LDA.b #$40 : STA.w SprTimerA, X
  LDA.b #$00 : STA.w $0CAA, X ; Sprite persist in dungeon
  LDA.b #$08 : STA.w $0E40, X ; Nbr Oam Entries 
  LDA.b #$E0 : STA.w $0F60, X ; Persist 

  PLB
  RTL
}

Sprite_Wolfos_CheckIfDefeated:
{
  LDA SprHealth, X : BNE .not_defeated
    LDA.b #$06 : STA SprAction, X ; Set to defeated
    LDA.b #$01 : STA SprHealth, X ; Refill the health of the sprite
    RTS
  .not_defeated
  RTS
}

; =========================================================

macro Wolfos_Move()
  JSL Sprite_DamageFlash_Long
  JSL Sprite_CheckDamageFromPlayerLong : BCC + 

  +
  JSL Sprite_PlayerCantPassThrough
  JSL Sprite_BounceFromTileCollision

  JSL Sprite_Move
  JSR Wolfos_DecideAction
endmacro

Wolfos_DecideAction:
{
  LDA SprTimerA, X : BNE .decide_new_action
    RTS
  .decide_new_action

  JSL Sprite_DirectionToFacePlayer
  LDA $0E ; y distance from player
  STA SprMiscC, X
  LDA $0F ; x distance from player
  STA SprMiscB, X

  LDA SprMiscC, X
  CMP #$10 ; Check if y distance is significant
  BCS .adjust_y
  LDA SprMiscB, X
  CMP #$10 ; Check if x distance is significant
  BCS .adjust_x

  .adjust_y
  JSL Sprite_IsBelowPlayer
  TYA
  BEQ .above_player
  %GotoAction(1) ; Attack Back
  RTS

  .above_player
  %GotoAction(0) ; Attack Forward
  RTS

  .adjust_x
  JSL Sprite_IsToRightOfPlayer
  TYA
  BEQ .right
  %GotoAction(3) ; Walk Left
  RTS

  .right
  %GotoAction(2) ; Walk Right
  RTS
}

!NormalSpeed = $08
!AttackSpeed = $0D

Sprite_Wolfos_Main:
{
  LDA.w SprAction, X
  JSL UseImplicitRegIndexedLocalJumpTable

  dw Wolfos_AttackForward ; 0x00
  dw Wolfos_AttackBack    ; 0x01
  dw Wolfos_WalkRight     ; 0x02
  dw Wolfos_WalkLeft      ; 0x03
  dw Wolfos_AttackRight   ; 0x04
  dw Wolfos_AttackLeft    ; 0x05
  dw Wolfos_Subdued       ; 0x06
  dw Wolfos_GrantMask     ; 0x07

  Wolfos_AttackForward:
  {
    %PlayAnimation(0, 2, 10)
    %Wolfos_Move()

    LDA #!NormalSpeed
    STA.w SprYSpeed, X

    LDA #$30
    STA SprTimerA, X

    RTS
  }

  Wolfos_AttackBack:
  {
    %PlayAnimation(3, 5, 10)
    %Wolfos_Move()

    LDA #-!NormalSpeed
    STA.w SprYSpeed, X

    LDA #$30
    STA SprTimerA, X

    RTS
  }

  Wolfos_WalkRight:
  {
    %StartOnFrame(6)
    %PlayAnimation(6, 8, 10)
    %Wolfos_Move()
    
    LDA #!NormalSpeed
    STA.w SprXSpeed, X
    STZ.w SprYSpeed, X

    JSL GetRandomInt : AND.b #$3F : BNE +
      %GotoAction(4)
    +

    LDA #$30
    STA SprTimerA, X

    RTS
  }

  Wolfos_WalkLeft:
  {
    %StartOnFrame(9)
    %PlayAnimation(9, 11, 10)
    %Wolfos_Move()

    LDA #-!NormalSpeed
    STA.w SprXSpeed, X
    STZ.w SprYSpeed, X

    JSL GetRandomInt : AND.b #$3F : BNE +
      %GotoAction(5)
    +

    LDA #$30
    STA SprTimerA, X

    RTS
  }

  Wolfos_AttackRight:
  {
    %StartOnFrame(12)
    %PlayAnimation(12, 13, 10)
    JSL Sprite_PlayerCantPassThrough
    JSL Sprite_BounceFromTileCollision

    JSL Sprite_Move

    LDA #!AttackSpeed
    STA.w SprXSpeed, X

    LDA SprTimerA, X : BNE +
      %GotoAction(2)
    +

    RTS
  }

  Wolfos_AttackLeft:
  {
    %StartOnFrame(14)
    %PlayAnimation(14, 15, 10)
    JSL Sprite_PlayerCantPassThrough
    JSL Sprite_BounceFromTileCollision

    JSL Sprite_Move

    LDA #-!AttackSpeed
    STA.w SprXSpeed, X

     LDA SprTimerA, X : BNE +
      %GotoAction(3)
    +

    RTS
  }

  Wolfos_Subdued:
  {
    %PlayAnimation(0, 0, 10)
    STZ.w SprXSpeed, X
    STZ.w SprYSpeed, X

    ; Run the dialogue and wait for a song of healing flag to be set
    LDA SprMiscD, X : BEQ .wait
    %ShowSolicitedMessage($20) : BCC .no_hablaba
      LDA.b #$01 : STA SprMiscD, X
      .wait
      LDA   $FE : BEQ .ninguna_cancion
        STZ   $FE
        LDA.b #$C0 : STA.w SprTimerD, X
        %GotoAction(7)
      .ninguna_cancion
    .no_hablaba
    RTS
  }

  Wolfos_GrantMask:
  {
    %PlayAnimation(0, 0, 10)

    LDY   #$13 : STZ $02E9     ; Give the Wolf Mask
    JSL   Link_ReceiveItem
    LDA   #$01 : STA.l $7EF303 ; Set the special flag

    LDA SprTimerD, X : BEQ .no_dialogue
      LDA.b #$06 : STA $0DD0, X ; kill sprite normal style
    .no_dialogue
    RTS
  }
}

Sprite_TimerAction:
{
  LDA.w SprTimerA, X : BEQ .reset_timer
    DEC.w SprTimerA, X
  RTS

  .reset_timer
  LDA #$30 : STA SprTimerA, X
  %GotoAction(0) ; Default to attack forward
  RTS
}


; =========================================================
; Animation Frame
; 0-2 Attack Forward
; 3-5 Attack Back
; 6-8 Walk Right 
; 9-11 Walk Left
; 12-13 Attack Right
; 14-15 Attack Left

Sprite_Wolfos_Draw:
{
  JSL Sprite_PrepOamCoord
  JSL Sprite_OAM_AllocateDeferToPlayer

  LDA $0DC0, X : CLC : ADC $0D90, X : TAY ;Animation Frame
  LDA .start_index, Y : STA $06

  ; Store Palette thing 
  LDA $0DA0, X : STA $08

  PHX
  LDX .nbr_of_tiles, Y ;amount of tiles -1
  LDY.b #$00
  .nextTile

  PHX ; Save current Tile Index?
      
  TXA : CLC : ADC $06 ; Add Animation Index Offset

  PHA ; Keep the value with animation index offset?

  ASL A : TAX 

  REP #$20

  LDA $00 : CLC : ADC .x_offsets, X : STA ($90), Y
  AND.w #$0100 : STA $0E 
  INY
  LDA $02 : CLC : ADC .y_offsets, X : STA ($90), Y
  CLC : ADC #$0010 : CMP.w #$0100
  SEP #$20
  BCC .on_screen_y

  LDA.b #$F0 : STA ($90), Y ;Put the sprite out of the way
  STA $0E
  .on_screen_y

  PLX ; Pullback Animation Index Offset (without the *2 not 16bit anymore)
  INY
  LDA .chr, X : STA ($90), Y
  INY
  ; Set palette flash modifier 
  LDA .properties, X : ORA $08 : STA ($90), Y

  PHY 
      
  TYA : LSR #2 : TAY
      
  LDA .sizes, X : ORA $0F : STA ($92), Y ; store size in oam buffer
      
  PLY : INY
      
  PLX : DEX : BPL .nextTile

  PLX

  RTS

  .start_index
  db $00, $02, $04, $06, $08, $0A, $0C, $10, $14, $18, $1C, $20, $24, $28, $2B, $2F
  .nbr_of_tiles
  db 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 2, 3, 2
  .x_offsets
  dw 0, 0
  dw 0, 0
  dw 0, 0
  dw 0, 0
  dw 0, 0
  dw 0, 0
  dw 8, -8, -8, 8
  dw -8, 8, 8, -8
  dw -8, 8, -8, 8
  dw -8, 8, 8, -8
  dw 8, -8, -8, 8
  dw 8, -8, 8, -8
  dw -8, 8, 8, -8
  dw -8, 8, 8
  dw 8, -8, -8, 8
  dw 8, -8, -8
  .y_offsets
  dw 0, -16
  dw 0, -16
  dw 0, -16
  dw 0, -16
  dw 0, -16
  dw 0, -16
  dw 0, 0, -16, -16
  dw 0, 0, -16, -16
  dw -16, -16, 0, 0
  dw 0, 0, -16, -16
  dw 0, 0, -16, -16
  dw -16, -16, 0, 0
  dw 0, 0, -16, -16
  dw 0, 0, -16
  dw 0, 0, -16, -16
  dw 0, 0, -16
  .chr
  db $E0, $C0
  db $E4, $C4
  db $E6, $C6
  db $E2, $C2
  db $E8, $C8
  db $EA, $CA
  db $A2, $A0, $80, $82
  db $A4, $A6, $86, $84
  db $88, $8A, $A8, $AA
  db $A2, $A0, $80, $82
  db $A4, $A6, $86, $84
  db $88, $8A, $A8, $AA
  db $AC, $AE, $8E, $8C
  db $EC, $EE, $CE
  db $AC, $AE, $8E, $8C
  db $EC, $EE, $CE
  .properties
  db $39, $39
  db $39, $39
  db $39, $39
  db $39, $39
  db $39, $39
  db $39, $39
  db $39, $39, $39, $39
  db $39, $39, $39, $39
  db $39, $39, $39, $39
  db $79, $79, $79, $79
  db $79, $79, $79, $79
  db $79, $79, $79, $79
  db $39, $39, $39, $39
  db $39, $39, $39
  db $79, $79, $79, $79
  db $79, $79, $79
  .sizes
  db $02, $02
  db $02, $02
  db $02, $02
  db $02, $02
  db $02, $02
  db $02, $02
  db $02, $02, $02, $02
  db $02, $02, $02, $02
  db $02, $02, $02, $02
  db $02, $02, $02, $02
  db $02, $02, $02, $02
  db $02, $02, $02, $02
  db $02, $02, $02, $02
  db $02, $02, $02
  db $02, $02, $02, $02
  db $02, $02, $02

}