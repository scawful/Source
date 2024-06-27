; =========================================================
; Goriya Sprite Properties
; =========================================================

!SPRID              = $2C ; The sprite ID you are overwriting (HEX)
!NbrTiles           = 03  ; Number of tiles used in a frame
!Harmless           = 00  ; 00 = Sprite is Harmful,  01 = Sprite is Harmless
!HVelocity          = 00  ; Is your sprite going super fast? put 01 if it is
!Health             = 00  ; Number of Health the sprite have
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
!ImperviousArrow    = 00  ; 01 = Impervious to arrows
!ImpervSwordHammer  = 00  ; 01 = Impervious to sword and hammer attacks
!Boss               = 00  ; 00 = normal sprite, 01 = sprite is a boss

%Set_Sprite_Properties(Sprite_Goriya_Prep, Sprite_Goriya_Long)

; =========================================================

Sprite_Goriya_Long:
{
  PHB : PHK : PLB

  JSR Sprite_Goriya_Draw   ; Call the draw code
  JSL Sprite_DrawShadow
  JSL Sprite_CheckActive   ; Check if game is not paused
  BCC .SpriteIsNotActive   ; Skip Main code is sprite is innactive

  JSR Sprite_Goriya_Main ; Call the main sprite code

  .SpriteIsNotActive
  PLB ; Get back the databank we stored previously
  RTL ; Go back to original code
}

; =========================================================

Sprite_Goriya_Prep:
{
  PHB : PHK : PLB

  LDA.b #$20 : STA.w SprHealth, X

  PLB
  RTL
}

; =========================================================

Sprite_Goriya_Main:
{
  LDA.w SprAction, X
  JSL UseImplicitRegIndexedLocalJumpTable

  dw Goriya_WalkingDown
  dw Goriya_WalkingLeftOrRight
  dw Goriya_WalkingUp

  Goriya_WalkingDown:
  {
    %PlayAnimation(0, 1, 10)
    JSR Sprite_Goriya_Move
    RTS
  }

  Goriya_WalkingLeftOrRight:
  {
    %PlayAnimation(2, 3, 10)
    JSR Sprite_Goriya_Move
    RTS
  }

  Goriya_WalkingUp:
  {
    %PlayAnimation(4, 5, 10)
    JSR Sprite_Goriya_Move
    RTS
  }
}

GoriyaMovementSpeed = 10

Sprite_Goriya_Move:
{
  JSL Sprite_Move
  JSL Sprite_BounceFromTileCollision
  JSL Sprite_PlayerCantPassThrough

  JSL Sprite_DamageFlash_Long

  JSL Sprite_CheckDamageToPlayer
  JSL Sprite_CheckDamageFromPlayer

  LDA.w SprTimerC, X : BNE +
    JSL GetRandomInt : AND.b #$03
    STA.w SprMiscB, X
    %SetTimerC(30)
  +

  LDA.w SprMiscB, X
  JSL UseImplicitRegIndexedLocalJumpTable

  dw Goriya_MoveUp
  dw Goriya_MoveDown
  dw Goriya_MoveLeft
  dw Goriya_MoveRight

  Goriya_MoveUp:
  {
    LDA.b #-GoriyaMovementSpeed : STA.w SprYSpeed, X
    STZ.w SprXSpeed, X
    %GotoAction(2)
    LDA.b #$00 : STA.w SprMiscE, X
    RTS 
  }

  Goriya_MoveDown:
  {
    LDA.b #GoriyaMovementSpeed : STA.w SprYSpeed, X
    STZ.w SprXSpeed, X
    %GotoAction(0)
    LDA.b #$01 : STA.w SprMiscE, X
    RTS 
  }

  Goriya_MoveLeft:
  {
    STZ.w SprYSpeed, X
    LDA.b #GoriyaMovementSpeed : STA.w SprXSpeed, X
    %GotoAction(1)
    LDA.b #$02 : STA.w SprMiscE, X
    RTS 
  }

  Goriya_MoveRight:
  {
    STZ.w SprYSpeed, X
    LDA.b #-GoriyaMovementSpeed : STA.w SprXSpeed, X
    %GotoAction(1)
    LDA.b #$03 : STA.w SprMiscE, X
    RTS 
  }
}

; =========================================================

!BodyForward = $C6
!BodyLeft = $E2
!BodyBackward = $E4
!HeadLeft = $C4
!HeadForward = $C2
!HeadBackward = $C0

; 0-1 : Walking Down
; 2-3 : Walking Left
; 4-5 : Walking Up
Sprite_Goriya_Draw:
{
  JSL Sprite_PrepOamCoord
  JSL Sprite_OAM_AllocateDeferToPlayer

  LDA.w SprGfx, X : CLC : ADC.w SprFrame, X : TAY;Animation Frame
  LDA.w .start_index, Y : STA $06
  LDA.w SprMiscA, X : STA $08
  LDA.w SprMiscE, X : CMP.b #$02 : BCC .not_right
  LDA.b $08 : EOR.b #$40 : STA.b $08
  .not_right

  PHX
    LDX .nbr_of_tiles, Y ;amount of tiles - 1
    LDY.b #$00
    .nextTile
    ; -------------------------------------------------------
    PHX ; Save current Tile Index?
      TXA : CLC : ADC $06 ; Add Animation Index Offset
      PHA ; Keep the value with animation index offset?

      ASL A : TAX 

      REP #$20
        LDA $00 : CLC : ADC .x_offsets, X : STA ($90), Y
        AND.w #$0100 : STA $0E : INY
        LDA $02 : CLC : ADC .y_offsets, X : STA ($90), Y
        CLC : ADC #$0010 : CMP.w #$0100
      SEP #$20
      BCC .on_screen_y

      ; Put the sprite out of the way
      LDA.b #$F0 : STA ($90), Y : STA $0E
      .on_screen_y

    PLX ; Pullback Animation Index Offset (without the *2 not 16bit anymore)
    INY
    LDA .chr, X : STA ($90), Y : INY
    LDA .properties, X : ORA $08 : STA ($90), Y

    PHY  
      TYA : LSR #2 : TAY
      LDA.b #$02 : ORA $0F : STA ($92), Y ; store size in oam buffer
    PLY : INY
        
    PLX : DEX : BPL .nextTile

  PLX

  RTS


  ; =========================================================

  .start_index
  db $00, $02, $04, $06, $08, $0A
  .nbr_of_tiles
  db 1, 1, 1, 1, 1, 1
  .x_offsets
  dw 0, 0
  dw 0, 0
  dw 0, 0
  dw 0, 0
  dw 0, 0
  dw 0, 0
  .y_offsets
  dw 0, -10
  dw 0, -10
  dw 0, -10
  dw -1, -10
  dw 0, -8
  dw 0, -8 
  .chr
  db $C6, $C2
  db $C6, $C2
  db $E2, $C4
  db $E0, $C4
  db $E4, $C0
  db $E4, $C0
  .properties
  db $63, $63
  db $73, $63
  db $63, $63
  db $73, $63
  db $63, $63
  db $73, $63
}