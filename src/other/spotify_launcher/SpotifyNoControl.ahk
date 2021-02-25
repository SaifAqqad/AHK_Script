;@Ahk2Exe-SetMainIcon %A_ScriptDir%\SpotifyNoControl.ico
#NoTrayIcon
Global SPOTIFY_PATH:= A_Args[1]
Try{
    ; if spotify is running -> get the PID
    if(tempHwnd:=WinExist("ahk_exe Spotify.exe"))
        WinGet, sPID, PID , ahk_id %tempHwnd%
    else{ ; if not, run spotify and get the PID
        Run,% SPOTIFY_PATH? SPOTIFY_PATH: "spotify:" , %A_AppData%, UseErrorLevel, sPID
        if(ErrorLevel){
            MsgBox, 16,, Pass the path to spotify
            ExitApp, 1
        }
    }
    ;wait for the window to exist
    WinWait, ahk_pid %sPID%
    ;get the Hwnd for the default window
    tempHwnd:= WinExist("Spotify")
    ; get the Hwnd for all spotify windows (including hidden windows)
    WinGet, sHwnd, List, ahk_pid %sPID%
    Loop, %sHwnd% {
        if(sHwnd%A_Index% = tempHwnd) ; skip the window if it's the default one
            Continue
        ; resize the window to 0,0 and place it on the bottom of the z order
        DllCall("SetWindowPos", "UInt", sHwnd%A_Index%, "UInt", 1, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x0200 | 0x0002)
    }
    ExitApp, 0
} Catch {
    ExitApp, 1
}