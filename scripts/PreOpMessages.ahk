#Requires AutoHotkey v2.0
#Include dependencies/_all.ahk

try Hotkey PreOpGUIKey, PreOpGUI
PreOpGUI(*) {
    Log("-- PRE-OP GUI --", 1)
    PreOpGUI := BuildGui("Pre-Op Message GUI")

    btn1 := PreOpGUI.AddButton("w160 Default", "RC Appointment Comment")
    btn1.OnEvent("Click", (*) => (PreOpGUI.Destroy(), ShowApptCommentGUI()))

    btn2 := PreOpGUI.AddButton("w160", "Text Message")
    btn2.OnEvent("Click", (*) => (PreOpGUI.Destroy(), ShowTxtMsgGUI()))

    PreOpGUI.Show("AutoSize Center")
}

ShowTxtMsgGUI() {
    Log("Text Message GUI", 1)
    g := BuildGui("Text Message")

    g.AddText(, "Phone Number:")
    phoneField := g.AddEdit("w220")

    outcomeField := g.AddDropDownList("w200 Choose1 vOutcome", [
        "Scheduled",
        "Rescheduled",
        "Cancelled"
    ])

    g.AddText(, "Appointment Date:")
    dateField := g.AddEdit("w220")

    g.AddText(, "Location:")
    locationField := g.AddEdit("w220")

    okBtn := g.AddButton("Default w100", "OK")
    okBtn.OnEvent("Click", (*) => RunTxtMsgMacro(g, phoneField, outcomeField, dateField, locationField))

    g.Show("AutoSize Center")
}

RunTxtMsgMacro(g, phoneField, outcomeField, dateField, locationField) {
    phone := phoneField.Value
    date := dateField.Value
    Outcome := OutcomeField.Text
    location := LocationField.Text

    if (phone = "" || date = "") {
        MsgBox("Please fill in all required fields.", "Missing Fields", "Icon!")
        return
    }

    g.Destroy()

    Log("Running Text Message GUI", 2)
    Log("Phone: " . phone)
    Log("Outcome: " . Outcome)
    Log("Date: " . date)
    Log("Location: " . location)

    if (Outcome = "Scheduled" or Outcome = "Rescheduled")
        msg := "An appointment has been " Outcome " for you on " date " in " location ". If you have any queries, please call on 02476966393."
    else if (Outcome = "Cancelled")
        msg := "Your appointment on " date " in " location " has been cancelled. If you have any queries, please call on 02476966393."
    else
        msg := "no outcome selected"
    Run("mailto:" phone "@sms.mmg.co.uk?subject=Text%20Message&body=" msg)
    Log("Text Message GUI", 4)
}

ShowApptCommentGUI() {
    Log("-- Enter Pre-OP Outcome GUI --", 1)
    EnterPreOpOutcomeGUI := BuildGui("Enter Pre-Op Outcome")
    EnterPreOpOutcomeGUI.AddDropDownList("w200 Choose1 vOrigin", [
        "From MPTL list",
        "PT called",
        "Email request",
        "Request from med sec"
    ])
    EnterPreOpOutcomeGUI.AddDropDownList("w200 Choose1 vPriority", [
        "",
        "Routine",
        "Urgent",
        "31/62"
    ])
    EnterPreOpOutcomeGUI.AddDropDownList("w200 Choose1 vPtInform", [
        "Letter sent",
        "Informed and agreed over telephone"
    ])
    EnterPreOpOutcomeGUI.AddButton("Default w80", "OK").OnEvent("Click", EnterOutcomeExe)
    EnterPreOpOutcomeGUI.Show("AutoSize Center")

    EnterOutcomeExe(*) {
        Log("Running Pre-Op Outcome", 2)
        fields := EnterPreOpOutcomeGUI.Submit()
        EnterPreOpOutcomeGUI.Destroy()
        Log("Origin: " . fields.Origin)
        Log("Priority: " . fields.Priority)
        Log("Patient informed: " . fields.PtInform)

        if fields.Origin != ""
            Send(fields.Origin . ", ")

        if fields.Priority != ""
            Send(fields.Priority . ", ")

        Send(fields.PtInform . " - JW " . FormatTime(, "dd/MM/yyyy"))

        Log("-- Enter Pre-Op Outcome GUI --", 4)
    }
}