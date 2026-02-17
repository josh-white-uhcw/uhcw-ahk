#Requires AutoHotkey v2.0

; Win+O to toggle transparency between opaque and transparent
#o::
{
    ; Get the active window ID
    activeWindow := WinGetID("A")

    ; Get current transparency (returns empty string if not set)
    currentTrans := WinGetTransparent(activeWindow)

    ; If no transparency is set or it's at 255 (fully opaque), set to %
    ; Otherwise, set back to fully opaque
    if (currentTrans = "" || currentTrans = 255)
    {
        WinSetTransparent(200, activeWindow)
    }
    else
    {
        ; Set back to fully opaque
        WinSetTransparent(255, activeWindow)
    }
}