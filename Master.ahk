#Requires AutoHotkey v2.0
#SingleInstance Force

global configFile := A_ScriptDir "\config.ini"

; Base Gui Stuff
myGui := Gui()
myGui.Opt("AlwaysOnTop Resize")
myGui.Title := "Master Script"

; Scripts
myGui.Add("Text", "xm y10 w600 h20 0x10") ; horizontal rule
myGui.Add("Text", "xm y+5 w600 h20 Center", "── Scripts ──")
myGui.Add("Text", "xm w600 h20 0x10")

scriptList := myGui.Add("ListBox", "xm y+5 w600 h200 multi")
LoadScripts()

myGui.Add("Button", "xm y+8 w180", "Open Script").OnEvent("Click", OpenScript)
myGui.Add("Button", "x+10 yp w180", "Refresh Scripts").OnEvent("Click", LoadScripts)
myGui.Add("Button", "x+10 yp w180", "Close All Scripts [Soon]").OnEvent("Click", CloseAllScripts)

; ── General Config Section ───────────────────────────────────────
myGui.Add("Text", "xm y+20 w600 h20 0x10")
myGui.Add("Text", "xm y+5 w600 h20 Center", "── General Config ──")
myGui.Add("Text", "xm w600 h20 0x10")

myGui.Add("Text", "xm y+10 w200", "Browser Name:")
ConfBrowser := myGui.Add("Edit", "x+10 yp-3 w380 vConfBrowser")

myGui.Add("Text", "xm y+10 w200", "Initials:")
ConfInitials := myGui.Add("Edit", "x+10 yp-3 w380 vConfInitials")

myGui.Add("Text", "xm y+10 w200", "Appt. Book Default Start Date:")
ConfAppointmentBookStartDate := myGui.Add("Edit", "x+10 yp-3 w380 vConfAppointmentBookStartDate")

ConfLegacySheet := myGui.Add("Checkbox", "xm y+10 w600", "Legacy Sheet (No Attendance ID Column)")

; ── Hotkeys Section ──────────────────────────────────────────────
myGui.Add("Text", "xm y+20 w600 h20 0x10")
myGui.Add("Text", "xm y+5 w600 h20 Center", "── Hotkeys ──")
myGui.Add("Text", "xm w600 h20 0x10")

myGui.Add("Text", "xm y+10 w200", "Enter Outcome: [WIP]")
HotkeyEnterOutcome := myGui.Add("Hotkey", "x+10 yp-3 w380 vHotkeyEnterOutcome")

myGui.Add("Text", "xm y+10 w200", "Revenue Cycle:")
HotkeyRevenueCycle := myGui.Add("Hotkey", "x+10 yp-3 w380 vHotkeyRevenueCycle")

myGui.Add("Text", "xm y+10 w200", "PowerChart:")
HotkeyPowerChart := myGui.Add("Hotkey", "x+10 yp-3 w380 vHotkeyPowerChart")

myGui.Add("Text", "xm y+10 w200", "Appointment Book: [WIP]")
HotkeyAppointmentBook := myGui.Add("Hotkey", "x+10 yp-3 w380 vHotkeyAppointmentBook")

myGui.Add("Text", "xm y+10 w200", "PM Office:")
HotkeyPMOffice := myGui.Add("Hotkey", "x+10 yp-3 w380 vHotkeyPMOffice")

myGui.Add("Text", "xm y+10 w200", "Add Referral:")
HotkeyAddReferral := myGui.Add("Hotkey", "x+10 yp-3 w380 vHotkeyAddReferral")

; ── Save / Reset ─────────────────────────────────────────────────
myGui.Add("Text", "xm y+20 w600 h20 0x10")

ResetBtn := myGui.Add("Button", "xm y+8 w180", "Reset Hotkeys")
SaveBtn := myGui.Add("Button", "x+10 yp w180", "Save Settings")
ResetBtn.OnEvent("Click", ResetHotkeys)
SaveBtn.OnEvent("Click", SaveSettings)

; ── Info ─────────────────────────────────────────────────────────
myGui.Add("Text", "xm y+20 w600 h20 0x10")
myGui.Add("Text", "xm y+5 w600 Center", "── Info ──")
myGui.Add("Text", "xm w600 h20 0x10")
myGui.Add("Text", "xm y+5 w600", "Will add info here soon")

; Load current settings and show
LoadCurrentSettings()
myGui.Show("w640")

; ── Resize handler so the ListBox and edits stretch with the window ──
myGui.OnEvent("Size", OnGuiSize)

