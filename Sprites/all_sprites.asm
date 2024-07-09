; =========================================================

incsrc ZSpriteLib/sprite_macros.asm

org    $308000
incsrc ZSpriteLib/sprite_new_table.asm

incsrc "Sprites/NPCs/farore.asm"
print  "End of farore.asm                 ", pc

incsrc "Sprites/Bosses/kydrog.asm"
print  "End of kydrog.asm                 ", pc

incsrc "Sprites/NPCs/maku_tree.asm"
print  "End of maku_tree.asm              ", pc

incsrc "Sprites/NPCs/mask_salesman.asm"
print  "End of mask_salesman.asm          ", pc

incsrc "Sprites/NPCs/bean_vendor.asm"
print  "End of bean_vendor.asm            ", pc

incsrc "Sprites/Bosses/octoboss.asm"
print  "End of octoboss.asm               ", pc

incsrc "Sprites/NPCs/Mermaid.asm"
print  "End of mermaid.asm                ", pc

incsrc "Sprites/Bosses/Manhandla.asm"
print  "End of manhandla.asm              ", pc

incsrc "Sprites/Enemies/deku_scrub_enemy.asm"
print  "End of deku_scrub_enemy.asm       ",  pc

incsrc "Sprites/Enemies/goriya.asm"
print  "End of goriya.asm                 ",  pc

incsrc "Sprites/Enemies/darknut.asm"
print  "End of darknut.asm                ",  pc

incsrc "Sprites/Enemies/sea_urchin.asm"
print  "End of sea_urchin.asm             ", pc

incsrc "Sprites/NPCs/korok.asm"
print  "End of korok.asm                  ", pc

incsrc "Sprites/NPCs/vasu.asm"
print  "End of vasu.asm                   ", pc

DontTeleportWithoutFlippers:
{
  LDA.l $7EF356 : BNE +
    RTL
  +
  #_1EEEE4: LDA.b #$2E
  #_1EEEE6: STA.b $11
  RTL
}

PutRollerBeneathLink:
{
  JSL Sprite_OAM_AllocateDeferToPlayer
  LDA.w $0DC0,X
  ASL A
  RTL
}

Graphics_Transfer:
{
  LDA.b $A0 : CMP.b #$5A : BNE +
    JSR ApplyManhandlaGraphics
    JSR ApplyManhandlaPalette
  +
  #_02BE5E: LDA.b $11
  #_02BE60: CMP.b #$02
  RTL
}

; UnderworldTransition_ScrollRoom
org $02BE5E
  JSL Graphics_Transfer

; Whirlpool
org $1EEEE4
  JSL DontTeleportWithoutFlippers

; SpriteDraw_Roller
org $058EE6
  JSL PutRollerBeneathLink

; =========================================================

print  ""
print  "Bank 31 Sprites"
print  ""

org    $318000
incsrc ZSpriteLib/sprite_functions.asm
print  "End of sprite_functions.asm       ", pc

incsrc "Sprites/Bosses/kydrog_boss.asm"
print  "End of kydrog_boss.asm            ", pc

incsrc "Sprites/NPCs/deku_scrub.asm"
print  "End of deku_scrub.asm             ", pc

incsrc "Sprites/Enemies/anti_kirby.asm"
print  "End of anti_kirby.asm             ", pc

incsrc "Sprites/Enemies/helmet_chuchu.asm"
print  "End of helmet_chuchu.asm          ", pc

incsrc "Sprites/Enemies/booki.asm"
print  "End of booki.asm                  ", pc

incsrc "Sprites/Enemies/thunder_ghost.asm"
print  "End of thunder_ghost.asm          ", pc

incsrc "Sprites/Objects/switch_track.asm"
print  "End of switch_track.asm           ", pc

incsrc "Sprites/Objects/mineswitch.asm"
print  "End of mineswitch.asm             ", pc

incsrc "Sprites/NPCs/village_dog.asm"
print  "End of village_dog.asm            ",  pc

incsrc "Sprites/Objects/minecart.asm"
print  "End of minecart.asm               ",  pc

incsrc "Sprites/Bosses/dark_link.asm"
print  "End of dark_link.asm              ", pc

incsrc "Sprites/Enemies/puffstool.asm"
print  "End of puffstool.asm              ", pc

incsrc "Sprites/Objects/deku_leaf.asm"
print  "End of deku_leaf.asm              ",  pc

incsrc "Sprites/Objects/portal_sprite.asm"
print  "End of portal_sprite.asm          ",  pc

incsrc "Sprites/NPCs/impa.asm"
print  "End of impa.asm                   ",  pc

incsrc "Sprites/Enemies/poltergeist.asm"
print  "End of poltergeist.asm            ",  pc

incsrc "Sprites/Enemies/pols_voice.asm"
print  "End of pols_voice.asm             ",  pc

incsrc "Sprites/NPCs/zora_princess.asm"
print  "End of zora_princess.asm          ",  pc

incsrc "Sprites/Bosses/wolfos.asm"
print  "End of wolfos.asm                 ",  pc

incsrc "Sprites/Objects/ice_block.asm"
print  "End of ice_block.asm              ",  pc

incsrc "Sprites/Objects/whirlpool.asm"

incsrc "Sprites/NPCs/ranch_girl.asm"
print  "End of Ranch Girl.asm             ", pc

incsrc "Sprites/NPCs/bug_net_kid.asm"

incsrc "Sprites/Bosses/king_dodongo.asm"

incsrc "Sprites/Bosses/arrghus.asm"
print  "End of arrghus.asm                ", pc

incsrc "Sprites/Bosses/lanmola.asm"
print  "End of Lanmola.asm                ", pc

