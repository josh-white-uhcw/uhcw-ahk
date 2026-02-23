; MERGING WITH MAIN WORKFLOW SCRIPT!!! DONT USE!!!
; MERGING WITH MAIN WORKFLOW SCRIPT!!! DONT USE!!!
; MERGING WITH MAIN WORKFLOW SCRIPT!!! DONT USE!!!
; MERGING WITH MAIN WORKFLOW SCRIPT!!! DONT USE!!!
; MERGING WITH MAIN WORKFLOW SCRIPT!!! DONT USE!!!

; "View Encounter" NEEDS TO BE THE BOTTOMMOST OPTION
 
; 7- View Encounter

; === CONFIGURATION ===
partialBrowserTitle := "Edge"      ; e.g. "Edge", "Chrome", "Firefox"
partialAccessTitle  := "Access"    ; window name to send data to
partialTabTitle     := "GEH"       ; part of the tab title to match
maxTabSwitches      := 15
initials            := "Josh"      ; (unused but kept for context)


Numpad7:: {
MouseMove(14, 839)
Click()
sleep(50)
Click()

SetTitleMatchMode(2)        ; Allow partial title matching

    ; Searches for a window with title containing "Encounter" for 5 seconds
    if WinWait("Encounter", , 5) {
        WinActivate()        ; Bring it to the foreground
        Sleep(200)        ; Optional: give it time to activate
        Send("^v")
        Sleep(200)
        Send("{Enter}")        ; Send the Enter key
        Sleep(500)
    } else {
        MsgBox("Cannot find 'Encounter Search' window")
        Return
    }

} 


Numpad8:: {
CoordMode("Mouse", "Screen")  
MouseMove(16, 694)
Click()
sleep(50)
Click()

SetTitleMatchMode(2)        ; Allow partial title matching

    ; Searches for a window with title containing "Encounter" for 5 seconds
    if WinWait("Encounter", , 5) {
        WinActivate()        ; Bring it to the foreground
        Sleep(200)        ; Optional: give it time to activate
        Send("#v")
        Sleep(200)
        CoordMode("Mouse", "Screen")  
        MouseMove(1805, 976)
        Click()
        Sleep(200)
        Send("^a")
        Sleep(100)
        Send("^c")
        Sleep(200)
        Send("{Enter}")        ; Send the Enter key
        Sleep(500)
    } else {
        MsgBox("Cannot find 'Encounter Search' window")
        Return
    }

} 


; === MAIN HOTKEY ===
Numpad9::
{
    foundBrowser := 0

    ; --- FIND BROWSER WINDOW ---
    for hwnd in WinGetList() {
        title := WinGetTitle(hwnd)
        if InStr(title, partialBrowserTitle) {
            foundBrowser := hwnd
            break
        }
    }

    if !foundBrowser {
        MsgBox("❌ No browser window found with partial title: " partialBrowserTitle)
        return
    }

    ; --- ACTIVATE BROWSER ---
    WinActivate(foundBrowser)
    Sleep(200)

    ; --- TAB CYCLING LOOP ---
    foundTab := false
    Loop maxTabSwitches {
        currentTitle := WinGetTitle("A")
        ToolTip("Current tab: " currentTitle)

        if InStr(currentTitle, partialTabTitle) {
            foundTab := true
            ToolTip() ; Clear tooltip
            Sleep(50)
            Send("^c")  ; Copy
            break
        }

        ; Go to next tab
        Send("^{Tab}")
        Sleep(250)
    }

    ToolTip() ; Always clear tooltip at end

    if !foundTab {
        MsgBox("⚠️ Tab with '" partialTabTitle "' not found after " maxTabSwitches " switches.")
        return
    }

    ; --- SWITCH TO ACCESS ---
    SetTitleMatchMode(2) ; Partial match
    if WinExist(partialAccessTitle) {
        WinActivate()
    } else {
        MsgBox("❌ Could not find window containing '" partialAccessTitle "'")
        return
    }

    ; >>> STOP HERE <<<
    ; Comment below this line to debug step-by-step.

    ; --- Optional further automation ---
    MouseMove(15, 119)
    Click()
    Sleep(50)
    Click()

    if WinWait("Encounter", , 5) {
        WinActivate()
        Sleep(200)
        Send("{Tab}")
        Sleep(100)
        Send("^v")
        Sleep(200)
        Send("{Enter}")
    } else {
        MsgBox("Cannot find 'Encounter' window")
        return
    }
}

PgUp:: {
    SetTitleMatchMode(2)

    if WinExist("Teams") {
        WinActivate()
    } else {
        MsgBox("Window not found")
        Return
    }

    ;go to teams and make a docx
    Click(498, 140)
    Sleep(200)
    Click(472, 217)
    Sleep(200)

    ; add wait for docx to open

    ;sleep again incase
    Sleep(2000)

    ;add focus to docx

    Click(154, 104)
    Sleep(200)
    Send("- Josh - ")
}