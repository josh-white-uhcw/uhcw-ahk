#Requires AutoHotkey v2.0
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
global partialBrowserTitle, outpatientTabTitle, eReferralTabTitle, maxTabSwitches, legacySheet, initials, clipboardDistance

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
} else {
    global partialBrowserTitle := "edge"
    global outpatientTabTitle := "new report"
    global eReferralTabTitle := "e-re"
    global maxTabSwitches := 10
    global legacySheet := false
    global initials := "DEFAULT NAME"
    global clipboardDistance := 10
}