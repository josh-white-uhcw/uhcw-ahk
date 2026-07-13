#Requires AutoHotkey v2.0
#Include dependencies/scripts/_all.ahk
#Include dependencies/UpdateChecker.ahk
#Include changelog.ahk

TraySetIcon("./images\Icons\Agent.ico")

SaveLogs := true
ShowErrors := true
rownumber := 0
ChangelogData := GetChangelogData()

global version := FileRead("version")
ScriptsDir := A_ScriptDir "\scripts"
scriptInfoPath := "arrays\scriptsInfo.ini"
ConfigIniPath := A_ScriptDir "\config.ini"

MasterGui := BuildGui("Master")

CategoryMap := Map()

Loop Files, ScriptsDir "\*.ahk"
{
    SectionName := SubStr(A_LoopFileName, 1, -4) ; Strips ".ahk"

    CustomName := IniRead(scriptInfoPath, SectionName, "Name", A_LoopFileName)
    FileDesc := IniRead(scriptInfoPath, SectionName, "Description", "")
    FileAi := IniRead(scriptInfoPath, SectionName, "LastUpdated", "")
    FileCat := IniRead(scriptInfoPath, SectionName, "Category", "Uncategorized")

    ; If this category hasn't been seen yet, initialize an empty array for it
    if !CategoryMap.Has(FileCat)
        CategoryMap[FileCat] := []

    ; Push the script data into its category group
    CategoryMap[FileCat].Push({
        FileName: A_LoopFileName,
        Name: CustomName,
        Status: FileAi,
        Desc: FileDesc
    })
}

for CatName, ScriptsInCat in CategoryMap
{
    ; Add a bold text label acting as a section header for the category
    MasterGui.AddText("w850 xm y+15", CatName " Scripts")

    for script in ScriptsInCat
    {
        rownumber++
    }

    ; Create a dedicated ListView for this category (r4 = 4 rows high)
    CategoryLV := MasterGui.AddListView("r" rownumber " w850 y+5", ["FileName", "Name", "Update Status", "Description"])
    rownumber := 0

    ; Populate only this ListView with its matching scripts
    for script in ScriptsInCat
    {
        CategoryLV.Add(, script.FileName, script.Name, script.Status, script.Desc)
    }

    CategoryLV.ModifyCol(1, 0) ; Hide
    CategoryLV.ModifyCol(2, "Auto") ; Auto-size
    CategoryLV.ModifyCol(4, "Auto") ; Auto-size
    CategoryLV.OnEvent("DoubleClick", RunFile) ; maybe make it open when checkeds
}

MasterGui.AddButton("xm", "Open Config").OnEvent("Click", (*) => ShowConfig())
MasterGui.AddButton("x+5", "Open About Page").OnEvent("Click", (*) => ShowAboutPage())

ChangelogText := FileRead("changelog.txt", "UTF-8")
MasterGui.AddEdit("ym r20 w450 Disabled", "WIP")

MasterGui.Show("AutoSize Center")

StatusBar := MasterGui.AddStatusBar("Border", "")
MasterGui.GetClientPos(, , &MasterGUIWidth)
MainStatusBarWidth := (MasterGUIWidth - 20) / 1
;MsgBox("MasterGUIWidth is " MasterGUIWidth "`n MainStatusBarWidth is " MainStatusBarWidth)
StatusBar.SetParts(10, MainStatusBarWidth, 10)
if UpdateAvalible
    StatusBar.SetText("Running Version | " version " --> " remoteVer " | Update avalible", 2)
else
    StatusBar.SetText("Running Version | " version " --> " remoteVer " | Up to date", 2)
StatusBar.SetText("", 3)

MasterGui.Show("AutoSize Center")

