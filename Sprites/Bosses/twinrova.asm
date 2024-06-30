; =========================================================
; Twinrova Boss Sprite
;
; Overrides Blind and the Blind Maiden to create a new 
; boss sequence. 
;
; =========================================================

!SPRID              = $CE ; The sprite ID you are overwriting (HEX)
!NbrTiles           = 06  ; Number of tiles used in a frame
!Harmless           = 00  ; 00 = Sprite is Harmful,  01 = Sprite is Harmless
!HVelocity          = 00  ; Is your sprite going super fast? put 01 if it is
!Health             = 00  ; Number of Health the sprite have
!Damage             = 00  ; (08 is a whole heart), 04 is half heart
!DeathAnimation     = 00  ; 00 = normal death, 01 = no death animation
!ImperviousAll      = 00  ; 00 = Can be attack, 01 = attack will clink on it
!SmallShadow        = 00  ; 01 = small shadow, 00 = no shadow
!Shadow             = 01  ; 00 = don't draw shadow, 01 = draw a shadow 
!Palette            = 00  ; Unused in this Twinrova (can be 0 to 7)
!Hitbox             = 03  ; 00 to 31, can be viewed in sprite draw tool
!Persist            = 00  ; 01 = your sprite continue to live offscreen
!Statis             = 00  ; 00 = is sprite is alive?, (kill all enemies room)
!CollisionLayer     = 01  ; 01 = will check both layer for collision
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
!Boss               = 01  ; 00 = normal sprite, 01 = sprite is a boss
%Set_Sprite_Properties(Sprite_Twinrova_Prep, Sprite_Twinrova_Long)

; =========================================================

Sprite_Twinrova_Long:
{
    PHB : PHK : PLB

    JSR Sprite_Twinrova_Draw 
    JSL Sprite_DrawShadow

    JSL Sprite_CheckActive : BCC .SpriteIsNotActive 

    JSR Sprite_Twinrova_CheckIfDead
    JSR Sprite_Twinrova_Main

  .SpriteIsNotActive
    PLB
    RTL
}

; =========================================================

Sprite_Twinrova_CheckIfDead:
{
  LDA SprAction, X : CMP.b #$0A : BEQ .not_dead
    ; If health is negative, set back to zero
    LDA SprHealth, X : CMP.b #$C3 : BCC .health_not_negative
      LDA.b #$00 : STA.w SprHealth, X

  .health_not_negative
    LDA SprHealth, X : BNE .not_dead
      PHX 
      LDA.b #$04 : STA $0DD0, X     ; Kill sprite boss style
      LDA.b #$0A : STA.w SprAction, X ; Go to Twinrova_Dead stage
      LDA.b #$10 : STA.w $0D90, X
      PLX
  .not_dead
  RTS
}

; =========================================================

Sprite_Twinrova_Prep:
{
  PHB : PHK : PLB

  ; Kill the sprite if the Maiden is present
  LDA.l $7EF3CC : CMP.b #$06 : BNE .prep_twinrova
    STZ.w $0DD0, X
  .prep_twinrova

  LDA.b #$5A : STA.w SprHealth, X ; Health
  LDA.b #$80 : STA $0CAA, X
  LDA.b #$04 : STA $0CD2, X ; Bump damage type (4 hearts, green tunic)
  LDA.w $0E60, X : AND.b #$BF : STA.w $0E60, X ; Not invincible 

  %SetSpriteSpeedX(15)
  %SetSpriteSpeedX(15)

  ; Blind Boss startup configuration
  LDA.b #$10 : STA $08
  LDA.b #$10 : STA $09

  LDA.b #$60 : STA.w SprTimerC, X
  LDA.b #$01 : STA.w SprMiscB, X
  LDA.b #$02 : STA.w SprMiscC, X
  LDA.b #$04 : STA.w SprMiscE, X
  LDA.b #$07 : STA.w SprGfx, X
  STZ.w $0B69

  PLB
  RTL
}

; =========================================================

!AnimSpeed = 8

macro Twinrova_Front()
  %PlayAnimation(0,1,!AnimSpeed)
endmacro

macro Twinrova_Back()
  %PlayAnimation(2,3,!AnimSpeed)
endmacro

macro Twinrova_Ready()
  %PlayAnimation(4,6,!AnimSpeed)
endmacro

macro Twinrova_Attack()
  %PlayAnimation(7,7,!AnimSpeed)
endmacro

macro Show_Koume()
  %PlayAnimation(8,8,!AnimSpeed)
endmacro

macro Show_Kotake()
  %PlayAnimation(9,9,!AnimSpeed)
endmacro

macro Twinrova_Hurt()
  %PlayAnimation(10,11,!AnimSpeed)
endmacro

; =========================================================

; Phase 0: Blind Maiden turns into Twinrova.
;          Initially should be invisible, then
;          transfer in Twinrova gfx and run dialogue.
;
; Phase 1: Twinrova is one entity, moving around the room
;          and shooting fire and ice attacks at Link.
;          Similar to the Trinexx attacks.
;
; Phase 2: Twinrova alternates between Koume (fire) and 
;          Kotake (ice) forms. Koume changes the arena
;          to a fire arena. Similar to Ganon fight changes.

