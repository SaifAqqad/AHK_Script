#IfWinActive ahk_exe VALORANT-Win64-Shipping.exe

<^R:: colorizeText("enemy")
<^G:: colorizeText("notification")
<^B:: colorizeText("team")
<^Y:: colorizeText("system")
<^P:: colorizeText("warning")
#If

colorizeText(p_type){
    clipboard:=""
    SendInput {CTRLDOWN}x{CTRLUP}
    ClipWait, 1
    if(clipboard){
        SendInput <%p_type%>%clipboard%</>
    }
}