RunFile(ListView, RowNumber) {
    ScriptName := ListView.GetText(RowNumber, 1)
    if ScriptName == ""
        return
    try {
        Run(A_ScriptDir "\scripts\" ScriptName)
        ToolTipTimer(ScriptName " opened!", 1)
    }
    catch
        MsgBox("Could not open " A_ScriptDir "\scripts\" ScriptName ".")
}


ShowConfig() {
    TraySetIcon("./images\Icons\Config program.ico")
    ConfigGui := BuildGui("Config")

    ConfigGui.Title := "Master Script - Config"

    ConfigGui.AddText("xm w600 h10 0x10")
    ConfigGui.AddText("y+0 w600 Center", "General")
    ConfigGui.AddText("xm y+0 w600 h10 0x10")

    ConfigGui.AddText("xm y+10 w200", "Browser Name:")
    ConfigGui.AddEdit("x+10 yp-3 w350 vConfBrowser")

    ConfigGui.AddText("xm y+10 w200", "Full Name:")
    ConfigGui.AddEdit("x+10 yp-3 w350 vConfFullName")

    ConfigGui.AddText("xm y+10 w200", "Appt. Book Default Start Date")
    ConfigGui.AddEdit("x+10 yp-3 w350 Number Limit8 vConfAppointmentBookStartDate")

    ConfigGui.AddCheckbox("xm y+10 w300 vConfLegacySheet", "Legacy Sheet (No Attendance ID Column)")
    ConfigGui.AddCheckbox("x+0 yp w300 vConfSudo", "Super User Apps")
    ConfigGui.AddCheckbox("xm y+10 w300 vConfSaveLogs Checked", "Save Logs")
    ConfigGui.AddCheckbox("x+0 yp w300 vConfShowErrors Checked", "Show Errors")
    ConfigGui.AddCheckbox("xm y+10 w300 vConfFancyEffects Checked", "Fancy Effects")
    ConfigGui.AddCheckbox("x+0 yp w300 vConfCheckForUpdates Checked", "Check For Updates")

    ConfigGui.AddText("xm y+20 w600 0x10")
    ConfigGui.AddText("xm y+5 w600 Center", "Hotkeys")
    ConfigGui.AddText("xm w600 0x10")

    for entry in [
        ["Enter Outcome:", "vHotkeyEnterOutcome"],
        ["Revenue Cycle:", "vHotkeyRevenueCycle"],
        ["PowerChart:", "vHotkeyPowerChart"],
        ["Appointment Book:", "vHotkeyAppointmentBook"],
        ["PM Office: [WIP]", "vHotkeyPMOffice"],
        ["Create Note:", "vHotkeyNoteCreate"],
        ["Add Referral:", "vHotkeyAddReferral"],
        ["Pre-Op Comments:", "vHotkeyPreOpGui"],
        ["Pre-Op Email Replies", "vHotkeyEmailReplies"],
        ["Pre-Op Message Centre Replies", "vHotkeyMessageCentreReplies"],
        ["Triage Request", "vHotkeyTriage"],
        ["Shorthand Translator:", "vHotkeyShorthandTranslator"]
    ] {
        ConfigGui.AddText("xm y+10 w200", entry[1])
        ConfigGui.AddHotkey("x+10 yp-3 w380 " entry[2])
    }

    ; Load current settings
    ConfigGui["ConfBrowser"].Value := IniRead(ConfigIniPath, "General", "Browser", "")
    ConfigGui["ConfFullName"].Value := IniRead(ConfigIniPath, "General", "FullName", "")
    ConfigGui["ConfAppointmentBookStartDate"].Value := IniRead(ConfigIniPath, "General", "AppointmentBookStartDate", "")
    ConfigGui["ConfLegacySheet"].Value := IniRead(ConfigIniPath, "General", "LegacySheet", 0)
    ConfigGui["ConfSudo"].Value := IniRead(ConfigIniPath, "General", "Sudo", 0)
    ConfigGui["ConfSaveLogs"].Value := IniRead(ConfigIniPath, "General", "SaveLogs", 1)
    ConfigGui["ConfShowErrors"].Value := IniRead(ConfigIniPath, "General", "ShowErrors", 1)
    ConfigGui["ConfFancyEffects"].Value := IniRead(ConfigIniPath, "General", "FancyEffects", 1)
    ConfigGui["ConfCheckForUpdates"].Value := IniRead(ConfigIniPath, "General", "CheckForUpdates", 1)


    for entry in [
        ["HotkeyEnterOutcome"],
        ["HotkeyRevenueCycle"],
        ["HotkeyPowerChart"],
        ["HotkeyAppointmentBook"],
        ["HotkeyPMOffice"],
        ["HotkeyNoteCreate"],
        ["HotkeyAddReferral"],
        ["HotkeyPreOpGui"],
        ["HotkeyEmailReplies"],
        ["HotkeyMessageCentreReplies"],
        ["HotkeyTriage"],
        ["HotkeyShorthandTranslator"]
    ] {
        ConfigGui[entry[1]].Value := IniRead(ConfigIniPath, "Hotkeys", entry[1], "")
    }

    ; Add buttons
    ConfigGui.AddButton("xm y+20", "Save").OnEvent("Click", (*) => SaveConfig(ConfigGui))
    ConfigGui.AddButton("x+10", "Reset").OnEvent("Click", (*) => ResetConfig(ConfigGui))

    ConfigGui.Show("AutoSize Center")
    TraySetIcon("./images\Icons\Agent.ico")
}

ShowAboutPage() {
    ;TraySetIcon("./images\Icons\Config program.ico")
    AboutGui := BuildGui("About")

    AboutGui.Title := "About"

    ; 2. Generate the HTML string dynamically from the array
    htmlBody := ""
    for logItem in ChangelogData {
        htmlBody .= "<div class='version'>" . logItem.Version . "</div>`n<ul>`n"
        for change in logItem.Changes {
            htmlBody .= "  <li><span class='" . change.type . "'>" . change.text . "</span></li>`n"
        }
        htmlBody .= "</ul>`n"
    }

    htmlContent := "
    (
        <!DOCTYPE html>
        <html>
        <head>
            <meta http-equiv='X-UA-Compatible' content='IE=edge'>
            <meta charset='UTF-8'>
            <style>
                body { font-family: 'Segoe UI', sans-serif; font-size: 14px; background-color: #fafafa; margin: 15px; }
                .version { color: #007acc; font-weight: bold; font-size: 16px; border-bottom: 1px solid #ccc; margin-top: 15px; }
                ul { list-style-type: none; padding-left: 5px; }
                li { margin-bottom: 5px; }
                .added { color: #2e7d32; }
                .changed { color: #f57c00; }
                .removed { color: #d32f2f; }
            </style>
        </head>
        <body>
    )" . htmlBody . " </body> </html>"

    WB := AboutGui.AddActiveX("w650 h500", "Shell.Explorer").Value

    WB.Navigate("about:blank")
    while WB.ReadyState != 4
        Sleep(10)
    WB.Document.write(htmlContent)
    WB.Document.close()

    AboutGui.Show("Autosize Center")

}

SaveConfig(GuiObj) {
    IniWrite(GuiObj["ConfBrowser"].Value, ConfigIniPath, "General", "Browser")
    IniWrite(GuiObj["ConfFullName"].Value, ConfigIniPath, "General", "FullName")
    IniWrite(GuiObj["ConfAppointmentBookStartDate"].Value, ConfigIniPath, "General", "AppointmentBookStartDate")
    IniWrite(GuiObj["ConfLegacySheet"].Value, ConfigIniPath, "General", "LegacySheet")
    IniWrite(GuiObj["ConfSudo"].Value, ConfigIniPath, "General", "Sudo")
    IniWrite(GuiObj["ConfSaveLogs"].Value, ConfigIniPath, "General", "SaveLogs")
    IniWrite(GuiObj["ConfShowErrors"].Value, ConfigIniPath, "General", "ShowErrors")
    IniWrite(GuiObj["ConfFancyEffects"].Value, ConfigIniPath, "General", "FancyEffects")
    IniWrite(GuiObj["ConfCheckForUpdates"].Value, ConfigIniPath, "General", "CheckForUpdates")
    for entry in [
        ["HotkeyEnterOutcome"],
        ["HotkeyRevenueCycle"],
        ["HotkeyPowerChart"],
        ["HotkeyAppointmentBook"],
        ["HotkeyPMOffice"],
        ["HotkeyNoteCreate"],
        ["HotkeyAddReferral"],
        ["HotkeyPreOpGui"],
        ["HotkeyEmailReplies"],
        ["HotkeyMessageCentreReplies"],
        ["HotkeyTriage"],
        ["HotkeyShorthandTranslator"]
    ] {
        IniWrite(GuiObj[entry[1]].Value, ConfigIniPath, "Hotkeys", entry[1])
    }
    MsgBox("Settings saved!")
}

ResetConfig(GuiObj) {
    ; Reset to defaults (adjust as needed)
    GuiObj["ConfBrowser"].Value := ""
    GuiObj["ConfFullName"].Value := ""
    GuiObj["ConfAppointmentBookStartDate"].Value := ""
    GuiObj["ConfLegacySheet"].Value := 0
    GuiObj["ConfSudo"].Value := 0
    GuiObj["ConfSaveLogs"].Value := 1
    GuiObj["ConfShowErrors"].Value := 1
    GuiObj["ConfFancyEffects"].Value := 1
    GuiObj["ConfCheckForUpdates"].Value := 1

    for entry in [
        ["HotkeyEnterOutcome"],
        ["HotkeyRevenueCycle"],
        ["HotkeyPowerChart"],
        ["HotkeyAppointmentBook"],
        ["HotkeyPMOffice"],
        ["HotkeyNoteCreate"],
        ["HotkeyAddReferral"],
        ["HotkeyPreOpGui"],
        ["HotkeyEmailReplies"],
        ["HotkeyMessageCentreReplies"],
        ["HotkeyTriage"],
        ["HotkeyShorthandTranslator"]
    ] {
        GuiObj[entry[1]].Value := ""
    }
}

NumpadEnter:: {
    MasterGui.Show("Autosize Center")
}