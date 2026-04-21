; combinations:
; [A-Za-z]\d{5} == 1 letter 5 num
; [A-Za-z]{2}\d{7} == 2 letter 7 num
; \d{8} == 9 num

MRNCheck() {
    if RegExMatch(A_Clipboard, "^(\d{9}|[A-Za-z]\d{5}|[A-Za-z]{2}\d{7})$") {
        Log("Regex true", 2)
        return true
    }
    else {
        ErrorMsg("Not A MRN: " . A_Clipboard)
        Log("Regex false: " . A_Clipboard, 3)
        return false
    }
}