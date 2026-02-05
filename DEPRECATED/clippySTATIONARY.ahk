#Requires AutoHotkey v2.0
#Include ../Master Workflow Script.ahk

; Paste from slot 1
F1:: Send(ClipSlot1)
F2:: Send(ClipSlot2)
F3:: Send(ClipSlot3)
F4:: Send(ClipSlot4)
F5:: Send(ClipSlot5)
F6:: Send(ClipSlot6)
F7:: Send(ClipSlot7)
F8:: Send(ClipSlot8)
F9:: Send(ClipSlot9)

; Clear all slots and tooltips
F10:: {
    global ClipSlot1, ClipSlot2, ClipSlot3, ClipSlot4, ClipSlot5
    global ClipSlot6, ClipSlot7, ClipSlot8, ClipSlot9, CurrentClipSlot, PreviousClip
    
    ClipSlot1 := ""
    ClipSlot2 := ""
    ClipSlot3 := ""
    ClipSlot4 := ""
    ClipSlot5 := ""
    ClipSlot6 := ""
    ClipSlot7 := ""
    ClipSlot8 := ""
    ClipSlot9 := ""
    PreviousClip := ""
    CurrentClipSlot := 1
    ToolTip("",,,1)
    ToolTip("",,,2)
    ToolTip("",,,3)
    ToolTip("",,,4)
    ToolTip("",,,5)
    ToolTip("",,,6)
    ToolTip("",,,7)
    ToolTip("",,,8)
    ToolTip("",,,9)
}