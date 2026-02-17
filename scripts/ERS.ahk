#Requires AutoHotkey v2.0
#Include ../ConfigLoader.ahk
#Include ../dependencies/_all.ahk

#:: {
    Send("Waitlist added to EPR")
}

Hotkey AddReferralKey, AddReferral
AddReferral(*) {
    OpenMacroGui()
}

; all below is for add referral !!!

OpenMacroGui() {
    macroGui := Gui("+AlwaysOnTop", "Add Referral Setup")
    macroGui.SetFont("s10", "Segoe UI")

    macroGui.Add("Text", , "UBRN (12 digits): *")
    ubrnEdit := macroGui.Add("Edit", "w200 vUbrn Number")
    ubrnEdit.OnEvent("Change", (*) => UpdateOkButton(macroGui))

    macroGui.Add("Text", , "Treatment Function: *")
    macroGui.Add("Edit", "w200 vTreatmentFunction").OnEvent("Change", (*) => UpdateOkButton(macroGui))

    macroGui.Add("Text", , "Priority: *")
    macroGui.Add("Edit", "w200 vPriority").OnEvent("Change", (*) => UpdateOkButton(macroGui))

    macroGui.Add("Text", , "Reason For Referral: *")
    macroGui.Add("Edit", "w200 vReasonForReferral").OnEvent("Change", (*) => UpdateOkButton(macroGui))

    macroGui.AddDateTime("vReferralDate", "dd/MM/yyyy")

    macroGui.Add("Text", "cRed", "* Required fields")

    okBtn := macroGui.Add("Button", "Default w80 vOkBtn Disabled", "OK")
    okBtn.OnEvent("Click", RunMacro.Bind(macroGui))

    macroGui.Show("AutoSize Center")
}

UpdateOkButton(guiObj) {
    fields := guiObj.Submit(false)

    ; Check UBRN is exactly 12 digits
    ubrnValid := (StrLen(fields.Ubrn) = 12) && RegExMatch(fields.Ubrn, "^\d{12}$")

    allFilled := ubrnValid
        && (Trim(fields.TreatmentFunction) != "")
        && (Trim(fields.Priority) != "")
        && (Trim(fields.ReasonForReferral) != "")

    guiObj["OkBtn"].Enabled := allFilled
}

RunMacro(guiObj, *) {
    fields := guiObj.Submit()

    shortDate := FormatTime(fields.ReferralDate, "dd/MM/yyyy")

    ; --- Execution ---
    if !windowCheck("Add Referral") {
        MsgBox("Window check failed")
        return
    }

    Send("uni") ; hospital trust
    Send("{Enter}")
    Sleep(50)
    Send("{Enter}") ; add new pathway
    Send("{Tab}")
    Send("I") ; indirect cab referral

    Send("+{Tab}")
    Send("+{Tab}")
    Send("+{Tab}")
    Send("+{Tab}")

    Send(fields.Ubrn)
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Enter}") ; "paste" thing
    Send("{Tab}") ; goes to treatment function
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send(fields.TreatmentFunction) ; treatment function

    ;Sleep (1000) ; debug

    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send(fields.Priority) ; priority

    ;Sleep (1000) ; debug

    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")

    ;
    Send(shortDate) ; referral date

    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")

    Send(fields.ReasonForReferral) ; reason for referral

    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Down}") ; RTT 10

    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send(fields.ReasonForReferral) ; reason for referral *2
}