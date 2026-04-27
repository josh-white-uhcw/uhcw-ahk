BuildGui(GuiTitle, Modifications := "") {
    g := Gui(modifications, GuiTitle)
    g.SetFont("s10", "Segoe UI")
    g.OnEvent("Escape", (*) => g.Destroy()) ; ESC closes
    g.Add("GroupBox", "x0 y-100 w300 h1")
    g.Add("Text", "x" g.MarginX " y-0.5" g.MarginY " w0 h0")
    Log("GUI Built", 2)
    return g
}