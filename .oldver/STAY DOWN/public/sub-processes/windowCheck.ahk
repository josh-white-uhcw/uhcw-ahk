#Requires AutoHotkey v2.0

windowCheck(windowTitle) {
    SetTitleMatchMode(2)

    if WinExist(windowTitle) {
        WinActivate()
        return true   ; explicitly return true if found
    } else {
        MsgBox("Window not found: " windowTitle)
        return false  ; explicitly return false if not found
    }
}