; copy and google the highlighted text
!Space::
    clipboard:=""
    SendInput {CTRLDOWN}c{CTRLUP}
    ClipWait, 1
    if(clipboard){
        txt:= UrlEncode(clipboard)
        Run https://www.google.com/search?hl=en&q=%txt%,, UseErrorLevel
    }else
        osd_obj.showAndHide("Search failed",,2)
Return 

; https://autohotkey.com/board/topic/35660-url-encoding-function/
UrlEncode( String ){
	OldFormat := A_FormatInteger
	SetFormat, Integer, H

	Loop, Parse, String 
    {
		if A_LoopField is alnum 
        {
			Out .= A_LoopField
			continue
		}
		Hex := SubStr( Asc( A_LoopField ), 3 )
		Out .= "%" . ( StrLen( Hex ) = 1 ? "0" . Hex : Hex )
	}
	SetFormat, Integer, %OldFormat%
	return Out
}