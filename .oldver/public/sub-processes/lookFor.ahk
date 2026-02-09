#Requires AutoHotkey v2.0

lookFor(imageName, clickCoordsX, clickCoordsY) {
    imagePath := A_ScriptDir "\..\images\" imageName ".png"
    If ImageSearch(&x, &y, 0, 0, A_ScreenWidth, 1920, imagePath) {
        
        Click(x + clickCoordsX, y + clickCoordsY)  ; Click specified
    }
    else {
        MsgBox("Could not find image")
        return
    }
}