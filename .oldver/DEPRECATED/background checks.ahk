; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 

#Requires AutoHotkey v2.0
; was going to deal with extra windows (encounter search, relationship search) but decided its better in the main file.

targetClass := "Transparent Windows Client"

SetTimer(() => {
    hwnd := WinExist("ahk_class " targetClass)
    if hwnd {
        ; Send Enter to the window's main control
        ControlSend("", "{Enter}", "ahk_id " hwnd)
        TrayTip("Sent Enter", "To window with class: " targetClass, 1000)
    }
}, 1000)
