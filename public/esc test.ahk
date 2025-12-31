#Include ../Master Workflow Script.ahk

; Script to test AHK functionality
Esc:: {
    MsgBox("a")
    if !betaTesting {
        MsgBox("b")
        return
    }

    MsgBox("c")
}
