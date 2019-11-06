#NoEnv
#include <VMI>
#include <GUI>
SendMode Input
SetWorkingDir %A_ScriptDir%
DetectHiddenWindows, On
SetNumLockState AlwaysOff
FileInstall, .\SoundEffects\mute.mp3, mute.mp3 ;Both sfx files are from Discord's sfx zip file https://t.co/AD6jvkePul 
FileInstall, .\SoundEffects\unmute.mp3, unmute.mp3 ; ^
TrayIcon := A_ScriptDir . "\Script.ico"
if (FileExist(TrayIcon)) {
     Menu, Tray, Icon, %TrayIcon%
}
Global DefaultMediaApp := "plexamp.exe"
GUI_spawn("AHK starting up..")
;===============================================Global Hotkeys===============================================
<^<+R::VMI_restart()

#Space::#s 

<!<+::#Space 

^End::ExitApp

*RShift::MuteMic()

#if, (isActiveWinFullscreen())
CapsLock::Return
#if

;===============================================Media Hotkeys===============================================
<!S::
DefaultMediaApp := "Spotify.exe"
GUI_spawn("Using Spotify")
Return

<!P::
DefaultMediaApp := "plexamp.exe"
GUI_spawn("Using Plexamp")
Return

$Media_Play_Pause::PlayPauseRun() 

$^Media_Play_Pause::sendInput {Media_Play_Pause} 

Volume_Up::
Vol:= VMI_volUp() 
GUI_spawn("Volume: " . Vol)
return

Volume_Down::
Vol:= VMI_volDown() 
GUI_spawn("Volume: " . Vol)
return

$<^Volume_Down:: ;Mutes Bus[0]
Mute:= VMI_muteToggle()
GUI_spawn( Mute = 0.0 ? "Audio Muted" : "Audio Unmuted" )
KeyWait, LControl 
Return

$<^<+Volume_Down:: ;Mutes System Audio 
Mute:= VMI_muteToggle("Strip[3]")
GUI_spawn( Mute = 0.0 ? "System Audio Muted" : "System Audio Unmuted" )
KeyWait, LControl 
Return

$#Volume_Down::
Vol:= VMI_volDown("Strip[4]") ;Decreases Media Audio volume
GUI_spawn("Media Volume: " . Vol)
return

$#Volume_Up::
Vol:= VMI_volUp("Strip[4]") ;increases Media Audio volume
GUI_spawn("Media Volume: " . Vol)
return

$<!Volume_Down::
Vol:= VMI_volDown("Strip[1]") ;Decreases Microphone volume
GUI_spawn("Microphone Volume: " . Vol)
return

$<!Volume_Up::
Vol:= VMI_volUp("Strip[1]") ;increases Microphone volume
GUI_spawn("Microphone Volume: " . Vol)
return

$<!<^Volume_Down::
Vol:= VMI_volDown("Strip[0]") ;Decreases Game chat volume
GUI_spawn("Game chat Volume: " . Vol)
return

$<!<^Volume_Up::
Vol:= VMI_volUp("Strip[0]") ;increases Game chat volume
GUI_spawn("Game chat Volume: " . Vol)
return

F7::
VMI_setAudioDevice("Bus[0]","wdm","Headset Earphone (Corsair HS70 Wireless Gaming Headset)")
GUI_spawn("Headphone Audio")
return

F8::          
VMI_setAudioDevice("Bus[0]","wdm","LG HDR WFHD (2- AMD High Definition Audio Device)")
GUI_spawn("Monitor Audio")
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
PlayPauseRun(){ ;either runs DefaultMediaApp then sends Media_play_pause or just sends it immediately
     
     if (WinExist("ahk_exe Spotify.exe") or WinExist("ahk_exe Anghami.exe") or WinExist("ahk_exe Plex.exe") or WinExist("ahk_exe Plexamp.exe")){
          SendInput, {Media_Play_Pause}
     }else {
          run, open %DefaultMediaApp%
          if ( DefaultMediaApp != "plexamp.exe" ){
               Sleep, 3500
               sendInput, {Media_Play_Pause}
          }
     }
     Return
}
MuteMic(){          ;toggles the microphone then either displays a toolkit or plays a sound effect
     
     MuteState := VA_GetMasterMute("AmazonBasics:1")
     VA_SetMasterMute(!MuteState, "AmazonBasics:1")
     GUI_spawn( !MuteState == True ? "Microphone muted" : "Microphone online" ) 
     if ( isActiveWinFullscreen() ){
          SoundPlay, % !MuteState == True ?  "mute.mp3" :  "unmute.mp3"
     }
     Return
}
isActiveWinFullscreen(){ ;returns true if the currently active window is fullscreen
     winID := WinExist( "A" )
     if ( !winID )
          Return false
     WinGet style, Style, ahk_id %WinID%
     WinGetPos ,,,winW,winH, %winTitle%
     return !((style & 0x20800000) or WinActive("ahk_class Progman") or WinActive("ahk_class WorkerW") or winH < A_ScreenHeight or winW < A_ScreenWidth)
          
}