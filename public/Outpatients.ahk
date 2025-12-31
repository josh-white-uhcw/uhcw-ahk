#Requires AutoHotkey v2.0
#Include ../Master Workflow Script.ahk

#Include sub-processes/outpatients/enterOutcome.ahk
#Include sub-processes/outpatients/hwnd.ahk
#Include sub-processes/outpatients/tab.ahk
#Include sub-processes/outpatients/windowCheck.ahk

#MaxThreadsBuffer True
#MaxThreads 1

; Outpatients Validation Hotkeys

; Get New MRN from browser tab
Numpad0:: {
    FindHwnd ; calls outpatients-sub/hwnd.ahk
    Sleep(100)

    FindTab ; calls outpatients-sub/tab.ahk
    Sleep(100)
    
    Send("{Down}")
    Send("^{Left}")
    Send("^{Left}")
    Sleep(100)

    if !legacySheet {
        Send("{Right}")
    }

    Sleep(100)
    Send("^{c}")
}

; Goto Powerchart and navigate to documentation
; this is the ugliest code ever. if you need to edit this before i re-write it im sorry 😭 
Numpad1:: {
    if !windowCheck("Power") {
        MsgBox("Window check failed")
        return
    }

    Click(1778, 112)
    Sleep(200)

    ; Check clipboard
    If InStr(A_Clipboard, "COPY"){
        MsgBox("Clipboard failed to copy!")
        Return
    }
    
    ; Pastes into searchbar and opens patient search
    Send("^v")
    Sleep(200)
    Send("{Enter}")
    Sleep(200)
    Send("{Enter}")

    SetTitleMatchMode(2)

    ; Wait for either relationship or encounter window
    ; yes there are two separate searches for encounter window, but for now it works so ¯\_(ツ)_/¯

    windowFound := ""
    startTime := A_TickCount
    timeout := 5000  ; 5 seconds
    
    while (A_TickCount - startTime < timeout) {
        if WinExist("Rela") {
            windowFound := "Relationship"
            break
        }
        if WinExist("Selec") {
            windowFound := "Encounter"
            break
        }
        Sleep(100)
    }
    
    ; Handle relationship window if found
    if (windowFound = "Relationship") {
        WinActivate("Rela")
        Sleep(200)
        Send("{Enter}")
        Sleep(500)
        
        ; Now wait for encounter window
        if WinWait("Selec", , 5) {
            WinActivate("Selec")
        
        ; Keep sending Enter until window closes
        while WinExist("Selec") {
            WinActivate("Selec")
            Send("{Enter}")
            Sleep(250)
        }
        }
    }
; Handle encounter window if found (skip relationship)
    else if (windowFound = "Encounter") {
        WinActivate("Selec")
        Sleep(50)
        
        ; Keep sending Enter until window closes
        while WinExist("Selec") {
            WinActivate("Selec")
            Send("{Enter}")
            Sleep(100)
        }
    }
    ; Neither window found
    else {
        MsgBox("Cannot find 'Assign A Relationship' or 'Encounter Selection' window")
        Return
    }
    
    ; Click first documentation entry
    CoordMode("Mouse", "Screen")
    MouseMove(2151, 371)
    Click()
}

; Goto Revenue Cycle window and paste MRN
Numpad2:: {
    if !windowCheck("Revenue Cycle") {
        MsgBox("Window check failed")
        return
    }

    Click(31, 57)
    Send("^v")
    Sleep(200)
    Send("{Enter}")
    Sleep(500)
    Send("{Enter}")

    if !betaTesting {
        return
    }

    Sleep(500)
    ; detecting the color of 'file' selection to know when to navigate to past appointments.
    CoordMode "Pixel", "Window"
    targetColor := 0xCCE8FF
    WinActivate "Rev"

    Loop {
        color := PixelGetColor(27,27)

        if (color = targetColor)
            break

        Send "{Alt}"
        Sleep 200
    }

    Sleep(50)
    Send("v")
    Sleep(50)
    Send("o")
    Sleep(50)
    Send("{Enter}")
    Sleep(50)
    Send("p")
}

; Goto Appointment Book window and paste MRN
Numpad3:: {
    if !windowCheck("Standard Patient Enquiry") {
        MsgBox("Window check failed")
        return
    }

    ; Close any open windows within
    ; Does not work in script for some reason however manually pressing Esc does? nothing bad comes of this however so if there is still a window open at run just run again
    Send("{Esc}")
    Sleep(50)
    Send("{Esc}")
    Sleep(50)
    Send("{Esc}")
    Sleep(50)

    ; Click '...'
    Click(280, 261)
    Sleep(500) ; Window can be slow

    ; Click 'Reset'
    Click(156, 530)
    Sleep(200)

    ; Paste and enter MRN
    Send("^v")
    Sleep(200)
    Send("{Enter}")
    Sleep(200)
    Send("{Enter}")
    Sleep(200)
    Send("{Enter}")
}

; Mark as "No Documentation"
^Numpad1:: {
    FindHwnd ; calls outpatients-sub/hwnd.ahk
    Sleep(100)

    FindTab ; calls outpatients-sub/tab.ahk
    Sleep(100)

    enterOutcome("No Documentation") ; calls outpatients-sub/enterOutcome.ahk
}

; Mark as "Checked Out" with NOC 3
^Numpad2:: {
    FindHwnd ; calls outpatients-sub/hwnd.ahk
    Sleep(100)

    FindTab ; calls outpatients-sub/tab.ahk
    Sleep(100)

    enterOutcome("Checked Out") ; calls outpatients-sub/enterOutcome.ahk
}

; Mark as "Already Checked Out" with NOC 3
^Numpad3:: {
    FindHwnd ; calls outpatients-sub/hwnd.ahk
    Sleep(100)

    FindTab ; calls outpatients-sub/tab.ahk
    Sleep(100)

    enterOutcome("Already Checked Out") ; calls outpatients-sub/enterOutcome.ahk
}

; Mark as "No Show" with NOC 3
^Numpad4:: {
    FindHwnd ; calls outpatients-sub/hwnd.ahk
    Sleep(100)

    FindTab ; calls outpatients-sub/tab.ahk
    Sleep(100)

    enterOutcome("No Show") ; calls outpatients-sub/enterOutcome.ahk
}

; Mark as "DNA No Documentation"
^Numpad5:: {
    FindHwnd ; calls outpatients-sub/hwnd.ahk
    Sleep(100)

    FindTab ; calls outpatients-sub/tab.ahk
    Sleep(100)

    enterOutcome("DNA No Documentation") ; calls outpatients-sub/enterOutcome.ahk
}

; Mark as "Checkout No Documentation"
^Numpad6:: {
    FindHwnd ; calls outpatients-sub/hwnd.ahk
    Sleep(100)

    FindTab ; calls outpatients-sub/tab.ahk
    Sleep(100)

    enterOutcome("Checkout No Documentation") ; calls outpatients-sub/enterOutcome.ahk
}