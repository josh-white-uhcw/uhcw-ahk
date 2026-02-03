#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; GLOBAL VARIABLES
; ============================================================================
global partialBrowserTitle, outpatientTabTitle, eReferralTabTitle
global maxTabSwitches, legacySheet, initials, clipboardDistance
global configPath := A_ScriptDir "\config.ini"

; ============================================================================
; INITIALIZATION
; ============================================================================
LoadSettings()
CreateMainGUI()

; ============================================================================
; GUI CREATION
; ============================================================================
CreateMainGUI() {
    global mainGui := Gui()
    mainGui.Title := "Master Script Runner"
    mainGui.OnEvent("Close", (*) => ExitApp())
    
    ; Create tabs
    tab := mainGui.Add("Tab3", "x10 y10 w500 h800", ["Scripts", "Settings", "Info"])
    
    CreateScriptsTab(tab)
    CreateSettingsTab(tab)
    CreateInfoTab(tab)
    
    tab.UseTab()
    mainGui.Show("w520 h840")
}

; ============================================================================
; TAB 1: SCRIPTS
; ============================================================================
CreateScriptsTab(tab) {
    tab.UseTab(1)
    
    mainGui.Add("Text", "x20 y40 w460", "Available Scripts:")
    
    global scriptList := mainGui.Add("ListBox", "x20 y+5 w460 h200 vScriptList")
    PopulateScripts()
    
    mainGui.Add("Button", "x20 y+10 w150 h30", "Launch Selected").OnEvent("Click", LaunchScript)
    mainGui.Add("Button", "x+10 yp w150 h30", "Refresh List").OnEvent("Click", (*) => PopulateScripts())
    mainGui.Add("Button", "x+10 yp w140 h30", "Open Scripts Folder").OnEvent("Click", (*) => Run(A_ScriptDir "\public"))
    
    mainGui.Add("Text", "x20 y+10", "Quick Actions:")
    mainGui.Add("Button", "x20 y+5 w220 h30", "Send DQ Action Message").OnEvent("Click", SendDQMessage)
}

; ============================================================================
; TAB 2: SETTINGS
; ============================================================================
CreateSettingsTab(tab) {
    tab.UseTab(2)
    
    ; Browser Settings
    CreateGroupBoxWithControls("Browser Settings", 20, 40, 460, [
        {type: "Text", opts: "x30 yp+20", text: "Browser Title:"},
        {type: "Edit", opts: "x+10 yp w200 vPartialBrowserTitle", text: partialBrowserTitle},
        {type: "Text", opts: "x30 y+10", text: "Max Tab Switches:"},
        {type: "Edit", opts: "x+10 yp w60 vMaxTabSwitches Number", text: maxTabSwitches}
    ])
    
    ; Report Settings
    CreateGroupBoxWithControls("Report Settings", 20, "", 460, [
        {type: "Text", opts: "x30 yp+20", text: "Outpatient Tab Title:"},
        {type: "Edit", opts: "x+10 yp w200 vOutpatientTabTitle", text: outpatientTabTitle},
        {type: "Text", opts: "x30 y+10", text: "eReferral Tab Title:"},
        {type: "Edit", opts: "x+10 yp w200 vEReferralTabTitle", text: eReferralTabTitle},
        {type: "Checkbox", opts: "x30 y+10 vLegacySheet Checked" . legacySheet, text: "Legacy Sheet (no Attendance ID)"}
    ])
    
    ; User Settings
    CreateGroupBoxWithControls("User Settings", 20, "", 460, [
        {type: "Text", opts: "x30 yp+20", text: "Your Initials:"},
        {type: "Edit", opts: "x+10 yp w100 vInitials", text: initials},
        {type: "Text", opts: "x+10 yp", text: "Clipboard Distance:"},
        {type: "Edit", opts: "x+10 yp w60 vClipboardDistance Number", text: clipboardDistance}
        ,{type: "Checkbox", opts: "x30 y+10 vEmulationHyprland Checked" . EmulationHyprland, text: "Enable Hyprland Emulation Mode"}
    ])

    mainGui.Add("Button", "x360 y+30 w120 h30", "Save Settings").OnEvent("Click", SaveSettings)
}

; ============================================================================
; TAB 3: INFO
; ============================================================================
CreateInfoTab(tab) {
    tab.UseTab(3)
    
    CreateAutoSizedGroupBox("Info", 20, 40, 460,
        "This gui SUCKED to edit.`n" .
        "Sorry for its bad formatting."
    )
    
    CreateAutoSizedGroupBox("Prereqs / Notes", 20, "", 460,
        "- turn numlock on `n" .
        "- note the kill command at the bottom to close instantly `n" . 
        "- appointment book searching in OP is weird right now, dont use `n"
        "- enter a MRN once manually on each app before using the script, as the apps are slow on first search which can make the script act weird `n" . 
        "- change the variables on the settings tab `n" .
        "- try refrain from using multiple scripts, some override each other `n" .
        "- both clippy scripts are placed weirdly, will allow more customisation soon `n" .
        "- --- Most importantly ---- be careful, chances are this code will do something unexpected to you, so sorry in advance for lack of documentation."
    )
    
    CreateAutoSizedGroupBox("Keys", 20, "", 460,
        "Master Workflow Script (global) `n"
        "- ` (backtick) - Kill script(s) immediately `n"
        "- ` (backtick) + Shift - Send DQ signature `n"
        "`n"

        "Clippy `n"
        "- F1-F9 - Paste from clipboard slots 1-9 `n"
        "- F10 - Clear all clipboard slots and tooltips `n"
        "- STATIONARY will use the values put in settings (when i add it soon) `n"
        "- ADAPT will override the next slot each time you copy, allowing storage of the 9 most recent clipboard snippets `n"
        "`n"

        "Outpatients `n"
        "- Numpad0 - Grabs next MRN `n"
        "- Numpad1 - Powerchart Documentation `n"
        "- Numpad2 - Revenue Cycle Summary `n"
        "- Numpad3 - Appointment book list (broken rn) `n"
        "- CTRL + Numpad1 - From the MRN column will enter 'No Documentation', name, and date `n"
        "- CTRL + Numpad2 - Same as above, but enters 'Checked Out' `n"
        "- CTRL + Numpad3 - Same as above, but enters 'Already Checked Out' `n"
        "- CTRL + Numpad4 - Same as above, but enters 'DNA' `n"
        "- CTRL + Numpad5 - Same as above, but enters 'DNA No Doc' `n"
        "- CTRL + Numpad6 - Same as above, but enters 'Checkout No Doc' `n"
        "`n"

        "ERS `n"
        "This script is in beta, so you should not use it right now.`n"

    )
}

