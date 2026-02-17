#Requires AutoHotkey v2.0
#Include ../ConfigLoader.ahk
#Include ../dependencies/_all.ahk

Hotkey RevenueCycleKey, RevenueCycle
RevenueCycle(*) {
    if !windowCheck("Revenue Cycle") { ; calls dependencies/WindowCheck.ahk
        return
    }

    Click(31, 57)
    Send("^v")
    Sleep(200)
    Send("{Enter}")
    Sleep(500)
    Send("{Enter}")
}

Hotkey PowerChartKey, PowerChart
PowerChart(*) {
    ToolTipTimer("Powerchart", 1)
    if !windowCheck("PowerChart") {
        return
    }

    if !FindImage("PowerChartMRN", "110", "10") { ; Clicks the search icon
        ToolTipTimer("??? - No task image found", 5)
        return
    }

    ; Finish later

    Sleep(200)
}