#Requires AutoHotkey v2.0
#Include ../dependencies/scripts/_all.ahk

TraySetIcon("..\images\Icons\Alarm (8 of 8).ico")

loop {
    Sleep(Second(55))
    Send("{RAlt}")
}