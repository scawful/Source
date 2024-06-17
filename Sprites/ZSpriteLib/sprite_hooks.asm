SprAction    = $0D80
SprFrame     = $0D90 ; This is also used to do various things in different sprites
SprMiscA     = $0DA0 ; This can be used to do anything in sprite
SprMiscB     = $0DB0 ; This can be used to do anything in sprite
SprMiscC     = $0DE0 ; This can be used to do anything in sprite (Mainly used for sprite direction)
SprMiscD     = $0E90 ; This can be used to do anything in sprite
SprMiscE     = $0EB0 ; This can be used to do anything in sprite
SprMiscF     = $0EC0 ; This can be used to do anything in sprite
SprMiscG     = $0ED0 ; This can be used to do anything in sprite

SprStunTimer = $0B58

SprTimerA    = $0DF0 ; This address value is decreased by one every frames
SprTimerB    = $0E00 ; This address value is decreased by one every frames
SprTimerC    = $0E10 ; This address value is decreased by one every frames
SprTimerD    = $0EE0 ; This address value is decreased by one every frames
SprTimerE    = $0F10 ; This address value is decreased by one every frames
SprTimerF    = $0F80 ; This address value is decreased by 2 every frames is also used by the gravity routine

SprPause     = $0F00 ; Can probably be used for anything 
SprFloor     = $0F20
SprType      = $0E20 ; This contains the ID of the sprite 00 = raven, 01 = vulture, etc...
SprSubtype   = $0E30 ; This contains the Sub ID of the sprite

; 0x00 - Sprite is dead, totally inactive
; 0x01 - Sprite falling into a pit with generic animation.
; 0x02 - Sprite transforms into a puff of smoke, often producing an item
; 0x03 - Sprite falling into deep water (optionally making a fish jump up?)
; 0x04 - Death Mode for Bosses (lots of explosions).
; 0x05 - Sprite falling into a pit that has a special animation (e.g. Soldier)
; 0x06 - Death Mode for normal creatures.
; 0x08 - Sprite is being spawned at load time. An initialization routine will
;         be run for one frame, and then move on to the active state (0x09) the
;         very next frame.
; 0x09 - Sprite is in the normal, active mode.
; 0x0A - Sprite is being carried by the player.
; 0x0B - Sprite is frozen and / or stunned.
SprState     = $0DD0 ; This tells if the sprite is alive, dead, frozen, etc...

; Bits 0-4: define the number of OAM slots used by the sprite
; Bit 5: Causes enemies to go towards the walls? strange...
; Bit 6: No idea but the master sword ceremony sprites seem to use them....?
; Bit 7: If set, enemy is harmless. Otherwise you take damage from contact.
SprNbrOAM    = $0E40 

SprHealth    = $0E50
SprGfxProps  = $0E60

; Direction of sprite collision with wall
SprCollision = $0E70 

; Used in sprite state 0x03 (falling in water), used as delay in most of the sprites
SprDelay     = $0E80
SprRecoil    = $0EA0 ; Recoil Timer
SprDeath     = $0EF0

SprProps     = $0F50 ; DIWS UUUU - [D boss death][I Impervious to all attacks][W Water slash] [S Draw Shadow] [U Unused]
SprHitbox    = $0F60 ; ISPH HHHH - [I ignore collisions][S Statis (not alive eg beamos)][P Persist code still run outside of camera][H Hitbox] 
SprHeight    = $0F70 ; Distance from the shadow
SprHeightS   = $0F90 ; Distance from the shadow subpixel

SprYRecoil   = $0F30
SprXRecoil   = $0F40

SprGfx       = $0DC0 ; Determine the GFX used for the sprite
OAMPtr       = $90
OAMPtrH      = $92

SprY         = $0D00
SprX         = $0D10
SprYH        = $0D20
SprXH        = $0D30

SprYSpeed    = $0D40
SprXSpeed    = $0D50

SprYRound    = $0D60
SprXRound    = $0D70

SprCachedX   = $0FD8 ; This doesn't need to be indexed with X it contains the 16bit position of the sprite
SprCachedY   = $0FDA ; This doesn't need to be indexed with X it contains the 16bit position of the sprite

DungeonMainCheck = $021B ;0x01
SpriteRanCheck = $8E ;0x01

