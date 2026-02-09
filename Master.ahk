#Requires AutoHotkey v2.0
#SingleInstance Force

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

; Mark the GroupBox as a Section reference point
myGui.Add("GroupBox", "x20 y40 w200 h100 Section", "Settings")

; xs/ys refer to the Section start, with offsets
myGui.Add("Text", "xs+10 ys+30", "First item")
myGui.Add("Edit", "xs+10 yp+50 w180")  ; yp = y previous
myGui.Add("Checkbox", "xp yp+50", "Enable feature")


; Places the following elements in tab 3 (Config)
Tab.UseTab(3)

MyGui.Add("Text", , "Initials:")
ConfInitials := MyGui.Add("Edit", "w200")
ConfLegacySheet := MyGui.Add("Checkbox", "", "Legacy Sheet (No Attendance ID Column)")
ConfEmulationHyprland := MyGui.Add("Checkbox", "", "Hyprland Mouse Focus Emulation")
; use ahk 'edit' gui thing for clipboards!

SaveBtn := MyGui.Add("Button", "", "Save Settings")
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
    ToolTip("test")
    SetTimer () => ToolTip(), -1000 ; make tooltip last 1 second
}

LoadCurrentSettings() {
    configFile := A_ScriptDir "\config.ini"

    ConfInitials.Value := IniRead(configFile, "Settings", "initials", "")
    ConfLegacySheet.Value := (IniRead(configFile, "Settings", "LegacySheet", "false") = "true") ? 1 : 0
    ConfEmulationHyprland.Value := (IniRead(configFile, "Settings", "EmulationHyprland", "false") = "true") ? 1 : 0
}

SaveSettings(*) {
    configFile := A_ScriptDir "\config.ini"

    IniWrite(ConfInitials.Value, configFile, "Settings", "initials")
    IniWrite(ConfLegacySheet.Value ? "true" : "false", configFile, "Settings", "LegacySheet")
    IniWrite(ConfEmulationHyprland.Value ? "true" : "false", configFile, "Settings", "EmulationHyprland")

    ToolTip("Settings saved!")
    SetTimer () => ToolTip(), -1000 ; make tooltip last 1 second
}