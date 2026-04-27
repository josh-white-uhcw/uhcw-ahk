REPO_URL := "https://github.com/Chariot-UHCW/AutoHotkey-Scripts.git"
RAW_VERSION := "https://raw.githubusercontent.com/Chariot-UHCW/AutoHotkey-Scripts/master/version"

CheckForUpdate()

CheckForUpdate() {
    ; Check local version
    if !FileExist(A_ScriptDir "\version") {
        MsgBox "Local version file not found.`nExpected: " "\version", "Update Checker", "Icon!"
        return
    }
    localVersion := Trim(FileRead(A_ScriptDir "\version"), " `t`r`n")

    ; Check remote version
    remoteVersion := FetchRemoteVersion(RAW_VERSION)
    if (remoteVersion = "") {
        MsgBox("Error - Cannot fetch remote - unable to update")
        return
    }

    ; Compare
    if (localVersion = remoteVersion) {
        return
    }

    ; Prompt update
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

    ; Create folder and get paths for updated script
    parentDir := GetParentDir(A_ScriptDir)
    newFolderName := "Chariot's AHK Scripts - " remoteVersion
    newFolderPath := parentDir "\" newFolderName

    ; Check if its already installed
    if DirExist(newFolderPath) {
        MsgBox(
            "Update already installed at:`n" newFolderPath "`n`n"
            "If you need to reinstall please delete that folder first and try again.",
            "Update Checker",
            "Icon!"
        )
        return
    }

    ; Clone repo
    gitCmd := 'git clone "' REPO_URL '" "' newFolderPath '"'
    RunWait A_ComSpec ' /c ' gitCmd, , "Hide"

    ; Check it installed
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

    ; Success message
    MsgBox(
        "Update cloned successfully!`n`n"
        "New folder:`n" newFolderPath "`n`n"
        "Please relaunch Masterv2.ahk from the new folder (version " remoteVersion ") and delete this old one (version " localVersion ").",
        "Update Complete",
        "Iconi"
    )
}

; I used ai for this part:
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

GetParentDir(path) {
    SplitPath path, , &parent
    return parent
}

GetFolderName(path) {
    SplitPath path, &name
    return name
}