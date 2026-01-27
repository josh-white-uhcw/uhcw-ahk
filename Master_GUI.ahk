#Requires AutoHotkey v2.0
#SingleInstance Force

; --------------------
; Variables - Load from INI if it exists
; --------------------
global partialBrowserTitle, outpatientTabTitle, eReferralTabTitle, maxTabSwitches, legacySheet, initials, clipboardDistance

; Get the directory of this script file
guiDir := RegExReplace(A_LineFile, "\\[^\\]*$", "")
configPath := guiDir "\config.ini"

; Load from INI file
if FileExist(configPath) {
    partialBrowserTitle := IniRead(configPath, "Browser", "PartialBrowserTitle", "edge")
    outpatientTabTitle := IniRead(configPath, "Reports", "OutpatientTabTitle", "new report")
    eReferralTabTitle := IniRead(configPath, "Reports", "EReferralTabTitle", "e-re")
    maxTabSwitches := IniRead(configPath, "Browser", "MaxTabSwitches", "10")
    legacySheet := IniRead(configPath, "Reports", "LegacySheet", "0")
    initials := IniRead(configPath, "User", "Initials", "DEFAULT NAME")
    clipboardDistance := IniRead(configPath, "User", "ClipboardDistance", "10")
} else { ; defaults for if config.ini does not exist yet
    partialBrowserTitle := "edge"
    outpatientTabTitle := "new report"
    eReferralTabTitle := "e-re"
    maxTabSwitches := "10"
    legacySheet := "0"
    initials := "DEFAULT NAME"
    clipboardDistance := "10"
}

; --------------------
; Create Main GUI
; --------------------
mainGui := Gui()
mainGui.Title := "Master Script Runner"
mainGui.OnEvent("Close", (*) => ExitApp())

; Add tabs for organization
tab := mainGui.Add("Tab3", "x10 y10 w500 h400", ["Scripts", "Settings", "Info"])

; --------------------
; TAB 1: Script Launcher
; --------------------
tab.UseTab(1)
mainGui.Add("Text", "x20 y40 w460", "Available Scripts:")

; List available scripts in ./public/
scriptList := mainGui.Add("ListBox", "x20 y60 w460 h200 vScriptList")
PopulateScripts()

mainGui.Add("Button", "x20 y270 w150 h30", "Launch Selected").OnEvent("Click", LaunchScript)
mainGui.Add("Button", "x180 y270 w150 h30", "Refresh List").OnEvent("Click", (*) => PopulateScripts())
mainGui.Add("Button", "x340 y270 w140 h30", "Open Scripts Folder").OnEvent("Click", (*) => Run(A_ScriptDir "\public"))

mainGui.Add("Text", "x20 y310", "Quick Actions:")
mainGui.Add("Button", "x20 y330 w220 h30", "Send DQ Action Message").OnEvent("Click", SendDQMessage)

; --------------------
; TAB 2: Settings
; --------------------
tab.UseTab(2)

; Browser settings
mainGui.Add("GroupBox", "x20 y40 w460 h90", "Browser Settings")
mainGui.Add("Text", "x30 y60", "Browser Title:")
mainGui.Add("Edit", "x150 y58 w200 vPartialBrowserTitle", partialBrowserTitle)
mainGui.Add("Text", "x30 y90", "Max Tab Switches:")
mainGui.Add("Edit", "x150 y88 w60 vMaxTabSwitches Number", maxTabSwitches)

; Report settings
mainGui.Add("GroupBox", "x20 y140 w460 h120", "Report Settings")
mainGui.Add("Text", "x30 y160", "Outpatient Tab Title:")
mainGui.Add("Edit", "x150 y158 w200 vOutpatientTabTitle", outpatientTabTitle)
mainGui.Add("Text", "x30 y190", "eReferral Tab Title:")
mainGui.Add("Edit", "x150 y188 w200 vEReferralTabTitle", eReferralTabTitle)
mainGui.Add("Checkbox", "x30 y220 vLegacySheet Checked" . legacySheet, "Legacy Sheet (no Attendance ID)")

; User settings
mainGui.Add("GroupBox", "x20 y270 w460 h80", "User Settings")
mainGui.Add("Text", "x30 y290", "Your Initials:")
mainGui.Add("Edit", "x150 y288 w100 vInitials", initials)
mainGui.Add("Text", "x270 y290", "Clipboard Distance:")
mainGui.Add("Edit", "x380 y288 w60 vClipboardDistance Number", clipboardDistance)

