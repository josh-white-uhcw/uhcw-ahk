
; UNSTABLE, USE WITH CAUTION

#Requires AutoHotkey v2.0
#Include ../Master Workflow Script.ahk

; GEH Validation Hotkeys

; Create docx using copied MRN
PgUp:: {
    SetTitleMatchMode(2)

    if WinExist("Teams") {
        WinActivate()
    } else {
        MsgBox("Window not found")
        Return
    }

    ;go to teams and make a docx
    Click(149, 138)
    Sleep(200)
    Click(126, 216)
}

; Enter title to doc when loaded
!v:: {
    Click(154, 104)
    Sleep(500)
    Send("^v")
    Send(" - ")
    Send(initials)
    Send(" - ")
}

; View encounter in Access
Numpad7:: {
    SetTitleMatchMode(2)

    ;access = pm office
    if WinExist("Access")
    {
        WinActivate()
    } else {
        MsgBox("Window not found")
        Return
    }

    Sleep(200)
    Click(14, 742)
    Sleep(50)
    Send "{Wheeldown}"
    Send "{Wheeldown}"
    Send "{Wheeldown}"
    Send "{Wheeldown}"
    Send "{Wheeldown}"
    Send "{Wheeldown}"
    Sleep(50)
    Click(14, 742)
    Sleep(100)
    Click(14, 742)
    
}