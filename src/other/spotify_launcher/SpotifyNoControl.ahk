;@Ahk2Exe-SetMainIcon %A_ScriptDir%\SpotifyNoControl.ico
#NoTrayIcon
Global SPOTIFY_PATH:= A_Args[1]
Try{
    if(tempHwnd:=WinExist("ahk_exe Spotify.exe"))
        WinGet, sPID, PID , ahk_id %tempHwnd%
    else{
        Run,% SPOTIFY_PATH? SPOTIFY_PATH: "spotify:" , %A_AppData%, UseErrorLevel, sPID
        if(ErrorLevel){
            MsgBox, 16,, Pass the path to spotify
            ExitApp, 1
        }
    }
    WinWait, ahk_pid %sPID%
    WinGet, sHwnd, List, ahk_pid %sPID%
    Loop, %sHwnd% {
        DllCall("SetWindowPos", "UInt", sHwnd%A_Index%, "UInt", 1, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x0200 | 0x0002 | 0x0004)
    }
    ExitApp, 0
} Catch {
    ExitApp, 1
}