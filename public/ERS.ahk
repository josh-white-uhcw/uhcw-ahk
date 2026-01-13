#Requires AutoHotkey v2.0
#Include ../Master Workflow Script.ahk

#Include sub-processes/hwnd.ahk
#Include sub-processes/ers/tab.ahk
#Include sub-processes/windowCheck.ahk

; Cycle for adding referrals
addReferralCycle := 1

; ERS Hotkeys

; Type clipboard as text (to bypass unpasteable inputs)
^+v::{ ; CTRL + SHIFT + V
    SendText(A_Clipboard)
}

; Hashtag to paste this message so it doesnt need to linger in the clipboard
#::{
    Send("Referral added to EPR/PAS to be booked")
}

AwaitingTriage() {
    Send(" - Awaiting triage")
}

+#::{
    AwaitingTriage()
}


; add referral process, make sure you click the first input box before using
F1:: {
    global addReferralCycle
    
    ; Enter from uni box to treatment function
    if (addReferralCycle = 1) {
        Send("uni")
        Sleep(150)
        Send("{Enter}")
        Sleep(150)
        Send("{Enter}")
        Sleep(150)
        Send("{Tab}")
        Sleep(150)
        Send("I")
        Sleep(150)
        Send("{Tab}")
        Sleep(150)
        Send("{Enter}")
        Sleep(150)
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        ; Put your first action here
        addReferralCycle := 2
    }

    ; to 'priority'
    else if (addReferralCycle = 2) {
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        ; Put your second action here
        addReferralCycle := 3
    }

    ; to 'referral recieved date'
    else if (addReferralCycle = 3) {
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        ; Put your third action here
        addReferralCycle := 4
    }

    ; to 'referral recieved date'
    else if (addReferralCycle = 4) {
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Sleep(150)
        Send("!{Down}")
        ; Put your third action here
        addReferralCycle := 5
    }

    ; Grab and enter serivce name
    else if (addReferralCycle = 5) {
        FindHwnd ; calls sub-processes/hwnd.ahk
        Sleep(100)

        FindTab ; calls sub-processes/ers/tab.ahk
        Sleep(100)

        Send("{Left}")
        Sleep(50)
        Send("{Left}")
        Sleep(50)
        Send("^c")
        Sleep(50)

        if !windowCheck("Revenue Cycle") {
        MsgBox("Window check failed")
        return
        }

        Sleep(50)

        Send("+{Tab}") 
        Send("+{Tab}") 
        Send("+{Tab}") 
        Send("+{Tab}") 
        Sleep(50)

        Send("^{v}")
        Sleep(50)
        AwaitingTriage()
        Sleep(100)

        Send("^a")
        Sleep(50)
        Send("^c")
        Sleep(50)

        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")

        Send("^v")

        addReferralCycle := 1
    }
}