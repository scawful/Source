POSY            = $7E0020
POSYH           = $7E0021
POSX            = $7E0022
POSXH           = $7E0023
POSZ            = $7E0024
POSZH           = $7E0025

; Link_ControlHandler - Indexed by $5D
; dw LinkState_Default                  ; 0x00
; dw LinkState_Pits                     ; 0x01
; dw LinkState_Recoil                   ; 0x02
; dw LinkState_SpinAttack               ; 0x03
; dw LinkState_Swimming                 ; 0x04
; dw LinkState_OnIce                    ; 0x05
; dw LinkState_Recoil                   ; 0x06
; dw LinkState_Zapped                   ; 0x07
; dw LinkState_UsingEther               ; 0x08
; dw LinkState_UsingBombos              ; 0x09
; dw LinkState_UsingQuake               ; 0x0A - DekuHover
; dw LinkState_HoppingSouthOW           ; 0x0B
; dw LinkState_HoppingHorizontallyOW    ; 0x0C
; dw LinkState_HoppingDiagonallyUpOW    ; 0x0D
; dw LinkState_HoppingDiagonallyDownOW  ; 0x0E
; dw LinkState_0F                       ; 0x0F
; dw LinkState_0F                       ; 0x10
; dw LinkState_Dashing                  ; 0x11
; dw LinkState_ExitingDash              ; 0x12
; dw LinkState_Hookshotting             ; 0x13
; dw LinkState_CrossingWorlds           ; 0x14
; dw LinkState_ShowingOffItem           ; 0x15
; dw LinkState_Sleeping                 ; 0x16
; dw LinkState_Bunny                    ; 0x17
; dw LinkState_HoldingBigRock           ; 0x18
; dw LinkState_ReceivingEther           ; 0x19
; dw LinkState_ReceivingBombos          ; 0x1A
; dw LinkState_ReadingDesertTablet      ; 0x1B
; dw LinkState_TemporaryBunny           ; 0x1C
; dw LinkState_TreePull                 ; 0x1D
; dw LinkState_SpinAttack               ; 0x1E