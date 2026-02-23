; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 

; ================================
; Hotkeys
; ================================

; Ctrl + Alt + X to immediately exit the script
^!x::ExitApp()

; ============================================
; Delete:: - Copy MRN, open patient chart, handle dialogs
; ============================================
Delete:: {
    ; -- Copy MRN from sheet --
    Send("{Esc}")
    Sleep(50)
    Loop 4 {
        Send("^{Left}")
        Sleep(50)
    }
    Sleep(50)
    Send("{Down}")
    Sleep(50)
    Send("{Right}")
    Sleep(50)
    Send("^c")  ; Copy MRN
    Sleep(250)

    ; -- Switch to PowerChart and enter MRN --
    CoordMode("Mouse", "Screen")
    Click(3708, 113)
    Sleep(100)
    Send("^v")
    Sleep(200)
    Send("{Enter}")

}

; ============================================
; Insert:: - Enter "No Documentation"
; ============================================
Insert:: {
    Send("!{Tab}")
    Sleep(200)

    Loop 3 {
        Send("{Right}")
        Sleep(200)
    }

    Send("No Documentation")
    Sleep(200)

    Loop 2 {
        Send("{Right}")
        Sleep(200)
    }

    Send("Josh")
    Sleep(200)

    Send("{Right}")
    Sleep(200)

    Send("{Up}")
    Sleep(200)

    Send("^c")  ; Copy current value
    Sleep(200)

    Send("{Down}")
    Sleep(200)

    Send("^v")  ; Paste copied value
    Sleep(50)

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

; ============================================
; Numpad9:: - Last date checked
; ============================================
Numpad9:: {
    Loop 12 {
        Send("{Right}")
        Sleep(50)
    }
    Send("{Up}")
    Sleep(50)
    Send("^c")
    Sleep(50)
    Send("{Down}")
    Sleep(50)
    Send("^v")
    Sleep(50)
    Send("^{Left}")
    Sleep(50)

}


