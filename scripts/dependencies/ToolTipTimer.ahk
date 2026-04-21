ToolTipTimer(message, time) { ; shorthand I made for displaying a tooltip with a lifetime in seconds
    ToolTip(message)
    SetTimer () => ToolTip(), -(time * 1000) ; millisecond conversion
}