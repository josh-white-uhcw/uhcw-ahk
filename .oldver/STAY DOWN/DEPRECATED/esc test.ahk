#Include ../Master Workflow Script.ahk
#Include ../UIA-v2-1.1.2\Lib\UIA.ahk

F1:: {
    hwnd := WinExist("Power")
    hMenu := DllCall("GetMenu", "Ptr", hwnd, "Ptr")
    
    if hMenu {
        ; Menu exists, try MenuSelect
        MenuSelect("ahk_id " hwnd, , "File")
    } else {
        MsgBox("No standard menu bar found")
    }
}