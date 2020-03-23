#NoEnv
#include <VMR>
#include <RapidHotkey>
#Include <OSD>
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
~Media_Play_Pause::RapidHotkey("runMedia", 2,,1)

Volume_Up::
Vol:= VMR_incGain() 
showOSD("Gain: " . Vol,-1,"999999")
return

Volume_Down::
Vol:= VMR_decGain() 
showOSD("Gain: " . Vol,-1,"999999")
return

$<^Volume_Down:: ;Mutes Bus[0]
Mute:= VMR_muteToggle()
showOSD((Mute = 0.0 ? "Global Audio Muted" : "Global Audio Unmuted"),-1,"999999")
KeyWait, LControl 
Return

$<^<+Volume_Down:: ;Mutes System Audio 
Mute:= VMR_muteToggle("Strip[3]")
showOSD( (Mute = 0.0 ? "System Audio Muted" : "System Audio Unmuted"),-1,"999999" )
KeyWait, LControl 
Return

$#Volume_Down::
Vol:= VMR_decGain("Strip[4]") ;Decreases Media Audio Gain
showOSD("Media: " . Vol,-1,"999999")
return

$#Volume_Up::
Vol:= VMR_incGain("Strip[4]") ;increases Media Audio Gain
showOSD("Media: " . Vol,-1,"999999")
return

$<!Volume_Down::
Vol:= VMR_decGain("Strip[1]") ;Decreases Microphone Gain
showOSD("Microphone: " . Vol,-1,"999999")
return

$<!Volume_Up::
Vol:= VMR_incGain("Strip[1]") ;increases Microphone Gain
showOSD("Microphone: " . Vol,-1,"999999")
return

$<!<^Volume_Down::
Vol:= VMR_decGain("Strip[0]") ;Decreases Game chat Gain
showOSD("Gamechat: " . Vol,-1,"999999")
return

$<!<^Volume_Up::
Vol:= VMR_incGain("Strip[0]") ;increases Game chat Gain
showOSD("Gamechat: " . Vol,-1,"999999")
return

F7::
VMR_setAudioDevice("Bus[0]",3,"hs70") 
showOSD("Headphone Audio",-1,"999999")
return

F8::          
VMR_setAudioDevice("Bus[0]",3,"LG HDR")
showOSD("Monitor Audio",-1,"999999")
return
;=============================================Functions=============================================
MuteMic(){
     
     MuteState := VA_GetMasterMute("AmazonBasics:1")
     VA_SetMasterMute(!MuteState, "AmazonBasics:1")
     showOSD( (!MuteState ? "Microphone muted" : "Microphone online"),-1,"999999" ) 
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
showOSD(txt, OSD_Theme:=-1, OSD_Accent:=-1 ){
     if (WinActive("ahk_exe ModernWarfare.exe"))
          return
     OSD_spawn(txt,OSD_Theme,OSD_Accent)
}
runMedia:
     run, plexamp , C:\Users\%A_UserName%\AppData\Local\Programs\plexamp
     return