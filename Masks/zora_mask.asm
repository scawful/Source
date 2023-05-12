; =============================================================================
; Zora Mask
; Fairy Flippers RAM Position $7EF33C - 01
; Normal Flippers RAM Position $7EF356 - 01
; 
; Underwater Flag RAM Position $7F500E
; =============================================================================

org $0998FC
  AddTransitionSplash:

org $07A569
LinkItem_ZoraMask:
{
  ; Check for R button held 
  LDA $F2 : CMP #$10 : BNE .return 

  JSR Link_CheckNewY_ButtonPress : BCC .return
  LDA $3A : AND.b #$BF : STA $3A        ; clear the Y button state 

  LDA $6C : BNE .return                 ; in a doorway
  LDA $0FFC : BNE .return               ; can't open menu

  LDY.b #$04 : LDA.b #$23
  JSL AddTransformationCloud
  LDA.b #$14 : JSR Player_DoSfx2

  LDA $02B2 : CMP #$02 : BEQ .unequip   ; is the zora mask on?
  JSL UpdateZoraPalette
  LDA #$36 : STA $BC
  LDA #$02 : STA $02B2
  BRA .return
.unequip
  JSL Palette_ArmorAndGloves
  LDA #$10 : STA $BC : STZ $02B2        ; take the mask off

.return
  CLC
  RTS
}

; =============================================================================

org $368000
incbin gfx/zora_link.4bpp

; =============================================================================

UpdateZoraPalette:
{
  REP #$30  ; change 16 bit mode
  LDX #$001E

  .loop
  LDA.l zora_palette, X : STA $7EC6E0, X
  DEX : DEX : BPL .loop

  SEP #$30  ; go back to 8 bit mode
  INC $15   ; update the palette
  RTL       
}

; TODO: Change from "bunny palette" to blue zora palette colors 
zora_palette:
  dw #$7BDE, #$7FFF, #$2F7D, #$19B5, #$3A9C, #$14A5, #$19FD, #$14B6
  dw #$55BB, #$362A, #$3F4E, #$162B, #$22D0, #$2E5A, #$1970, #$7616
  dw #$6565, #$7271, #$2AB7, #$477E, #$1997, #$14B5, #$459B, #$69F2
  dw #$7AB8, #$2609, #$19D8, #$3D95, #$567C, #$1890, #$52F6, #$2357, #$0000

; =============================================================================

org $07F93F
LinkState_UsingZoraMask:
{
  ; Check if the mask is equipped 
  LDA $02B2 : CMP #$02 : BNE .normal : CLC

  ; Check if we are in water or not 
  LDA $5D : CMP #$04 : BEQ .swimming : CLC
  
.normal
  ; Return to normal state 
  STZ $55
  STZ $037B
  STZ $0351
  LDA #$00 : STA $5E ; Reset speed to normal 
  STA $037B
  JMP .return
  
.swimming
  ; Check if we are indoors or outdoors 
  LDA $1B : BNE .dungeon ; z flag is 1 

  ; OVERWORLD -----------------------------------------------------------------
  .overworld 
  {
    ; Check the Y button and clear state if activated
    JSR Link_CheckNewY_ButtonPress : BCC .return
    LDA $3A : AND.b #$BF : STA $3A       

    ; Check if already underwater 
    LDA $0AAB : BEQ .dive

    STZ $55     ; Reset cape flag 
    STZ $0AAB   ; Reset underwater flag 
    STZ $0351   ; Reset ripple flag 
    STZ $037B   ; Reset invincibility flag
    LDA #$04 : STA $5D ; Put Link in Swimming State

    JMP .return

  .dive
    ; Handle overworld underwater swimming 
    LDA #$01 : STA $55   ; Set cape flag 
    STA $037B            ; Set invincible flag 
    LDA #$08 : STA $5E   ; Set underwater speed 
    LDA #$01 : STA $0AAB ; Set underwater flag
    STA $0351            ; Set ripple flag

    ; Splash visual effect 
    LDA.b #$15 : LDY.b #$00
    JSL AddTransitionSplash

    ; Stay in swimming mode 
    LDA #$04 : STA $5D
    ; Splash sound effect 
    ; LDA #$24 : STA $012E  
    
  .return
    JSR $E8F0 ; HandleIndoorCameraAndDoors
    RTS
  }

  ; DUNGEON DIVE --------------------------------------------------------------
  .dungeon
  {
    ; Check if we are in water or not 
    LDA $5D : CMP #$04 : BNE .return_dungeon : CLC

    ; Check if already underwater
    LDA $0AAB : BNE .return_dungeon : CLC 

    ; Check if we are on a proper tile or not 
    ; 

    ; Check the Y button and clear state if activated
    JSR Link_CheckNewY_ButtonPress : BCC .return_dungeon
    LDA $3A : AND.b #$BF : STA $3A 

  .dive_dungeon
    ; Splash effect 
    LDA.b #$15 : LDY.b #$00
    JSL AddTransitionSplash

    STZ $5D     ; reset player to ground state 
    STZ $EE     ; move link to lower level
    
    LDA #$72
    STA $9A     ; Set layer 

    LDA #$08
    STA $5E     ; Set the player speed 

    STZ $0345

    LDA #$01
    STA $0AAB   ; Set the player underwater flag 

  .return_dungeon
    JSR $E8F0 ; HandleIndoorCameraAndDoors
    RTS
  }
}

.dungeon_resurface
{
  LDA $1B : BEQ .return_default ; We are in overworld actually 

  ; Check if the player is actually diving 
  LDA $0AAB : BEQ .return_default

  ; Check if the ground level is safe
  ; Otherwise, eject the player back to the surface
  LDA $0114 : BNE .remove_dive : CLC

  ; Check the Y button and clear state if activated
  JSR Link_CheckNewY_ButtonPress : BCC .return_default
  LDA $3A : AND.b #$BF : STA $3A 
  {
    ; Restore Swimming Effects
    LDA.b #$15 : LDY.b #$00 : JSL AddTransitionSplash
  .remove_dive
    LDA #$04 : STA $5D ; Set Link to Swimming State
    LDA #$01 : STA $EE ; Set Link to upper level
    STA $0345          ; Set deep water flag 

    ; Remove Diving Effects
    LDA $67 : AND #$01 : STA $2F
    STZ $5E            ; Reset speed to normal
    STZ $0AAB          ; Reset underwater flag 
    STZ $0351          ; Reset ripple flag
    STZ $24            ; Reset z coordinate for link
    STZ $0372          ; Reset link bounce flag
    LDA #$62 : STA $9A ; Reset dungeon layer
    JMP .return_default
  }

.return_default
  STZ $0302
  RTS
}


.dungeon_stairs
{
  LDA $02B2 : CMP #$02 : BNE .return_hop
  STZ $5E            ; Reset speed to normal
  STZ $0AAB          ; Reset underwater flag 
  LDA #$62 : STA $9A ; Reset dungeon layer
.return_hop
  LDA #$06 : STA $5D ; Set Link to Recoil State
  RTS
}

; =============================================================================

; End of LinkState_Swimming
org $079781
  JSR LinkState_UsingZoraMask
  RTS

; End of LinkState_Default 
org $0782D2
  JSR LinkState_UsingZoraMask_dungeon_resurface
  JSR $E8F0
  CLC
  RTS

; C2C3
org $07C307
  JSR LinkState_UsingZoraMask_dungeon_stairs
  RTS
