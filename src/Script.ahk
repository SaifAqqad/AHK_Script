#NoEnv
#include <VMI>
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
;=======================================Global Hotkeys=======================================
<^<+R::VMI_restart()

#Space::#s 

<!<+::#Space 

^End::ExitApp

*RShift::MuteMic()

#if, (!VMI_showTooltip(""))
CapsLock::Return
#if

;=======================================Media Hotkeys=======================================
<!S::
DefaultMediaApp := "Spotify.exe"
VMI_showTooltip("Using Spotify")
Return

<!P::
DefaultMediaApp := "plexamp.exe"
VMI_showTooltip("Using Plexamp")
Return

$Media_Play_Pause::PlayPauseRun() 

$^Media_Play_Pause::sendInput {Media_Play_Pause} 

Volume_Up::
Vol:= VMI_volUp(VMI_DefaultAudioDevice) 
VMI_showTooltip(Vol . " db")
return

Volume_Down::
Vol:= VMI_volDown(VMI_DefaultAudioDevice) 
VMI_showTooltip(Vol . " db")
return

$<^Volume_Down:: ;Mutes VMI_DefaultAudioDevice
Mute:= VMI_muteToggle(VMI_DefaultAudioDevice)
VMI_showTooltip( Mute = 0.0 ? "Audio Muted" : "Audio Unmuted" )
KeyWait, LControl 
Return

$<^<+Volume_Down:: ;Mutes System Audio Strip
Mute:= VMI_muteToggle("Strip[3]")
VMI_showTooltip( Mute = 0.0 ? "System Audio Muted" : "System Audio Unmuted" )
KeyWait, LControl 
Return

$#Volume_Down::
Vol:= VMI_volDown("Strip[4]") ;Decreases Media Audio Strip volume
VMI_showTooltip(Vol . " db")
return

$#Volume_Up::
Vol:= VMI_volUp("Strip[4]") ;increases Media Audio Strip volume
VMI_showTooltip(Vol . " db")
return

F7::
VMI_setAudioDevice("Bus[0]","wdm","Headset Earphone (Corsair HS70 Wireless Gaming Headset)")
VMI_showTooltip("Headphone Audio")
return

F8::          
VMI_setAudioDevice("Bus[0]","wdm","LG HDR WFHD (2- AMD High Definition Audio Device)")
VMI_showTooltip("Monitor Audio")
return

;====================================Fortnite Macros========================================
#if, WinActive("ahk_exe FortniteClient-Win64-Shipping.exe")
;Build reset macro
$XButton2:: 
sendInput, {g}
sleep,30
sendInput, {RButton}
sleep, 30
sendInput, {g}
sleep, 30
Return
;Hold Edit-building key macro
$g::
sendInput {g}
KeyWait, g
Return
$g Up::
SendInput {g}
Return
#if
;=====================================Functions=====================================
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
     if ( !VMI_showTooltip( !MuteState == True ? "Microphone muted" : "Microphone online" ) ){
          SoundPlay, % !MuteState == True ?  "mute.mp3" :  "unmute.mp3"
     }
     Return
}
