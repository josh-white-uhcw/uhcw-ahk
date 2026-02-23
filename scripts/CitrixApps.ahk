#Requires AutoHotkey v2.0
#Include ../ConfigLoader.ahk
#Include ../dependencies/_all.ahk
Critical ; allows queuing keys

try Hotkey EnterOutcomeKey, EnterOutcome
EnterOutcome(*) {
    AppointmentBookGUI := Gui("+AlwaysOnTop", "Add Referral Setup")
    AppointmentBookGUI.SetFont("s10", "Segoe UI")

    AppointmentBookGUI.Add("Text", , "Treatment Function: *")
    AppointmentBookGUI.Add("DropDownList", "w200 Choose1 vOutcome", ["No Documentation", "Workflow Error-Unactionable", "Workflow Error-Actionable", "Checked Out", "Already Checked Out", "Other Query", "Cancelled", "No Show", "Checkout No Documentation", "No OPA", "Java Error", "Java Error Unactionable"])

    AppointmentBookGUI.Add("Text", , "NOC:")
    AppointmentBookGUI.Add("Edit", "w200 vNOC Number")

    AppointmentBookGUI.Add("Text", "cRed", "* Required fields")

    okBtn := AppointmentBookGUI.Add("Button", "Default w80 vOkBtn", "OK")
    okBtn.OnEvent("Click", RunOutcomeGui.Bind(AppointmentBookGUI))

    AppointmentBookGUI.Show("AutoSize Center")
}

RunOutcomeGui(guiObj, *) {
    fields := guiObj.Submit()
    guiObj.Destroy()
    ; --- Execution ---
    ; code here later
    ToolTipTimer("runtest", 1)

    if !windowCheck(browser) {
        return
    }
    ; outcome: MsgBox(fields.Outcome)
    ; noc: MsgBox(fields.NOC)
    Sleep(500)
    loop 4 {
        Send("{Right}")
    }
    Send(fields.Outcome)
    Send("{Right}")
    Send(fields.NOC)
    Send("{Right}")
    Send(initials)
    Send("{Right}")
    Send(FormatTime(, "MM/dd/yyyy"))
    Sleep(150)
    Send("{Enter}")
    Send("{Home}")
    if !legacySheet {
        Send("{Right}")
    }
    Send("{Escape}")
    Send("{Escape}")
}

try Hotkey RevenueCycleKey, RevenueCycle
RevenueCycle(*) {
    if !windowCheck("Revenue Cycle") { ; calls dependencies/WindowCheck.ahk
        return
    }

    Click(31, 57)
    Send("^v")
    Sleep(200)
    Send("{Enter}")
    Sleep(500)
    Send("{Enter}")
}

try Hotkey PowerChartKey, PowerChart
PowerChart(*) {
    ToolTipTimer("Powerchart", 1)
    if !windowCheck("PowerChart") {
        return
    }

    Sleep(100)
    if !FindImage("PowerChart_MRN-Search", "110", "10") { ; Clicks the search icon
        ToolTipTimer("??? - No image found", 5)
        return
    }

    ; Finish later

    Sleep(200)
}

try Hotkey PMOfficeKey, PMOffice
PMOffice(*) {
    if !windowCheck("Office") { ; calls dependencies/WindowCheck.ahk
        return
    }
}

NumpadDel:: { ; temp
}

try Hotkey AppointmentBookKey, AppointmentBook
AppointmentBook(*) {
    AppointmentBookGUI := Gui("+AlwaysOnTop", "Appointment Book Search")
    AppointmentBookGUI.SetFont("s10", "Segoe UI")
    AppointmentBookGUI.Add("Text", , "MRN: *")
    MRNEdit := AppointmentBookGUI.Add("Edit", "w200 vMRN")
    MRNEdit.OnEvent("Change", (*) => UpdateOkButton(AppointmentBookGUI))
    AppointmentBookGUI.AddDateTime("vStartDate", "dd/MM/" AppointmentBookStartDate) ; defined in master
    AppointmentBookGUI.AddDateTime("vEndDate", "dd/MM/yyyy")
    AppointmentBookGUI.Add("Text", "cRed", "* Required fields")
    okBtn := AppointmentBookGUI.Add("Button", "Default w80 vOkBtn Disabled", "OK")
    okBtn.OnEvent("Click", RunMacro.Bind(AppointmentBookGUI))
    AppointmentBookGUI.Show("AutoSize Center")
}

UpdateOkButton(guiObj) {
    fields := guiObj.Submit(false)
    guiObj["OkBtn"].Enabled := fields.MRN != ""
}

RunMacro(guiObj, *) {
    fields := guiObj.Submit()
    ;shortDate := FormatTime(fields.ReferralDate, "dd/MM/yyyy")

    ; real execution
    if !WindowCheck("Standard Patient") {
        return
    }

    if !FindImage("AppointmentBook_Ellipsis", 10, 10) {
        return
    }
    ToolTipTimer("YES", 1)
}