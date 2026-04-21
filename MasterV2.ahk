#Requires AutoHotkey v2.0
#Include scripts/dependencies/_all.ahk
#Include dependencies/UpdateChecker.ahk

SaveLogs := true
ShowErrors := true

ScriptsDir := A_ScriptDir "\scripts"
DescriptionsIniPath := ScriptsDir "\_descriptions.ini"
ConfigIniPath := A_ScriptDir "\config.ini"

MasterGui := BuildGui("Master")

ScriptList := MasterGui.AddListView("Checked r10 w700", ["Name", "Description"])
Loop Files, ScriptsDir "\*.ahk"
{
    FileDesc := IniRead(DescriptionsIniPath, "Descriptions", A_LoopFileName, "")
    ScriptList.Add(, A_LoopFileName, FileDesc)
}

ScriptList.OnEvent("DoubleClick", RunFile) ; maybe make it open when checked
ScriptList.ModifyCol(1, "Auto") ; Auto-size

MasterGui.AddButton("", "Open Selected")
MasterGui.AddButton("x+10", "Refresh all scripts")
MasterGui.AddButton("x+10", "Close all scripts").OnEvent("Click", (*) => CloseScripts())
MasterGui.AddButton("xm", "Open Config").OnEvent("Click", (*) => ShowConfig())

MasterGui.Show("AutoSize Center")