Sprite_Twinrova_Main:
{
  JSL Sprite_PlayerCantPassThrough
  JSL Sprite_DamageFlash_Long

  LDA.w SprAction, X
  JSL   UseImplicitRegIndexedLocalJumpTable
  
  dw Twinrova_Init          ; 0x00
  dw Twinrova_MoveState     ; 0x01
  dw Twinrova_MoveForwards  ; 0x02
  dw Twinrova_MoveBackwards ; 0x03
  dw Twinrova_PrepareAttack ; 0x04
  dw Twinrova_FireAttack    ; 0x05
  dw Twinrova_IceAttack     ; 0x06
  dw Twinrova_Hurt          ; 0x07
  dw Twinrova_KoumeMode     ; 0x08
  dw Twinrova_KotakeMode    ; 0x09
  dw Twinrova_Dead          ; 0x0A

  ; -------------------------------------------------------
  ; 0x00 
  Twinrova_Init:
  {
    %ShowUnconditionalMessage($123)
    LDA.w SprTimerD, X : BNE +
      LDA.b #$20 : STA.w SprTimerD, X
      %GotoAction(1)
    +
    RTS
  }

  ; -------------------------------------------------------
  ; 0x01
  Twinrova_MoveState:
  {
    STZ.w $0360
    LDA SprHealth, X : CMP.b #$20 : BCS .phase_1
      ; -------------------------------------------
      ; Phase 2
      LDA SprTimerE, X : BNE .kotake
        LDA #$70 : STA.w SprTimerD, X
        %GotoAction(8) ; Koume Mode
        RTS
      .kotake
        LDA #$70 : STA.w SprTimerD, X
        %GotoAction(9) ; Kotake Mode
        RTS

    ; ---------------------------------------------
    .phase_1
    LDA $0DA0 : BEQ .not_flashing
      LDA.b #$30 : STA.w SprTimerD, X
      %GotoAction(7) ; Goto Twinrova_Hurt
      RTS
    .not_flashing

    JSL GetRandomInt : AND.b #$3F : BNE +
      LDA.b #$20 : STA.w SprTimerD, X
      STZ   $AC      ; Set the fire attack
      %GotoAction(4) ; Prepare Attack
      RTS
    +

    JSL GetRandomInt : AND.b #$3F : BNE ++
      LDA.b #$20 : STA.w SprTimerD, X
      LDA   #$01 : STA $AC ; Set the ice attack
      %GotoAction(4) ; Prepare Attack
      RTS
    ++

    JSL GetRandomInt : AND.b #$0F : BEQ .random_strafe
        JSL Sprite_IsBelowPlayer : TYA : BNE .MoveBackwards
        %GotoAction(2) ; Move Forwards
        RTS
    .random_strafe
        JSL GetRandomInt : AND.b #$01 : BEQ .strafe_left
            LDA #$10 : STA.w SprXSpeed, X
            %GotoAction(2) ; Move Forwards with strafe
            RTS
        .strafe_left
            LDA #$F0 : STA.w SprXSpeed, X
            %GotoAction(2) ; Move Forwards with strafe
            RTS

    .MoveBackwards
      %GotoAction(3) ; MoveBackwards
      RTS
  }

  ; -------------------------------------------------------
  ; 0x02 - Twinrova_MoveForwards
  Twinrova_MoveForwards:
  {
    %Twinrova_Front()

    PHX 
    JSL Sprite_CheckDamageFromPlayerLong
    %DoDamageToPlayerSameLayerOnContact()
    PLX 

    LDA #$10  ; Set speed
    JSL Sprite_FloatTowardPlayer
    JSL Sprite_CheckTileCollision

    %GotoAction(1)
    RTS
  }

  ; -------------------------------------------------------
  ; 0x03 - Twinrova_MoveBackwards
  Twinrova_MoveBackwards:
  {
    %Twinrova_Back()

    PHX 
    JSL Sprite_CheckDamageFromPlayerLong
    %DoDamageToPlayerSameLayerOnContact()
    PLX 

    LDA #$20
    JSL Sprite_FloatTowardPlayer
    JSL Sprite_CheckTileCollision

    %GotoAction(1)
    RTS
  }

  ; -------------------------------------------------------
  ; 0x04
  Twinrova_PrepareAttack:
  {
      %StartOnFrame(7)
      %Twinrova_Attack()

      LDA #$01 : STA $0360

      LDA $0CAA : AND.b #$03 : STA $0CAA
      LDA SprTimerD, X : BNE +
        LDA $0CAA : ORA.b #$03 : STA $0CAA
        LDA.b #$40 : STA.w SprTimerD, X
        LDA   $AC : BEQ .fire
          %GotoAction(6) ; Ice Attack
          RTS
      .fire
          %GotoAction(5)
    +
      RTS
  }

  ; -------------------------------------------------------
  ; 0x05
  Twinrova_FireAttack:
  {
    %StartOnFrame(4)
    %Twinrova_Ready()

    JSR Sprite_Twinrova_FireAttack

    ; Random chance to release fireball
    JSL GetRandomInt : AND.b #$3F : BNE ++
      JSR ReleaseFireballs
    ++

    LDA.w SprTimerD, X : BNE +
      %GotoAction(1)
    +
    RTS
  }

  ; -------------------------------------------------------
  ; 0x06
  Twinrova_IceAttack:
  {
    %StartOnFrame(4)
    %Twinrova_Ready()

    JSR Sprite_Twinrova_IceAttack

    LDA.w SprTimerD, X : BNE +
      %GotoAction(1)
    +
    RTS
  }

  ; -------------------------------------------------------
  ; 0x07
  Twinrova_Hurt:
  {
    %StartOnFrame(10)
    %Twinrova_Hurt()
    
    ; Check if hurt timer is zero, if not keep flashing hurt animation
    LDA.w SprTimerD, X : BNE .HurtAnimation

    ; Determine dodge or retaliate behavior
    JSL GetRandomInt
    AND.b #$07  ; 1 in 8 chance for dodge/retaliate
    BNE .DodgeOrRetaliate
    BRA .ResumeNormalState

    .DodgeOrRetaliate
        ; Determine whether to dodge or retaliate
        JSL GetRandomInt
        AND.b #$01
        BEQ .PerformDodge
        BRA .PerformRetaliate

    .PerformDodge
        JSR DoRandomStrafe
        LDA.b #$20 : STA.w SprTimerA, X  ; Set timer for dodge duration
        LDA.b #$02 : STA.w SprMiscA, X  ; Set state to random strafe
        RTS

    .PerformRetaliate
        ; Immediate retaliation with fire or ice attack
        JSL GetRandomInt
        AND.b #$01
        BEQ .FireAttack
        BRA .IceAttack

    .FireAttack
        LDA.b #$20 : STA.w SprTimerD, X
        STZ $AC  ; Set fire attack
        %GotoAction(4) ; Prepare Attack
        RTS

    .IceAttack
        LDA.b #$20 : STA.w SprTimerD, X
        LDA.b #$01 : STA $AC  ; Set ice attack
        %GotoAction(4) ; Prepare Attack
        RTS

    .ResumeNormalState
        %GotoAction(1)  ; Resume normal movement state
        RTS

    .HurtAnimation
      RTS
  }

  ; -------------------------------------------------------
  ; 0x08
  Twinrova_KoumeMode:
  {
    %StartOnFrame(8)
    %Show_Koume()

    PHX
    JSL Sprite_CheckDamageFromPlayerLong
    %DoDamageToPlayerSameLayerOnContact()
    PLX 

    JSL GetRandomInt : AND.b #$3F : BNE ++
      JSR AddPitHazard
      JSR Ganon_SpawnFallingTilesOverlord
    ++

    ; Random chance to release fireball
    JSL GetRandomInt : AND.b #$3F : BNE +++
      JSL Sprite_SpawnFireball
    +++

    
    JSR RageModeMove

    LDA SprTimerD, X : BNE +
      LDA #$70 : STA.w SprTimerE, X
      %GotoAction(1)
    +
    RTS
  }

  ; -------------------------------------------------------
  ; 0x09
  Twinrova_KotakeMode:
  {
    %StartOnFrame(9)
    %Show_Kotake()

    PHX
    JSL Sprite_CheckDamageFromPlayerLong
    %DoDamageToPlayerSameLayerOnContact()
    PLX 

    JSL Sprite_IsBelowPlayer 
    CPY #$01 : BEQ .not_below
      JSL GetRandomInt : AND.b #$3F : BNE ++
        JSL $1DE612 ; Sprite_SpawnLightning
        LDA #$30
        JSL Sprite_ProjectSpeedTowardsPlayer
      ++
    .not_below

    JSR RageModeMove

    JSL GetRandomInt : AND.b #$0F : BNE +++
      JSR RestoreFloorTile
    +++

    LDA SprTimerD, X : BNE +
      %GotoAction(1)
    +
    RTS
  }

  ; -------------------------------------------------------
  ; 0x0A
  Twinrova_Dead:
  {
    %StartOnFrame(11)
    %Twinrova_Hurt()
    RTS
  }
}


