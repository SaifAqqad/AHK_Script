#NoEnv
#include <VMR>
OSD_spawn("AHK starting up..")
SendMode Input
SetWorkingDir %A_ScriptDir%
SetNumLockState AlwaysOff
FileInstall, .\sfx\mute.mp3, mute.mp3 ;Both sfx files are from Discord's sfx zip file https://t.co/AD6jvkePul 
FileInstall, .\sfx\unmute.mp3, unmute.mp3 ; ^
TrayIcon := A_ScriptDir . "\Script.ico"
if (FileExist(TrayIcon)) {
     Menu, Tray, Icon, %TrayIcon%
}
;===============================================Global Hotkeys===============================================
<^<+R::VMR_restart()

#Space::
clipboard = 
SendInput {CTRLDOWN}c{CTRLUP}
ClipWait
Run http://www.google.com/search?hl=en&q=%clipboard%,, UseErrorLevel
Return 

<!<+::#Space 

^End::ExitApp

*RShift::MuteMic()

#if, (isActiveWinFullscreen())
CapsLock::Return
#if

F6::
WinKill, ahk_exe speedtest.exe
run, speedtest
return
;===============================================Media Hotkeys===============================================
$Media_Play_Pause::PlayPauseRun() 

$^Media_Play_Pause::sendInput {Media_Play_Pause} 

Volume_Up::
Vol:= VMR_incGain() 
OSD_spawn("Gain: " . Vol)
return

Volume_Down::
Vol:= VMR_decGain() 
OSD_spawn("Gain: " . Vol)
return

$<^Volume_Down:: ;Mutes Bus[0]
Mute:= VMR_muteToggle()
OSD_spawn( Mute = 0.0 ? "Global Audio Muted" : "Global Audio Unmuted" )
KeyWait, LControl 
Return

$<^<+Volume_Down:: ;Mutes System Audio 
Mute:= VMR_muteToggle("Strip[3]")
OSD_spawn( Mute = 0.0 ? "System Audio Muted" : "System Audio Unmuted" )
KeyWait, LControl 
Return

$#Volume_Down::
Vol:= VMR_decGain("Strip[4]") ;Decreases Media Audio Gain
OSD_spawn("Media: " . Vol)
return

$#Volume_Up::
Vol:= VMR_incGain("Strip[4]") ;increases Media Audio Gain
OSD_spawn("Media: " . Vol)
return

$<!Volume_Down::
Vol:= VMR_decGain("Strip[1]") ;Decreases Microphone Gain
OSD_spawn("Microphone: " . Vol)
return

$<!Volume_Up::
Vol:= VMR_incGain("Strip[1]") ;increases Microphone Gain
OSD_spawn("Microphone: " . Vol)
return

$<!<^Volume_Down::
Vol:= VMR_decGain("Strip[0]") ;Decreases Game chat Gain
OSD_spawn("Gamechat: " . Vol)
return

$<!<^Volume_Up::
Vol:= VMR_incGain("Strip[0]") ;increases Game chat Gain
OSD_spawn("Gamechat: " . Vol)
return

F7::
VMR_setAudioDevice("Bus[0]",3,"hs70") 
OSD_spawn("Headphone Audio")
return

F8::          
VMR_setAudioDevice("Bus[0]",3,"LG HDR")
OSD_spawn("Monitor Audio")
return

;============================================Fortnite Macros================================================
#if, WinActive("ahk_exe FortniteClient-Win64-Shipping.exe")
;Build reset macro
$XButton2:: 
sendInput, {g}
sleep,30
sendInput, {RButton}
sleep, 30
sendInput, {g}
Return
/*Hold Edit-building key macro
$g::
sendInput {g}
KeyWait, g
Return
$g Up::
SendInput {g}
Return
*/
#if
;=============================================Functions=============================================
PlayPauseRun(){
     
     if (WinExist("ahk_exe Spotify.exe") or WinExist("ahk_exe Anghami.exe") or WinExist("ahk_exe Plex.exe") or WinExist("ahk_exe Plexamp.exe") or WinExist("myTube!")){
          SendInput, {Media_Play_Pause}
     }else {
          run, plexamp.exe
     }
     Return
}
MuteMic(){
     
     MuteState := VA_GetMasterMute("AmazonBasics:1")
     VA_SetMasterMute(!MuteState, "AmazonBasics:1")
     OSD_spawn( !MuteState ? "Microphone muted" : "Microphone online" ) 
     if ( isActiveWinFullscreen() ){
          SoundPlay, % !MuteState ?  "mute.mp3" :  "unmute.mp3"
     }
     Return
}
isActiveWinFullscreen(){ ;returns true if the active window is fullscreen
     winID := WinExist( "A" )
     if ( !winID )
          Return false
     WinGet style, Style, ahk_id %WinID%
     WinGetPos ,,,winW,winH, %winTitle%
     return !((style & 0x20800000) or WinActive("ahk_class Progman") or WinActive("ahk_class WorkerW") or winH < A_ScreenHeight or winW < A_ScreenWidth)
          
}