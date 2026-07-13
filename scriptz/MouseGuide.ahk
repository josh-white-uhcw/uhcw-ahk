#Requires AutoHotkey v2.0

ImagePath := "../images/MouseGuide/MouseGuideRed.png"
MaxW := 12 ; keep a 1.5 ratio
MaxH := 18
Opacity := 255  ; 1 - 255

CoordMode "Mouse", "Screen"

Overlay := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +E0x8000000")
Overlay.MarginX := 0
Overlay.MarginY := 0

try {
    Pic := Overlay.Add("Picture", "w" MaxW " h" MaxH " +Limit", ImagePath)
} catch {
    MsgBox("Image file not found!")
    ExitApp
}

Overlay.BackColor := "Black"
WinSetTransColor("Black " Opacity, Overlay)

Overlay.Show("NoActivate")

SetTimer(FollowMouse, 5)

FollowMouse() {
    MouseGetPos(&x, &y)

    ; Move the overlay
    Overlay.Move(x, y)

    DllCall("SetWindowPos", "Ptr", Overlay.Hwnd, "Ptr", -1, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x0003 | 0x0010)
}