; =========================================================
; Handles dynamic floaty movement for Twinrova
; =========================================================

RageModeMove:
{
  ; If timer is zero, determine a new movement mode
  LDA SprTimerA, X : BEQ .DetermineMovementMode

  ; Execute current movement mode
  LDA SprMiscA, X
  CMP #$01 : BEQ .MoveTowardsPlayer
  CMP #$02 : BEQ .RandomStrafe
  CMP #$03 : BEQ .RandomDodge
  CMP #$04 : BEQ .StayInPlace

  JMP .UpdatePosition

  .DetermineMovementMode
  ; Determine random movement mode with weighted probabilities
  JSL GetRandomInt
  AND.b #$0F
  CMP.b #$05
  BCC .SetMoveTowardsPlayer  ; 0-5 -> Predictive movement towards player
  CMP.b #$0A
  BCC .SetRandomStrafe       ; 6-10 -> Random strafe
  CMP.b #$0E
  BCC .SetRandomDodge        ; 11-14 -> Random dodge
  ; 15 -> Stay in place
  LDA.b #$04 : STA.w SprMiscA, X
  LDA.b #$30 : STA.w SprTimerA, X  ; Set timer for 48 frames
  RTS
  BRA .StayInPlace

  .SetMoveTowardsPlayer
  LDA.b #$01 : STA.w SprMiscA, X
  LDA.b #$30 : STA.w SprTimerA, X  ; Set timer for 48 frames
  BRA .MoveTowardsPlayer

  .SetRandomStrafe
  LDA.b #$02 : STA.w SprMiscA, X
  LDA.b #$30 : STA.w SprTimerA, X  ; Set timer for 48 frames
  BRA .RandomStrafe

  .SetRandomDodge
  LDA.b #$03 : STA.w SprMiscA, X
  LDA.b #$30 : STA.w SprTimerA, X  ; Set timer for 48 frames
  BRA .RandomDodge

  .MoveTowardsPlayer
  ; Predictive movement towards player with altitude increase
  JSL Sprite_DirectionToFacePlayer
  JSL Sprite_ApplySpeedTowardsPlayer
  LDA.b #$10 : STA.w SprHeight, X ; Set height
  BRA .UpdatePosition

  .RandomStrafe
  JSR DoRandomStrafe
  BRA .UpdatePosition

  .RandomDodge
  ; Random dodge with controlled movement
  JSL GetRandomInt
  AND.b #$03
  TAY
  LDA VelocityOffsets+4, Y : STA.w SprXSpeed, X
  INY
  LDA VelocityOffsets, Y : STA.w SprYSpeed, X
  LDA.b #$10 : STA.w SprHeight, X ; Set height
  BRA .UpdatePosition

  .StayInPlace
  ; Stay in place to prepare for attack or other action
  STZ.w SprXSpeed, X
  STZ.w SprYSpeed, X
  LDA.b #$10 : STA.w SprHeight, X ; Set height
  BRA .UpdatePosition

  .Evasive
  ; Evasive action if too close to player
  JSL GetRandomInt
  AND.b #$03
  TAY
  LDA VelocityOffsets, Y : EOR #$FF : INC : STA.w SprXSpeed, X
  INY
  LDA VelocityOffsets+4, Y : EOR #$FF : INC : STA.w SprYSpeed, X
  LDA.b #$10 : STA.w SprHeight, X ; Set height
  BRA .UpdatePosition

  .UpdatePosition
  ; Handle floaty movement with controlled altitude
  LDA.w SprHeight, X : CMP #$10 : BNE .CheckGrounded
    DEC.w SprHeight, X
    DEC.w $0F90, X

  .CheckGrounded
  ; Move sprite
  JSL Sprite_Move

  ; Check for tile collision and bounce if necessary
  JSL Sprite_BounceFromTileCollision

  ; Reduce the state timer and reset state if necessary
  DEC.w SprTimerA, X
  RTS
}

