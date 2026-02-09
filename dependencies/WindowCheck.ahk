windowCheck(windowTitle) { ; focuses a window if windowTitle matches the app name
    if WinExist(windowTitle) {
        WinActivate(windowTitle)
        return true   ; output for "if windowCheck()..."
    }
    else {
        MsgBox("Window not found: " windowTitle)
        return false  ; explicitly return false if not found
    }
}