#Requires AutoHotkey v2.0
#SingleInstance Force

; Configuration
WINDOW_TITLE := "Revenue Cycle"  ; Change this to match your Cerner window title
PARENT_TITLE := "Cerner Container"
CHECK_INTERVAL := 1000  ; Check every 1 second

; Create the parent container window
CreateParentWindow()

; Set up a timer to check for Cerner windows
SetTimer(CheckForWindows, CHECK_INTERVAL)

; Keep script running
return

CreateParentWindow() {
    global hParent
    
    ; Create a simple GUI to act as the parent window
    ParentGui := Gui("+Resize", PARENT_TITLE)
    ParentGui.BackColor := "0x2b2b2b"
    ParentGui.Show("w1200 h800")
    
    ; Store the parent window handle
    hParent := ParentGui.Hwnd
    
    ; Handle parent window closing
    ParentGui.OnEvent("Close", (*) => ExitApp())
}

CheckForWindows(*) {
    global hParent, WINDOW_TITLE
    
    ; Find all windows matching the title
    try {
        windows := WinGetList("ahk_exe wfica32.exe")  ; Citrix Receiver/Workspace executable
        
        for hwnd in windows {
            title := WinGetTitle("ahk_id " hwnd)
            
            ; Check if window title contains our target text and isn't already embedded
            if (InStr(title, WINDOW_TITLE) && !IsEmbedded(hwnd)) {
                EmbedWindow(hwnd)
            }
        }
    }
}

IsEmbedded(hwnd) {
    global hParent
    ; Check if the window is already a child of our parent
    parent := DllCall("GetParent", "Ptr", hwnd, "Ptr")
    return (parent = hParent)
}

EmbedWindow(hwnd) {
    global hParent
    
    ; Remove window styles that prevent embedding
    style := DllCall("GetWindowLong", "Ptr", hwnd, "Int", -16, "Int")  ; GWL_STYLE
    style &= ~0x00C00000  ; Remove WS_CAPTION
    style &= ~0x00040000  ; Remove WS_SIZEBOX
    DllCall("SetWindowLong", "Ptr", hwnd, "Int", -16, "Int", style)
    
    ; Set the parent window
    DllCall("SetParent", "Ptr", hwnd, "Ptr", hParent, "Ptr")
    
    ; Position the embedded window
    DllCall("SetWindowPos", 
        "Ptr", hwnd,
        "Ptr", 0,
        "Int", 0,
        "Int", 0,
        "Int", 1200,
        "Int", 800,
        "UInt", 0x0040)  ; SWP_SHOWWINDOW
    
    ToolTip("Embedded window: " WinGetTitle("ahk_id " hwnd))
    SetTimer(() => ToolTip(), -2000)
}

; Hotkey to manually refresh/check for windows (Ctrl+Alt+R)
^!r:: {
    CheckForWindows()
}

; Hotkey to exit script (Ctrl+Alt+Q)
^!q:: {
    ExitApp()
}