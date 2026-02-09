#Requires AutoHotkey v2.0
#Include ../ConfigLoader.ahk
#Include ../dependencies/_all.ahk

Numpad1:: {
    ToolTipTimer("Not Implemented Yet", 1)
}

Numpad2:: {
    if !windowCheck("Revenue Cycle") {
        return
    }

    ToolTipTimer("Opening Revenue Cycle", 1)

    Click(31, 57) ; Search Bar
    Send("^v")
    Sleep(200)
    Send("{Enter}")
    Sleep(500)
    Send("{Enter}")
}