; Save button
mainGui.Add("Button", "x360 y360 w120 h30", "Save Settings").OnEvent("Click", SaveSettings)

; --------------------
; TAB 3: Info
; --------------------
tab.UseTab(3)

mainGui.Add("GroupBox", "x20 y40 w460", "About This Application")
mainGui.Add("Text", "x30 yp+20 w440",
    "Info here.`n" .
    "soon."
)

mainGui.Add("GroupBox", "x20 y+10 w460", "Features")
mainGui.Add("Text", "x30 yp+20 w440",
    "- bunch of text `n" .
    "- bunch of text `n" .
    "- bunch of text `n" .
    "- bunch of text `n" .
    "- more `n"
)

mainGui.Add("GroupBox", "x20 y+10 w460 h80", "Support")
mainGui.Add("Text", "x30 yp+20 w440", "For issues or questions, check the config.ini file`nin the script directory for configuration options.")


tab.UseTab() ; End tabs

; Show the GUI
mainGui.Show("w520 h440")

; --------------------
; Functions
; --------------------
PopulateScripts() {
    global scriptList
    scriptList := mainGui["ScriptList"]
    scriptList.Delete()
    
    if DirExist(A_ScriptDir "\public") {
        Loop Files, A_ScriptDir "\public\*.ahk" {
            scriptList.Add([A_LoopFileName])
        }
    } else {
        scriptList.Add(["No scripts found - create ./public/ folder"])
    }
}

LaunchScript(*) {
    scriptList := mainGui["ScriptList"]
    selectedIndex := scriptList.Value
    
    if (selectedIndex = 0) {
        MsgBox("Please select a script to launch!", "No Selection", "Icon!")
        return
    }
    
    ; Use .Text property to get selected item
    selectedScript := scriptList.Text
    scriptPath := A_ScriptDir "\public\" selectedScript
    
    if FileExist(scriptPath) {
        Run('"' A_AhkPath '" "' scriptPath '"')
        MsgBox("Launched: " selectedScript, "Script Started", "Iconi T1")
    } else {
        MsgBox("Script not found: " scriptPath, "Error", "Icon!")
    }
}

SendDQMessage(*) {
    Send("Actioned by DQ (Data Quality Team)")
    MsgBox("DQ message sent!", "Success", "Iconi T1")
}

SaveSettings(*) {
    ; Get values from GUI
    Saved := mainGui.Submit(false)
    
    ; Update global variables
    global partialBrowserTitle := Saved.PartialBrowserTitle
    global outpatientTabTitle := Saved.OutpatientTabTitle
    global eReferralTabTitle := Saved.EReferralTabTitle
    global maxTabSwitches := Saved.MaxTabSwitches
    global legacySheet := Saved.LegacySheet
    global initials := Saved.Initials
    global clipboardDistance := Saved.ClipboardDistance
    
    ; Save to INI file for persistence
    IniWrite(partialBrowserTitle, configPath, "Browser", "PartialBrowserTitle")
    IniWrite(outpatientTabTitle, configPath, "Reports", "OutpatientTabTitle")
    IniWrite(eReferralTabTitle, configPath, "Reports", "EReferralTabTitle")
    IniWrite(maxTabSwitches, configPath, "Browser", "MaxTabSwitches")
    IniWrite(legacySheet, configPath, "Reports", "LegacySheet")
    IniWrite(initials, configPath, "User", "Initials")
    IniWrite(clipboardDistance, configPath, "User", "ClipboardDistance")

    ToolTip("Settings saved!",,, 1,)
    SetTimer () => ToolTip(), -1000
}

; Load settings from INI on startup
LoadSettings() {
    global
    if FileExist(configPath) {
        partialBrowserTitle := IniRead(configPath, "Browser", "PartialBrowserTitle", partialBrowserTitle)
        outpatientTabTitle := IniRead(configPath, "Reports", "OutpatientTabTitle", outpatientTabTitle)
        eReferralTabTitle := IniRead(configPath, "Reports", "EReferralTabTitle", eReferralTabTitle)
        maxTabSwitches := IniRead(configPath, "Browser", "MaxTabSwitches", maxTabSwitches)
        legacySheet := IniRead(configPath, "Reports", "LegacySheet", legacySheet)
        initials := IniRead(configPath, "User", "Initials", initials)
        clipboardDistance := IniRead(configPath, "User", "ClipboardDistance", clipboardDistance)
    }
}

LoadSettings()