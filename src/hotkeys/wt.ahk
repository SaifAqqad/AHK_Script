;windows terminal hotkey
*#T::
newTab:= GetKeyState("Alt")
WinGet, wtPID, PID, ahk_exe WindowsTerminal.exe
if(!wtPID){
     Run, wt.exe, %A_Desktop%\..\, UseErrorLevel
     WinWait, ahk_exe WindowsTerminal.exe,,4
     Sleep, 500
}
if(newTab){
     Run, wt.exe -w 0 nt, %A_Desktop%\..\, UseErrorLevel
}
; activate the wt window & focus the input to the window
fCount:=0
focusInput:
Try{
     WinActivate, ahk_exe WindowsTerminal.exe ahk_class CASCADIA_HOSTING_WINDOW_CLASS
     ControlFocus, Windows.UI.Input.InputSite.WindowClass1, ahk_exe WindowsTerminal.exe
}catch{
     Sleep, 20
     if(++fCount<4)
          Goto, focusInput
}
return