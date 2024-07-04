; =========================================================
;           The Legend of Zelda: Oracle of Secrets
;                   Composed by: Scawful
;
; Expanded Banks:
;  21-2A ZS Reserved
;   2B - Items: all_items.asm
;   2C - Dungeon Objects, Spike Subtype, Together Warp Tag
;   2D - Menu
;   2E - HUD
;   2F - 
;   30 - Sprites: all_sprites.asm
;   31 - Sprites: all_sprites.asm
;   32 - Sprites: all_sprites.asm
;   33 - Custom Collision Tables
;   34 - Time System, Custom Overworld Overlays
;   35 - Deku Link GFX
;   36 - Zora Link GFX
;   37 - Bunny Link GFX
;   38 - Wolf Link GFX
;   39 - Minish Link GFX
;   3A - StartupMasks, Palette_ArmorAndGloves, CgramAuxToMain
;   3B - GBC Link GFX
;   3C - Expanded Dialogue
;   3D - LW World Map
;   3E - DW World Map
;   3F - Load Custom GFX, Boat GFX
;
; =========================================================

; .... h.m.
;  h - hall of secrets
;  m - maku tree
OOSPROG         = $7EF3D6

; Bitfield of less important progression
; .fbh .zsu
;   u - Uncle visited in secret passage; controls spawn (0: spawn | 1: gone)
;   s - Priest visited in sanc after Zelda is kidnapped again
;   z - Zelda brought to sanc
;   h - Uncle has left Link's house; controls spawn (0: spawn | 1: gone)
;   b - Book of Mudora obtained/mentioned; controls Aginah dialog
;   f - Flipped by fortune tellers to decide which fortune set to give
OOSPROG2       = $7EF3C6

incsrc "Overworld/custom_gfx.asm"
print  "End of custom_gfx.asm             ", pc
incsrc "Overworld/ZCustomOverworld.asm"
print  "End of ZCustomOverworld.asm       ", pc

incsrc "Core/ram.asm"

namespace Oracle
{
  print ""
  print "Applying patches to Oracle of Secrets"
  print ""

  incsrc "Util/ram.asm"
  incsrc "Util/functions.asm"
  incsrc "Core/music_macros.asm"

  incsrc "Core/message.asm"

  ; -------------------------------------------------------
  ; Overworld

  print "  -- Overworld --  "
  print ""
  
  incsrc "Overworld/overworld.asm"

  print ""

  ; -------------------------------------------------------
  ; Dungeon

  print "  -- Dungeon --  "
  print ""

  incsrc "Dungeons/dungeons.asm"

  print ""

  ; -------------------------------------------------------
  ; Music

  print "  -- Music --  "
  print ""

  incsrc "Music/lost_woods_v2.asm"
  print  "End of Music/lost_woods_v2.asm       ", pc

  incsrc "Music/color_dungeon_theme.asm"
  print  "End of Music/color_dungeon_theme.asm    ", pc

  incsrc "Music/stone_tower_temple_v2.asm"
  print  "End of stone_tower_temple.asm     ", pc

  incsrc "Music/song_of_healing.asm"
  print  "End of Music/song_of_healing.asm    ", pc


  print ""

  ; -------------------------------------------------------
  ; Sprites

  print "  -- Sprites --  "
  print ""

  incsrc "Sprites/all_sprites.asm"

  print ""

  ; -------------------------------------------------------
  ; Transformation Masks

  print "  -- Masks --  "
  print ""

  incsrc "Masks/all_masks.asm"

  print ""

  ; -------------------------------------------------------
  ; Items

  print "  -- Items --  "
  print ""

  incsrc "Items/all_items.asm"

  print ""

  ; -------------------------------------------------------
  ; Custom Menu and HUD

  print "  -- Menu --  "
  print ""

  incsrc "Menu/menu.asm"
  

  ; -------------------------------------------------------
  ; Misc
  
  ; LinkState_Bunny.not_moving
  org $078427 
    JSR $9BAA ; Link_HandleAPress

  incsrc "Util/item_cheat.asm"

  ; -------------------------------------------------------

  print ""
  print "Finished applying patches"
}
namespace off
