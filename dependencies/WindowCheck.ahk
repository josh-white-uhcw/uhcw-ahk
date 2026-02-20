WindowCheck(windowTitle) {
    SetTitleMatchMode(2)

    if WinExist(windowTitle) {
        WinActivate(windowTitle)
        return true   ; explicitly return true if found
    } else {
        MsgBox("Window not found: " windowTitle)
        return false  ; explicitly return false if not found
    }
}