OnGuiSize(GuiObj, MinMax, Width, Height) {
    if MinMax = -1
        return
    innerW := Width - 40
    scriptList.Move(, , innerW)
    ConfBrowser.Move(, , innerW - 210)
    ConfInitials.Move(, , innerW - 210)
    ConfAppointmentBookStartDate.Move(, , innerW - 210)
    ConfLegacySheet.Move(, , innerW)
    HotkeyEnterOutcome.Move(, , innerW - 210)
    HotkeyRevenueCycle.Move(, , innerW - 210)
    HotkeyPowerChart.Move(, , innerW - 210)
    HotkeyAppointmentBook.Move(, , innerW - 210)
    HotkeyPMOffice.Move(, , innerW - 210)
    HotkeyAddReferral.Move(, , innerW - 210)
}

; ── Scripts ──────────────────────────────────────────────────────

LoadScripts(*) {
    scriptList.Delete()
    if !DirExist(A_ScriptDir "\scripts") {
        scriptList.Add(["Cannot find ./scripts folder"])
        return
    }
    Loop Files, A_ScriptDir "\scripts\*.ahk" {
        scriptList.Add([A_LoopFileName])
    }
}

OpenScript(*) {
    if (scriptList.Value = 0) {
        ToolTip("No script selected")
        SetTimer(() => ToolTip(), -1000)
        return
    }
    fileName := scriptList.Text[1]
    fullPath := A_ScriptDir "\scripts\" fileName
    if !IsScriptRunning(fileName)
        Run('"' A_AhkPath '" "' fullPath '"')
}

CloseAllScripts(*) {
    Loop Files, A_ScriptDir "\scripts\*.ahk" {
        if (A_LoopFileName = "Master.ahk")
            continue
        if IsScriptRunning(A_LoopFileName)
            WinClose(A_ScriptDir "\scripts\" A_LoopFileName)
    }
}

IsScriptRunning(fileName) {
    return WinExist(A_ScriptDir "\scripts\" fileName)
}

; ── Settings ─────────────────────────────────────────────────────

LoadCurrentSettings() {
    ConfBrowser.Value := IniRead(configFile, "Settings", "browser", "")
    ConfInitials.Value := IniRead(configFile, "Settings", "initials", "")
    ConfLegacySheet.Value := (IniRead(configFile, "Settings", "LegacySheet", "false") = "true") ? 1 : 0
    ConfAppointmentBookStartDate.Value := IniRead(configFile, "Settings", "AppointmentBookStartDate", "")

    HotkeyEnterOutcome.Value := IniRead(configFile, "Hotkeys", "EnterOutcome", "")
    HotkeyRevenueCycle.Value := IniRead(configFile, "Hotkeys", "RevenueCycle", "")
    HotkeyPowerChart.Value := IniRead(configFile, "Hotkeys", "PowerChart", "")
    HotkeyPMOffice.Value := IniRead(configFile, "Hotkeys", "PMOffice", "")
    HotkeyAddReferral.Value := IniRead(configFile, "Hotkeys", "AddReferral", "")
}

SaveSettings(*) {
    IniWrite(ConfBrowser.Value, configFile, "Settings", "browser")
    IniWrite(ConfInitials.Value, configFile, "Settings", "initials")
    IniWrite(ConfLegacySheet.Value ? "true" : "false", configFile, "Settings", "LegacySheet")
    IniWrite(ConfAppointmentBookStartDate.Value, configFile, "Settings", "AppointmentBookStartDate")

    IniWrite(HotkeyEnterOutcome.Value, configFile, "Hotkeys", "EnterOutcome")
    IniWrite(HotkeyRevenueCycle.Value, configFile, "Hotkeys", "RevenueCycle")
    IniWrite(HotkeyPowerChart.Value, configFile, "Hotkeys", "PowerChart")
    IniWrite(HotkeyPMOffice.Value, configFile, "Hotkeys", "PMOffice")
    IniWrite(HotkeyAddReferral.Value, configFile, "Hotkeys", "AddReferral")

    ToolTip("Settings saved!")
    SetTimer(() => ToolTip(), -1000)
}

ResetHotkeys(*) {
    IniDelete("config.ini", "Hotkeys")
    Run("Master.ahk")
    ToolTip("Hotkeys cleared! Click 'Save Settings' to apply.")
    SetTimer(() => ToolTip(), -2000)
}

; ── Hotkey to show GUI ────────────────────────────────────────────
NumpadEnter:: {
    myGui.Show()
}