DoRandomStrafe:
{
  ; Random strafe with controlled movement
  JSL GetRandomInt
  AND.b #$03
  TAY
  LDA VelocityOffsets, Y : STA.w SprXSpeed, X
  INY
  LDA VelocityOffsets+4, Y : STA.w SprYSpeed, X
  LDA.b #$10 : STA.w SprHeight, X ; Set height
  RTS
}

; Velocity offsets table
VelocityOffsets:
    db $08, $F8, $08, $F8  ; X speeds (right, left, down, up)
    db $04, $FC, $04, $FC  ; Y speeds (down, up, right, left)

; Target positions table (relative to the player)
TargetPositions:
    dw $0040, $FFC0  ; Right, Left
    dw $0040, $FFC0  ; Down, Up

; =========================================================

; Reused function from TrinexxBreath.
TrinexxBreath_AltEntry:
{
  LDA $1A : AND.b #$07 : BNE .no_adjustment
    JSL GetRandomInt
    AND.b #$03
    TAY
    LDA SpeedAdjustments, Y : CLC : ADC $0D50, X : STA $0D50, X
    LDA SpeedAdjustments+4, Y : CLC : ADC $0D40, X : STA $0D40, X
  .no_adjustment

  JSL Sprite_BounceFromTileCollision
  LDA $1A : AND.b #$03 : BNE .no_shake
    JSL Sprite_IsToRightOfPlayer
    LDA $0D50, X : CMP .x_speed_targets, Y : BEQ .no_shake
      CLC : ADC.w .shake_x, Y : STA $0D50, X

  .no_shake
  JSL Sprite_IsBelowPlayer 
    LDA $0D40, X : CMP .x_speed_targets, Y : BEQ .exit
      CLC : ADC.w .shake_y, Y : STA $0D40, X

  JSL Sprite_CheckTileCollision : BEQ .exit
    JSL Sprite_FloatTowardPlayer

  .exit
  RTS

  .x_speed_targets
    db 16, -16

  .shake_x
    db  1, -1

  .shake_y
    db  0, -1

  ; Adjustments for xy speeds (small positive, small negative)
  SpeedAdjustments:
  db  $02, $FE, $04, $FC ; X
  db  $01, $FF, $02, $FE ; Y
}

Sprite_Twinrova_FireAttack:
{ 
  JSL Sprite_CheckTileCollision : BNE .no_collision
    JSL Sprite_Move
  .no_collision
  JSR AddFireGarnish
  JMP TrinexxBreath_AltEntry
}

