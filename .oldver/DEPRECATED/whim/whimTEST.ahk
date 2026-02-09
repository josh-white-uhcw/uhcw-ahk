#Requires AutoHotkey v2.0

; DLL calls for window parenting
SetParent := DllCall.Bind("SetParent", "Ptr", , "Ptr", , "Ptr")
SetWindowLong := DllCall.Bind("SetWindowLong", "Ptr", , "Int", , "Int", , "Int")
GetWindowLong := DllCall.Bind("GetWindowLong", "Ptr", , "Int", , "Int")

; Window style constants
GWL_STYLE := -16
WS_CHILD := 0x40000000
WS_POPUP := 0x80000000

; Configuration
CONTAINER_X := 100
CONTAINER_Y := 100
CONTAINER_WIDTH := 1200
CONTAINER_HEIGHT := 800

containers := Map()

; Monitor for new Citrix windows
SetTimer(CheckForCitrixWindows, 500)

CheckForCitrixWindows() {
    windows := WinGetList("ahk_class Transparent Windows Client ahk_exe wfica32.exe")
    
    for hwnd in windows {
        ; Skip if we've already containerized this window
        if containers.Has(hwnd)
            continue
            
        ; Skip if window doesn't exist or is being destroyed
        if !WinExist("ahk_id " hwnd)
            continue
            
        ; Create container for this Citrix window
        CreateContainer(hwnd)
    }
}

CreateContainer(citrixHwnd) {
    try {
        ; Get the Citrix window title
        citrixTitle := WinGetTitle("ahk_id " citrixHwnd)
        
        ; Create a container GUI
        container := Gui("+Resize +MinSize800x600", citrixTitle " (Container)")
        container.Show("x" CONTAINER_X " y" CONTAINER_Y " w" CONTAINER_WIDTH " h" CONTAINER_HEIGHT)
        
        ; Get container window handle
        containerHwnd := container.Hwnd
        
        ; Wait a moment for container to be ready
        Sleep(100)
        
        ; Change Citrix window to child style
        style := GetWindowLong(citrixHwnd, GWL_STYLE)
        style := style & ~WS_POPUP  ; Remove popup style
        style := style | WS_CHILD    ; Add child style
        SetWindowLong(citrixHwnd, GWL_STYLE, style)
        
        ; Parent the Citrix window to the container
        SetParent(citrixHwnd, containerHwnd)
        
        ; Position and size the Citrix window to fill the container
        WinMove(0, 0, CONTAINER_WIDTH, CONTAINER_HEIGHT, "ahk_id " citrixHwnd)
        
        ; Store references
        container.CitrixHwnd := citrixHwnd
        container.OnEvent("Size", ResizeCitrixWindow)
        container.OnEvent("Close", (*) => CleanupContainer(citrixHwnd))
        
        containers[citrixHwnd] := container
        
    } catch as err {
        MsgBox("Error creating container: " err.Message)
    }
}

ResizeCitrixWindow(guiObj, MinMax, Width, Height) {
    ; Resize the embedded Citrix window when container is resized
    try {
        if guiObj.HasProp("CitrixHwnd") && WinExist("ahk_id " guiObj.CitrixHwnd) {
            WinMove(0, 0, Width, Height, "ahk_id " guiObj.CitrixHwnd)
        }
    }
}

CleanupContainer(citrixHwnd) {
    ; When container closes, restore the Citrix window or close it
    if containers.Has(citrixHwnd) {
        container := containers[citrixHwnd]
        containers.Delete(citrixHwnd)
        
        ; Optional: restore window or just let it close with container
        try {
            if WinExist("ahk_id " citrixHwnd) {
                ; Restore original window style
                style := GetWindowLong(citrixHwnd, GWL_STYLE)
                style := style & ~WS_CHILD
                style := style | WS_POPUP
                SetWindowLong(citrixHwnd, GWL_STYLE, style)
                SetParent(citrixHwnd, 0)  ; Unparent
            }
        }
        
        container.Destroy()
    }
}

; Clean up containers for closed Citrix windows
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

; Hotkey to manually refresh containers
^!r:: {
    MsgBox("Refreshing containers...")
    CheckForCitrixWindows()
}

; Exit script
^!x:: ExitApp()