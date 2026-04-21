REPO_URL := "https://github.com/Chariot-UHCW/AutoHotkey-Scripts.git"
RAW_VERSION := "https://raw.githubusercontent.com/Chariot-UHCW/AutoHotkey-Scripts/master/version"

CheckForUpdate()

CheckForUpdate() {
    ; --- 1. Read local version ------------------------------------
    localVersionFile := A_ScriptDir "\version"
    if !FileExist(localVersionFile) {
        MsgBox "Local version file not found.`nExpected: " localVersionFile, "Update Checker", "Icon!"
        return
    }
    localVersion := Trim(FileRead(localVersionFile), " `t`r`n")

    ; --- 2. Fetch remote version (with timeout) -------------------
    remoteVersion := FetchRemoteVersion(RAW_VERSION)
    if (remoteVersion = "") {
        MsgBox("Error - Cannot fetch remote - unable to update")
        return
    }

    ; --- 3. Compare -----------------------------------------------
    if (localVersion = remoteVersion) {
        ; Up to date — continue silently
        return
    }

    ; --- 4. Prompt ------------------------------------------------
    answer := MsgBox(
        "A new version is available!`n`n"
        "Current : " localVersion "`n"
        "Latest  : " remoteVersion "`n`n"
        "You can view the changelog at the repo page or in changelog.txt once installed.`n`n"
        "Clone the new version now?",
        "Update Available",
        "YesNo Icon?"
    )
    if (answer != "Yes")
        return

    ; --- 5. Work out sibling folder name and path -----------------
    ;  A_ScriptDir  = C:\...\autohotkeyscript
    ;  parentDir    = C:\...
    ;  newFolder    = autohotkeyscript-0.1.0   (uses REMOTE version)
    parentDir := GetParentDir(A_ScriptDir)
    newFolderName := "Chariot's AHK Scripts - " remoteVersion
    newFolderPath := parentDir "\" newFolderName

    ; --- 6. Check the target doesn't already exist ----------------
    if DirExist(newFolderPath) {
        MsgBox(
            "Update already installed at:`n" newFolderPath "`n`n"
            "If you need to reinstall please delete that folder first and try again.",
            "Update Checker",
            "Icon!"
        )
        return
    }

    ; --- 7. Git clone ---------------------------------------------
    gitCmd := 'git clone "' REPO_URL '" "' newFolderPath '"'
    RunWait A_ComSpec ' /c ' gitCmd, , "Hide"

    ; --- 8. Verify clone succeeded --------------------------------
    if !DirExist(newFolderPath) {
        MsgBox(
            "Clone failed. You probably don't have git installed. Please check:`n"
            "  • Git is installed and on your PATH`n"
            "  • You have internet access`n`n"
            "Repo: " REPO_URL,
            "Update Failed",
            "IconX"
        )
        return
    }

    ; --- 9. Notify user -------------------------------------------
    MsgBox(
        "Update cloned successfully!`n`n"
        "New folder:`n" newFolderPath "`n`n"
        "Please relaunch Masterv2.ahk from the new folder (version " remoteVersion ") and delete this old one (version " localVersion ").",
        "Update Complete",
        "Iconi"
    )
}

; ------------------------------------------------------------
;  Downloads the raw version file and returns the first line.
;  Returns "" on any failure so startup is never blocked.
; ------------------------------------------------------------
FetchRemoteVersion(url) {
    try {
        http := ComObject("WinHttp.WinHttpRequest.5.1")
        http.Open("GET", url, false)
        http.SetTimeouts(3000, 3000, 3000, 5000)   ; resolve / connect / send / receive (ms)
        http.Send()
        if (http.Status = 200) {
            ; Grab only the first line in case of trailing newlines
            raw := StrSplit(http.ResponseText, "`n")[1]
            return Trim(raw, " `t`r`n")
        }
    }
    ; Network error, timeout, etc. — fail silently
    return ""
}

; ------------------------------------------------------------
;  Returns the parent directory of a given path.
;  e.g.  C:\Scripts\myfolder  →  C:\Scripts
; ------------------------------------------------------------
GetParentDir(path) {
    SplitPath path, , &parent
    return parent
}

; ------------------------------------------------------------
;  Returns just the final folder name from a full path.
;  e.g.  C:\Scripts\myfolder  →  myfolder
; ------------------------------------------------------------
GetFolderName(path) {
    SplitPath path, &name
    return name
}