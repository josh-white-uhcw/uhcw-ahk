#Requires AutoHotkey v2.0
#Include ../dependencies/scripts/_all.ahk

TraySetIcon("..\images\Icons\Dialog.ico")

Intro := "Hi,"
Resumbit := "Please resubmit this request once this criteria has been filled"

try Hotkey EmailReplyGUIKey, EmailReplyGUI
EmailReplyGUI(*) {
    Log("-- Enter Pre-OP Outcome GUI --", 1)
    EmailReplyGUI := BuildGui("Enter Pre-Op Outcome")
    EmailReplyGUI.AddText("", "Reply")
    EmailReplyGUI.AddDropDownList("w300 Choose1 Disabled vReply", [
        "NOT WORKING YET!!!"
    ])
    EmailReplyGUI.AddEdit("Disabled", "")
    ;EmailReplyGUI.AddEdit(, "Test")
    ;EmailReplyGUI.AddButton("Default w300 xm y+24", "OK").OnEvent("Click", EnterOutcomeExe)
    EmailReplyGUI.Show("AutoSize Center")

    EnterOutcomeExe(*) {
        Log("Running Pre-Op Outcome", 2)
        fields := EmailReplyGUI.Submit()
        EmailReplyGUI.Destroy()

        Sleep(500)

        Send(Intro "`n" "`n")

        if fields.Reply = "APPROVED - Booked"
            Send("This pre-op assessment has been booked.")

        if fields.Reply = "DENIED - No Surgical Pathway / Triage"
            Send("This request hasn't been actioned as there is no Surgical Pathway and/or Triage for this patient. Please resubmit this request once this criteria has been filled")

        if fields.Reply = "DENIED - Invalid for refresh"
            Send("This request hasn't been actioned as the Surgical Pathway and Triage for this patient has expired. Please resubmit this request once a new surgical order / surgical pathway has been made.")

        if fields.Reply = "DENIED - Not Our Speciality"
            Send("This request hasn't been actioned as we are unable to book for this speciality. Please resubmit this request to the proper team.")


    }
}