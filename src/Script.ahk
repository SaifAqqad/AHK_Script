#NoEnv
#Include <VMR>
#Include <RapidHotkey>
#Include <OSD>
SendMode Input
SetNumLockState AlwaysOff
FileInstall, .\sfx\mute.mp3, mute.mp3 ;Both sfx files are from Discord's sfx zip file https://t.co/AD6jvkePul 
FileInstall, .\sfx\unmute.mp3, unmute.mp3 ; ^
if (FileExist("Script.ico")) {
     Menu, Tray, Icon, %TrayIcon%
}
OSD_spawn("AHK starting up..")
Global DefaultMediaApp:=
Global Output1Name:=
Global Output1Driver:=
Global Output2Name:=
Global Output2Driver:=
Global Mic:= 
if (!FileExist("config.ini")) {
     IniWrite, DefaultMediaApp=""`n, config.ini, settings
     IniWrite, Output1Name=""`nOutput1Driver=""`nOutput2Name=""`nOutput2Driver=""`nMic=""`n, config.ini, devices
     editConfig()
}
readconfig()
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

>^End::ExitApp

>^Insert::editConfig()

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

F7::
VMR_setOutputDevice(0,Output1Name,Output1Driver) 
showOSD(Output1Name)
return

F8::         
VMR_setOutputDevice(0,Output2Name,Output2Driver)
showOSD(Output2Name)
return
;=============================================Functions=============================================
runMedia:
     Run, %DefaultMediaApp%,, Hide
     return
MuteMic(){
     MuteState := VA_GetMasterMute(Mic)
     VA_SetMasterMute(!MuteState, Mic)
     OSD_destroy()
     if (!MuteState){
          showOSD("Microphone muted","191919","E13502")
     }else{
          showOSD("Microphone online","191919","0066C1")
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
readconfig(){
     IniRead, DefaultMediaApp, config.ini, settings, DefaultMediaApp, %A_Space%
     IniRead, Output1Name, config.ini, devices, Output1Name, %A_Space%
     IniRead, Output1Driver, config.ini, devices, Output1Driver, %A_Space%
     IniRead, Output2Name, config.ini, devices, Output2Name, %A_Space%
     IniRead, Output2Driver, config.ini, devices, Output2Driver, %A_Space%
     IniRead, Mic, config.ini, devices, Mic, %A_Space%
     if(!DefaultMediaApp or !Output1Name or !Output1Driver or !Output2Name or !Output2Driver  or !Mic)
          editConfig()
}
editConfig(){
     showDevicesList()
     RunWait, notepad.exe config.ini
     Reload
}
showDevicesList(){
     FileDelete, list.temp
     outputlist:= VMR_getOutputDevicesList()
     inputlist:= VMR_getInputDevicesList()
     FileAppend,[Output Devices]`n, list.temp
     loop % outputlist.Length()
     {
          name:= outputlist[A_Index].Name
          driver:= outputlist[A_Index].Driver
          FileAppend,%name% : %driver%`n,list.temp
     }
     FileAppend,`n[Input Devices]`n,list.temp
     loop % inputlist.Length()
     {
          name:= inputlist[A_Index].Name
          driver:= inputlist[A_Index].Driver
          FileAppend,%name% : %driver%`n,list.temp     
     }
     Run, notepad.exe list.temp
}