; Primarily deals with bump damage
; tzpd bbbb
;   t - TODO
;   z - High priority target for bees to give hints
;   p - Powder interaction (0: normal | 1: ignore)
;   d - Behavior when a boss spawns (0: die | 1: live)
;   b - bump damage class
;   Bump damage classes are read from a table at $06F42D
;   Each table entry has 3 values, for green, blue, and red mails
;   class   g    b    r
;   0x00    2    1    1
;   0x01    4    4    4
;   0x02    0    0    0
;   0x03    8    4    2
;   0x04    8    8    8
;   0x05   16    8    4
;   0x06   32   16    8
;   0x07   32   24   16
;   0x08   24   16    8
;   0x09   64   48   24
;
; Higher values are invalid, but here's what they are:
;   0x0A  169   48   32
;   0x0B  142  246  169
;   0x0C  144  133   71
;   0x0D  169   16  133
;   0x0E   70  169   33
;   0x0F   34  124  187
SprBump      = $0CD2

; Damage sprite is enduring
SprDmg       = $0CE2

; Sprite Deflection Properties
;     abcdefgh
;     a - If set... creates some condition where it may or may not die
;     b - Same as bit 'a' in some contexts (Zora in particular)
;     c - While this is set and unset in a lot of places for various sprites, its
;         status doesn't appear to ever be queried. Based on the pattern of its
;         usage, however, the best deduction I can make is that this was a flag
;         intended to signal that a sprite is an interactive object that Link can
;         push against, pull on, or otherwise exerts a physical presence.
;     d - If hit from front, deflect Ice Rod, Somarian missile,
;         boomerang, hookshot, and sword beam, and arrows stick in
;         it harmlessly.  If bit 1 is also set, frontal arrows will
;         instead disappear harmlessly.  No monsters have bit 4 set
;         in the ROM data, but it was functional and interesting
;         enough to include.
;     e - If set, makes the sprite collide with less tiles than usual
;     f - If set, makes sprite impervious to sword and hammer type attacks
;     g - If set, makes sprite impervious to arrows, but may have other additional meanings.
;     h - Handles behavior with previous deaths flagged in $7F:DF80 (0: default | 1: ignore)
SprDefl      = $0CAA

; iwbs pppp
;   i - disable tile interaction
;   w - something water
;   b - sprite is blocked by shield
;   s - taking damage sfx to use TODO name
;   p - prize pack
SprPrize     = $0BE0

; tttt a.bp
;   t - tile hitbox TODO ???
;   a - deflect arrows TODO VERIFY
;   b - boss death
;   p - idk
SprTileDie   = $0B6B

; If nonzero, ancillae do not interact with the sprite
; Bulletproof
SprBulletproof = $0BA0

Sprite_SetSpawnedCoords = $09AE64

; =========================================================
; set the oam coordinate for the sprite draw
Sprite_PrepOamCoord =  $06E416

; =========================================================
; check if the sprite is getting damage from player or items
Sprite_CheckDamageFromPlayer = $06F2AA

; =========================================================
; check if the sprite is touching the player to damage
Sprite_CheckDamageToPlayer = $06F121

; =========================================================
; damage the player everywhere on screen?
Sprite_AttemptDamageToPlayerPlusRecoil = $06F41F

; =========================================================
;Draw the sprite depending of the position of the player (if he has to be over or under link)
org $06F864
Sprite_OAM_AllocateDeferToPlayer:

org $0DBA80
OAM_AllocateFromRegionA:
org $0DBA84
OAM_AllocateFromRegionB:
org $0DBA88
OAM_AllocateFromRegionC:
org $0DBA8C
OAM_AllocateFromRegionD:
org $0DBA90
OAM_AllocateFromRegionE:
org $0DBA94
OAM_AllocateFromRegionF:

org $05DF70
Sprite_DrawMultiple_quantity_preset:

; =========================================================
;makes all the sprites on screen shaking?
org $0680FA
ApplyRumbleToSprites:

; =========================================================
; args : 
; !pos1_low  = $00
; !pos1_size = $02
; !pos2_low  = $04
; !pos2_size = $06
; !pos1_high = $08
; !pos2_high = $0A
; !ans_low   = $0F
; !ans_high  = $0C
;returns carry clear if there was no overlap
CheckIfHitBoxesOverlap = $0683E6

; =========================================================
; $0FD8 = sprite's X coordinate
; $0FDA = sprite's Y coordinate
Sprite_Get_16_bit_Coords = $0684BD

; =========================================================
; load / draw a 16x16 sprite
Sprite_PrepAndDrawSingleLarge = $06DBF0

; =========================================================
; load / draw a 8x8 sprite
Sprite_PrepAndDrawSingleSmall = $06DBF8

; =========================================================
; draw shadow (requires additional oam allocation)
Sprite_DrawShadow = $06DC54

; =========================================================
; check if the sprite is colliding with a solid tile set $0E70, X
; ----udlr , u = up, d = down, l = left, r = right
Sprite_CheckTileCollision = $06E496

