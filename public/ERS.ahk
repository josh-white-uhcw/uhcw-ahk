#Requires AutoHotkey v2.0

; Hotkey: Ctrl+Shift+V
^+v::{
    SendText(A_Clipboard)
}

#HotIf GetKeyState("e", "P") && GetKeyState("r", "P")
s:: {
    Send("f")
}
#HotIf

