#Requires AutoHotkey v2.0
#SingleInstance Force

global configFile := A_ScriptDir "\config.ini"

; Base Gui Stuff
myGui := Gui()
myGui.Opt("AlwaysOnTop")
myGui.Title := "Master Script"

; Tabs
Tab := MyGui.Add("Tab3", , ["General", "Info", "Config"])

; Places the following elements in tab 1 (General)
Tab.UseTab(1)

scriptList := myGui.Add("ListBox", "multi w500 h250")
LoadScripts() ; Run on launch

MyGui.Add("Button", "Default w100", "Open Script").OnEvent("Click", OpenScript)
MyGui.Add("Button", "Default w100", "Refresh Scripts").OnEvent("Click", LoadScripts)

; Places the following elements in tab 2 (Info)
Tab.UseTab(2)

myGui.Add("Text", , "Will add info here soon")


; Places the following elements in tab 3 (Config)
Tab.UseTab(3)

MyGui.Add("Text", , "Browser Name:")
ConfBrowser := MyGui.Add("Edit", "w200")
MyGui.Add("Text", , "Initials:")
ConfInitials := MyGui.Add("Edit", "w200")
ConfLegacySheet := MyGui.Add("Checkbox", "", "Legacy Sheet (No Attendance ID Column)")

; Hotkey Controls
MyGui.Add("Text", "xm+10 y+20", "Enter Outcome:")
HotkeyEnterOutcome := MyGui.Add("Hotkey", "x+10 yp-3 w200 vHotkeyEnterOutcome")

MyGui.Add("Text", "xm+10 y+10", "Revenue Cycle:")
HotkeyRevenueCycle := MyGui.Add("Hotkey", "x+10 yp-3 w200 vHotkeyRevenueCycle")

MyGui.Add("Text", "xm+10 y+10", "PowerChart:")
HotkeyPowerChart := MyGui.Add("Hotkey", "x+10 yp-3 w200 vHotkeyPowerChart")

MyGui.Add("Text", "xm+10 y+10", "Add Referral:")
HotkeyAddReferral := MyGui.Add("Hotkey", "x+10 yp-3 w200 vHotkeyAddReferral")

ResetBtn := MyGui.Add("Button", "xm+10 y+20", "Reset Hotkeys")
SaveBtn := MyGui.Add("Button", "x+10 yp", "Save Settings")
ResetBtn.OnEvent("Click", ResetHotkeys)
SaveBtn.OnEvent("Click", SaveSettings)

; Load current settings
LoadCurrentSettings()

; Display the GUI
MyGui.Show()

; Scripts

LoadScripts(*) {
    scriptList.Delete() ; Removes so duplicates are not created

    if !DirExist(A_ScriptDir "\scripts") { ; relative to this folder there should be a ./scripts/ folder with all the main scripts in
        scriptList.Add(["Cannot find ./scripts folder"])
        return
    }

    Loop Files, A_ScriptDir "\scripts\*.ahk" { ; Loops through all files in ./scripts/ and adds them to the listbox
        scriptList.Add([A_LoopFileName])
    }
}

OpenScript(*) {
    ToolTip("not added yet, open manually")
    SetTimer () => ToolTip(), -1000 ; make tooltip last 1 second
}

LoadCurrentSettings() {
    ConfBrowser.Value := IniRead(configFile, "Settings", "browser", "")
    ConfInitials.Value := IniRead(configFile, "Settings", "initials", "")
    ConfLegacySheet.Value := (IniRead(configFile, "Settings", "LegacySheet", "false") = "true") ? 1 : 0

    ; Load hotkeys
    HotkeyEnterOutcome.Value := IniRead(configFile, "Hotkeys", "EnterOutcome", "")
    HotkeyRevenueCycle.Value := IniRead(configFile, "Hotkeys", "RevenueCycle", "")
    HotkeyPowerChart.Value := IniRead(configFile, "Hotkeys", "PowerChart", "")
    HotkeyAddReferral.Value := IniRead(configFile, "Hotkeys", "AddReferral", "")
}

SaveSettings(*) {
    IniWrite(ConfBrowser.Value, configFile, "Settings", "browser")
    IniWrite(ConfInitials.Value, configFile, "Settings", "initials")
    IniWrite(ConfLegacySheet.Value ? "true" : "false", configFile, "Settings", "LegacySheet")

    ; Save hotkeys
    IniWrite(HotkeyEnterOutcome.Value, configFile, "Hotkeys", "EnterOutcome")
    IniWrite(HotkeyRevenueCycle.Value, configFile, "Hotkeys", "RevenueCycle")
    IniWrite(HotkeyPowerChart.Value, configFile, "Hotkeys", "PowerChart")
    IniWrite(HotkeyAddReferral.Value, configFile, "Hotkeys", "AddReferral")

    ToolTip("Settings saved!")
    SetTimer () => ToolTip(), -1000 ; make tooltip last 1 second
}

ResetHotkeys(*) {
    IniDelete("config.ini", "Hotkeys") ; Delete the [Hotkeys] section
    Run("Master.ahk") ; Restart

    ToolTip("Hotkeys cleared! Click 'Save Settings' to apply.")
    SetTimer () => ToolTip(), -2000 ; make tooltip last 2 seconds
}