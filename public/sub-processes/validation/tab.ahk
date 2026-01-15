#Requires AutoHotkey v2.0

; needs re-write ngl, looks ugly and is probably unoptimised.

FindTab() {
    Loop maxTabSwitches {
        currentTitle := WinGetTitle("A")
        ToolTip("Current window title: " currentTitle)

        if InStr(currentTitle, "valid") {
            ToolTip()
            return true
        }

        Send("^{Tab}")
        Sleep(250)
    }

    ToolTip()
    MsgBox("Could Not Find Tab - Make sure it's open and the variables have the right names and length.")
    return false
}