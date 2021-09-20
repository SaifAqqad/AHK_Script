DetectHiddenWindows, On
Global SPOTIFY_EXE:= "Spotify.exe"

<^Up::
spotify.SetVolume(10,1)
osd_obj.showAndHide("Spotify Volume: " spotify.GetVolume(),"1ED760")
return

<^Down::
spotify.SetVolume(-10,1)
osd_obj.showAndHide("Spotify Volume: " spotify.GetVolume(),"1ED760")
return

<^Right::
spotify.NextTrack()
track:= spotify.GetCurrentTrackInfo()
osd_obj.showAndHide("Playing: " track.item.artists[0].name " - " track.item.name,"1ED760")
return

<^Left::
spotify.PreviousTrack()
track:= spotify.GetCurrentTrackInfo()
osd_obj.showAndHide("Playing: " track.item.artists[0].name " - " track.item.name,"1ED760")
return

*~Media_Play_Pause::RapidHotkey("call_runSpotify",2,0.4,1)

call_runSpotify:
runSpotify()
return

runSpotify(){
    Try{
        ; if spotify is running -> get the PID
        WinGet, sPID, PID , ahk_exe %SPOTIFY_EXE%
        if(!sPID){ ; if not, run spotify
            Run, % getSpotifyFullPath() , %A_AppData%,, sPID
            WinWait, ahk_exe %SPOTIFY_EXE%,, 5
            WinShow, ahk_exe %SPOTIFY_EXE%
        }
        WinActivate, ahk_exe %SPOTIFY_EXE%
        return 1
    } Catch {
        return 0
    }
}

getSpotifyFullPath(){
    p_path:= A_Args[1]
    if(!p_path){
        ; works regardless of where spotify is installed
        RegRead, p_path, HKCR\spotify\shell\open\command
        SplitPath, p_path,, p_path
        p_path:= StrReplace(p_path, """") "\" SPOTIFY_EXE
    }
    return p_path
}