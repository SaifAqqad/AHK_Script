#NoEnv
#Include, %A_ScriptDir%\Lib\VoiceMeeterIntegration.ahk
OnExit("VMLogout")
VMLogin()
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
<^<+R::RestartVM()

#Space::#s 

<!<+::#Space 

^End::ExitApp

*RShift::MuteMic()

#if, (!ShowTooltip(""))
CapsLock::Return
#if

;=======================================Media Hotkeys=======================================
<!S::
DefaultMediaApp := "Spotify.exe"
ShowTooltip("Using Spotify")
Return

<!P::
DefaultMediaApp := "plexamp.exe"
ShowTooltip("Using Plexamp")
Return

F11::SwitchAudioDevice("0") 

F12::SwitchAudioDevice("1") 

$Media_Play_Pause::PlayPauseRun() 

$^Media_Play_Pause::sendInput {Media_Play_Pause} 

Volume_Up::VolUp(CurrentAudioDevice) 

Volume_Down::VolDown(CurrentAudioDevice) 

$<^Volume_Down:: ;Mutes CurrentAudioDevice
MuteToggle(CurrentAudioDevice)
KeyWait, LControl 
Return

$<^<+Volume_Down:: ;Mutes System Audio Strip
MuteToggle("Strip[3].")
KeyWait, LControl 
Return

$#Volume_Down::VolDown("Strip[4].") ;Decreases Media Audio Strip volume

$#Volume_Up::VolUp("Strip[4].") ;increases Media Audio Strip volume
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
PlayPauseRun() ;either runs DefaultMediaApp then sends Media_play_pause or just sends it immediately
{
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
MuteMic() ;toggles the microphone then either displays a toolkit or plays a sound effect
{
     MuteState := VA_GetMasterMute("AmazonBasics:1")
     VA_SetMasterMute(!MuteState, "AmazonBasics:1")
     if ( !ShowTooltip( !MuteState == True ? "Microphone muted" : "Microphone online" ) ){
          SoundPlay, % !MuteState == True ?  "mute.mp3" :  "unmute.mp3"
     }
     Return
}

