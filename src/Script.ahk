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

#Space::SendInput {CtrlDown}{F3}

!Space::
clipboard = 
SendInput {CTRLDOWN}c{CTRLUP}
ClipWait, 1
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

Volume_Up::showOSD("Gain: " . VMR_incGain(,1) ) ;Increase Bus[0] gain

Volume_Down::showOSD("Gain: " . VMR_decGain(,1)) ;Decrease Bus[0] gain

$<^Volume_Down:: ;Mutes Bus[0]
Mute:= VMR_muteToggle()
showOSD((Mute ? "Global Audio Muted" : "Global Audio Unmuted"))
KeyWait, LControl 
Return

$<^<+Volume_Down:: ;Mutes System Audio 
Mute:= VMR_muteToggle("Strip[3]")
showOSD( (Mute ? "System Audio Muted" : "System Audio Unmuted") )
KeyWait, LControl 
Return

$#Volume_Down::showOSD("Media: " . VMR_decGain("Strip[4]",1)) ;Decreases Media Audio Gain

$#Volume_Up::showOSD("Media: " . VMR_incGain("Strip[4]",1)) ;increases Media Audio Gain

$<!Volume_Down::showOSD("Microphone: " . VMR_decGain("Strip[1]")) ;Decreases Microphone Gain

$<!Volume_Up::showOSD("Microphone: " . VMR_incGain("Strip[1]") ) ;increases Microphone Gain

$<!<^Volume_Down::showOSD("Gamechat: " . VMR_decGain("Strip[0]",1) ) ;Decreases Game chat Gain

$<!<^Volume_Up::showOSD("Gamechat: " . VMR_incGain("Strip[0]",1)) ;increases Game chat Gain

F7::showOSD("A1: " . VMR_setOutputDevice(0,"hs70"))

F8::showOSD("A1: " . VMR_setOutputDevice(0,"LG HDR"))
;=============================================Functions=============================================
MuteMic(){
     MuteState := VA_GetMasterMute("AmazonBasics:1")
     VA_SetMasterMute(!MuteState, "AmazonBasics:1")
     if (!MuteState){
          showOSD("Microphone muted",,"B10501")
     }else{
          showOSD("Microphone online",,"21D725")
     }
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
     if (WinActive("ahk_exe ModernWarfare.exe") or WinActive("ahk_exe VALORANT-Win64-Shipping.exe"))
          return
     OSD_spawn(txt,OSD_Theme,OSD_Accent)
}
runMedia:
     run, plexamp , C:\Users\%A_UserName%\AppData\Local\Programs\plexamp
     return