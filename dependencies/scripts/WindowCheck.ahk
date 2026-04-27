WindowCheck(windowTitle, Fail := "Return") {
    SetTitleMatchMode(2)

    if WinExist(windowTitle) {
        WinActivate(windowTitle)
        Log("WindowCheck found and focused: " windowTitle, 2)
        return true
    } else {
        if (Fail = "Return") {
            ErrorMsg("Window not found: " windowTitle)
            Log("WindowCheck could not find: " windowTitle, 3)
            return false
        } else if (Fail = "Warn") {
            ToolTipTimer("Window not found: " windowTitle, 2)
            Log("WindowCheck could not find: " windowTitle " (Warn mode)", 2)
            return
        } else if (Fail = "Continue") {
            Log("WindowCheck could not find: " windowTitle " (Continue mode)", 2)
        }
    }
}