RunFile(ListView, RowNumber) {
    ScriptName := ListView.GetText(RowNumber, 1)
    try {
        Run(A_ScriptDir "\scripts\" ScriptName)
        ToolTipTimer(ScriptName " opened!", 1)
    }
    catch
        MsgBox("Could not open " A_ScriptDir "\scripts\" ScriptName ".")
}

ShowConfig() {
    ConfigGui := BuildGui("Config")

    ConfigGui.Title := "Master Script - Config"

    ConfigGui.AddText("xm w600 h10 0x10")
    ConfigGui.AddText("y+0 w600 Center", "General")
    ConfigGui.AddText("xm y+0 w600 h10 0x10")

    ConfigGui.AddText("xm y+10 w200", "Browser Name:")
    ConfigGui.AddEdit("x+10 yp-3 w380 vConfBrowser")

    ConfigGui.AddText("xm y+10 w200", "Initials:")
    ConfigGui.AddEdit("x+10 yp-3 w380 vConfInitials")

    ConfigGui.AddText("xm y+10 w200", "Appt. Book Default Start Date")
    ConfigGui.AddEdit("x+10 yp-3 w380 Number Limit8 vConfAppointmentBookStartDate")

    ConfigGui.AddCheckbox("xm y+10 w300 vConfLegacySheet", "Legacy Sheet (No Attendance ID Column)")
    ConfigGui.AddCheckbox("x+0 yp w300 vConfSudo", "Super User Apps")
    ConfigGui.AddCheckbox("xm y+10 w300 vConfSaveLogs Checked", "Save Logs")
    ConfigGui.AddCheckbox("x+0 yp w300 vConfShowErrors Checked", "Show Errors")
    ConfigGui.AddCheckbox("xm y+10 w300 vConfFancyEffects Checked", "Fancy Effects")

    ConfigGui.AddText("xm y+20 w600 0x10")
    ConfigGui.AddText("xm y+5 w600 Center", "Hotkeys")
    ConfigGui.AddText("xm w600 0x10")

    for entry in [
        ["Enter Outcome:", "vHotkeyEnterOutcome"],
        ["Revenue Cycle:", "vHotkeyRevenueCycle"],
        ["PowerChart:", "vHotkeyPowerChart"],
        ["Appointment Book:", "vHotkeyAppointmentBook"],
        ["PM Office: [WIP]", "vHotkeyPMOffice"],
        ["Add Referral:", "vHotkeyAddReferral"],
        ["Pre-Op Options:", "vHotkeyPreOpGui"]
    ] {
        ConfigGui.AddText("xm y+10 w200", entry[1])
        ConfigGui.AddHotkey("x+10 yp-3 w380 " entry[2])
    }

    ; Load current settings
    ConfigGui["ConfBrowser"].Value := IniRead(ConfigIniPath, "General", "Browser", "")
    ConfigGui["ConfInitials"].Value := IniRead(ConfigIniPath, "General", "Initials", "")
    ConfigGui["ConfAppointmentBookStartDate"].Value := IniRead(ConfigIniPath, "General", "AppointmentBookStartDate", "")
    ConfigGui["ConfLegacySheet"].Value := IniRead(ConfigIniPath, "General", "LegacySheet", 0)
    ConfigGui["ConfSudo"].Value := IniRead(ConfigIniPath, "General", "Sudo", 0)
    ConfigGui["ConfSaveLogs"].Value := IniRead(ConfigIniPath, "General", "SaveLogs", 1)
    ConfigGui["ConfShowErrors"].Value := IniRead(ConfigIniPath, "General", "ShowErrors", 1)
    ConfigGui["ConfFancyEffects"].Value := IniRead(ConfigIniPath, "General", "FancyEffects", 1)

    for entry in [
        ["HotkeyEnterOutcome"],
        ["HotkeyRevenueCycle"],
        ["HotkeyPowerChart"],
        ["HotkeyAppointmentBook"],
        ["HotkeyPMOffice"],
        ["HotkeyAddReferral"],
        ["HotkeyPreOpGui"]
    ] {
        ConfigGui[entry[1]].Value := IniRead(ConfigIniPath, "Hotkeys", entry[1], "")
    }

    ; Add buttons
    ConfigGui.AddButton("xm y+20", "Save").OnEvent("Click", (*) => SaveConfig(ConfigGui))
    ConfigGui.AddButton("x+10", "Reset").OnEvent("Click", (*) => ResetConfig(ConfigGui))

    ConfigGui.Show("AutoSize Center")
}

SaveConfig(GuiObj) {
    IniWrite(GuiObj["ConfBrowser"].Value, ConfigIniPath, "General", "Browser")
    IniWrite(GuiObj["ConfInitials"].Value, ConfigIniPath, "General", "Initials")
    IniWrite(GuiObj["ConfAppointmentBookStartDate"].Value, ConfigIniPath, "General", "AppointmentBookStartDate")
    IniWrite(GuiObj["ConfLegacySheet"].Value, ConfigIniPath, "General", "LegacySheet")
    IniWrite(GuiObj["ConfSudo"].Value, ConfigIniPath, "General", "Sudo")
    IniWrite(GuiObj["ConfSaveLogs"].Value, ConfigIniPath, "General", "SaveLogs")
    IniWrite(GuiObj["ConfShowErrors"].Value, ConfigIniPath, "General", "ShowErrors")
    IniWrite(GuiObj["ConfFancyEffects"].Value, ConfigIniPath, "General", "FancyEffects")
    for entry in [
        ["HotkeyEnterOutcome"],
        ["HotkeyRevenueCycle"],
        ["HotkeyPowerChart"],
        ["HotkeyAppointmentBook"],
        ["HotkeyPMOffice"],
        ["HotkeyAddReferral"],
        ["HotkeyPreOpGui"]
    ] {
        IniWrite(GuiObj[entry[1]].Value, ConfigIniPath, "Hotkeys", entry[1])
    }
    MsgBox("Settings saved!")
}

ResetConfig(GuiObj) {
    ; Reset to defaults (adjust as needed)
    GuiObj["ConfBrowser"].Value := ""
    GuiObj["ConfInitials"].Value := ""
    GuiObj["ConfAppointmentBookStartDate"].Value := ""
    GuiObj["ConfLegacySheet"].Value := 0
    GuiObj["ConfSudo"].Value := 0
    GuiObj["ConfSaveLogs"].Value := 1
    GuiObj["ConfShowErrors"].Value := 1
    GuiObj["ConfFancyEffects"].Value := 1
    for entry in [
        ["HotkeyEnterOutcome"],
        ["HotkeyRevenueCycle"],
        ["HotkeyPowerChart"],
        ["HotkeyAppointmentBook"],
        ["HotkeyPMOffice"],
        ["HotkeyAddReferral"],
        ["HotkeyPreOpGui"]
    ] {
        GuiObj[entry[1]].Value := ""
    }
}

CloseScripts() {

}

MasterGuiOpen := 1
NumpadEnter:: {

    global MasterGuiOpen

    if MasterGuiOpen {
        MasterGui.Hide()
        MasterGuiOpen := 0
    }
    else {
        MasterGui.Show()
        MasterGuiOpen := 1
    }
}