incsrc "Sprites/Bosses/lanmola_Expanded.asm"
print  "End of Lanmola_Expanded.asm       ", pc

incsrc "Sprites/NPCs/followers.asm"
print  "End of followers.asm              ", pc

incsrc "Sprites/NPCs/fortune_teller.asm"
print  "End of fortune_teller.asm         ", pc

warnpc $328000

; =========================================================

print  ""
print  "Bank 32 Sprites"
print  ""

org $328000

incsrc "Sprites/Bosses/twinrova.asm"
print  "End of twinrova.asm               ",  pc

incsrc "Sprites/Bosses/kydreeok.asm"
print  "End of kydreeok.asm               ",  pc

incsrc "Sprites/Bosses/kydreeok_head.asm"
print  "End of kydreeok_head.asm          ",  pc

; =========================================================

; Sprite Recoil and Death
; TODO: Sprite_AttemptKillingOfKin

; Kydreeok Head die like Sidenexx
org $06EFFF
  CMP.b #$CF

org $06F003
  CMP.b #$CF

; Make Dark Link die like sidenexx
org $06F003
  CMP.b #$C1

; Make Helmet ChuChu recoil link
org $06F37D
  CMP.b #$05

; Make Kydreeok head recoil Link
org $06F381
  CMP.b #$CF

; =========================================================

InCutScene = $7EF303

; Player2JoypadReturn
org $0083F8
  LDA InCutScene : BEQ .notInCutscene
    STZ $F0
    STZ $F2
    STZ $F4
    STZ $F6
    STZ $F8
    STZ $FA ; kill all input
  .notInCutscene
  RTS

warnpc $00841E

; =========================================================

Bananas = $7EF38B

org $1EF27D
ShopItem_Banana:
{
  JSR $F4CE   ; SpriteDraw_ShopItem
  JSR $FE78   ; Sprite_CheckIfActive_Bank1E
  JSL $1EF4F3 ; Sprite_BehaveAsBarrier
  JSR $F391   ; ShopItem_CheckForAPress
  BCC .exit

    LDA.l Bananas : CMP.b #$0A : BCS .error
    LDA.b #$1E : LDY.b #$00
    JSR $F39E ; ShopItem_HandleCost
    BCC $F1A1 ; ShopItem_GiveFailureMessage

    STZ.w $0DD0,X

    INC.b Bananas

    LDY.b #$42
    JSR $F366 ; ShopItem_HandleReceipt

  .exit
  RTS
  .error
  JSR $F38A ; ShopItem_PlayBeep
}
warnpc $1EF2AB

; =========================================================

; Shop item heart OAM
; SpriteDraw_ShopItem
org $1EF42E
  dw  -4,  16 : db $03, $02, $00, $00 ; 3
  dw  -4,  16 : db $03, $02, $00, $00 ; 3
  dw   4,  16 : db $30, $02, $00, $00 ; 0
  dw   0,   0 : db $E5, $03, $00, $02 ; item
  dw   4,  11 : db $38, $03, $00, $00 ; shadow

; =========================================================

; Octoballoon_FormBabby
; Reduce by half the number of babies spawned
org $06D814
  LDA.b #$02

; SpritePrep_HauntedGroveOstritch
org $068BB2
NOP #11

; HauntedGroveRabbit_Idle
org $1E9A8F
NOP #5

; MedallionTablet (Goron)
org $05F274
  LDA.l $7EF378 ; Unused SRAM

org $08C2E3
  dw $006F ; BUTTER SWORD DIALOGUE

; Fix the capital 'B' debug item cheat.
org $0CDC26
    db $80 ; replace a $F0 (BEQ) with a $80 (BRA).

; Follower_Disable
; Don't disable Kiki so we can switch maps with him.
org $09ACF3
  LDA.l $7EF3CC
  CMP.b #$0E

; Kiki, don't care if we're not in dark world
org $099FEB
#_099FEB: LDA.b $8A
#_099FED: AND.b #$FF

org $1EE48E
  NOP #6

; Kiki activate cutscene 3 (tail palace)
org $1EE630
LDA.b #$03 : STA.w $04C6

; Kid at ranch checks for flute
org $05FF7D
  LDA.l $7EF34C
  CMP.b #$01
  
; Running Man draw palette
org $05E9CD
SpriteDraw_RunningBoy:
  #_05E9CD: dw   0,  -8 : db $2C, $00, $00, $02
  #_05E9D5: dw   0,   0 : db $EE, $0E, $00, $02

  #_05E9DD: dw   0,  -7 : db $2C, $00, $00, $02
  #_05E9E5: dw   0,   1 : db $EE, $4E, $00, $02

  #_05E9ED: dw   0,  -8 : db $2A, $00, $00, $02
  #_05E9F5: dw   0,   0 : db $CA, $0E, $00, $02

  #_05E9FD: dw   0,  -7 : db $2A, $00, $00, $02
  #_05EA05: dw   0,   1 : db $CA, $4E, $00, $02

  #_05EA0D: dw   0,  -8 : db $2E, $00, $00, $02
  #_05EA15: dw   0,   0 : db $CC, $0E, $00, $02

  #_05EA1D: dw   0,  -7 : db $2E, $00, $00, $02
  #_05EA25: dw   0,   1 : db $CE, $0E, $00, $02

  #_05EA2D: dw   0,  -8 : db $2E, $40, $00, $02
  #_05EA35: dw   0,   0 : db $CC, $4E, $00, $02

  #_05EA3D: dw   0,  -7 : db $2E, $40, $00, $02
  #_05EA45: dw   0,   1 : db $CE, $4E, $00, $02

; =========================================================
