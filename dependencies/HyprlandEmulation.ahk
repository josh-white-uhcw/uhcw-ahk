#Requires AutoHotkey v2.0

global lastPID := 0 ; dummy value for hyprland emulation on first run

; focuses window under cursor
while emulationHyprland {
    if GetKeyState("LButton", "P") {  ; continue if left click is inactive
        Sleep(10)
        continue
    }

    if A_TimeIdleMouse < 50 { ; 100ms inactivity check, for floating windows.
        Sleep(10)
        continue
    }

    MouseGetPos(, , &WindowID)
    currentPID := WinGetPID("ahk_id " WindowID) ; logging PID over ID helps not focus when context menus are opened

    if (lastPID = currentPID) {  ; continue if last focused PID = current PID under cursor
        Sleep(10)
        continue
    }

    ; conditions met:
    WinActivate("ahk_id " WindowID) ; focus new
    lastPID := currentPID ; log new PID for next loop

    Sleep(10)
}