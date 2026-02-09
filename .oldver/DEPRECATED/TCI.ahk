#Requires AutoHotkey v2.0

; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 

; --- Hotkey to kill the script instantly ---
^!x:: {
    ExitApp()
}

; ============================================
; Delete:: - Copy MRN, open patient chart, handle dialogs
; ============================================
Delete:: {
    Send("^{Left}")
    Sleep(10)
    Send("^{Left}")
    Sleep(10)
    Send("^{Left}")
    Sleep(10)
    Send("^{Left}")
    Sleep(100)
    Send("^c")
    Sleep(100)

    SetTitleMatchMode(2)  ; Allow partial title matching
    If WinExist("Standard Patient En") {
        WinActivate()
    } Else {
        MsgBox("Window not found")
        Return
    }

    Sleep(2000)
    Click(280, 259)
    Sleep(200)
    CoordMode "Mouse", "Screen"      ; Make sure Click uses screen coordinates
    Click 476, 677
    Sleep(200)
    Send("^v")
    Sleep(100)
    Send("{Enter}")
    Sleep(100)
    Send("{Enter}")
    Sleep(100)
    Send("{Enter}")
}

; ============================================
; Insert:: - Copy MRN, open patient chart, handle dialogs
; ============================================
Insert:: {
    Send("{Right}")
    Send("{Right}")
    Send("{Right}")
    Send("{Right}")
    Send("No Documentation")
    Send("{Right}")
    Send("Josh")
    Send("{Right}")
    Send("^;")
    Send("{Enter}")
}

; ============================================
; Home:: - Return to Revenue Cycle window and paste MRN
; ============================================
Home:: {
    SetTitleMatchMode(2)  ; Allow partial title matching

    If WinExist("Revenue Cyc") {
        WinActivate()
    } Else {
        MsgBox("Window not found")
        Return
    }

    Click(31, 57)
    Send("^v")
    Sleep(200)
    Send("{Enter}")
    Sleep(500)
    Send("{Enter}")
}