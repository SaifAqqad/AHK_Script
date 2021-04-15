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
        ; get the Hwnd for the default window
        tempHwnd:= WinExist("Spotify ahk_exe " SPOTIFY_EXE)
        ; get the Hwnd for all spotify windows (including hidden windows)
        WinGet, sHwnd, List, ahk_pid %sPID%
        Loop, %sHwnd% {
            if(sHwnd%A_Index% = tempHwnd) ; skip the default window
                Continue
            ; resize the window to 0,0 and place it on the bottom of the z order
            DllCall("SetWindowPos", "UInt", sHwnd%A_Index%, "UInt", 1, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x0200 | 0x0002)
        }
        return 1
    } Catch {
        return 0
    }
}