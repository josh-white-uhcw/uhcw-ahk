; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 
; DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED DEPRECATED 

#Requires AutoHotkey v2.0
#t:: { ; creates up to 20 tooltips with the text from the current clipboard
	Static No := 0
	ToolTip A_ClipBoard,,, ++No := Mod(No, 20)
} ; copies the tooltip text under the mouse
#c::MouseGetPos(,, &VarWin), A_ClipBoard := ControlGetText(VarWin)

; win+t to make note from clipboard
; win+c on note to copy to clipboard 