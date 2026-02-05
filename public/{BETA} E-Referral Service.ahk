#Requires AutoHotkey v2.0
#Include ../Master Workflow Script.ahk

#Include sub-processes/hwnd.ahk
#Include sub-processes/ers/tab.ahk
#Include sub-processes/windowCheck.ahk
#Include sub-processes/lookFor.ahk

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

+#::{ ; shift + hash 
    Send(" - Awaiting triage")
}

; add referral process, just open the "Add referral" window.
; kinda spagetti so read through it.
Insert:: {
    global addReferralCycle
    ; Enter from uni box to treatment function
    if (addReferralCycle = 1) {

        if !windowCheck("Add Referral") {
        MsgBox("Window check failed")
        addReferralCycle := 1 ; reset
        return
        }

        if lookFor("Hospital-Trust", 20, 25) {
        MsgBox("Could not find Hospital Trust box")
        addReferralCycle := 1 ; reset
        return
        }
    
        Sleep(100)
        Send("uni") ; hospital trust
        Sleep(150)
        Send("{Enter}")
        Sleep(150)
        Send("{Enter}") ; add new pathway
        Sleep(150)
        Send("{Tab}")
        Sleep(150)
        Send("I") ; indirect cab referral
        Sleep(150)
        Send("{Tab}") 
        Sleep(150)
        Send("{Enter}") ; "paste" thing
        Sleep(150)
        Send("{Tab}") ; goes to treatment function
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        addReferralCycle := 2
    }

    else if (addReferralCycle = 2) {
        Send("{Tab}") ; to 'priority'
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        addReferralCycle := 3
    }

    
    else if (addReferralCycle = 3) {
        Send("{Tab}") ; to 'referral recieved date'
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        addReferralCycle := 4
    }

    else if (addReferralCycle = 4) {
        Send("{Tab}") ; to RTT Status
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Sleep(150)
        Send("!{Down}") ; opens dropdown
        addReferralCycle := 5
    }

    
    else if (addReferralCycle = 5) {

        if !windowCheck("Add") {
        MsgBox("Window check failed")
        return
        }

        Sleep(50)

        Send("+{Tab}") ; to reason for referral
        Send("+{Tab}") 
        Send("+{Tab}") 
        Send("+{Tab}") ; you need to go copy and paste it
        addReferralCycle := 6
    }

    ;
    else if (addReferralCycle = 6) {

        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")
        Send("{Tab}")

        Send("^v") ; pastes since it SHOULD be on the clipboard still

        addReferralCycle := 7
    }

    else if (addReferralCycle = 7) {

        loop 32 {
            Send("+{Tab}") ; goes back to ubrn (last cause epr autocomplete blows if you do this first)
            Sleep(10)
        }

        addReferralCycle := 1 ; resets
    }
}