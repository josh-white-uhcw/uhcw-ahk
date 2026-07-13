#Requires AutoHotkey v2.0
#Include ../dependencies/scripts/_all.ahk

TraySetIcon("..\images\Icons\Book 4.ico")

try Hotkey NoteCreateKey, NoteCreate
NoteCreate(*) {
    NoteCreateGUI := BuildGui("Note Creator")

    NoteCreateGUI.AddText("", "Note Title")
    global NoteTitle := NoteCreateGUI.AddEdit("w300", "")

    NoteCreateGUI.AddText("", "Note Contents [Optional]")
    global NoteText := NoteCreateGUI.AddEdit("w300", "")

    NoteCreateGUI.AddText("", "")
    NoteCreateGUI.Add("Button", "Default w300 vOkBtn", "Create").OnEvent("Click", Note.Bind(NoteCreateGUI))
    ;NoteCreateGUI.Add("Button", "Default w300 vOkAOTBtn", "Create [Always On Top]").OnEvent("Click", Note.Bind(NoteCreateGUI))

    NoteCreateGUI.Show("AutoSize Center")
}

Note(*) {
    NoteGUI := BuildGui(NoteTitle.Value, "+AlwaysOnTop +Resize -MaximizeBox -MinimizeBox ")
    if NoteText.Value != ""
        NoteGUI.AddEdit("r10 w600", NoteText.Value)

    NoteGUI.Show("Center")
}