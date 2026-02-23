#Requires AutoHotkey v2.0
#Include ../ConfigLoader.ahk
#Include ../dependencies/_all.ahk

#:: {
    Send("Waitlist added to EPR")
}

try Hotkey AddReferralKey, AddReferral
AddReferral(*) {
    macroGui := Gui("+AlwaysOnTop", "Add Referral Setup")
    macroGui.SetFont("s10", "Segoe UI")
    macroGui.Add("Text", , "UBRN (12 digits): *")
    ubrnEdit := macroGui.Add("Edit", "w200 vUbrn")
    ubrnEdit.OnEvent("Change", (*) => UpdateOkButton(macroGui))
    macroGui.Add("Text", , "Treatment Function: *")
    macroGui.Add("DropDownList", "w200 Choose1 vTreatmentFunction", TreatmentFunctionsList) ; messy keeping all functions here, at bottom now
    macroGui.Add("Text", , "Priority: *")
    macroGui.Add("DropDownList", "w200 Choose1 vPriority", ["?", "Cancer 2WW", "Urgent", "Routine", "Rapid Access"])
    macroGui.Add("Text", , "Reason For Referral: *")
    macroGui.Add("Edit", "w200 vReasonForReferral").OnEvent("Change", (*) => UpdateOkButton(macroGui))
    macroGui.AddDateTime("vReferralDate", "dd/MM/yyyy")
    macroGui.Add("Text", "cRed", "* Required fields")
    okBtn := macroGui.Add("Button", "Default w80 vOkBtn Disabled", "OK")
    okBtn.OnEvent("Click", RunMacro.Bind(macroGui))
    macroGui.Show("AutoSize Center")
}

; all below is for add referral process!!!

UpdateOkButton(guiObj) {
    fields := guiObj.Submit(false)
    ubrnStripped := StrReplace(fields.Ubrn, " ", "") ; strip spaces
    ubrnValid := (StrLen(ubrnStripped) = 12) && RegExMatch(ubrnStripped, "^\d{12}$") ; requires 12 numbers
    allFilled := ubrnValid ; 12 numbers
        && (fields.TreatmentFunction != "?")
        && (fields.Priority != "?")
        && (Trim(fields.ReasonForReferral) != "")
    guiObj["OkBtn"].Enabled := allFilled
}

RunMacro(guiObj, *) {
    fields := guiObj.Submit()

    shortDate := FormatTime(fields.ReferralDate, "dd/MM/yyyy")

    ; real execution
    if !WindowCheck("Add Referral") {
        MsgBox("Window check failed")
        return
    }

    if !FindImage("RevenueCycle_Hospital-Trust", "110", "20") { ; Clicks the search icon
        ToolTipTimer("??? - No image found", 5)
        return
    }

    ; sleeps below here are needed when new boxes are added to the window.

    Send("uni") ; hospital trust
    Send("{Enter}")
    Sleep(100)
    Send("{Enter}") ; add new pathway
    Sleep(10)
    Send("{Tab}")
    Send("I") ; indirect cab referral
    Sleep(10)

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

    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send(fields.Priority) ; priority

    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
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
    Send(fields.ReasonForReferral) ; reason for referral #2
}

TreatmentFunctionsList := [
    "?", ; placeholder default, makes user expeicitly select an option
    "Bariatic Surgery Service",
    "Cardiology Heart Failure Clinic",
    "Cardiology Service",
    "Cardiothoracic Surgery Service",
    "Clinical Haematology Service",
    "Colorectal Surgery Service",
    "Dermatology Service",
    "Diabetes Service",
    "Dietetics Service",
    "Ears Nose and Throat Service",
    "Elderly Medicine Service",
    "Endocrinology Service",
    "Gastroenterology Service",
    "General Surgery Service",
    "Gynaecology Service",
    "Infertility",
    "Maxillo Facial Surgery Service",
    "Neurology Service",
    "Neuropsychology",
    "Neurosurgical Service",
    "Oph Cataract",
    "Oph Cornea",
    "Oph Glaucoma",
    "Oph Laser",
    "Oph Med Ret",
    "Oph NormEye ULVF",
    "Oph Oculo",
    "Oph Paeds",
    "Oph VR",
    "Orthotics Service",
    "Paediatric Clinical Haematology Service",
    "Paediatric Dermatology",
    "Paediatric Endocrinology Service",
    "Paediatric Gastroenterology",
    "Paediatric Neurology Service",
    "Paediatric Plastic Surgery Service",
    "Paediatric Respiratory Medicine Service",
    "Paediatric Rheumatology Service",
    "Paediatric Surgery Service",
    "Paediatrics Service",
    "Paeds Trauma and Orthopaedics Service",
    "Pain Management Service",
    "Plastic Surgery Service",
    "Renal Medicine Service",
    "Respiratory Medicine Service",
    "Rheumatology Service",
    "Spinal Surgery Service",
    "Stroke Medicine Service",
    "Transient Ischaemic Attack",
    "Trauma & Orthopaedics Service",
    "Upper Gastrointestinal Surgery Service",
    "Urology Service"
]