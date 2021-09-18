DetectHiddenWindows, On
Global SPOTIFY_EXE:= "Spotify.exe"
, current_vol:=""

$*Volume_Up::
if(GetKeyState("LAlt","P")){
    Try {
        if(current_vol="")
            current_vol:= spotify.GetCurrentPlaybackInfo().device.volume_percent
        current_vol:= Min(Max(current_vol+10, 0), 100)
        spotify.SetVolume(current_vol)
        osd_obj.showAndHide("Spotify Volume: " current_vol,"1ED760")
    }
}else
    SendInput, {Volume_Up}
return
$*Volume_Down::
if(GetKeyState("LAlt","P")){
    Try {
        if(current_vol="")
            current_vol:= spotify.GetCurrentPlaybackInfo().device.volume_percent
        current_vol:= Min(Max(current_vol-10, 0), 100)
        spotify.SetVolume(current_vol)
        osd_obj.showAndHide("Spotify Volume: " current_vol,"1ED760")
    }
}else
    SendInput, {Volume_Down}
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