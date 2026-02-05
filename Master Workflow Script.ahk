#Requires AutoHotkey v2.0
#SingleInstance Force

; --------------------
; Keys
; --------------------
`:: {
    ExitApp()
}
+`:: {
    Send("Actioned by DQ (Data Quality Team)")
}
; --------------------
; Variables - Load from INI if it exists
; --------------------

; Get the directory of this script file (not the calling script)
workflowDir := RegExReplace(A_LineFile, "\\[^\\]*$", "")
configPath := workflowDir "\config.ini"

; Load from INI file
if FileExist(configPath) {
    partialBrowserTitle := IniRead(configPath, "Browser", "PartialBrowserTitle", "")
    outpatientTabTitle := IniRead(configPath, "Reports", "OutpatientTabTitle", "")
    eReferralTabTitle := IniRead(configPath, "Reports", "EReferralTabTitle", "")
    maxTabSwitches := IniRead(configPath, "Browser", "MaxTabSwitches", "")
    legacySheet := IniRead(configPath, "Reports", "LegacySheet", "")
    initials := IniRead(configPath, "User", "Initials", "")
    clipboardDistance := IniRead(configPath, "User", "ClipboardDistance", "")
    EmulationHyprland := IniRead(configPath, "User", "EmulationHyprland", "")
    AdaptionMode := IniRead(configPath, "Clipboard", "AdaptionMode", "")
    ClipSlot1 := IniRead(configPath, "Clipboard", "ClipSlot1", "")
    ClipSlot2 := IniRead(configPath, "Clipboard", "ClipSlot2", "")
    ClipSlot3 := IniRead(configPath, "Clipboard", "ClipSlot3", "")
    ClipSlot4 := IniRead(configPath, "Clipboard", "ClipSlot4", "")
    ClipSlot5 := IniRead(configPath, "Clipboard", "ClipSlot5", "")
    ClipSlot6 := IniRead(configPath, "Clipboard", "ClipSlot6", "")
    ClipSlot7 := IniRead(configPath, "Clipboard", "ClipSlot7", "")
    ClipSlot8 := IniRead(configPath, "Clipboard", "ClipSlot8", "")
    ClipSlot9 := IniRead(configPath, "Clipboard", "ClipSlot9", "")
} else {
    global partialBrowserTitle := "edge"
    global outpatientTabTitle := "new report"
    global eReferralTabTitle := "e-re"
    global maxTabSwitches := 10
    global legacySheet := false
    global initials := "DEFAULT NAME"
    global clipboardDistance := 10
    global EmulationHyprland := false
    global AdaptionMode := false
    global ClipSlot1 := "EMPTY"
    global ClipSlot2 := "EMPTY"
    global ClipSlot3 := "EMPTY"
    global ClipSlot4 := "EMPTY"
    global ClipSlot5 := "EMPTY"
    global ClipSlot6 := "EMPTY"
    global ClipSlot7 := "EMPTY"
    global ClipSlot8 := "EMPTY"
    global ClipSlot9 := "EMPTY"
}

; Hyprland emulation test
; only focuses window under mouse for now, rebuilding hyprland from scratch will be pretty hard. 
if EmulationHyprland {
    loop {
    MouseGetPos(, , &WindowID)
    WinActivate("ahk_id " WindowID)
    Sleep(100)
    }
}