; $1DBDD6 - TrinexxFire_AddFireGarnish
AddFireGarnish:
{
    INC.w SprDelay, X : LDA SprDelay, X : AND.b #$07 : BNE .return
      LDA.b #$2A : JSL Sound_SetSfx2PanLong
      LDA.b #$1D : PHX : TXY : TAX : STA $00

  .next_slot
    LDA $7FF800, X : BEQ .free_slot ; Search for free Garnish slot
      DEX : BPL .next_slot
        DEC $0FF8 : BPL .use_search_index
          LDA $00 : STA $0FF8
    .use_search_index
      LDX $0FF8
  .free_slot
    ; Set garnish ID, set garnish handled flag, set garnish parent sprite
    LDA.b #$10 : STA $7FF800, X : STA $0FB4 : TYA : STA $7FF92C, X
    LDA.w SprX, Y  : STA $7FF83C, X                    ; Garnish XL
    LDA.w SprXH, Y : STA $7FF878, X                    ; Garnish XH
    LDA.w SprY, Y  : CLC : ADC.b #$10 : STA $7FF81E, X ; Garnish YL
    LDA.w SprYH, Y : ADC.b #$00 : STA $7FF85A, X       ; Garnish YH
    LDA.b #$7F : STA $7FF90E, X : STX $00              ; Set garnish timer 
    PLX

  .return
    RTS
}

; =========================================================

Sprite_Twinrova_IceAttack:
{
  JSL Sprite_CheckTileCollision : BNE .no_collision
    JSL Sprite_Move
  .no_collision
  JSR AddIceGarnishV2
  JMP TrinexxBreath_AltEntry
}

; $1DBD65 - TrinexxBreath_ice_add_ice_garnish
AddIceGarnishV2:
{
    INC.w SprDelay, X : LDA SprDelay, X : AND.b #$07 : BNE .return
      LDA.b #$14 : JSL Sound_SetSfx3PanLong
      LDA.b #$1D : PHX : TXY : TAX : STA $00

  .next_slot
    LDA $7FF800, X : BEQ .free_slot ; Search for free Garnish slot
      DEX : BPL .next_slot
        DEC $0FF8 : BPL .use_search_index
          LDA.b #$00 : STA $0FF8
    .use_search_index
      LDX $0FF8
  .free_slot
    ; Set garnish ID, set garnish handled flag, set garnish parent sprite
    LDA.b #$0C : STA $7FF800, X : STA $0FB4 : TYA : STA $7FF92C, X
    LDA.w SprX, Y : STA $7FF83C, X                    ; Garnish XL
    LDA.w SprXH, Y : STA $7FF878, X                   ; Garnish XH
    LDA.w SprY, Y : CLC : ADC.b #$10 : STA $7FF81E, X ; Garnish YL
    LDA.w SprYH, Y : ADC.b #$00 : STA $7FF85A, X      ; Garnish YH
    LDA.b #$7F : STA $7FF90E, X : STX $00             ; Set garnish timer
    PLX

  .return
    RTS
}

; =========================================================
; Overwrite vanilla Trinexx ice garnish
; Plays like a simple ice cloud animation now.

pushpc

org $09B5DE
  Garnish_PrepOamCoord:

org $09B70C
  Garnish_SetOamPropsAndLargeSize:

org $09B459
  Garnish_CheckPlayerCollision:

org $09B5D6
  Garnish_SetOamPropsAndSmallSize:

; SpriteData_Bump - Ice Garnish 
org $0DB266+$CD
  db $04

org $09B33F
TrinexxIce_Pool:
{
  .chr
    db $2E, $2E, $2E, $2E
    db $2C, $2C, $2C, $2C
    db $2C, $2C, $2C, $2C
  .properties
    db $35, $35, $35, $35
}

pullpc

RestoreFloorTile:
{
  PHA 
  LDA.l $7FF83C,X
  STA.b $00
  LDA.l $7FF83C,X
  STA.b $00

  LDA.l $7FF878,X
  STA.b $01

  LDA.l $7FF81E,X
  SEC
  SBC.b #$10
  STA.b $02

  LDA.l $7FF85A,X
  SBC.b #$00
  STA.b $03

  LDY.b #$00
  JSL $01E7A9 ; Underworld_UpdateTilemapWithCommonTile

  PLA
  RTS
}

AddPitHazard:
{
  PHA

  LDA.l $7FF83C,X
  STA.b $00

  LDA.l $7FF878,X
  STA.b $01

  LDA.l $7FF81E,X
  SEC
  SBC.b #$10
  STA.b $02

  LDA.l $7FF85A,X
  SBC.b #$00
  STA.b $03

  LDY.b #$04
  JSL $01E7A9 ; Underworld_UpdateTilemapWithCommonTile

  PLA
  RTS
}


