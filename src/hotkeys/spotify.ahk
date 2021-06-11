*~Media_Play_Pause::RapidHotkey("call_runSpotify",2,,1)

call_runSpotify:
runSpotify()
return

runSpotify(SPOTIFY_PATH:=""){
    static SPOTIFY_EXE:= "spotify.exe"
    Try{
        ; if spotify is running -> get the PID
        WinGet, sPID, PID , ahk_exe %SPOTIFY_EXE%
        if(!sPID){ ; if not, run spotify
            Run,% SPOTIFY_PATH? SPOTIFY_PATH : "spotify:" , %A_AppData%, Hide, sPID
            ; wait for the window to exist
            WinWait, ahk_exe %SPOTIFY_EXE%,, 5
            ; get the PID
            WinGet, sPID, PID
            WinShow, 
        }
        ; Focus the main window
        WinActivate, ahk_pid %sPID%
        ; get the Hwnd for all spotify windows
        WinGet, sHwnd, List, ahk_pid %sPID%
        Loop, %sHwnd% {
            ; only the main window has a title
            ; so check the window title
            WinGetTitle, sTitle, % "ahk_id " . sHwnd%A_Index%
            if(sTitle) ; if there's a title -> skip the window
                Continue
            ; resize the window to 0,0 and place it on the bottom of the z order
            DllCall("SetWindowPos", "UInt", sHwnd%A_Index%, "UInt", 1, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x0200 | 0x0002)
        }
        return 1
    } Catch {
        return 0
    }
}