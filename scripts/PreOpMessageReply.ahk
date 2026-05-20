#Requires AutoHotkey v2.0
#Include ../dependencies/scripts/_all.ahk

TraySetIcon("..\images\Icons\Dialog.ico")

Intro := "Hello,"
Outro := ""
Signature := "`n`n - " fullName

try Hotkey MessageCentreGUIKey, MessageCentreGUI
MessageCentreGUI(*) {
    Log("-- Enter Pre-OP Outcome GUI --", 1)
    MessageCentreGUI := BuildGui("Enter Pre-Op Outcome")
    MessageCentreGUI.AddText("", "Reply")
    MessageCentreGUI.AddDropDownList("w300 Choose1 vReply", [
        "APPROVED - Pre-Op Booked",
        "DENIED - Has Future Pre-Op",
        "DENIED - Had Past Pre-Op",
        "DENIED - No Surgical Pathway"
        ;"DENIED - Not a refresh"
    ])
    MessageCentreGUI.AddEdit("Disabled", "")
    ;MessageCentreGUI.AddEdit(, "Test")
    MessageCentreGUI.AddButton("Default w300 xm y+24", "OK").OnEvent("Click", EnterOutcomeExe)
    MessageCentreGUI.Show("AutoSize Center")

    EnterOutcomeExe(*) {
        Log("Running Pre-Op Outcome", 2)
        fields := MessageCentreGUI.Submit()
        MessageCentreGUI.Destroy()

        Sleep(500) ; takes RC a second to focus the box again

        Send(Intro "`n`n")

        if fields.Reply = "APPROVED - Pre-Op Booked"
            Send("This pre-op assessment has been booked.")

        if fields.Reply = "DENIED - Has Future Pre-Op"
            Send("This request hasn't been actioned as this patient already has a future pre-op appointment. " Outro)

        if fields.Reply = "DENIED - Had Past Pre-Op"
            Send("This request hasn't been actioned as this patient already had a past pre-op appointment which is still valid. " Outro)

        if fields.Reply = "DENIED - No Surgical Pathway"
            Send("This request hasn't been actioned as this patient does not have a surgical pathway listed in their Powerchart documents. Please re-request once the criteria has been fulfilled. " Outro)

        ;Send(Signature)
    }
}