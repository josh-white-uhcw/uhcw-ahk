Log(message, status := 0) {
    if !SaveLogs
        return

    ; Allows Root files and script files to log to the correct location

    if DirExist(A_ScriptDir "\..\logs")
        LogFile := A_ScriptDir "\..\logs\" FormatTime(A_Now, "yyyy-MM-dd") ".txt"
    else if DirExist(A_ScriptDir "\logs")
        LogFile := A_ScriptDir "\logs\" FormatTime(A_Now, "yyyy-MM-dd") ".txt"
    else {
        ErrorMsg("No Log folder found!")
        return
    }

    if status = 1 ; START
        statusText := "⏳"
    else if status = 2 ; LOG
        statusText := "📝"
    else if status = 3 ; STOP/ERROR
        statusText := "🚫"
    else if status = 4 ; COMPLETE
        statusText := "✅"
    else ; INFORMATION
        statusText := "❕"

    logLine := "[" . FormatTime(A_Now, "HH:mm:ss") "." A_MSec "] " statusText . " " . message . "`n"

    mutexName := "Global\AHK_LogMutex_" . StrReplace(LogFile, "\", "_")
    hMutex := DllCall("CreateMutex", "Ptr", 0, "Int", 0, "Str", mutexName, "Ptr")
    DllCall("WaitForSingleObject", "Ptr", hMutex, "UInt", 5000)

    try {
        maxRetries := 5
        loop maxRetries {
            try {
                FileAppend(logLine, LogFile, "UTF-8-RAW")
                break  ; success, stop retrying
            } catch OSError as e {
                if e.number = 32 && A_Index < maxRetries
                    Sleep(50)  ; wait 50ms then retry
                else
                    throw  ; give up after maxRetries, or re-throw non-32 errors
            }
        }
    } finally {
        DllCall("ReleaseMutex", "Ptr", hMutex)
        DllCall("CloseHandle", "Ptr", hMutex)
    }
}

MRNLog() {
    ; will copy all clipboard text to a file.
}

ErrorMsg(message) {
    if !ShowErrors
        return

    MsgBox("🚫 Error: " . message)
}