Ganon_SpawnFallingTilesOverlord:
{
  #_1D90D0: LDY.b #$07

  .next_slot
  #_1D90D2: LDA.w $0B00,Y
  #_1D90D5: BEQ .free_slot

  #_1D90D7: DEY
  #_1D90D8: BPL .next_slot

  #_1D90DA: RTS

  ;----------------------------------------------------------

  .free_slot
  #_1D90DB: LDA.w $0EC0,X
  #_1D90DE: CMP.b #$04
  #_1D90E0: BCS .dont_spawn

  #_1D90E2: INC.w $0EC0,X

  #_1D90E5: PHX

  #_1D90E6: TAX

  #_1D90E7: LDA.w .overlord_type,X
  #_1D90EA: STA.w $0B00,Y

  #_1D90ED: LDA.w .position_x,X
  #_1D90F0: STA.w $0B08,Y

  #_1D90F3: LDA.b $23
  #_1D90F5: STA.w $0B10,Y

  #_1D90F8: LDA.w .position_y,X
  #_1D90FB: STA.w $0B18,Y

  #_1D90FE: LDA.b $21
  #_1D9100: STA.w $0B20,Y

  #_1D9103: LDA.b #$00
  #_1D9105: STA.w $0B28,Y
  #_1D9108: STA.w $0B30,Y

  #_1D910B: PLX

  .dont_spawn
  #_1D910C: RTS

  .overlord_type
  #_1D90C4: db $0C ; OVERLORD 0C
  #_1D90C5: db $0D ; OVERLORD 0D
  #_1D90C6: db $0E ; OVERLORD 0E
  #_1D90C7: db $0F ; OVERLORD 0F

  .position_x
  #_1D90C8: db $18
  #_1D90C9: db $D8
  #_1D90CA: db $D8
  #_1D90CB: db $18

  .position_y
  #_1D90CC: db $20
  #_1D90CD: db $20
  #_1D90CE: db $D0
  #_1D90CF: db $D0
}

; =========================================================

Sprite_Twinrova_Draw:
{
    JSL Sprite_PrepOamCoord
    JSL Sprite_OAM_AllocateDeferToPlayer

    LDA $0DC0, X : CLC : ADC $0D90, X : TAY;Animation Frame
    LDA .start_index, Y : STA $06

    ; Store Palette thing 
    LDA $0DA0, X : STA $08

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

    ; Set palette flash modifier 
    LDA .properties, X : ORA $08 : STA ($90), Y

    PHY 
        
    TYA : LSR #2 : TAY
        
    SEP #$20 ;set A back to 8bit but not X and Y
    LDA .sizes, X : ORA $0F : STA ($92), Y ; store size in oam buffer
        
    PLY : INY
        
    PLX : DEX : BPL .nextTile

    SEP #$30

    PLX

    RTS

  .start_index
    db $00, $04, $08, $0C, $10, $14, $18, $1C, $22, $26, $2A, $2E
  .nbr_of_tiles
    db 3, 3, 3, 3, 3, 3, 3, 5, 3, 3, 3, 3
  .x_offsets
    dw -8, 8, 8, -8
    dw -8, 8, -8, 8
    dw -8, 8, -8, 8
    dw -8, 8, -8, 8
    dw -8, 8, -8, 8
    dw -8, 8, -8, 8
    dw -8, 8, -8, 8
    dw -16, 0, 16, -16, 0, 16
    dw -8, 8, -8, 8
    dw -8, 8, -8, 8
    dw -8, 8, -8, 8
    dw -8, 8, -8, 8
  .y_offsets
    dw -8, -8, 8, 8
    dw -7, -7, 9, 9
    dw -8, -8, 8, 8
    dw -8, -8, 8, 8
    dw -8, -8, 8, 8
    dw -7, -7, 9, 9
    dw -6, -6, 10, 10
    dw -8, -8, -8, 8, 8, 8
    dw -8, -8, 8, 8
    dw -8, -8, 8, 8
    dw -8, -8, 8, 8
    dw -7, -7, 9, 9
  .chr
    db $00, $02, $22, $24
    db $04, $06, $24, $26
    db $08, $0A, $28, $2A
    db $0C, $0E, $28, $2A
    db $44, $46, $64, $66
    db $48, $4A, $68, $6A
    db $4C, $4E, $6C, $6E
    db $88, $8A, $8C, $A8, $AA, $AC
    db $80, $82, $A0, $A2
    db $84, $86, $A4, $A6
    db $40, $42, $60, $62
    db $40, $42, $60, $62
  .properties
    db $39, $39, $39, $39
    db $39, $39, $39, $39
    db $39, $39, $39, $39
    db $39, $39, $39, $39
    db $39, $39, $39, $39
    db $39, $39, $39, $39
    db $39, $39, $39, $39
    db $39, $39, $39, $39, $39, $39
    db $39, $39, $39, $39
    db $39, $39, $39, $39
    db $39, $39, $39, $39
    db $39, $39, $39, $39
  .sizes
    db $02, $02, $02, $02
    db $02, $02, $02, $02
    db $02, $02, $02, $02
    db $02, $02, $02, $02
    db $02, $02, $02, $02
    db $02, $02, $02, $02
    db $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $00
    db $02, $02, $02, $02
    db $02, $02, $02, $02
    db $02, $02, $02, $02
    db $02, $02, $02, $02
}

; =========================================================

