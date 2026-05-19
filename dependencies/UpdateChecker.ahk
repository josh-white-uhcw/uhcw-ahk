#Requires AutoHotkey v2.0
#SingleInstance Force

; --- Configuration ---
REPO_URL    := "https://github.com/Chariot-UHCW/AutoHotkey-Scripts.git"
RAW_VERSION := "https://raw.githubusercontent.com/Chariot-UHCW/AutoHotkey-Scripts/master/version"
LOCAL_VER_FILE := A_ScriptDir "\version"

; Assume not
global UpdateAvalible := False

; Run check on startup
CheckForUpdates()

CheckForUpdates() {
    try {
        ; 1. Get Remote Version
        http := ComObject("WinHttp.WinHttpRequest.5.1")
        http.Open("GET", RAW_VERSION, false)
        http.Send()
        
        if (http.Status != 200)
            return
            
        global remoteVer := Trim(http.ResponseText)
        localVer  := FileExist(LOCAL_VER_FILE) ? Trim(FileRead(LOCAL_VER_FILE)) : "0.0.0"

        ; 2. Robust Version Comparison
        if IsNewer(remoteVer, localVer) {
            global UpdateAvalible := True
            msg := MsgBox("New Update Found!`n`nLocal: " localVer "`nRemote: " remoteVer "`n`nUpdate now?", "Updater", 4)
            if (msg = "Yes") {
                DoUpdate()
            }
        }
    } catch Error as e {
        ; Silent fail if no internet/server down
    }
}

; Compares x.x.x version strings. Returns true if vRemote > vLocal
IsNewer(vRemote, vLocal) {
    r := StrSplit(vRemote, "."), l := StrSplit(vLocal, ".")
    loop Max(r.Length, l.Length) {
        rv := (A_Index <= r.Length) ? Integer(r[A_Index]) : 0
        lv := (A_Index <= l.Length) ? Integer(l[A_Index]) : 0
        if (rv > lv)
            return true
        if (rv < lv)
            return false
    }
    return false
}

DoUpdate() {
    if !DirExist(A_ScriptDir "\.git") {
        MsgBox "Error: This folder is not a Git repository. Cannot auto-update."
        return
    }

    ; The batch file handles the process hand-off
    ; 'git fetch' + 'git reset' ensures we match the repo exactly 
    ; without touching untracked files like .ini
    batchScript := 
    (
        "@echo off`n"
        "echo Updating to latest version...`n"
        "timeout /t 1 /nobreak > nul`n"
        "git fetch --all`n"
        "git reset --hard origin/master`n" 
        "start `"`" `"" A_ScriptFullPath "`"`n"
        "del `"%~f0`" & exit"
    )

    tempBatch := A_ScriptDir "\update_tmp.bat"
    if FileExist(tempBatch)
        FileDelete(tempBatch)
        
    FileAppend(batchScript, tempBatch)
    Run(tempBatch, , "Hide")
    ExitApp()
}
;MsgBox "Application Loaded. Running Version: " (FileExist(LOCAL_VER_FILE) ? FileRead(LOCAL_VER_FILE) : "Unknown")