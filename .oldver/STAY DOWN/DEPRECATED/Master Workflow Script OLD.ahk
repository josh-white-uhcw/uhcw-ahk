#Requires AutoHotkey v2.0

; --------------------
; Info
; --------------------

; This script is used as a info guide to the sub-scripts and contains extra info to be aware of.
; It does not need to be opened alongside the others as it is auto-#included. 
; Please note whats below, but keep in mind it is not absolute, some things may be changed without being updated here.

; --------------------
; PREREQS / NOTES - IMPORTANT
; --------------------

; - turn numlock on
; - note the kill command at the bottom of this page incase of immediate need to stop (shouldn't need to happen, I've added safeguards to everything in the public folder.)
; - if using appointment book it needs the "standard patient enquiry" window and "Person" tab open. it helps to enter the start date beforehand too
; - enter a MRN once manually on each app before using the script, as the apps are slow on first search which can make the script act weird
; - change the variables listed at the bottom of this page to match your needs (browser name, initials, etc)
; - do not use more than one script at a time (excluding clippys), Hotkeys may conflict and other similar issues.
; - clippyADAPT may be placed in a weird spot when first copying, supposed to be anchored to the right but sometimes dont work.
; - don't use any scripts in the beta or deprecated folder without setting up with me first, as they are basically unstable or require a very specific undocumented setup.
; --- Most importantly ---- be careful, chances are this code will do something unexpected to you but totally normal for me, so sorry in advance for lack of documentation.

; --------------------
; CURRENT KEYS
; --------------------

; - Master Workflow Script (global)
; - ` (backtick) - Kill script(s) immediately
; - ` (backtick) + Shift - Send DQ signature 

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
; - CTRL + SHIFT + V - Types clipboard as individual characters, allows pasting into Revenue Cycle's UBRN field.
; - Hashtag (#) - Paste "Referral added to EPR/PAS to be booked"
; - Shift + Hashtag - Paste "- Awaiting triage"
; - Insert - Start input process.

; --------------------
; Keys
; --------------------

; Hotkey to kill any script instantly
`:: {   ; Backtick - the key next to 1
    ExitApp()
}

; DQ Action message
+`:: {
    Send("Actioned by DQ (Data Quality Team)")
}

; --------------------
; Variables
; --------------------

; Report(s) opening
partialBrowserTitle := "edge"       ; replace 'Edge' with your browser of choice
outpatientTabTitle := "new report"  ; change from 'new report' to whatever is in the title of your spreadsheet tab if you need to be more specific
eReferralTabTitle := "e-re"  ; normally its this
maxTabSwitches := 10    ; How many tabs should be checked before giving up finding the sheet?

; Report modifiers
legacySheet := false    ; set to true if you hide attendance ID column OR if the sheet your using does not contain it. set to false if attendance ID is present.
initials := "Josh"  ; Name in sheet?

; Clipboard
clipboardDistance := 10 ; How far down on the screen should the clipboards start appearing? (in 200px increments, 10 is a good default)