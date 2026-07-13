#Requires AutoHotkey v2.0
#SingleInstance Force

; this is hella ai generated
; i just needed to throw it together.
; once i rewrite the code ill remove this comment.
; forgive me

global configFile := A_ScriptDir "\..\arrays\txtMsg.ini"
global globals := Map()
global templates := Map()
global dropdowns := Map()

LoadConfig()
ShowMainGui()


; ============================================================
;  CUSTOM INI PARSER
; ============================================================
LoadConfig() {
    global globals, templates, dropdowns, configFile
    globals.Clear()
    templates.Clear()
    dropdowns.Clear()

    fileText := FileRead(configFile, "UTF-8")

    lines := []
    for line in StrSplit(fileText, "`n")
        lines.Push(StrReplace(line, "`r", ""))

    currentSection := ""
    currentData := Map()
    bodyLines := []
    inBody := false

    FlushSection() {
        if (currentSection = "")
            return

        if (StrLower(currentSection) = "globals") {
            for k, v in currentData
                globals[k] := v
        } else if (StrLower(currentSection) = "dropdowns") {
            for k, v in currentData {
                opts := []
                for o in StrSplit(v, ",")
                    opts.Push(Trim(o))
                dropdowns[StrLower(k)] := opts
            }
        } else {
            if (inBody) {
                currentData["body"] := FinaliseBody(bodyLines)
                inBody := false
                bodyLines := []
            }

            vars := []
            if currentData.Has("variables") {
                for v in StrSplit(StripQuotes(currentData["variables"]), ",")
                    vars.Push(Trim(v))
            }

            templates[currentSection] := {
                to: currentData.Has("to") ? StripQuotes(currentData["to"]) : "",
                subject: currentData.Has("subject") ? StripQuotes(currentData["subject"]) : "",
                body: currentData.Has("body") ? currentData["body"] : "",
                vars: vars
            }
        }
        currentData := Map()
    }

    for line in lines {

        if RegExMatch(line, "^\[(.+)\]$", &m) {
            if (inBody) {
                currentData["body"] := FinaliseBody(bodyLines)
                inBody := false
                bodyLines := []
            }
            FlushSection()
            currentSection := Trim(m[1])
            continue
        }

        if (currentSection = "")
            continue

        if (inBody) {
            bodyLines.Push(line)
            continue
        }

        if (Trim(line) = "" || SubStr(Trim(line), 1, 1) = ";")
            continue

        eqPos := InStr(line, "=")
        if (!eqPos)
            continue

        key := Trim(SubStr(line, 1, eqPos - 1))
        val := Trim(SubStr(line, eqPos + 1))
        keyLower := StrLower(key)

        if (keyLower = "body") {
            if (SubStr(val, 1, 1) = '"' && !(StrLen(val) > 1 && SubStr(val, -1) = '"')) {
                inBody := true
                bodyLines := [SubStr(val, 2)]
            } else {
                currentData["body"] := StripQuotes(val)
            }
        } else {
            currentData[keyLower] := StripQuotes(val)
        }
    }

    if (inBody) {
        currentData["body"] := FinaliseBody(bodyLines)
    }
    FlushSection()
}

FinaliseBody(lines) {
    i := lines.Length
    while (i >= 1) {
        trimmed := RTrim(lines[i])
        if (trimmed != "") {
            if (SubStr(trimmed, -1) = '"')
                lines[i] := SubStr(trimmed, 1, StrLen(trimmed) - 1)
            break
        }
        i--
    }
    result := ""
    for idx, line in lines
        result .= (idx = 1 ? "" : "`n") . line
    return result
}

StripQuotes(s) {
    s := Trim(s)
    if (StrLen(s) >= 2 && SubStr(s, 1, 1) = '"' && SubStr(s, -1) = '"')
        return SubStr(s, 2, StrLen(s) - 2)
    return s
}


; ============================================================
;  MAIN GUI
; ============================================================
ShowMainGui() {
    global templates

    g := Gui(, "Text Message Templates")
    g.SetFont("s10", "Segoe UI")

    col := 0, row := 0
    btnW := 180, btnH := 40
    padX := 8, padY := 8
    startX := 12, startY := 12

    for name, _ in templates {
        x := startX + col * (btnW + padX)
        y := startY + row * (btnH + padY)
        btn := g.Add("Button", Format("x{} y{} w{} h{}", x, y, btnW, btnH), name)
        btn.OnEvent("Click", MakeHandler(name))
        if (++col >= 3) {
            col := 0
            row++
        }
    }

    totalRows := Ceil(templates.Count / 3)
    guiW := startX * 2 + 3 * (btnW + padX) - padX
    guiH := startY * 2 + totalRows * (btnH + padY) - padY
    g.Show(Format("w{} h{}", guiW, guiH))
}

MakeHandler(name) => (ctrl, *) => ShowVarGui(name)


; ============================================================
;  VARIABLE INPUT GUI
; ============================================================
ShowVarGui(tplName) {
    global templates, globals, dropdowns

    tpl := templates[tplName]
    varList := tpl.vars

    inputVars := []
    for v in varList
        if (!globals.Has(v))
            inputVars.Push(v)

    g := Gui("+AlwaysOnTop", tplName)
    g.SetFont("s10", "Segoe UI")

    y := 12
    controls := Map()
    isDropdown := Map()

    if (inputVars.Length = 0) {
        g.Add("Text", "x12 y12 w300", "No variables needed. Click Send.")
        y := 40
    }

    for varName in inputVars {
        g.Add("Text", Format("x12 y{} w300", y), varName ":")
        y += 20
        if (dropdowns.Has(StrLower(varName))) {
            ctrl := g.Add("DropDownList", Format("x12 y{} w300 Choose1", y), dropdowns[StrLower(varName)])
            isDropdown[varName] := true
        } else {
            ctrl := g.Add("Edit", Format("x12 y{} w300 h24", y))
            isDropdown[varName] := false
        }
        controls[varName] := ctrl
        y += 32
    }

    y += 4
    sendBtn := g.Add("Button", Format("x12  y{} w80 h28 Default", y), "Send")
    cancelBtn := g.Add("Button", Format("x100 y{} w80 h28", y), "Cancel")
    cancelBtn.OnEvent("Click", (*) => g.Destroy())
    g.OnEvent("Close", (*) => g.Destroy())
    sendBtn.OnEvent("Click", DoSend)

    g.Show(Format("w328 h{}", y + 44))

    DoSend(*) {
        vals := Map()
        for k, v in globals
            vals[k] := v
        for varName, ctrl in controls
            vals[varName] := isDropdown[varName] ? ctrl.Text : ctrl.Value

        to := tpl.to
        subject := tpl.subject
        body := tpl.body

        for k, v in vals {
            to := StrReplace(to, "{" k "}", v)
            subject := StrReplace(subject, "{" k "}", v)
            body := StrReplace(body, "{" k "}", v)
        }

        g.Destroy()
        Run("mailto:" to "?subject=" UriEncode(subject) "&body=" UriEncode(body))
    }
}


; ============================================================
;  URI ENCODE
; ============================================================
UriEncode(str) {
    out := ""
    loop parse, str {
        c := A_LoopField
        if RegExMatch(c, "[A-Za-z0-9\-_.~]")
            out .= c
        else
            out .= Format("%{:02X}", Ord(c))
    }
    return out
}