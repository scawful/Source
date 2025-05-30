; =========================================================
; Portal Sprite
; =========================================================

!SPRID              = Sprite_Portal
!NbrTiles           = 01  ; Number of tiles used in a frame
!Harmless           = 00  ; 00 = Sprite is Harmful,  01 = Sprite is Harmless
!HVelocity          = 00  ; Is your sprite going super fast? put 01 if it is
!Health             = 00  ; Number of Health the sprite have
!Damage             = 00  ; (08 is a whole heart), 04 is half heart
!DeathAnimation     = 00  ; 00 = normal death, 01 = no death animation
!ImperviousAll      = 00  ; 00 = Can be attack, 01 = attack will clink on it
!SmallShadow        = 00  ; 01 = small shadow, 00 = no shadow
!Shadow             = 00  ; 00 = don't draw shadow, 01 = draw a shadow
!Palette            = 00  ; Unused in this Portal (can be 0 to 7)
!Hitbox             = 00  ; 00 to 31, can be viewed in sprite draw tool
!Persist            = 01  ; 01 = your sprite continue to live offscreen
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
%Set_Sprite_Properties(Sprite_Portal_Prep, Sprite_Portal_Long)

Sprite_Portal_Long:
{
  PHB : PHK : PLB
  JSR Sprite_Portal_Draw
  JSL Sprite_CheckActive : BCC .SpriteIsNotActive
    JSR Sprite_Portal_Main
  .SpriteIsNotActive
  PLB
  RTL
}

Sprite_Portal_Prep:
{
  PHB : PHK : PLB
  ; Persist outside of camera
  LDA #$00 : STA.w SprDefl, X
  LDA.w SprHitbox, X : AND.b #$C0 : STA.w SprHitbox, X
  STZ.w SprTileDie, X
  LDA.b #$FF : STA.w SprBulletproof, X
  PLB
  RTL
}

; =========================================================
; FREE RAM: 0x08

BluePortal_X      = $7E06F8
BluePortal_Y      = $7E06F9
OrangePortal_X    = $7E06FA
OrangePortal_Y    = $7E06FB

BlueActive        = $7E06FC
OrangeActive      = $7E06FD
; OrangePortal_Y_Low  = $7E06FE
; OrangePortal_Y_High = $7E06FF

OrangeSpriteIndex = $7E0633
BlueSpriteIndex   = $7E0632

Sprite_Portal_Main:
{
  LDA.w SprAction, X
  JSL   JumpTableLocal

  dw StateHandler
  dw BluePortal
  dw OrangePortal

  dw BluePortal_WarpDungeon
  dw OrangePortal_WarpDungeon

  dw BluePortal_WarpOverworld
  dw OrangePortal_WarpOverworld

  StateHandler:
  {
    JSR CheckForDismissPortal
    JSR RejectOnTileCollision

    LDA $7E0FA6 : BNE .BluePortal
      LDA #$01 : STA $0307
      TXA : STA.w OrangeSpriteIndex
      LDA.w SprY, X : STA.w OrangePortal_X
      LDA.w SprX, X : STA.w OrangePortal_Y
      LDA.b #$01 : STA.w SprSubtype, X
      %GotoAction(2)
      RTS
    .BluePortal
    LDA #$02 : STA $0307
    TXA : STA.w BlueSpriteIndex
    LDA.w SprY, X : STA.w BluePortal_X
    LDA.w SprX, X : STA.w BluePortal_Y
    LDA.b #$02 : STA.w SprSubtype, X
    %GotoAction(1)
    RTS
  }

  BluePortal:
  {
    %StartOnFrame(0)
    %PlayAnimation(0,1,8)

    LDA $11 : CMP.b #$2A : BNE .not_warped_yet
      STZ $11
    .not_warped_yet
    CLC

    LDA.w SprTimerD, X : BNE .NoOverlap
      JSL Link_SetupHitBox
      JSL $0683EA          ; Sprite_SetupHitbox_long
      JSL CheckIfHitBoxesOverlap : BCC .NoOverlap
      CLC
      LDA $1B : BEQ .outdoors
      %GotoAction(3) ; BluePortal_WarpDungeon
    .NoOverlap
    RTS

    .outdoors
    %GotoAction(5) ; BluePortal_WarpOverworld
    RTS
  }

  OrangePortal:
  {
    %StartOnFrame(2)
    %PlayAnimation(2,3,8)
    LDA $11 : CMP.b #$2A : BNE .not_warped_yet
      STZ $11
    .not_warped_yet
    CLC
    LDA.w SprTimerD, X : BNE .NoOverlap
    JSL Link_SetupHitBox
    JSL $0683EA          ; Sprite_SetupHitbox_long

    JSL CheckIfHitBoxesOverlap : BCC .NoOverlap
    CLC
    ; JSL $01FF28 ; Player_CacheStatePriorToHandler

    LDA $1B : BEQ .outdoors
      %GotoAction(4) ; OrangePortal_WarpDungeon
      .NoOverlap
      RTS

    .outdoors
    %GotoAction(6) ; OrangePortal_WarpOverworld
    RTS
  }

  BluePortal_WarpDungeon:
  {
    LDA $7EC184 : STA $20
    LDA $7EC186 : STA $22

    LDA $7EC188 : STA $0600
    LDA $7EC18A : STA $0604
    LDA $7EC18C : STA $0608
    LDA $7EC18E : STA $060C

    PHX
    LDA.w OrangeSpriteIndex : TAX
    LDA #$40 : STA.w SprTimerD, X
    LDA.w SprY,                X : STA $7EC184
    STA.w BluePortal_Y
    LDA.w SprX,                X : STA $7EC186
    STA.w BluePortal_X
    PLX

    LDA #$14 : STA $11
    %GotoAction(1) ; Return to BluePortal
    RTS
  }

  OrangePortal_WarpDungeon:
  {
    LDA $7EC184 : STA $20
    LDA $7EC186 : STA $22

    ; Camera Scroll Boundaries
    LDA $7EC188 : STA $0600 ; Small Room North
    LDA $7EC18A : STA $0604 ; Small Room South
    LDA $7EC18C : STA $0608 ; Small Room West
    LDA $7EC18E : STA $060C ; Small Room South

    PHX
    LDA.w BlueSpriteIndex : TAX
    LDA #$40 : STA.w SprTimerD, X
    LDA.w SprY,                X : STA $7EC184
    STA.w OrangePortal_Y
    LDA.w SprX,                X : STA $7EC186
    STA.w OrangePortal_X
    PLX

    LDA #$14 : STA $11
    %GotoAction(2) ; Return to OrangePortal
    RTS
  }

  BluePortal_WarpOverworld:
  {
    LDA.w OrangePortal_X : STA $20
    LDA.w OrangePortal_Y : STA $22
    LDA $7EC190 : STA $0610
    LDA $7EC192 : STA $0612
    LDA $7EC194 : STA $0614
    LDA $7EC196 : STA $0616

    JSL ApplyLinksMovementToCamera

    PHX ; Infinite loop prevention protocol
    LDA.w OrangeSpriteIndex : TAX
    LDA #$40 : STA.w SprTimerD, X

    PLX
    LDA #$01 : STA $5D
    ;LDA #$2A : STA $11
    %GotoAction(1) ; Return to BluePortal
    RTS
  }

  OrangePortal_WarpOverworld:
  {
    LDA.w BluePortal_X : STA $20
    LDA.w BluePortal_Y : STA $22
    LDA $7EC190 : STA $0610
    LDA $7EC192 : STA $0612
    LDA $7EC194 : STA $0614
    LDA $7EC196 : STA $0616

    JSL ApplyLinksMovementToCamera

    PHX
    LDA.w BlueSpriteIndex : TAX
    LDA #$40 : STA.w SprTimerD, X
    PLX

    LDA #$01 : STA $5D
    ;LDA #$2A : STA $11

    %GotoAction(2) ; Return to BluePortal
    RTS
  }
}

