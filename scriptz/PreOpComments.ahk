#Requires AutoHotkey v2.0
#Include ../dependencies/scripts/_all.ahk

TraySetIcon("..\images\Icons\Dialog.ico")

try Hotkey PreOpGUIKey, PreOpGUI
PreOpGUI(*) {
    Log("-- Enter Pre-OP Outcome GUI --", 1)
    EnterPreOpOutcomeGUI := BuildGui("Enter Pre-Op Outcome")
    EnterPreOpOutcomeGUI.AddText("", "Origin")
    EnterPreOpOutcomeGUI.AddDropDownList("w300 Choose1 vOrigin", [
        "From worklist",
        "From message centre",
        "From MPTL list",
        "Moved to accommodate a more urgent patient",
        "Pt called",
        "Email request",
        "Rebooked due to staff sickness",
        "Request from med sec",
        "Request from nurse",
        "Clerical error"
    ])
    EnterPreOpOutcomeGUI.AddText("", "Priority")
    EnterPreOpOutcomeGUI.AddDropDownList("w300 Choose1 vPriority", [
        "Routine",
        "Urgent",
        "31/62",
        ""
    ])
    EnterPreOpOutcomeGUI.AddText("", "Patient Inform Method")
    EnterPreOpOutcomeGUI.AddDropDownList("w300 Choose1 vPtInform", [
        "Letter sent",
        "Informed and agreed over telephone",
        "Text message sent",
        "Voicemail left",
        "Nurse agreed to contact patient to inform",
        "Med sec agreed to contact patient to inform"
    ])
    EnterPreOpOutcomeGUI.AddText("", "Extra Comments")
    global Extra := EnterPreOpOutcomeGUI.AddEdit("r3 w300 -WantReturn vExtra", "")
    EnterPreOpOutcomeGUI.AddText("", "TCI")
    global TCIQuery := EnterPreOpOutcomeGUI.AddEdit("w150 vTCIQuery", "")
    global TCIDate := EnterPreOpOutcomeGUI.AddDateTime("xp+150 yp w150 vTCIDate", "")
    EnterPreOpOutcomeGUI.AddText("xm", "Breach")
    global BreachQuery := EnterPreOpOutcomeGUI.AddEdit("w150 vBreachQuery", "")
    global BreachDate := EnterPreOpOutcomeGUI.AddDateTime("xp+150 yp w150 vBreachDate", "")
    EnterPreOpOutcomeGUI.AddButton("Default w300 xm y+24", "OK").OnEvent("Click", EnterOutcomeExe)
    EnterPreOpOutcomeGUI.Show("AutoSize Center")

    EnterOutcomeExe(*) {
        Log("Running Pre-Op Outcome", 2)
        fields := EnterPreOpOutcomeGUI.Submit()
        EnterPreOpOutcomeGUI.Destroy()
        Log("Origin: " . fields.Origin)
        Log("Priority: " . fields.Priority)
        Log("Patient informed: " . fields.PtInform)
        Log("Tci date: " . FormatTime(fields.TCIDate, "dd/MM/yyyy"))
        Log("breach date: " . fields.BreachDate)
        Log("now: " . FormatTime(, "dd/MM/yyyy"))

        if fields.Priority != ""
            Send(fields.Priority . ", ")

        ; if both text and diff date is presented, the date is prioritised.
        if FormatTime(fields.TCIDate, "dd/MM/yyyy") != FormatTime(, "dd/MM/yyyy")
            Send("TCI " FormatTime(fields.TCIDate, "dd/MM/yyyy") ", ")
        else if fields.TCIQuery != ""
            Send("TCI " fields.TCIQuery ", ")

        ; if both text and diff date is presented, the date is prioritised.
        if FormatTime(fields.BreachDate, "dd/MM/yyyy") != FormatTime(, "dd/MM/yyyy")
            Send("Breaches " FormatTime(fields.BreachDate, "dd/MM/yyyy") ", ")
        else if fields.BreachQuery != ""
            Send("Breaches " fields.BreachQuery ", ")

        if fields.Origin != ""
            Send(fields.Origin . ", ")

        if fields.Extra != ""
            Send(fields.Extra . ", ")

        Send(fields.PtInform . " - " . initials . " " . FormatTime(, "dd/MM/yyyy"))

        Log("-- Enter Pre-Op Outcome GUI --", 4)
    }
}