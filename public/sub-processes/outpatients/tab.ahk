#Requires AutoHotkey v2.0
#Include ../../../Master Workflow Script.ahk

; needs re-write ngl, looks ugly and is probably unoptimised.

FindTab() {
    Loop maxTabSwitches {
        Sleep(200)
        currentTitle := WinGetTitle("A")
        ToolTip("Current window title: " currentTitle)

        if InStr(currentTitle, partialTabTitle) {
            ToolTip()
            return true
        }

        Send("^{Tab}")
        Sleep(250)
    }

    ToolTip()
    return false
}