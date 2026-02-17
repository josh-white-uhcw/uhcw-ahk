#Requires AutoHotkey v2.0
#Include ../ConfigLoader.ahk
#Include ../dependencies/_all.ahk

; --- Debugging ---
MsgBox("Script is running from: " . A_ScriptDir . "`n`nLooking for INI at: " . configFile . "`n`nFile exists: " . (FileExist(configFile) ? "YES" : "NO"))

if !FileExist(configFile) {
    MsgBox("INI not found! Opening script folder so you can check...")
    Run(A_ScriptDir)
    ExitApp()
}

; --- Read and display raw INI content ---
;rawContent := FileRead(configFile)
;MsgBox("INI file contents:`n`n" . rawContent)

; --- Try to read the value ---
;RevenueCycleKey := Trim(IniRead(configFile, "Hotkeys", "RevenueCycle", ""))

MsgBox("IniRead returned: '" . RevenueCycleKey . "'")

if (RevenueCycleKey != "") {
    Hotkey RevenueCycleKey, RevenueCycle
    MsgBox("Hotkey successfully bound to: " . RevenueCycleKey)
} else {
    MsgBox("Hotkey value was empty after reading!")
}

RevenueCycle(HotkeyName) {
    MsgBox("RevenueCycle triggered! Key: " . HotkeyName)
}