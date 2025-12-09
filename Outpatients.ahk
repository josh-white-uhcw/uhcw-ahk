#Requires AutoHotkey v2.0
#Include Master Workflow Script.ahk

; Outpatients Validation Hotkeys

; Get New MRN from browser tab
Numpad0:: {
    foundHwnd := 0

    ; Find the browser window
    for hwnd in WinGetList() {
        title := WinGetTitle(hwnd)
        if InStr(title, partialBrowserTitle) {
            foundHwnd := hwnd
            break
        }
    }

    if !foundHwnd {
        MsgBox("❌ No window found with partial title: " partialBrowserTitle)
        ExitApp
    }

    WinActivate(foundHwnd)
    Sleep(100)

    ; Search through tabs for the target
    Loop maxTabSwitches {
        Sleep(200)
        currentTitle := WinGetTitle("A")
        ToolTip("Current window title: " currentTitle)

        if InStr(currentTitle, partialTabTitle) {
            ToolTip()
            
            ; Navigate to MRN cell and copy
            Send("{Down}")
            Send("^{Left}")
            Send("^{Left}")
            Send("^{Left}")
            Send("^{Left}")
            Sleep(100)
            Send("^{c}")
            return
        }

        Send("^{Tab}")
        Sleep(250)
    }

    ToolTip()
    MsgBox("❌ Tab with title containing '" partialTabTitle "' not found.")
}

; Goto Powerchart and navigate to documentation
Numpad1:: {
    SetTitleMatchMode(2)

    if WinExist("Power") {
        WinActivate()
    } else {
        MsgBox("Window not found")
        Return
    }

    Click(1778, 112)
    Sleep(200)
    
    ; Pastes into searchbar and opens patient search
    Send("^v")
    Sleep(200)
    Send("{Enter}")
    Sleep(200)
    Send("{Enter}")

    SetTitleMatchMode(2)

    ; Wait for either relationship or encounter window
    ; yes there are two separate searches for encounter window, but for now they both work so ¯\_(ツ)_/¯

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
        Sleep(200)
        
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
        Sleep(200)
        
        ; Keep sending Enter until window closes
        while WinExist("Selec") {
            WinActivate("Selec")
            Send("{Enter}")
            Sleep(200)
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
    SetTitleMatchMode(2)

    if WinExist("Revenue Cycle") {
        WinActivate()
    } else {
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

; Goto Appointment Book window and paste MRN
Numpad3:: {
    SetTitleMatchMode(2)

    if WinExist("Standard Patient Enquiry") { ; Name might look different if the window is focused, this will still target it
        WinActivate()
    } else {
        MsgBox("Window not found")
        Return
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

    ; Find the browser window
    foundHwnd := 0

    for hwnd in WinGetList() {
        title := WinGetTitle(hwnd)
        if InStr(title, partialBrowserTitle) {
            foundHwnd := hwnd
            break
        }
    }

    if !foundHwnd {
        MsgBox("❌ No window found with partial title: " partialBrowserTitle)
        ExitApp
    }

    WinActivate(foundHwnd)
    Sleep(100)

    ; Find the tab
    Loop maxTabSwitches {
        Sleep(200)
        currentTitle := WinGetTitle("A")
        ToolTip("Current window title: " currentTitle)

        if InStr(currentTitle, partialTabTitle) {
            ToolTip()
            
            Send("{Right}")
            Send("{Right}")
            Send("{Right}")
            Send("{Right}")
            Send("No Documentation")
            Send("{Right}")
            Send("{Right}")
            ;initials - variable declared at start of file
            Send(initials)
            Send("{Right}")
            Send("^{;}")
            Sleep(100)
            Send("{Enter}")
            Send("{Up}")
            
            return
        }

        Send("^{Tab}")
        Sleep(250)
    }

    ToolTip()
    MsgBox("❌ Tab with title containing '" partialTabTitle "' not found.")
}

; Mark as "Checked Out" with NOC 3
^Numpad2:: {
    foundHwnd := 0

    for hwnd in WinGetList() {
        title := WinGetTitle(hwnd)
        if InStr(title, partialBrowserTitle) {
            foundHwnd := hwnd
            break
        }
    }

    if !foundHwnd {
        MsgBox("❌ No window found with partial title: " partialBrowserTitle)
        ExitApp
    }

    WinActivate(foundHwnd)
    Sleep(100)

    Loop maxTabSwitches {
        Sleep(200)
        currentTitle := WinGetTitle("A")
        ToolTip("Current window title: " currentTitle)

        if InStr(currentTitle, partialTabTitle) {
            ToolTip()
            
            Send("{Right}")
            Send("{Right}")
            Send("{Right}")
            Send("{Right}")
            Send("Checked Out")
            Send("{Right}")
            Send("3")
            Send("{Right}")
            ;initials - variable declared at start of file            
            Send(initials)
            Send("{Right}")
            Send("^{;}")
            Sleep(100)
            Send("{Enter}")
            Send("{Up}")
            
            return
        }

        Send("^{Tab}")
        Sleep(250)
    }

    ToolTip()
    MsgBox("❌ Tab with title containing '" partialTabTitle "' not found.")
}

; Mark as "DNA No Documentation"
^Numpad4:: {
    foundHwnd := 0

    for hwnd in WinGetList() {
        title := WinGetTitle(hwnd)
        if InStr(title, partialBrowserTitle) {
            foundHwnd := hwnd
            break
        }
    }

    if !foundHwnd {
        MsgBox("❌ No window found with partial title: " partialBrowserTitle)
        ExitApp
    }

    WinActivate(foundHwnd)
    Sleep(100)

    Loop maxTabSwitches {
        Sleep(200)
        currentTitle := WinGetTitle("A")
        ToolTip("Current window title: " currentTitle)

        if InStr(currentTitle, partialTabTitle) {
            ToolTip()
            
            Send("{Right}")
            Send("{Right}")
            Send("{Right}")
            Send("{Right}")
            Send("DNA No Documentation")
            Send("{Right}")
            Send("{Right}")
            ;initials - variable declared at start of file            
            Send(initials)
            Send("{Right}")
            Send("^{;}")
            Sleep(100)
            Send("{Enter}")
            Send("{Up}")
            
            return
        }

        Send("^{Tab}")
        Sleep(250)
    }

    ToolTip()
    MsgBox("❌ Tab with title containing '" partialTabTitle "' not found.")
}

; Mark as "Checkout No Documentation"
^Numpad5:: {
    foundHwnd := 0

    for hwnd in WinGetList() {
        title := WinGetTitle(hwnd)
        if InStr(title, partialBrowserTitle) {
            foundHwnd := hwnd
            break
        }
    }

    if !foundHwnd {
        MsgBox("❌ No window found with partial title: " partialBrowserTitle)
        ExitApp
    }

    WinActivate(foundHwnd)
    Sleep(100)

    Loop maxTabSwitches {
        Sleep(200)
        currentTitle := WinGetTitle("A")
        ToolTip("Current window title: " currentTitle)

        if InStr(currentTitle, partialTabTitle) {
            ToolTip()
            
            Send("{Right}")
            Send("{Right}")
            Send("{Right}")
            Send("{Right}")
            Send("Checkout No Documentation")
            Send("{Right}")
            Send("{Right}")
            ;initials - variable declared at start of file            
            Send(initials)
            Send("{Right}")
            Send("^{;}")
            Sleep(100)
            Send("{Enter}")
            Send("{Up}")
            
            return
        }

        Send("^{Tab}")
        Sleep(250)
    }

    ToolTip()
    MsgBox("❌ Tab with title containing '" partialTabTitle "' not found.")
}