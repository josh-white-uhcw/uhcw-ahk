#Requires AutoHotkey v2.0
#Include ../../../Master Workflow Script.ahk

; needs re-write ngl, looks ugly and is probably unoptimised.

FindHwnd() {
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
}