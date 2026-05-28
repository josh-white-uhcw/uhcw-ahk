#Requires AutoHotkey v2.0
#SingleInstance

configFile := A_ScriptDir "\..\config.ini"

global browser := IniRead(configFile, "General", "Browser", "")
global fullName := IniRead(configFile, "General", "FullName", "")
global initials := fullName ? RegExReplace(fullName, "\b(\w)\w*\b|\W+", "$1") : ""
global legacySheet := (IniRead(configFile, "General", "LegacySheet", "0") = "1")
global Sudo := (IniRead(configFile, "General", "Sudo", "0") = "1")
global SaveLogs := (IniRead(configFile, "General", "SaveLogs", "1") = "1")
global ShowErrors := (IniRead(configFile, "General", "ShowErrors", "1") = "1")
global FancyEffects := (IniRead(configFile, "General", "FancyEffects", "1") = "1")
global AppointmentBookStartDate := IniRead(configFile, "General", "AppointmentBookStartDate", "")

global EnterOutcomeKey := IniRead(configFile, "Hotkeys", "HotkeyEnterOutcome", "")
global RevenueCycleKey := IniRead(configFile, "Hotkeys", "HotkeyRevenueCycle", "")
global PowerChartKey := IniRead(configFile, "Hotkeys", "HotkeyPowerChart", "")
global AppointmentBookKey := IniRead(configFile, "Hotkeys", "HotkeyAppointmentBook", "")
global PMOfficeKey := IniRead(configFile, "Hotkeys", "HotkeyPMOffice", "")
global AddReferralKey := IniRead(configFile, "Hotkeys", "HotkeyAddReferral", "")
global PreOpGUIKey := IniRead(configFile, "Hotkeys", "HotkeyPreOpGui", "")
global EmailReplyGUIKey := IniRead(configFile, "Hotkeys", "HotkeyEmailReplies", "")
global ShorthandTranslatorKey := IniRead(configFile, "Hotkeys", "HotkeyShorthandTranslator", "")