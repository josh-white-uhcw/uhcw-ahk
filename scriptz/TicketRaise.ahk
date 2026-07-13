#Requires AutoHotkey v2.0
#Include ../dependencies/scripts/_all.ahk

equipmentNumber := "AEV10001"
location := "20026"
contactNumberNotListed := "teams"

PgUp:: {
    Log("-- Ticket Raise GUI --", 1)
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
    Log("Running Ticket Raise", 2)
    fields := guiObj.Submit()
    Log("Fields Submitted: MRN: " . fields.MRN . ", WaitlistFIN: " . fields.WaitlistFIN . ", EncounterFIN: " . fields.EncounterFIN)

    ; real execution
    if !WindowCheck(browser)
        return

    loop {
        if !FindImage("TicketRaise_Equipment", 10, 30) {
            Run ("https://uhcw.service-now.com/sp?id=sc_cat_item&sys_id=234c5ab11b30bd100068eb91b24bcb77")
            Sleep 1500  ; image search can skip over it or something?
            Log("Didn't find equipment box, opening URL", 2)
        }
        else {
            break
        }
    }

    Log("Found Equipment Box", 2)
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
    Send("i") ; inpatient
    Send("{Enter}")
    Sleep(200)
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
    Log("Everything sent.", 2)
    Log("-- Ticket Raise GUI --", 4)
}