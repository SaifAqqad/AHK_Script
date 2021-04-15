;windows terminal hotkey
*#T::
; if wt is running -> get the PID
WinGet, wtPID, PID, ahk_exe WindowsTerminal.exe
if(!wtPID){ ; if not, run wt
     Run, wt.exe, %A_Desktop%\..\, UseErrorLevel, wtPID
     Sleep, 500
}
; activate the wt window
WinActivate, ahk_pid %wtPID%
; focus the input to the window
ControlFocus, Windows.UI.Input.InputSite.WindowClass1, ahk_pid %wtPID%
return
