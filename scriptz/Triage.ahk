#Requires AutoHotkey v2.0
#Include ../dependencies/scripts/_all.ahk

TraySetIcon("..\images\Icons\Writing on sheet.ico")

try Hotkey TriageKey, Triage
Triage(*) {
    TriageRequestGui := BuildGui("Triage Request")

    TriageRequestGui.AddText("", "Nurse-In-Charge")
    TriageRequestGui.AddDropDownList("w300 Choose1 vNIC", [
        "Ram",
        "Bernie",
        "Maria",
        "Mimi"
    ])

    TriageRequestGui.AddText("", "MRN / NHS Num")
    MRN := TriageRequestGui.AddEdit("r1 w300 vMRN", "")

    TriageRequestGui.Add("Button", "Default w300 vOkBtn", "OK").OnEvent("Click", SendRequest.Bind(TriageRequestGui))

    TriageRequestGui.Show("AutoSize Center")
    MRN.Focus()
}

SendRequest(guiObj, *) {
    fields := guiObj.Submit()

    NICEmail := ""
    if fields.NIC = "Ram"
        NICEmail := "Ramandeep.Gahir@uhcw.nhs.uk"
    else if fields.NIC = "Bernie"
        NICEmail := "Bernadette.Hutchinson@uhcw.nhs.uk"
    else if fields.NIC = "Maria"
        NICEmail := "Maria.Bourne@uhcw.nhs.uk"
    else if fields.NIC = "Mimi"
        NICEmail := "Relindis.Aje-Anjeh@uhcw.nhs.uk"

    if (NICEmail != "" && fields.MRN != "") {
        Run("mailto:" NICEmail "?subject=Triage Request - " fields.MRN "&body=Hi,%0D%0A%0D%0ATriage Please%0D%0A%0D%0AThanks,%0D%0A" . fullName)
    }
}