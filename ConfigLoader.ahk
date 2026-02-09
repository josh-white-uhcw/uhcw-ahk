#Requires AutoHotkey v2.0

configFile := A_ScriptDir "\config.ini"

global initials := IniRead(configFile, "Settings", "initials", "")
global legacySheet := (IniRead(configFile, "Settings", "LegacySheet", "false") = "true")
global emulationHyprland := (IniRead(configFile, "Settings", "EmulationHyprland", "false") = "true")