ApplyTwinrovaGraphics:
{
    PHX 
    REP #$20               ; A = 16, XY = 8
    LDX #$80 : STX $2100   ; turn the screen off (required)
    LDX #$80 : STX $2115   ; Set the video port register every time we write it increase by 1
    LDA #$5000 : STA $2116 ; Destination of the DMA $5800 in vram <- this need to be divided by 2
    LDA #$1801 : STA $4300 ; DMA Transfer Mode and destination register 
                           ; "001 => 2 registers write once (2 bytes: p, p+1)"
    LDA.w #TwinrovaGraphics : STA $4302     ; Source address where you want gfx from ROM
    LDX.b #TwinrovaGraphics>>16 : STX $4304
    LDA   #$2000 : STA $4305                ; Size of the transfer 4 sheets of $800 each
    LDX   #$01 : STX $420B                  ; Do the DMA 
    LDX #$0F : STX $2100                    ; Turn the screen back on
    SEP #$30
    PLX
    RTL

  TwinrovaGraphics:
    incbin twinrova.bin
}

; $1DC845
#Fireball_Configure:
{
  LDA.w $0CAA,Y
  ORA.b #$08
  STA.w $0CAA,Y

  LDA.b #$04
  STA.w $0CD2,Y

  .exit
  RTS
}

; $1DC879
ReleaseFireballs:
{

  JSL Sprite_SpawnFireball
  BMI .exit_a

  JSR Fireball_Configure

  PHX
  TYX

  JSL Sprite_DirectionToFacePlayer

  LDA.w .speed_x,Y
  STA.w $0D50,X

  LDA.w .speed_y,Y
  STA.w $0D40,X

  LDA.w SprX,X
  CLC
  ADC.w .offset_x_low,Y
  STA.w SprX,X

  LDA.w SprXH,X
  ADC.w .offset_x_high,Y
  STA.w SprXH,X

  LDA.w SprY,X
  CLC
  ADC.w .offset_y_low,Y
  STA.w SprY,X

  LDA.w SprYH,X
  ADC.w .offset_y_high,Y
  STA.w SprYH,X

  PLX

  .exit_a
  RTS


  .offset_x_low
  db  12, -12,   0,   0

  .offset_x_high
  db   0,  -1,   0,   0

  .offset_y_low
  db   0,   0,  12, -12

  .offset_y_high
  db   0,   0,   0,  -1

  .speed_y ; bleeds into next
  db   0,   0

  .speed_x
  db  40, -40,   0,   0
}

pushpc

; =========================================================
; Blind Maiden spawn code

org $0DB818
  SpritePrep_LoadProperties:

; Follower_BasicMover.dont_scare_kiki
org $09A1E4
Follower_BasicMover:
{
    ; Check if the follower is the blind maiden
    LDA.l $7EF3CC : CMP.b #$06 : BNE .no_blind_transform
      ; Check if we are in room 0xAC
      REP #$20 
      LDA.b $A0 : CMP.w #$00AC : BNE .no_blind_transform
        ; ; Check room flag 0x65
        ; LDA.l $7EF0CA : AND.w #$0100 : BEQ .no_blind_transform
          SEP #$20
          JSL Follower_CheckBlindTrigger : BCC .no_blind_transform
  .blind_transform
    ; Load follower animation step index from $02CF
    LDX.w $02CF
    LDA.w $1A28, X : STA.b $00 ; Follower XL
    LDA.w $1A3C, X : STA.b $01 ; Follower XH
    LDA.w $1A00, X : SEC : SBC.b #$10 : STA.b $02 ; Follower YL
    LDA.w $1A14, X : STA.b $03 ; Follower YH

    ; Dismiss the follower and spawn Twinrova
    LDA.b #$00 : STA.l $7EF3CC
    JSL Blind_SpawnFromMaiden

    ; Close the shutter door 
    INC.w $0468

    ; Clear door tilemap position for some reason
    STZ.w $068E : STZ.w $0690

    ; TODO: Find out what submodule this is.
    LDA.b #$05 : STA.b $11

    ; SONG 15
    LDA.b #$15 : STA.w $012C

    RTS
  
  org $09A23A
  .no_blind_transform
}

; =========================================================

org $099E90
Follower_CheckBlindTrigger:
{
    PHB : PHK : PLB

    ; Cache the follower's position
    LDX.w $02CF
    LDA.w $1A00, X : STA.b $00
    LDA.w $1A14, X : STA.b $01
    LDA.w $1A28, X : STA.b $02
    LDA.w $1A3C, X : STA.b $03
    STZ.b $0B

    ; Check if the follower is within the trigger area
    LDA.w $1A50, X : STA.b $0A : BPL .positive_z
      LDA.b #$FF : STA.b $0B

  .positive_z
    REP #$20

    LDA.b $00 : CLC : ADC.b $0A : CLC : ADC.w #$000C : STA.b $00
    LDA.b $02 : CLC : ADC.w #$0008 : STA.b $02
    LDA.w #$1568 : SEC : SBC.b $00 : BPL .positive_x
      EOR.w #$FFFF : INC A
  .positive_x
    CMP.w #$0018 : BCS .fail
      LDA.w #$1980 : SEC : SBC.b $02 : BPL .positive_y
        EOR.w #$FFFF : INC A

  .positive_y
    CMP.w #$0018
    BCS .fail

  .success
    SEP #$20
    PLB : SEC
    RTL

  .fail
    SEP #$20
    PLB : CLC
    RTL
}

