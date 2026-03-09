#Requires AutoHotkey v2.0
#Include ../ConfigLoader.ahk
#Include ../dependencies/_all.ahk
Critical ; allows queuing keys
SetTimer(AutoLoop, 100)

try Hotkey EnterOutcomeKey, EnterOutcome
EnterOutcome(*) {
    EnterOutcomeGUI := Gui("+AlwaysOnTop", "Add Referral Setup")
    EnterOutcomeGUI.SetFont("s10", "Segoe UI")

    EnterOutcomeGUI.Add("Text", , "Treatment Function: *")
    EnterOutcomeGUI.Add("DropDownList", "w200 Choose1 vOutcome", ["No Documentation", "Workflow Error-Unactionable", "Workflow Error-Actionable", "Checked Out", "Already Checked Out", "Other Query", "Cancelled", "No Show", "Checkout No Documentation", "No OPA", "Java Error", "Java Error Unactionable"])

    EnterOutcomeGUI.Add("Text", , "NOC:")
    EnterOutcomeGUI.Add("Edit", "w200 vNOC Number")

    EnterOutcomeGUI.Add("Text", "cRed", "* Required fields")

    okBtn := EnterOutcomeGUI.Add("Button", "Default w80 vOkBtn", "OK")
    okBtn.OnEvent("Click", RunOutcomeGui.Bind(EnterOutcomeGUI))

    EnterOutcomeGUI.Show("AutoSize Center")
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

    if Sudo {
        WinWait("External MPI Retrieve")
        WinClose("External MPI Retrieve")
        ToolTipTimer("Closed", 1)
    }
}

try Hotkey PowerChartKey, PowerChart
PowerChart(*) {
    ToolTipTimer("Powerchart", 1)
    if !windowCheck("PowerChart") {
        return
    }

    Sleep(100)
    if !FindImage("PowerChart/MRN-Search", "110", "10") { ; Clicks the search icon
        ToolTipTimer("??? - No image found", 5)
        return
    }

    Send("^v")
    Send("{Enter}")
    Sleep(50)
    Send("{Enter}")

    if Sudo {
        WinWait("ACCESSIBLE INFO")
        if !FindImage("PowerChart/Dismiss", "10", "10") {
            ToolTipTimer("??? - No image found", 5)
            return
        }
    }


    Sleep(200)
    Send("{Enter}")
}

try Hotkey PMOfficeKey, PMOffice
PMOffice(*) {
    PMOfficeGUI := Gui("+AlwaysOnTop", "PM Office Options")
    PMOfficeGUI.SetFont("s10", "Segoe UI")

    PMOfficeGUI.Add("Text", , "Make sure clipboard is MRN!")

    okBtn := PMOfficeGUI.Add("Button", "Default vViewEncounter", "View Encounter")
    okBtn.OnEvent("Click", ViewEncounter.Bind(PMOfficeGUI))

    okBtn := PMOfficeGUI.Add("Button", "Default vInpatientElectiveAdmission Disabled", "Inpatient Elective Admission [Soon]")
    okBtn.OnEvent("Click", InpatientElectiveAdmission.Bind(PMOfficeGUI))

    okBtn := PMOfficeGUI.Add("Button", "Default vDischarge Disabled", "Discharge [Soon]")
    okBtn.OnEvent("Click", Discharge.Bind(PMOfficeGUI))

    PMOfficeGUI.Show("AutoSize Center")
}

ViewEncounter(guiObj, *) {
    guiObj.Destroy()
    ; --- Execution ---

    if !WindowCheck("Access") {
        ToolTipTimer("Access window not found", 1)
        return
    }

    if !FindImage("PMOffice/ViewEncounter", "10", "10") {
        Send("{Down}")
        Send("{End}") ; does to bottom of list, to see other buttons
        Sleep(50)

        if !FindImage("PMOffice/ViewEncounter", "10", "10") {
            ToolTipTimer("??? - No image found", 5)
            return
        }
    }

    ToolTipTimer("WORKED!", 1)
    Send("{Enter}")

    WinWait("Encounter Search")
    Send("^v")
    Send("{Enter}")

    ; finish later

}

InpatientElectiveAdmission(guiObj, *) {
    fields := guiObj.Submit()
    guiObj.Destroy()
    ; --- Execution ---
}

Discharge(guiObj, *) {
}

try Hotkey AppointmentBookKey, AppointmentBook
AppointmentBook(*) {
    if !WindowCheck("Standard Patient") {
        return
    }

    Sleep(50)

    if !FindImage("AppointmentBook/Ellipsis", 10, 10) {
        return
    }

    Sleep(800)

    if !FindImage("AppointmentBook/Reset", 10, 10) {
        return
    }

    Send("^v")
    Send("{Enter}")
    Sleep(100)
    Send("{Enter}")

    Sleep(100)
    Send(AppointmentBookStartDate)
    Send("{Enter}")
}

AutoLoop() {
    Sleep(100) ; Stops PU usage going crazy

    try WinKill("Encounter Selection") ; Close PowerChart encounter selection after search
    try if WinExist("Assign") { ; Close 'Assign a relationship' after searching
        WinActivate("Assign")
        Send("{Enter}")
    }
}