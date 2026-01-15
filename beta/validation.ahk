#Requires AutoHotkey v2.0
#Include ../Master Workflow Script.ahk

#Include ../public/sub-processes/hwnd.ahk
#Include ../public/sub-processes/validation/tab.ahk
#Include ../public/sub-processes/windowCheck.ahk

Del::{
    FindHwnd()
    Sleep(100)
    FindTab()
    Sleep(100)
    Send("{Right}")
    Send("{Right}")
    Send("{Right}")
    Send("waiting for appt, pending waitlist")
    Sleep(100)
    Send("{Right}")
    Send("Josh W")
    Sleep(100)
    Send("{Right}")
    Send("^;")
}

End:: {
    FindHwnd ; calls outpatients-sub/hwnd.ahk
    Sleep(100)

    FindTab ; calls outpatients-sub/tab.ahk
    Sleep(100)
    
    Send("{Down}")
    Send("^{Left}")
    Send("^{Left}")
    Sleep(100)
    Send("{Right}")
    Send("{Right}")
    Send("{Right}")
    Send("{Right}")

    Sleep(100)
    Send("^{c}")
}