; =========================================================
; Called during Blind Maiden section of Follower_BasicMover
; to spawn Twinrova from the Blind Maiden.

org $1DA03C
Blind_SpawnFromMaiden:
{
  JSL ApplyTwinrovaGraphics

  LDX.b #$00 ; Load the boss into sprite index 0

  ; Set the sprite to alive and active
  LDA.b #$09 : STA.w $0DD0,X

  ; SPRITE CE
  LDA.b #$CE : STA.w $0E20,X

  ; Load the position cache from the maiden follower
  LDA.b $00 : STA.w SprX,X
  LDA.b $01 : STA.w SprXH,X
  LDA.b $02 : SEC : SBC.b #$10 : STA.w SprY,X
  LDA.b $03 : STA.w SprYH,X

  ; Removed because it was causing the sprite to disappear
  ; JSL SpritePrep_LoadProperties

  ; Set SprTimerC
  LDA.b #$C0 : STA.w $0E10,X

  ; Set SprGfx
  LDA.b #$00 : STA.w $0DC0,X

  ; Set SprMiscC and bulletproof properties
  LDA.b #$02 : STA.w $0DE0,X : STA.w $0BA0,X

  ; Set the 2nd key / heart piece items taken room flag 
  LDA.w $0403 : ORA.b #$20 : STA.w $0403

  ; Clear blinds head spin flag
  STZ.w $0B69

  RTL
}

; =========================================================
; We are using space from this function to insert the 
; Twinrova graphics above, since the prep is now handled
; in the custom sprite code.

org $1DA081
SpritePrep_Blind_PrepareBattle:
{
    ; LDA.l $7EF3CC
    ; CMP.b #$06 ; FOLLOWER 06
    ; BEQ .despawn

    LDA.w $0403
    AND.b #$20
    BEQ .despawn

    LDA.b #$60
    STA.w $0E10,X

    LDA.b #$01
    STA.w $0DB0,X

    LDA.b #$02
    STA.w $0DE0,X

    LDA.b #$04
    STA.w $0EB0,X

    LDA.b #$07
    STA.w $0DC0,X

    STZ.w $0B69

    RTL

  .despawn
    STZ.w $0DD0,X

    RTL
}

warnpc $1DA0B1

org $01B3E1
  RoomDraw_BombableFloor:
    LDA.b $A0
    CMP.w #$00AD

; =========================================================
; TODO: Decide if we want to use this garnish in the fight.
; Currently unused.

org $1DA0B1
BlindLaser_SpawnTrailGarnish:
{
    LDA.w SprDelay,X
    AND.b #$00
    BNE .exit

    PHX
    TXY

    LDX.b #$1D

  .next_slot
    LDA.l $7FF800,X
    BEQ .free_slot

    DEX
    BPL .next_slot

    DEC.w $0FF8
    BPL .use_search_index

    LDA.b #$1D
    STA.w $0FF8

  .use_search_index
    LDX.w $0FF8

  .free_slot
    LDA.b #$0F ; GARNISH 0F
    STA.l $7FF800,X
    STA.w $0FB4

    LDA.w $0DC0,Y
    STA.l $7FF9FE,X

    TYA
    STA.l $7FF92C,X

    LDA.w SprX,Y
    STA.l $7FF83C,X

    LDA.w SprXH,Y
    STA.l $7FF878,X

    LDA.w SprY,Y
    CLC
    ADC.b #$10
    STA.l $7FF81E,X

    LDA.w SprYH,Y
    ADC.b #$00
    STA.l $7FF85A,X

    LDA.b #$0A
    STA.l $7FF90E,X

    PLX

  .exit
    RTL
}

pullpc


; ==============================================================================
; Mantle and Maiden

pushpc

org $068841
    JSL NewMantlePrep
    RTS

org $1AFC52
    db $06 ; check for maiden instead of zelda

org $1AFCA7
    ; Tiles
    db $0C, $0E, $0C, $2C, $2E, $2C
    ; Mantle Properties : 
    db $3D, $3D, $7D, $3D, $3D, $7D

pullpc

NewMantlePrep:
{
    LDA SprY, X : CLC : ADC.b #$07 : STA.w SprY, X
    LDA SprX, X : CLC : ADC.b #$08 : STA.w SprX, X

    LDA $7EF0DA : AND #$0F : BEQ +
        LDA SprX, X : CLC : ADC.b #$28 : STA.w SprX, X
    +

    RTL
}

pushpc

org $09A1EC
    JSL CheckForMaidenInLibrary

; Prevent mantle from setting spawn point
org $1AFC6D
NOP #6
; LDA.b #$04
; STA.l $7EF3C8

pullpc 

CheckForMaidenInLibrary:
{
    LDA $A0 : CMP.b #$BD : BNE .notTheLibrary
        LDA $11 : BNE .notTheLibrary
            LDA $7FF9D2 : BNE .dialogue_played
                LDA #$1D : LDY #$00
                JSL Sprite_ShowMessageUnconditional
                LDA #$01 : STA $7FF9D2

            .dialogue_played

    .notTheLibrary

    ; Check for blind room vanilla
    REP #$20
    LDA.b $A0

    RTL
}

; ==============================================================================