CheckForDismissPortal:
{
  LDA $06FE : CMP.b #$02 : BCC .return
    LDA $7E0FA6 : BEQ .DespawnOrange ; Check what portal is spawning next
      PHX
        LDA.w BlueSpriteIndex : TAX
        STZ.w SprState, X
        DEC.w $06FE
      PLX
    .DespawnOrange
    PHX
      LDA.w OrangeSpriteIndex : TAX
      STZ.w SprState, X
      DEC.w $06FE
    PLX
  RTS

  .return
  INC $06FE ; This ticker needs to be reset when transitioning rooms and maps.
  RTS
}

RejectOnTileCollision:
{
  LDA.w SprY, X : AND #$F8 : STA.b $00 : LDA.w SprYH, X : STA.b $01
  LDA.w SprX, X : AND #$F8 : STA.b $02 : LDA.w SprXH, X : STA.b $03

  ; Fetch tile attributes based on current coordinates
  LDA.b #$00 : JSL Sprite_GetTileAttr

  ; Load the tile index
  LDA $0FA5 : CLC : CMP.b #$00 : BEQ .not_out_of_bounds
                    CMP.b #$48 : BEQ .not_out_of_bounds

    ; Clear the sprite and make an error sound
    LDA #$3C ; SFX2.3C Error beep
    STA $012E ; Queue sound effect

    LDA #$00 : STA.w SprState, X
    DEC $06FE

  .not_out_of_bounds
  RTS
}

Sprite_Portal_Draw:
{
  JSL Sprite_PrepOamCoord
  JSL Sprite_OAM_AllocateDeferToPlayer

  LDA $0DC0, X : CLC : ADC $0D90, X : TAY;Animation Frame
  LDA .start_index, Y : STA $06

  PHX
  LDX   .nbr_of_tiles, Y ;amount of tiles -1
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
  CLC   : ADC #$0010 : CMP.w #$0100
  SEP   #$20
  BCC   .on_screen_y

  LDA.b #$F0 : STA ($90), Y ;Put the sprite out of the way
  STA   $0E
  .on_screen_y

  PLX ; Pullback Animation Index Offset (without the *2 not 16bit anymore)
  INY
  LDA .chr, X : STA ($90), Y
  INY
  LDA .properties, X : STA ($90), Y

  PHY

  TYA : LSR #2 : TAY

  LDA.b #$02 : ORA $0F : STA ($92), Y ; store size in oam buffer

  PLY : INY

  PLX : DEX : BPL .nextTile

  PLX

  RTS

  .start_index
    db $00, $01, $02, $03
  .nbr_of_tiles
    db 0, 0, 0, 0
  .x_offsets
    dw 0
    dw 0
    dw 0
    dw 0
  .y_offsets
    dw 0
    dw 0
    dw 0
    dw 0
  .chr
    db $EE
    db $EE
    db $EE
    db $EE
  .properties
    db $24
    db $64
    db $22
    db $62
}
