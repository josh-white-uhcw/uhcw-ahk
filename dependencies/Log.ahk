; ============================================================
;  LOG WINDOW  -  call Log(message, status) anywhere
;  Status codes: 1=pending  2=info  3=error  4=success
; ============================================================

LogGui := ""
LogEdit := ""
LogLineCount := 0


Log(message, status) {
    global LogGui, LogEdit, LogLineCount

    if ShowLogs != true
        return

    ; --- pick emoji and label for each status ---
    if status = 1
        tag := "⏳ WAIT "
    else if status = 2
        tag := "  •  INFO "
    else if status = 3
        tag := "✗ FAIL "
    else if status = 4
        tag := "✓  OK  "
    else {
        MsgBox("Log() called with unknown status: " . status)
        return
    }

    ; --- build the log line ---
    timestamp := FormatTime(, "HH:mm:ss")
    line := "[" . timestamp . "]  " . tag . "  " . message

    ; --- create the window on first call ---
    if !IsObject(LogGui) {
        LogGui := Gui("+Resize +AlwaysOnTop", "Log")
        LogGui.BackColor := "1e1e1e"
        LogGui.MarginX := 0
        LogGui.MarginY := 0

        LogGui.SetFont("s9", "Consolas")

        ; multi-line read-only edit box fills the whole window
        LogEdit := LogGui.Add("Edit",
            "vLogOutput " .
            "x0 y0 w600 h400 " .
            "ReadOnly -E0x200 " .     ; no sunken border
            "Background1e1e1e " .
            "cE0E0E0 " .
            "+Multi +HScroll +VScroll")

        ; resize edit box when window is resized
        LogGui.OnEvent("Size", LogResize)
        LogGui.OnEvent("Close", LogClose)

        LogGui.Show("w600 h400 x" (A_ScreenWidth - 630) " y30 NoActivate")
    }

    ; --- append line (Edit controls use `r`n) ---
    current := LogEdit.Value
    LogEdit.Value := (current = "" ? "" : current . "`r`n") . line
    LogLineCount++

    ; --- scroll to bottom ---
    SendMessage(0x115, 7, 0, LogEdit.Hwnd)   ; WM_VSCROLL  SB_BOTTOM
}


; --- keep the edit box filling the window on resize ---
LogResize(guiObj, minMax, width, height) {
    global LogEdit
    LogEdit.Move(0, 0, width, height)
}


; --- hide instead of destroy so logs are not lost ---
LogClose(guiObj) {
    guiObj.Hide()
}

; status: ⏳start, ➖process/normal/continue, 🚫error/stop, ✅done/success,
; logs should be shown in the top right, once bottom of page is hit reset to the top


; old code to add at some point

;tooltipIndex := 0

;AddTooltip(text) {
;    global tooltipIndex
;    tooltipIndex := Mod(tooltipIndex, 20) + 1
;    ToolTip(text, A_ScreenWidth - 200, (tooltipIndex - 1) * 30, tooltipIndex)
;}
