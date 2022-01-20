DetectHiddenWindows, On
Global SPOTIFY_EXE:= "Spotify.exe"

<!Up::
Try vol:= spotify.SetVolume(10,1)
osd_obj.showAndHide("Spotify Volume: " vol,"1ED760",1)
return

<!Down::
Try vol:= spotify.SetVolume(-10,1)
osd_obj.showAndHide("Spotify Volume: " vol,"1ED760",1)
return

<!Right::
Try spotify.NextTrack()
SetTimer, showPlaying, -200
return

<!Left::
Try spotify.PreviousTrack()
SetTimer, showPlaying, -200
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

showPlaying(){
    Try {
        track:= spotify.GetCurrentTrackInfo()
        osd_obj.showAndHide(track.item.artists[1].name " - " track.item.name,"1ED760",2)
    }
}