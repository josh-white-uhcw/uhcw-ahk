#Requires AutoHotkey v2.0
#Include ../dependencies/scripts/_all.ahk

try Hotkey ShorthandTranslatorKey, ShorthandTranslator
ShorthandTranslator(*) {
    SHGUI := BuildGui("Shorthand Translator")

    input := SHGUI.AddEdit("r9 w500", "Does not work right now, please disregard until changelogs say its been added.")
    translateButton := SHGUI.AddButton("", "Translate")
    translateButton.OnEvent("Click", (*) => Translate(input, SHGUI))

    output := SHGUI.AddEdit("r9 w500 ReadOnly", dictionary)

    SHGUI.Show("AutoSize Center")
}

Translate(input, SHGUI) {
    output := "test"
}

global dictionaryFile := A_ScriptDir . "\arrays\dictionary.txt"
global dictionary := FileRead(dictionaryFile)