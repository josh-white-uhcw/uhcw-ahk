#Requires AutoHotkey v2.0
#Include ../dependencies/scripts/_all.ahk

TraySetIcon("..\images\Icons\New letter.ico")

count := 0
tally := 0 ; 10ths

LetterCountGui := BuildGUI("Letter Count")

; Total GUI content width = 300
; Button row total = 70+10+70+10+70+10+70 = 310... let's keep 300 and adjust spacing

guiWidth := 320
margin := 10

; Center the large count display
LetterCountGui.SetFont("s24")
display := LetterCountGui.AddText("Center w" . guiWidth, count)

; Button row 1: four buttons, 70 wide, 10 gap → total = 70*4 + 10*3 = 310
; To center in guiWidth (320): leftMargin = (320 - 310) / 2 = 5
LetterCountGui.SetFont("s12")
btn10Subtract := LetterCountGui.AddButton("xm5 w70 h40", "-10")
btnSubtract    := LetterCountGui.AddButton("x+10 w70 h40", "-1")
btnAdd         := LetterCountGui.AddButton("x+10 w70 h40", "+1")
btn10Add       := LetterCountGui.AddButton("x+10 w70 h40", "+10")

; Button row 2: two buttons, 150 wide, 10 gap → total = 150*2 + 10 = 310
; Same margin: xm5
btnTally        := LetterCountGui.AddButton("xm5 w150 h40", "10th (Tally 10)")
btnTallyRestore := LetterCountGui.AddButton("x+10 w150 h40", "Readd 10ths to the main count")

; Tally label centered across full width
LetterCountGui.SetFont("s10 italic")
tallyDisplay := LetterCountGui.AddText("xm Center w" . guiWidth, "10ths: 0")

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