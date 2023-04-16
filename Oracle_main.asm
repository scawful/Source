;===========================================================
;           The Legend of Zelda: Oracle of Secrets
;                   Composed by: Scawful
;
; Hacks Included:
;   Inventory Screen Overhaul
;   Book Reveals Secrets
;   Bunny Hood Item
;   Ice Rod Freezes Water
;   Intro skip after leaving house
;   Key block link's awakening
;   Lost Sea Area Combo

; 
;
; Expanded Banks Key:
;   20 - None
;   21 - Jump Feather
;   22 - Book of Secrets
;   23 - Bottle Net 
;   24 - Menu
;   25 - HUD
;   26 - House Tag
;   27 - Mask Routines(?)
;   28 - None
;   29 - Custom Sprite Jump Table
;   30 - Custom Sprite Functions
;   31 - Deku Link Code
;   32 - Farore Sprite Code
;   33 - None
;   34 - None
;   35 - Deku Link GFX
;   36 - Zora Link GFX
;   37 - Bunny Link GFX
;   38 - Wolf Link GFX
;   39 - Palette_ArmorAndGloves  
;   
;===========================================================

namespace Oracle
{
  print ""
  print "Applying patches to Oracle of Secrets"
  print ""

  incsrc "Util/ram.asm"
  incsrc "Util/functions.asm"


  incsrc "Sprites/farore_and_maku.asm"
  print  "End of Sprites/farore_and_maku.asm", pc

  ; ---------------------------------------------------------
  incsrc "Items/jump_feather.asm"
  print  "End of Items/jump_feather.asm     ", pc

  ; ---------------------------------------------------------
  incsrc "Graphics/boat_gfx.asm"
  print  "End of Graphics/boat_gfx.asm      ", pc

  ; ---------------------------------------------------------
  incsrc "Dungeons/keyblock.asm"
  print  "End of Dungeons/keyblock.asm      ", pc

  ; ---------------------------------------------------------
  incsrc "Events/house_tag.asm"
  print  "End of Events/house_tag.asm       ", pc

  ; ---------------------------------------------------------
  incsrc "Menu/menu.asm"
  print  "End of Menu/menu.asm              ", pc

  ; ---------------------------------------------------------
  ; incsrc "Items/bottle_net.asm"
  ; print "End of Items/bottle_net.asm        ", pc

  ; ---------------------------------------------------------
  incsrc "Events/maku_tree.asm"
  print  "End of Events/maku_tree.asm       ", pc

  ; ---------------------------------------------------------
  incsrc "Events/lostsea.asm"
  print  "End of Events/lostsea.asm         ", pc

  ; ---------------------------------------------------------
  incsrc "Items/ice_rod.asm"
  print  "End of Items/ice_rod.asm          ", pc

  ; ---------------------------------------------------------
  incsrc "Items/book_of_secrets.asm"
  print  "End of Items/book_of_secrets.asm  ", pc

  ; ---------------------------------------------------------
  incsrc "Debug/debug.asm"
  print  "End of Debug/debug.asm            ", pc
  
  ; ---------------------------------------------------------
  incsrc "Masks/mask_routines.asm"

  ; ---------------------------------------------------------
  incsrc "Masks/deku_mask.asm"
  print  "End of Masks/deku_mask.asm        ", pc

  ; ---------------------------------------------------------
  incsrc "Masks/zora_mask.asm"
  print  "End of Masks/zora_mask.asm        ", pc

  ; ---------------------------------------------------------
  incsrc "Masks/wolf_mask.asm"
  print  "End of Masks/wolf_mask.asm        ", pc

  ; ---------------------------------------------------------
  incsrc "Masks/bunny_hood.asm"
  print  "End of Masks/bunny_hood.asm       ", pc

  print ""
  print "Finished applying patches"
}
namespace off
