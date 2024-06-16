; -----------------------------------------------------------------------------------
; INDOOR COLLISION TABLES
;
; By Jeimuzu
; -----------------------------------------------------------------------------------


; 00 = No collision
; 01 = Standard collision (deflects projectiles)
; 02 = Standard collision (ignores projectiles)


; -----------------------------------------------------------------------------------
; GLOBAL COLLISION TABLES
; -----------------------------------------------------------------------------------

; Table 00		Doors & Stairs
; Table 01		Layer 2 Walls
; Table 02		Layer 1 Walls
; Table 03		Floors & Rails
; Table 04		Big Chest; Block; Dialogue; Exhaust; Pot; Shooters; Statue; Torch
; Table 05		See Blockset Collision Tables
; Table 06		See Blockset Collision Tables
; Table 07		Large Block; Peg; Pit; Small Chest; Spike Block; Torch???????????


; Table 00 (SNES: E9659 > E9698) (PC: $71659 > $71698))
; -----------------------------------------------------------------------------------
org $E9659

;		00   01   02   03   04   05   06   07   08   09   0A   0B   0C   0D   0E   0F
;		 1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16
; -----------------------------------------------------------------------------------
	db $01, $01, $01, $00, $02, $01, $02, $00, $01, $01, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $00, $00, $01, $00, $00, $02, $00, $00, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $01, $01, $01, $02, $02, $02, $02, $02, $01, $01, $00, $00 
	db $02, $02, $02, $02, $02, $02, $01, $02, $02, $02, $02, $02, $01, $01, $00, $00


; Table 01 (SNES: $E9699 > $E96D8) (PC: $71699 > $716D8)
; -----------------------------------------------------------------------------------
org $E9699

;		00   01   02   03   04   05   06   07   08   09   0A   0B   0C   0D   0E   0F
;		 1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16
; -----------------------------------------------------------------------------------
	db $00, $00, $00, $2A, $01, $20, $01, $01, $04, $01, $01, $18, $01, $02, $1C, $01 
	db $28, $28, $2A, $2A, $01, $02, $01, $01, $04, $00, $00, $00, $28, $01, $0A, $00 
	db $01, $01, $0C, $0C, $02, $02, $02, $02, $28, $2A, $20, $20, $20, $02, $08, $00 
	db $04, $04, $01, $01, $01, $02, $02, $02, $00, $00, $20, $20, $00, $02, $00, $00


; Table 02 (SNES: $E96D9 > $E9718) (PC: $716D9 > $71718)
; -----------------------------------------------------------------------------------
org $E96D9

;		00   01   02   03   04   05   06   07   08   09   0A   0B   0C   0D   0E   0F
;		 1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16
; -----------------------------------------------------------------------------------
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $02, $02 
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $18, $10, $10, $01, $01, $01 
	db $01, $01, $04, $04, $04, $04, $04, $04, $01, $02, $02, $00, $00, $00, $00, $00 
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $02, $02


; Table 03 (SNES: $E9719 > $E9758) (PC: $71719 > $71758)
; -----------------------------------------------------------------------------------
org $E9719

;		00   01   02   03   04   05   06   07   08   09   0A   0B   0C   0D   0E   0F
;		 1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16
; -----------------------------------------------------------------------------------
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $62, $62 
	db $00, $00, $24, $24, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $62, $62 
	db $27, $02, $02, $02, $27, $27, $01, $00, $00, $00, $00, $24, $00, $00, $00, $00 
	db $27, $27, $27, $27, $27, $10, $02, $01, $00, $00, $00, $24, $00, $00, $00, $00


; Table 04 (SNES: $E9759 > $E9798) (PC: $71759 > $71798)
; -----------------------------------------------------------------------------------
org $E9759

;		00   01   02   03   04   05   06   07   08   09   0A   0B   0C   0D   0E   0F
;		 1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16
; -----------------------------------------------------------------------------------
	db $27, $02, $02, $02, $27, $64, $27, $27, $02, $02, $02, $24, $00, $00, $00, $00 
	db $27, $27, $27, $27, $27, $64, $02, $02, $01, $02, $02, $23, $02, $00, $00, $00 
	db $27, $27, $27, $27, $27, $64, $02, $27, $02, $54, $00, $00, $27, $02, $02, $02 
	db $27, $27, $27, $27, $27, $27, $02, $27, $02, $54, $00, $00, $27, $02, $02, $02


; Table 05		See Blockset Collision Tables


; Table 06		See Blockset Collision Tables


; Table 07 (SNES: $E9799 > $E97D8) (PC: $71799 > $717D8)
; -----------------------------------------------------------------------------------
org $E9799

;		00   01   02   03   04   05   06   07   08   09   0A   0B   0C   0D   0E   0F
;		 1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16
; -----------------------------------------------------------------------------------
	db $27, $27, $00, $27, $60, $60, $01, $01, $01, $01, $02, $02, $0D, $00, $00, $4B ; Animated Tiles
	db $67, $67, $67, $67, $66, $66, $66, $66, $00, $00, $20, $20, $20, $20, $20, $20
	db $27, $63, $27, $55, $55, $01, $44, $00, $01, $20, $02, $02, $1C, $3A, $3B, $00
	db $27, $63, $27, $53, $53, $01, $44, $01, $0D, $00, $00, $00, $09, $09, $09, $09

; -----------------------------------------------------------------------------------
