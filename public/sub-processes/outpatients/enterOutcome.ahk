#Requires AutoHotkey v2.0
#Include ../../../Master Workflow Script.ahk

enterOutcome(outcome) {
    Send("{Right}")
    Send("{Right}")
    Send("{Right}")
    Send("{Right}")
    Send(outcome)
    Send("{Right}")
    Send("3")
    Send("{Right}")
    ;initials - variable declared at start of file            
    Send(initials)
    Send("{Right}")
    Send("^{;}")
    Sleep(100)
    Send("{Enter}")
    Send("{Up}")
}