#Requires AutoHotkey v2.0
#Include ../dependencies/scripts/_all.ahk

TraySetIcon("..\images\Icons\Program Folder (16x16px & 32x32px).ico")
Critical ; Allows queuing keys
SetTimer(AutoLoop, 50) ; normal loops hijack control

try Hotkey EnterOutcomeKey, EnterOutcome
EnterOutcome(*) {
    Log("-- Enter Outcome GUI --", 1)
    EnterOutcomeGUI := BuildGui("Enter Outcome")
    EnterOutcomeGUI.AddDropDownList("w300 Choose1 vOutcome", [
        "No Documentation",
        "Already Actioned",
        "Checked Out",
        "Cancelled",
        "No Show",
        "Other Query",
        "Workflow Error",
        "EPR Error",
        "DNA No Documentation",
        "Checkout No Documentation",
        "Rescheduled"
    ])
    EnterOutcomeGUI.AddCheckBox("vDischarge", "Discharge?")
    EnterOutcomeGUI.AddButton("Default w80", "OK").OnEvent("Click", EnterOutcomeExe)
    EnterOutcomeGUI.Show("AutoSize Center")

    ; REWRITE THIS FOR EXCEL APP!
    EnterOutcomeExe(*) {
        Log("Running Outcome", 2)
        fields := EnterOutcomeGUI.Submit()
        Log("Outcome: " . fields.Outcome)
        Log("Discharge: " . fields.Discharge)
        EnterOutcomeGUI.Destroy()
        if !WindowCheck("Excel") or !MRNCheck()
            return

        xl := ComObjActive("Excel.Application")

        ; here i would compare the clipboard and goto that cell, but excel app makes the clipboard go kaboom after every action :/
        MRNrow := xl.ActiveCell.Row

        xl.Cells(MRNrow, 6).Value := fields.Outcome   ; Comments [F]
        xl.Cells(MRNrow, 8).Value := initials   ; Initials [H]
        xl.Cells(MRNrow, 9).Value := FormatTime(, "dd/MM/yyyy")   ; Date reviewed DSG [I]

        if fields.Outcome != "No Documentation" { ; NOC [G]
            if fields.Discharge = 1
                xl.Cells(MRNrow, 7).Value := "1"
            else
                xl.Cells(MRNrow, 7).Value := "3"
        }

        xl.Cells(MRNrow + 1, 2).Select  ; Goes one down from B

        Log("-- Enter Outcome GUI --", 4)
    }
}

try Hotkey RevenueCycleKey, RevenueCycle
RevenueCycle(*) {
    Log("-- Revenue Cycle --", 1)
    if !WindowCheck("Revenue Cycle") or !MRNCheck()
        return

    Click(31, 57) ; Search bar, very very consistent
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

    Log("-- Revenue Cycle --", 4)
}

try Hotkey PowerChartKey, PowerChart
PowerChart(*) {
    Log("-- PowerChart --", 1)
    if !windowCheck("PowerChart") or !MRNCheck() or !FindImage("PowerChart/MRN-Search", "10", "10")
        return

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
    Log("-- PowerChart --", 4)
}

try Hotkey AppointmentBookKey, AppointmentBook
AppointmentBook(*) {
    Log("-- Appointment Book --", 1)
    if !WindowCheck("Standard Patient") or !MRNCheck() or !FindImage("AppointmentBook/Ellipsis", 10, 10)
        return

    if !FindImage("AppointmentBook/Reset", 10, 10) {
        Log("Could not find reset button", 3) ; put this into findimage once re-writeen
        return
    }

    Send("^v")
    Send("{Enter}")
    Sleep(1000)
    Send("{Enter}")

    Sleep(1000)
    Send(AppointmentBookStartDate)
    Send("{Enter}")
    Log("-- Appointment Book --", 4)
}

try Hotkey PMOfficeKey, PMOffice
PMOffice(*) {
    PMOfficeGUI := BuildGui("PM Office Options")

    PMOfficeGUI.AddText( , "Make sure clipboard is MRN!")

    okBtn := PMOfficeGUI.AddButton("w300 Default", "View Encounter")
    okBtn.OnEvent("Click", RunConversation.Bind("ViewEncounter"))

    okBtn := PMOfficeGUI.AddButton("w300", "Inpatient Elective Admission [Soon]")
    okBtn.OnEvent("Click", RunConversation.Bind("InpatientElectiveAdmission"))

    okBtn := PMOfficeGUI.AddButton("w300", "Discharge [Soon]")
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
    try if WinKill("Encounter Selection") {
        Log("Killed Encounter Selection")
    }
    try if WinExist("Assign") { ; Close 'Assign a relationship' after searching
        WinActivate("Assign")
        Send("{Enter}")
        Sleep(500)
        Log("Sent enter to close Assign window")
    }
    try if WinExist("Admit Patient") { ; 'TCI date not today' thing
        WinActivate("Admit Patient")
        Send("{Enter}")
        Log("Sent enter to close 'TCI date not today' window")
    }
}