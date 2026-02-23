#Requires AutoHotkey v2.0

; DLL calls
SetParent := DllCall.Bind("SetParent", "Ptr", , "Ptr", , "Ptr")
SetWindowLong := DllCall.Bind("SetWindowLong", "Ptr", , "Int", , "Int", , "Int")
GetWindowLong := DllCall.Bind("GetWindowLong", "Ptr", , "Int", , "Int")

; Window style constants
GWL_STYLE := -16
GWL_EXSTYLE := -20
WS_CHILD := 0x40000000
WS_POPUP := 0x80000000
WS_VISIBLE := 0x10000000
WS_CLIPSIBLINGS := 0x04000000
WS_CLIPCHILDREN := 0x02000000

; Configuration
CONTAINER_X := 100
CONTAINER_Y := 100
CONTAINER_WIDTH := 1200
CONTAINER_HEIGHT := 800

containers := Map()

SetTimer(CheckForCitrixWindows, 500)

CheckForCitrixWindows() {
    windows := WinGetList("ahk_class Transparent Windows Client ahk_exe wfica32.exe")
    
    for hwnd in windows {
        if containers.Has(hwnd)
            continue
            
        if !WinExist("ahk_id " hwnd)
            continue
            
        CreateContainer(hwnd)
    }
}

CreateContainer(citrixHwnd) {
    try {
        citrixTitle := WinGetTitle("ahk_id " citrixHwnd)
        
        ; Create container - key is using +E0x02000000 for WS_CLIPCHILDREN
        container := Gui("+Resize +MinSize800x600 +E0x02000000", citrixTitle " (Container)")
        container.MarginX := 0
        container.MarginY := 0
        container.Show("x" CONTAINER_X " y" CONTAINER_Y " w" CONTAINER_WIDTH " h" CONTAINER_HEIGHT)
        
        containerHwnd := container.Hwnd
        
        Sleep(100)
        
        ; Change Citrix window style
        style := GetWindowLong(citrixHwnd, GWL_STYLE)
        style := style & ~WS_POPUP
        style := style | WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS
        SetWindowLong(citrixHwnd, GWL_STYLE, style)
        
        ; Parent the Citrix window
        SetParent(citrixHwnd, containerHwnd)
        
        ; Position and size
        WinMove(0, 0, CONTAINER_WIDTH, CONTAINER_HEIGHT, "ahk_id " citrixHwnd)
        
        ; Bring to front and set focus
        WinActivate("ahk_id " citrixHwnd)
        
        ; Store references
        container.CitrixHwnd := citrixHwnd
        container.OnEvent("Size", ResizeCitrixWindow)
        container.OnEvent("Close", (*) => CleanupContainer(citrixHwnd))
        
        ; Add custom message handler for focus
        OnMessage(0x0021, WM_MOUSEACTIVATE)  ; WM_MOUSEACTIVATE
        
        containers[citrixHwnd] := container
        
    } catch as err {
        MsgBox("Error creating container: " err.Message)
    }
}

; Forward mouse activation to child window
WM_MOUSEACTIVATE(wParam, lParam, msg, hwnd) {
    for citrixHwnd, container in containers {
        if container.Hwnd = hwnd {
            ; Activate the child Citrix window
            WinActivate("ahk_id " citrixHwnd)
            return 1  ; MA_ACTIVATE
        }
    }
}

ResizeCitrixWindow(guiObj, MinMax, Width, Height) {
    try {
        if guiObj.HasProp("CitrixHwnd") && WinExist("ahk_id " guiObj.CitrixHwnd) {
            citrixHwnd := guiObj.CitrixHwnd
            
            ; Simply resize - let Citrix handle its own content
            WinMove(0, 0, Width, Height, "ahk_id " citrixHwnd)
            
            ; Give it a moment then force focus
            SetTimer(() => WinActivate("ahk_id " citrixHwnd), -50)
        }
    }
}

CleanupContainer(citrixHwnd) {
    if containers.Has(citrixHwnd) {
        container := containers[citrixHwnd]
        containers.Delete(citrixHwnd)
        
        try {
            if WinExist("ahk_id " citrixHwnd) {
                style := GetWindowLong(citrixHwnd, GWL_STYLE)
                style := style & ~WS_CHILD
                style := style | WS_POPUP
                SetWindowLong(citrixHwnd, GWL_STYLE, style)
                SetParent(citrixHwnd, 0)
            }
        }
        
        container.Destroy()
    }
}

SetTimer(CleanupClosedWindows, 2000)

CleanupClosedWindows() {
    for citrixHwnd in containers {
        if !WinExist("ahk_id " citrixHwnd) {
            container := containers[citrixHwnd]
            containers.Delete(citrixHwnd)
            container.Destroy()
        }
    }
}

^!r:: {
    MsgBox("Refreshing containers...")
    CheckForCitrixWindows()
}

^!x:: ExitApp()