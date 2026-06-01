#Requires AutoHotkey v2.0
#Include ../dependencies/scripts/_all.ahk

TraySetIcon("..\images\Icons\Writing on sheet.ico")

NICEmailList := IniRead("../arrays\nicList.ini")

try Hotkey TriageKey, Triage
Triage(*) {
    TriageRequestGui := BuildGui("Triage Request")

    TriageRequestGui.AddText("","Nurse-In-Charge")
    TriageRequestGui.AddDropDownList("w300 Choose1 vNIC", [
            "Ram",
            "Bernie"
        ])
    
    TriageRequestGui.AddText("","MRN / NHS Num")
    MRN := TriageRequestGui.AddEdit("r1 w300 vMRN", "") 

    TriageRequestGui.Add("Button", "Default w300 vOkBtn", "OK").OnEvent("Click", SendRequest.Bind(TriageRequestGui))

    TriageRequestGui.Show("AutoSize Center")
    MRN.Focus()
}

SendRequest(guiObj, *) {
    ; FIX 2: Use the passed guiObj instead of the global variable name
    fields := guiObj.Submit() 

    ; Initialize the variable to prevent "unset variable" errors
    NICEmail := "" 

    if fields.NIC = "Ram"
        NICEmail := "Ramandeep.Gahir@uhcw.nhs.uk"
    else if fields.NIC = "Bernie"
        NICEmail := "Bernadette.Hutchinson@uhcw.nhs.uk"

    ; Only run if we actually matched an email and MRN isn't blank
    if (NICEmail != "" && fields.MRN != "") {
        Run("mailto:" NICEmail "?subject=Triage Request - " fields.MRN "&body=Hi,%0D%0A%0D%0ATriage Please%0D%0A%0D%0AThanks,%0D%0A" . fullName)
    }
}