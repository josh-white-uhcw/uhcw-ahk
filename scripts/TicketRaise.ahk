#Requires AutoHotkey v2.0
#Include ../ConfigLoader.ahk
#Include ../dependencies/_all.ahk

equipmentNumber := "P103092"
contactNumber := "Number Not Listed"
location := "20026"
contactNumberNotListed := "teams"


PgUp:: {
    TicketRaiseGUI := Gui("+AlwaysOnTop", "Merge Ticket Maker")
    TicketRaiseGUI.SetFont("s10", "Segoe UI")
    ;mrn
    TicketRaiseGUI.Add("Text", , "MRN: *")
    global MRNEdit := TicketRaiseGUI.Add("Edit", "w200 vMRN")
    MRNEdit.OnEvent("Change", (*) => UpdateOkButton(TicketRaiseGUI))
    ;waitlist fin
    TicketRaiseGUI.Add("Text", , "Waitlist FIN: *")
    global WaitlistFINEdit := TicketRaiseGUI.Add("Edit", "w200 vWaitlistFIN")
    WaitlistFINEdit.OnEvent("Change", (*) => UpdateOkButton(TicketRaiseGUI))
    ;mergewith
    TicketRaiseGUI.Add("Text", , "Encounter FIN: *")
    global EncounterFINEdit := TicketRaiseGUI.Add("Edit", "w200 vEncounterFIN")
    EncounterFINEdit.OnEvent("Change", (*) => UpdateOkButton(TicketRaiseGUI))

    TicketRaiseGUI.Add("Text", "cRed", "* Required fields")
    okBtn := TicketRaiseGUI.Add("Button", "Default w80 vOkBtn Disabled", "OK")
    okBtn.OnEvent("Click", RunMacro.Bind(TicketRaiseGUI))
    TicketRaiseGUI.Show("AutoSize Center")
}

UpdateOkButton(guiObj) {
    fields := guiObj.Submit(false)
    guiObj["OkBtn"].Enabled := fields.MRN != "" && fields.WaitlistFIN != "" && fields.EncounterFIN != ""
}

RunMacro(guiObj, *) {
    fields := guiObj.Submit()
    ;shortDate := FormatTime(fields.ReferralDate, "dd/MM/yyyy")

    ; real execution
    if !WindowCheck(browser) {
        MsgBox("no")
        return
    }

    if !FindImage("TicketRaise_Equipment", 10, 30) {
        return
    }

    ToolTipTimer("YES", 1)
    Send(equipmentNumber)
    Sleep(500)
    Send("{Tab}")
    Send(location)
    Sleep(500)
    Send("{Tab}")
    Sleep(500)
    Send("{Enter}")
    Sleep(1000)
    Send("{Tab}")
    Send(contactNumberNotListed)
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Sleep(1000)
    Send("i")
    Send("{Enter}")
    Sleep(50)
    Send("{Tab}")
    Send("{Tab}")
    Send(fields.MRN)
    Send("{Tab}")
    Send("{Tab}")
    Send(fields.WaitlistFIN)
    Send("{Tab}")
    Send("{Tab}")
    Send("Inpatient")
    Send("{Tab}")
    Send("{Tab}")
    Send(fields.WaitlistFIN)
    Send("{Tab}")
    Send("{Tab}")
    Send("DSG")
    Send("{Tab}")
    Send("Hello, please merge the waitlist: " . fields.WaitlistFIN . ". with the encounter FIN: " . fields.EncounterFIN . ". Thank you!")
}