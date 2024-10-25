; Dungeons

incsrc "Dungeons/keyblock.asm"
print  "End of keyblock.asm               ", pc

; Pendant from chest position
org $098823
  LDY.b #$68

; Disable hardcoded sanctuary song
org $028BE7
  NOP #2

; Fixed color fade-in effect
; TODO: Investigate if this is the best way to fix this.
; Module06_UnderworldLoad
org $028364
Module06_UnderworldLoad:
{
  LDA.b #$00 ; Fixed color RGB: #808000
  STA.b $9C

  LDA.b #$00 : STA.b $9D

  LDA.b #$00 : STA.b $9E
  LDA.b #$00
  STA.l $7EC005
  STA.l $7EC006

  JSL $079A2C ; Link_TuckIntoBed
}

incsrc "Dungeons/enemy_damage.asm"
print  "End of enemy_damage.asm           ", pc

incsrc "Dungeons/house_walls.asm"

; Use of Bank 0x2C begins
incsrc "Dungeons/Objects/object_handler.asm"
print  "End of object_handler.asm         ", pc

; Tag: Holes8
incsrc "Dungeons/together_warp_tag.asm"

; Custom Tag: Holes7
; Minish Tag: Holes5
incsrc "Dungeons/custom_tag.asm"

; Tag: Holes0
incsrc "Dungeons/floor_puzzle.asm"

incsrc "Dungeons/spike_subtype.asm"

incsrc "Dungeons/attract_scenes.asm"
print  "End of attract_scenes.asm         ", pc

incsrc "Collision/CollisionTablesExpanded.asm"
incsrc "Collision/GlobalCollisionTables.asm"

pullpc ; Bank 0x33

TransferDungeonMapGfx:
{
  REP #$20
  LDX #$80 : STX $2100
  LDX #$80 : STX $2115
  LDA #$5000 : STA $2116 ; Destination of the DMA in VRAM
  LDA #$1801 : STA $4300 ; DMA Transfer Mode and destination register
  LDA.w #MapGfx     : STA $4302
  LDX.b #MapGfx>>16 : STX $4304
  LDA #$2000 : STA $4305
  LDX #$01 : STX $420B
  LDX #$0F : STX $2100
  SEP #$30

  LDA.b #$09 : STA.b $14
  RTL

  MapGfx:
    incbin dungeon_maps.bin
}

CheckForTingleMaps:
{
  LDA.w $040C : CMP.b #$0C : BEQ .check_mush
                CMP.b #$0A : BEQ .check_tail
                CMP.b #$10 : BEQ .check_castle
                CMP.b #$16 : BEQ .check_zora
                CMP.b #$12 : BEQ .check_glacia
                CMP.b #$0E : BEQ .check_goron
                CMP.b #$18 : BEQ .check_ship
                JMP +
  .check_mush
    LDA.l TingleMaps : AND.b #$01 : RTL
  .check_tail
    LDA.l TingleMaps : AND.b #$02 : RTL
  .check_castle
    LDA.l TingleMaps : AND.b #$04 : RTL
  .check_zora
    LDA.l TingleMaps : AND.b #$08 : RTL
  .check_glacia
    LDA.l TingleMaps : AND.b #$10 : RTL
  .check_goron
    LDA.l TingleMaps : AND.b #$20 : RTL
  .check_ship
    LDA.l TingleMaps : AND.b #$40 : RTL
  +
  LDA.w $040C
  CMP.b #$FF
  RTL
}

NewWaterOverlayData:
; Horizontal
db $1B, $A1, $C9 ; 0x0C9: Flood water (medium) ⇲ | { 06, 28 } | Size: 0D
db $51, $A1, $C9 ; 0x0C9: Flood water (medium) ⇲ | { 14, 28 } | Size: 05
db $71, $A1, $C9 ; 0x0C9: Flood water (medium) ⇲ | { 1C, 28 } | Size: 05
db $92, $A1, $C9 ; 0x0C9: Flood water (medium) ⇲ | { 24, 28 } | Size: 09
db $A2, $A1, $C9 ; 0x0C9: Flood water (medium) ⇲ | { 24, 28 } | Size: 09
db $C1, $A1, $C9 ; 0x0C9: Flood water (medium) ⇲ | { 28, 0C } | Size: 07

; Vertical
db $A1, $33, $C9 ; 0x0C9: Flood water (medium) ⇲ | { 28, 0C } | Size: 07
db $A1, $72, $C9 ; 0x0C9: Flood water (medium) ⇲ | { 28, 1C } | Size: 06
db $FF, $FF ; End

print "End of dungeons.asm               ", pc

pushpc

org $0288FF
  JSL CheckForTingleMaps : NOP

; Transfer Dungeon Map Graphics
; Module0E_03_01_00_PrepMapGraphics
org $0AE152
JSL TransferDungeonMapGfx

; RoomTag_GetHeartForPrize
; Swap LW/DW check on spawn falling prize
org $01C71B
  LDA.l $7EF37A ; Crystals in LW

org $01C727
  LDA.l $7EF374 ; Pendants in DW

; RoomTag_WaterGate
org $01CBAC
LDA.w #NewWaterOverlayData>>16
STA.b $B9
LDA.w #NewWaterOverlayData>>0
