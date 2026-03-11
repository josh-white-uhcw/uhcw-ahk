#Requires AutoHotkey v2.0
#Include ../ConfigLoader.ahk
#Include ../dependencies/_all.ahk
Critical ; allows queuing keys
SetTimer(AutoLoop, 100) ; run loop at bottom every 100ms

try Hotkey EnterOutcomeKey, EnterOutcome
EnterOutcome(*) {
    EnterOutcomeGUI := Gui("+AlwaysOnTop", "Add Referral Setup")
    EnterOutcomeGUI.SetFont("s10", "Segoe UI")

    EnterOutcomeGUI.Add("Text", , "Treatment Function: *")
    EnterOutcomeGUI.Add("DropDownList", "w200 Choose1 vOutcome", [
        "No Documentation",
        "Already actioned",
        "EPR Error",
        "Checked Out",
        "Other",
        "Cancelled",
        "No Show",
        "Other",
        "Workflow Error"
    ])

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
    if !windowCheck(browser) {
        return
    }
    Sleep(500)
    loop 5 {
        Send("{Right}")
    }
    Send(fields.Outcome)
    Send("{Right}")
    Send(fields.NOC)
    Send("{Right}")
    Send(initials)
    Send("{Right}")
    Send(FormatTime(, "dd/MM/yyyy"))
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
    if !MRNCheck() {
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
    if !MRNCheck() {
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

try Hotkey AppointmentBookKey, AppointmentBook
AppointmentBook(*) {
    if !WindowCheck("Standard Patient") {
        return
    }
    if !MRNCheck() {
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

try Hotkey PMOfficeKey, PMOffice
PMOffice(*) {
    PMOfficeGUI := Gui("+AlwaysOnTop", "PM Office Options")
    PMOfficeGUI.SetFont("s10", "Segoe UI")

    PMOfficeGUI.Add("Text", , "Make sure clipboard is MRN!")

    okBtn := PMOfficeGUI.Add("Button", "Default", "View Encounter")
    okBtn.OnEvent("Click", RunConversation.Bind("ViewEncounter"))

    okBtn := PMOfficeGUI.Add("Button", "", "Inpatient Elective Admission [Soon]")
    okBtn.OnEvent("Click", RunConversation.Bind("InpatientElectiveAdmission"))

    okBtn := PMOfficeGUI.Add("Button", "", "Discharge [Soon]")
    okBtn.OnEvent("Click", RunConversation.Bind("Discharge"))

    PMOfficeGUI.Show("AutoSize Center")

    RunConversation(ConvName, *) {
        PMOfficeGUI.Destroy()

        if !windowCheck("Access Management Office") {
            return
        }
        if !MRNCheck() {
            return
        }

        CoordMode "Mouse", "Screen"
        Click(2012, 58)
        CoordMode "Mouse", "Client"
        Sleep(250)

        if !FindImage("PMOffice/" . ConvName, "10", "10") {
            ToolTipTimer("Cannot Find Conversation", 5)
            return
        }

        ToolTipTimer("Found Conversation", 1)
        Send("{Enter}")

        if !WinWait("Encounter Search", , 5) {
            MsgBox "Encounter Search did not appear"
            return
        }

        if ConvName = "Discharge" {
            Send("{Tab}")
        }
        Send("^v")
        Send("{Enter}")

        if ConvName = "InpatientElectiveAdmission" {
            WinWaitClose("Encounter Search")
            if !WinWait("Inpatient Elective Admission", , 5) {
                MsgBox "Inpatient window did not appear"
                return
            }
        }
    }
}

AutoLoop() {
    Sleep(100) ; Stops CPU usage going crazy

    try WinKill("Encounter Selection") ; Close PowerChart encounter selection after search
    try if WinExist("Assign") { ; Close 'Assign a relationship' after searching
        WinActivate("Assign")
        Send("{Enter}")
    }
    try if WinExist("Admit Patient") { ; 'TCI date not today' thing
        WinActivate("Admit Patient")
        Send("{Enter}")
    }
}