#Requires AutoHotkey v2.0

; Configuration
TARGET_WINDOW_TITLE := "Revenue Cycle"  ; Change this to your target window title
PARENT_WIDTH := 800
PARENT_HEIGHT := 600

; Global variables
global targetHwnd := 0
global parentGui := ""

; Create the parent window
CreateParentWindow()

; Start monitoring for the target window
SetTimer(CheckAndEmbedWindow, 500)

return

CreateParentWindow() {
    global parentGui
    
    parentGui := Gui("+Resize", "Window Container")
    parentGui.OnEvent("Size", OnParentResize)
    parentGui.OnEvent("Close", (*) => ExitApp())
    parentGui.Show("w" PARENT_WIDTH " h" PARENT_HEIGHT)
}

CheckAndEmbedWindow() {
    global targetHwnd, TARGET_WINDOW_TITLE
    
    ; If already embedded, just ensure sizing
    if (targetHwnd != 0 && WinExist("ahk_id " targetHwnd)) {
        ResizeEmbeddedWindow()
        return
    }
    
    ; Look for the target window
    if (WinExist(TARGET_WINDOW_TITLE)) {
        targetHwnd := WinGetID(TARGET_WINDOW_TITLE)
        EmbedWindow(targetHwnd)
    }
}

EmbedWindow(hwnd) {
    global parentGui
    
    ; Get parent window handle
    parentHwnd := parentGui.Hwnd
    
    ; Remove window styles that would interfere with embedding
    WS_CAPTION := 0x00C00000
    WS_THICKFRAME := 0x00040000
    WS_CHILD := 0x40000000
    
    currentStyle := DllCall("GetWindowLong", "Ptr", hwnd, "Int", -16, "UInt")
    
    ; Remove caption and thick frame, add child style
    newStyle := (currentStyle & ~(WS_CAPTION | WS_THICKFRAME)) | WS_CHILD
    
    DllCall("SetWindowLong", "Ptr", hwnd, "Int", -16, "UInt", newStyle)
    
    ; Set the parent
    DllCall("SetParent", "Ptr", hwnd, "Ptr", parentHwnd)
    
    ; Force resize to match parent
    ResizeEmbeddedWindow()
    
    ; Show the window
    WinShow("ahk_id " hwnd)
}

ResizeEmbeddedWindow() {
    global targetHwnd, parentGui
    
    if (targetHwnd == 0 || !WinExist("ahk_id " targetHwnd))
        return
    
    ; Get parent client area
    parentGui.GetPos(,, &width, &height)
    
    ; Resize and reposition the embedded window to fill parent
    DllCall("SetWindowPos", 
        "Ptr", targetHwnd,
        "Ptr", 0,
        "Int", 0,
        "Int", 0,
        "Int", width,
        "Int", height,
        "UInt", 0x0040)  ; SWP_SHOWWINDOW
}

OnParentResize(GuiObj, MinMax, Width, Height) {
    ; Force embedded window to resize when parent resizes
    ResizeEmbeddedWindow()
}