; ============================================================================
; HELPER FUNCTIONS
; ============================================================================

; Creates a GroupBox with controls and auto-adjusts height
CreateGroupBoxWithControls(title, x, y, width, controls) {
    yPos := (y = "") ? "y+40" : "y" y
    gb := mainGui.Add("GroupBox", "x" x " " yPos " w" width, title)
    
    lastControl := ""
    for ctrl in controls {
        lastControl := mainGui.Add(ctrl.type, ctrl.opts, ctrl.text)
    }
    
    if (lastControl != "") {
        AutoSizeGroupBox(gb, lastControl)
    }
}

; Creates a GroupBox with text content and auto-adjusts height
CreateAutoSizedGroupBox(title, x, y, width, content) {
    yPos := (y = "") ? "y+40" : "y" y
    gb := mainGui.Add("GroupBox", "x" x " " yPos " w" width, title)
    txtControl := mainGui.Add("Text", "x" (x+10) " yp+20 w" (width-20), content)
    
    txtControl.GetPos(,, &w, &h)
    gb.Move(,, width, h + 30)
}

; Auto-sizes a GroupBox to fit its last control
AutoSizeGroupBox(groupBox, lastControl) {
    groupBox.GetPos(, &gby,,)
    lastControl.GetPos(, &lcty,, &lcth)
    groupBox.Move(,, , lcty + lcth - gby + 15)
}

; ============================================================================
; SCRIPT MANAGEMENT FUNCTIONS
; ============================================================================

PopulateScripts() {
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
    selectedIndex := scriptList.Value
    
    if (selectedIndex = 0) {
        MsgBox("Please select a script to launch!", "No Selection", "Icon!")
        return
    }
    
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

; ============================================================================
; SETTINGS MANAGEMENT
; ============================================================================

SaveSettings(*) {
    Saved := mainGui.Submit(false)
    
    ; Update global variables
    global partialBrowserTitle := Saved.PartialBrowserTitle
    global outpatientTabTitle := Saved.OutpatientTabTitle
    global eReferralTabTitle := Saved.EReferralTabTitle
    global maxTabSwitches := Saved.MaxTabSwitches
    global legacySheet := Saved.LegacySheet
    global initials := Saved.Initials
    global clipboardDistance := Saved.ClipboardDistance
    global EmulationHyprland := Saved.EmulationHyprland

    
    ; Save to INI file
    IniWrite(partialBrowserTitle, configPath, "Browser", "PartialBrowserTitle")
    IniWrite(outpatientTabTitle, configPath, "Reports", "OutpatientTabTitle")
    IniWrite(eReferralTabTitle, configPath, "Reports", "EReferralTabTitle")
    IniWrite(maxTabSwitches, configPath, "Browser", "MaxTabSwitches")
    IniWrite(legacySheet, configPath, "Reports", "LegacySheet")
    IniWrite(initials, configPath, "User", "Initials")
    IniWrite(clipboardDistance, configPath, "User", "ClipboardDistance")
    IniWrite(EmulationHyprland, configPath, "User", "EmulationHyprland")
    
    ToolTip("Settings saved!",,, 1)
    SetTimer(() => ToolTip(), -1000)
}

LoadSettings() {
    if !FileExist(configPath) {
        SetDefaultSettings()
        return
    }
    
    global partialBrowserTitle := IniRead(configPath, "Browser", "PartialBrowserTitle", "edge")
    global outpatientTabTitle := IniRead(configPath, "Reports", "OutpatientTabTitle", "new report")
    global eReferralTabTitle := IniRead(configPath, "Reports", "EReferralTabTitle", "e-re")
    global maxTabSwitches := IniRead(configPath, "Browser", "MaxTabSwitches", "10")
    global legacySheet := IniRead(configPath, "Reports", "LegacySheet", "0")
    global initials := IniRead(configPath, "User", "Initials", "DEFAULT NAME")
    global clipboardDistance := IniRead(configPath, "User", "ClipboardDistance", "10")
    global EmulationHyprland := IniRead(configPath, "User", "EmulationHyprland", "0")
}

SetDefaultSettings() {
    global partialBrowserTitle := "edge"
    global outpatientTabTitle := "new report"
    global eReferralTabTitle := "e-re"
    global maxTabSwitches := "10"
    global legacySheet := "0"
    global initials := "DEFAULT NAME"
    global clipboardDistance := "10"
    global EmulationHyprland := "0"
}
