BuildGui(GuiTitle, Modifications := "") {
    g := Gui(modifications, GuiTitle)
    g.SetFont("s10", "Segoe UI")
    g.OnEvent("Escape", (*) => g.Destroy()) ; ESC closes
    Log("GUI Built", 2)
    return g
}