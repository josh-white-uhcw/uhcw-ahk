#Requires AutoHotkey v2.0

; Info

; This script is used as a info guide to the sub-scripts and contains extra info to be aware of. It does not need to be opened alongside the others as it is auto-#included. 
; Please note whats below, but keep in mind it is not absolute, some things may be changed without being updated here.

; PREREQS - IMPORTANT

; - turn numlock on
; - note the kill command at the bottom of this page incase of immediate need to stop
; - for appointment book open the "standard patient enquiry" window before use (the eye icon) and be in the "Person" tab. it helps to enter the start date beforehand too
; - enter a MRN once manually on each app before using the script, as the apps are slow on first search which can make the script act weird
; - change the variables listed at the bottom of this page to match your needs (browser name, initials, etc)
; - do not use more than one script at a time (excluding this one and clippy), Hotkeys may conflict and other similar issues.
; - don't use any scripts in the beta or deprecated folder without setting up with me first, as they are basically unstable or require a very specific undocumented setup.
; - MOST IMPORTANTLY - This is not a script to do your work for you, it merely assists. It is some of the most spagetti code I have ever written and will probably mess something up the moment you look away so pay attention and use with caution.

; CURRENT KEYS

; - Master Workflow Script
; - ` (backtick) - Kill script(s) immediately

; - Clippy
; - F1-F9 - Paste from clipboard slots 1-9
; - F10 - Clear all clipboard slots and tooltips
; - when using STATIONARY enter the text into the quotes and they will stay.
; - when using ADAPT each time you copy text it overrides the next slot meaning you can hold the 9 most recent clipboard snippets.

; - Outpatients
; - Numpad0 - Goes to first open xlsx browser tab, absolute left, down, and copy cell (MRN), if legacy mode is disabled it will move one right to account for attendance ID.
; - Numpad1 - Puts copied MRN into Powerchart and searches, up until it opens the first documentation entry
; - Numpad2 - Puts copied MRN into Revenue Cycle and searches, up until its searching the PDS database (no reliable way to open past appointments at this time)
; - Numpad3 - Puts copied MRN into Appointment Book and searches, up until all appointments are listed
; - CTRL + Numpad1 - Goes to first open xlsx browser tab and enters 'No Documentation' along with Name and Date. May have different effects if used on sheets with extra columns, edit enterOutcome.ahk or hide columns as needed.
; - CTRL + Numpad2 - ^ but 'Checked Out'
; - CTRL + Numpad3 - ^ but 'Already Checked Out'
; - CTRL + Numpad4 - ^ but 'DNA'
; - CTRL + Numpad5 - ^ but 'DNA No Doc'
; - CTRL + Numpad6 - ^ but 'Checkout No Doc'

; - ERS
; - CTRL + SHIFT + V - Paste clipboard as characters, allows pasting into Revenue Cycle's UBRN field.
; - E + R -  

; - GEH [VERY VERY SPECFIC SETUP NEEDED, DONT USE]
; - PgUp - In Teams, makes a new Word doc
; - ALT + V - In Word doc, enters title format with MRN and initials
; - Numpad7 - Goes to PM Office and opens up the encounter search window (peak laziness)

; - Variables
partialBrowserTitle := "edge"   ; replace 'Edge' with your browser of choice
partialTabTitle := "xlsx"   ; replace 'xlsx' with the name of the spreadsheet used if multiple are open, keeping it as xlsx is fine most of the time
maxTabSwitches := 5    ; How many tabs should be checked before giving up?
legacySheet := true ; set to true if you hide attendance ID column OR if the sheet your using does not contain it. set to false if attendance ID is present.
initials := "Josh"  ; Name in sheet?

; --- Hotkey to kill the script instantly ---
`:: {   ; Backtick - next to 1
    ExitApp()
}