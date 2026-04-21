#Requires AutoHotkey v2.0
#Include dependencies/_all.ahk

count := 0
tally := 0 ; 10ths

LetterCountGui := BuildGUI("Letter Count")

LetterCountGui.SetFont("s24")
display := LetterCountGui.AddText("Center w300", count)

LetterCountGui.SetFont("s12")
btn10Subtract := LetterCountGui.AddButton("w70 h40", "-10")
btnSubtract := LetterCountGui.AddButton("x+10 w70 h40", "-1")
btnAdd := LetterCountGui.AddButton("x+10 w70 h40", "+1")
btn10Add := LetterCountGui.AddButton("x+10 w70 h40", "+10")
btnTally := LetterCountGui.AddButton("xm w150 h40", "10th (Tally 10)")
btnTallyRestore := LetterCountGui.AddButton("x+10 w150 h40", "Readd 10ths to the main count")

LetterCountGui.SetFont("s10 italic")
tallyDisplay := LetterCountGui.AddText("xm Center w300", "10ths: 0")

; Events
btn10Subtract.OnEvent("Click", (*) => UpdateCounter(-10))
btnSubtract.OnEvent("Click", (*) => UpdateCounter(-1))
btnAdd.OnEvent("Click", (*) => UpdateCounter(1))
btn10Add.OnEvent("Click", (*) => UpdateCounter(10))

btnTally.OnEvent("Click", (*) => ProcessTally())
btnTallyRestore.OnEvent("Click", (*) => ProcessTallyRestore())

UpdateCounter(amount) {
    global count
    count += amount
    display.Value := count
}

ProcessTally() {
    global count, tally
    if count < 10
        return
    count -= 10
    tally += 1
    display.Value := count
    tallyDisplay.Value := "10ths removed: " . tally
}

ProcessTallyRestore() {
    global tally, count
    while tally > 0 {
        tally -= 1
        loop 10 {
            count += 1
            display.Value := count
            if FancyEffects
                Sleep(2)
        }
        tallyDisplay.Value := "10ths removed: " . tally
    }
}

LetterCountGui.Show()