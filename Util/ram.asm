; ==============================
; RAM in Use
StoryState = $7C

org $008000
base $7E0730

MenuScrollLevelV: skip 1
MenuScrollLevelH: skip 1
MenuScrollHDirection: skip 2
MenuItemValueSpoof: skip 2
ShortSpoof: skip 1 
MusicNoteValue: skip 2
OverworldLocationPointer: skip 2

base off
