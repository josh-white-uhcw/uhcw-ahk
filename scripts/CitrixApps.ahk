#Requires AutoHotkey v2.0
#Include ../ConfigLoader.ahk
#Include ../dependencies/_all.ahk
Critical ; allows queuing keys

try Hotkey EnterOutcomeKey, EnterOutcome

EnterOutcome(*) {
    macroGui := Gui("+AlwaysOnTop", "Add Referral Setup")
    macroGui.SetFont("s10", "Segoe UI")

    macroGui.Add("Text", , "Treatment Function: *")
    macroGui.Add("DropDownList", "w200 Choose1 vOutcome", ["No Documentation", "Workflow Error-Unactionable", "Workflow Error-Actionable", "Checked Out", "Already Checked Out", "Other Query", "Cancelled", "No Show", "Checkout No Documentation", "No OPA", "Java Error", "Java Error Unactionable"])

    macroGui.Add("Text", , "NOC:")
    macroGui.Add("Edit", "w200 vNOC Number")

    macroGui.Add("Text", "cRed", "* Required fields")

    okBtn := macroGui.Add("Button", "Default w80 vOkBtn", "OK")
    okBtn.OnEvent("Click", RunOutcomeGui.Bind(macroGui))

    macroGui.Show("AutoSize Center")
}

RunOutcomeGui(guiObj, *) {
    fields := guiObj.Submit()
    guiObj.Destroy()
    ; --- Execution ---
    ; code here later
    ToolTipTimer("runtest", 1)

    if !windowCheck(browser) {
        return
    }
    ; outcome: MsgBox(fields.Outcome)
    ; noc: MsgBox(fields.NOC)
    Sleep(500)
    loop 4 {
        Send("{Right}")
    }
    Send(fields.Outcome)
    Send("{Right}")
    Send(fields.NOC)
    Send("{Right}")
    Send(initials)
    Send("{Right}")
    Send(FormatTime(, "MM/dd/yyyy"))
    Sleep(150)
    Send("{Enter}")
    Send("{Home}")
    if !legacySheet {
        Send("{Right}")
    }
    Send("{Escape}")
    Send("{Escape}")
}

try Hotkey RevenueCycleKey, RevenueCycle
RevenueCycle(*) {
    if !windowCheck("Revenue Cycle") { ; calls dependencies/WindowCheck.ahk
        return
    }

    Click(31, 57)
    Send("^v")
    Sleep(200)
    Send("{Enter}")
    Sleep(500)
    Send("{Enter}")
}

try Hotkey PowerChartKey, PowerChart
PowerChart(*) {
    ToolTipTimer("Powerchart", 1)
    if !windowCheck("PowerChart") {
        return
    }

    Sleep(50)
    if !FindImage("PowerChartMRN", "110", "10") { ; Clicks the search icon
        ToolTipTimer("??? - No task image found", 5)
        return
    }

    ; Finish later

    Sleep(200)
}

NumpadDel:: { ; temp

}