; =========================================================
; $00[0x02] - Entity Y coordinate
; $02[0x03?] - Entity X coordinate
; $0FA5
Sprite_GetTileAttr = $06E87B

; =========================================================
; check if the sprite is colliding with a solid sloped tile
Sprite_CheckSlopedTileCollision = $06E8FD

; =========================================================
; set the velocity x,y towards the player (A = speed)
Sprite_ApplySpeedTowardsPlayer = $06EA12

; =========================================================
; \return $0E is low byte of player_y_pos - sprite_y_pos
; \return $0F is low byte of player_x_pos - sprite_x_pos
Sprite_DirectionToFacePlayer = $06EAA0

; =========================================================
; if Link is to the left of the sprite, Y = 1, otherwise Y = 0.
Sprite_IsToRightOfPlayer = $06EACD

; =========================================================
; return Y=1 sprite is below player, otherwise Y = 0
Sprite_IsBelowPlayer = $06EAE4

; =========================================================
; $06 = sprite's Y coordinate
; $07 = sprite's X coordinate
Sprite_IsBelowLocation = $06EB1D

; =========================================================
; check damage done to player if they collide on same layer
Sprite_CheckDamageToPlayerSameLayer = $06F129

; =========================================================
; check damage done to player if they collide even if they are not on same layer
Sprite_CheckDamageToPlayerIgnoreLayer = $06F131

; =========================================================
; play a sound loaded in A
org $0DBB6E
Sound_SetSfx1PanLong:

org $0DBB7C
Sound_SetSfx2PanLong:

org $0DBB8A
Sound_SetSfx3PanLong:

; =========================================================
;spawn a new sprite on screen, A = sprite id
;when using this function you have to set the position yourself
;these values belong to the sprite who used that function not the new one 
;$00 low x, $01 high x
;$02 low y, $03 high y
;$04 height, $05 low x (overlord)
;$06 high x (overlord), $07 low y (overlord)
;$08 high y (overlord)
Sprite_SpawnDynamically = $1DF65D

Player_ResetState = $07F1A3

; =========================================================
; move the sprite if he stand on a conveyor belt
Sprite_ApplyConveyorAdjustment = $1D8010

; =========================================================
;set the hitbox of the player (i think)
;org $0683EA
;Sprite_SetupHitBoxLong:

; =========================================================
; set tile of dungeon
Dungeon_SpriteInducedTilemapUpdate = $01E7A9


; =========================================================
; player can't pass through the sprite
Sprite_PlayerCantPassThrough = $1EF4F3

; =========================================================
; player can't hookshot to that sprite
Sprite_NullifyHookshotDrag = $0FF540

; =========================================================
; stop the dash attack of the player
Player_HaltDashAttack = $0791B9

; =========================================================
; show a message box without any condition
; A = low byte of message ID to use.
; Y = high byte of message ID to use.
Sprite_ShowMessageUnconditional = $05E219

; =========================================================
; Y = item id
Link_ReceiveItem = $0799AD

; =========================================================
; show a message if we press A and face the sprite
; A = low byte of message ID to use.
; Y = high byte of message ID to use.
Sprite_ShowSolicitedMessageIfPlayerFacing = $05E1A7

; =========================================================
; show a message if we touch the sprite 
; should be used with Sprite_PlayerCantPassThrough
; A = low byte of message ID to use.
; Y = high byte of message ID to use.
Sprite_ShowMessageFromPlayerContact = $05E1F0

; Parameters: Stack, A
UseImplicitRegIndexedLocalJumpTable = $008781

EnableForceBlank = $00893D


; =========================================================
; $04 = X
; $05 = HighX
; $06 = Y
; $07 = HighY
;   A = Speed
; \return $00 - Y Velocity
; \return $01 - X Velocity

Sprite_ProjectSpeedTowardsEntityLong = $06EA22

; =========================================================
; Misc long functions 

Sprite_SpawnFireball = $0DDA06

Sprite_MoveLong = $1D808C

Sprite_DrawRippleIfInWater = $1EFF8D

Sprite_SpawnSparkleGarnish = $058008

GetRandomInt = $0DBA71

Sprite_ProjectSpeedTowardsPlayer = $06EA1A

Sprite_CheckDamageFromPlayerLong = $06F2AA

Sprite_CheckIfLifted = $06AA0C

Sprite_TransmuteToBomb = $06AD50

Sprite_SetSpawnedCoordinates = $09AE64

Guard_ParrySwordAttacks = $06EB5E

ThrownSprite_TileAndSpriteInteraction_long = $06DFF2

; =========================================================
; Local functions which may be useful for sprites
; Sprite_AttemptZapDamage - 06EC02
