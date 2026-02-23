#Requires AutoHotkey v2.0
#Include ../Master Workflow Script.ahk

; messy code, sorry, it works tho

if (AdaptionMode) {
    ; Timer to monitor clipboard changes
    SetTimer(ClipboardMonitor, 500)
}
else {
    ToolTip("Adaption Mode is disabled. Clipboard monitoring is inactive.", 1920, 10)
}

; Clipboard slots (1-9) with slot 1 always being the most recent
global PreviousClip := ""

ClipboardMonitor() {
    global ClipSlot1, ClipSlot2, ClipSlot3, ClipSlot4, ClipSlot5
    global ClipSlot6, ClipSlot7, ClipSlot8, ClipSlot9, PreviousClip
    
    currentClip := A_Clipboard
    
    ; Only process if clipboard changed
    if (currentClip != PreviousClip && currentClip != "") {
        PreviousClip := currentClip
        
        ; Shift all slots back by one
        ClipSlot9 := ClipSlot8
        ClipSlot8 := ClipSlot7
        ClipSlot7 := ClipSlot6
        ClipSlot6 := ClipSlot5
        ClipSlot5 := ClipSlot4
        ClipSlot4 := ClipSlot3
        ClipSlot3 := ClipSlot2
        ClipSlot2 := ClipSlot1
        ClipSlot1 := currentClip
        
        UpdateTooltips()
    }
}

UpdateTooltips() {
    global ClipSlot1, ClipSlot2, ClipSlot3, ClipSlot4, ClipSlot5
    global ClipSlot6, ClipSlot7, ClipSlot8, ClipSlot9
    
    maxLength := 50
    
    Loop 9 {
        slotContent := ClipSlot%A_Index%
        if (slotContent != "") {
            ; Find first newline position
            newlinePos := InStr(slotContent, "`n")
            
            ; Determine where to cut: at newline or maxLength, whichever comes first
            if (newlinePos > 0 && newlinePos <= maxLength)
                cutoffPos := newlinePos - 1
            else if (StrLen(slotContent) > maxLength)
                cutoffPos := maxLength
            else
                cutoffPos := StrLen(slotContent)
            
            ; Build display text
            if (cutoffPos < StrLen(slotContent))
                displayText := SubStr(slotContent, 1, cutoffPos) . "... - F" . A_Index
            else
                displayText := slotContent . " - F" . A_Index
            
            ToolTip(displayText, 1920, (A_Index - 1+(ClipboardDistance)) * 20, A_Index) ; ClipboardDistance is defined in the master file
        }
        else
            ToolTip("", , , A_Index)
    }
}

; Paste from slots
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
    if (!AdaptionMode) {
        MsgBox("You cannot clear the clipboard in static mode.")
        return
    }
    global ClipSlot1, ClipSlot2, ClipSlot3, ClipSlot4, ClipSlot5
    global ClipSlot6, ClipSlot7, ClipSlot8, ClipSlot9, PreviousClip
    
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
    
    Loop 9
        ToolTip("", , , A_Index)
}

UpdateTooltips()