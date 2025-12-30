#Requires AutoHotkey v2.0
#Include ../Master Workflow Script.ahk

SetTimer(PerformRandomAction, 2000)

PerformRandomAction() {
    actions := [
        () => MouseMove(A_ScreenWidth * Random(0.2, 0.8), A_ScreenHeight * Random(0.2, 0.8)),
        () => Send(" "),
        () => KeyPress("w"),
        () => Click()
    ]
    actions[Random(1, actions.Length)]()
}

KeyPress(key) {
    Send("{" key " down}{" key " up}")
}