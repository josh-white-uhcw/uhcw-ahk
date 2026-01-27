#Requires AutoHotkey v2.0
#Include ../Master Workflow Script.ahk

#Include sub-processes/outpatients/enterOutcome.ahk
#Include sub-processes/hwnd.ahk
#Include sub-processes/outpatients/tab.ahk
#Include sub-processes/windowCheck.ahk
#Include sub-processes/lookFor.ahk

Critical ; Allows keys to be queued one after another

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
Numpad1:: {
    if !windowCheck("Power") {
        MsgBox("Window check failed")
        return
    }

    ; Search for "File" menu button
    if lookFor("MRN-Search", 20, 10) {
        MsgBox("Could not find MRN search button")
        return
    }
    
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
    
    Sleep(100) ; safety for testing

    ; Wait for either relationship or encounter window

    loop { ; Loop felt like the best way to do this, tenfold better than the old method
        if WinExist("Relationship") {
            WinActivate("Relationship")
            Send("{Enter}")
            ; no break here, it should stay in the loop until encounter window is found.
        }
        else if WinExist("Encounter Selection") {
            ToolTip("encounter found")
            loop { ; Closes the 'Encounter Selection' Window, normally its stubborn so i assumed a loop was required, however it might not be? will test at a later time.
                if WinExist("Encounter Selection") {
                    WinClose("Encounter Selection")
                    Sleep(100) ; Stops killing the CPU in this loop
                } 
                else {
                    break  ; Exit this loop once closed.
                }
            }
            break ; breaks from the main loop once encounter selection has passed.
        }
        Sleep(100) ; Stops killing the CPU on the main loop
    }

    ; Click first documentation entry
    Sleep(200)
    lookFor("service-date", 20, 30)

    Sleep(100) ; Sleep so queues dont overlap
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

    ; No need to add naviagation to past appointments, as you can set that manually in Revenue Cycle in View > Perspective Layout > Save

    Sleep(100)  ; Sleep so queues dont overlap
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