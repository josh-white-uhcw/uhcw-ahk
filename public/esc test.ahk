#Include ../Master Workflow Script.ahk

; Script to test AHK functionality
Esc:: {
    MsgBox("a")
    Sleep(1000)
    MsgBox("b")
}

F1:: {
    Send(A_MM)
    Send("/")
    Send(A_DD)
    Send("/")
    Send(A_YYYY)
}
