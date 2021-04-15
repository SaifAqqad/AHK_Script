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
#If