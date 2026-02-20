FindImage(imageName, clickCoordsX := 0, clickCoordsY := 0) { ; clickCoords are optional.
    imagePath := A_ScriptDir "\..\images\" imageName ".png"
    If ImageSearch(&x, &y, 0, 0, A_ScreenWidth, 1920, imagePath) { ; searches the entire screen
        Click(x + clickCoordsX, y + clickCoordsY)  ; Click with specified offset if the image found
        return true
    }
    else {
        MsgBox("Could not find image")
        return false
    }
}