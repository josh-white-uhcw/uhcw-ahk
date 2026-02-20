#Requires AutoHotkey v2.0
configFile := A_ScriptDir "\..\config.ini"

global browser := Iniread(configFile, "Settings", "browser", "")
global initials := IniRead(configFile, "Settings", "initials", "")
global legacySheet := (IniRead(configFile, "Settings", "LegacySheet", "false") = "true")

global EnterOutcomeKey := IniRead(configFile, "Hotkeys", "EnterOutcome", "")
global RevenueCycleKey := IniRead(configFile, "Hotkeys", "RevenueCycle", "")
global PowerChartKey := IniRead(configFile, "Hotkeys", "PowerChart", "")
global AppointmentBookKey := IniRead(configFile, "Hotkeys", "AppointmentBook", "")

global AddReferralKey := IniRead(configFile, "Hotkeys", "AddReferral", "")

^+v:: {
    ; Bypasses unpasteable areas
    SendInput(A_Clipboard)
}

ToolTipTimer("Config Loaded", 1)