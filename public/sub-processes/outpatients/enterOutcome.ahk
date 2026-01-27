#Requires AutoHotkey v2.0

enterOutcome(outcome) {
    Send("{Right}")
    Send("{Right}")
    Send("{Right}")
    Send("{Right}")
    Send(outcome)
    Send("{Right}")
    Send("3")
    Send("{Right}")
    Send(initials) ; all scripts include the master script, which applies the variables here too - ignore the warning
    Send("{Right}")
    
    Send(A_MM)
    Send("/")
    Send(A_DD)
    Send("/")
    Send(A_YYYY)

    Sleep(150)
    Send("{Enter}")
    Send("{Up}")
}