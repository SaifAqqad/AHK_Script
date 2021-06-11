; VALORANT hotkeys
#If, WinActive("ahk_exe VALORANT-Win64-Shipping.exe")

;disable capslock,winkey
*CapsLock::
*LWin::
Return

Insert::
SendInput, {.}
Sleep, 50
SendInput, {1}
Sleep, 50
SendInput, {3}
Sleep, 50
return

Del::
SendInput, {.}
Sleep, 50
SendInput, {1}
Sleep, 50
SendInput, {1}
Sleep, 50
return

PgUp::
SendInput, {.}
Sleep, 50
SendInput, {3}
Sleep, 50
SendInput, {1}
Sleep, 50
return

PgDn::
SendInput, {.}
Sleep, 50
SendInput, {1}
Sleep, 50
SendInput, {4}
Sleep, 50
return

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