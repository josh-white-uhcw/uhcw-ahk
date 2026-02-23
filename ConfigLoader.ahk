#Requires AutoHotkey v2.0
#SingleInstance

configFile := A_ScriptDir "\..\config.ini"

global OpenMasterGuiKey := Iniread(configFile, "Settings", "OpenMasterGui", "")
global browser := Iniread(configFile, "Settings", "browser", "")
global initials := IniRead(configFile, "Settings", "initials", "")
global legacySheet := (IniRead(configFile, "Settings", "LegacySheet", "false") = "true")
global AppointmentBookStartDate := IniRead(configFile, "Settings", "AppointmentBookStartDate", "")

global EnterOutcomeKey := IniRead(configFile, "Hotkeys", "EnterOutcome", "")
global RevenueCycleKey := IniRead(configFile, "Hotkeys", "RevenueCycle", "")
global PowerChartKey := IniRead(configFile, "Hotkeys", "PowerChart", "")
global AppointmentBookKey := IniRead(configFile, "Hotkeys", "AppointmentBook", "")
global PMOfficeKey := IniRead(configFile, "Hotkeys", "PMOffice", "")

global AddReferralKey := IniRead(configFile, "Hotkeys", "AddReferral", "")

^+v:: {
    ; Bypasses unpasteable areas
    SendInput(A_Clipboard)
}

ToolTipTimer("Config Loaded", 1)