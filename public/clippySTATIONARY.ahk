#Requires AutoHotkey v2.0
#Include ../Master Workflow Script.ahk

; Clipboard rules

; Clipboard slots (1-9), enter the text into the quotes and the corresponding function key will paste. example below.
global ClipSlot1 := "waitlist created in EPR/PAS, to be booked later"
global ClipSlot2 := ""
global ClipSlot3 := ""
global ClipSlot4 := ""
global ClipSlot5 := ""
global Clipslot6 := ""
global ClipSlot7 := ""
global ClipSlot8 := ""
global ClipSlot9 := ""

; Paste from slot 1
F1:: {
    global ClipSlot1
    Send(ClipSlot1)
}

; Paste from slot 2
F2:: {
    global ClipSlot2
    Send(ClipSlot2)
}

; Paste from slot 3
F3:: {
    global ClipSlot3
    Send(ClipSlot3)
}

; Paste from slot 4
F4:: {
    global ClipSlot4
    Send(ClipSlot4)
}

; Paste from slot 5
F5:: {
    global ClipSlot5
    Send(ClipSlot5)
}

; Paste from slot 6
F6:: {
    global ClipSlot6
    Send(ClipSlot6)
}

; Paste from slot 7
F7:: {
    global ClipSlot7
    Send(ClipSlot7)
}

; Paste from slot 8
F8:: {
    global ClipSlot8
    Send(ClipSlot8)
}

; Paste from slot 9
F9:: {
    global ClipSlot9
    Send(ClipSlot9)
}

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