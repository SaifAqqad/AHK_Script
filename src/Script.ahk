#NoEnv
#Include <VMR>
#Include <RapidHotkey>
#Include <OSD>
SendMode Input
SetNumLockState AlwaysOff
if (FileExist("Script.ico")) {
     Menu, Tray, Icon, Script.ico
}
OSD_spawn("AHK starting up..")
Global DefaultMediaApp, Output1Name, Output1Driver, Output2Name, Output2Driver
Global voicemeeter:= new VMR()
voicemeeter.login()
if (!FileExist("config.ini")) {
     IniWrite, DefaultMediaApp=""`n, config.ini, settings
     IniWrite, Output1Name=""`nOutput1Driver=""`nOutput2Name=""`nOutput2Driver=""`n, config.ini, devices
     editConfig()
}
readconfig()
;===============================================Global Hotkeys===============================================
<^<+R::voicemeeter.restart()

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

#if, (isActiveWinFullscreen())
CapsLock::Return
#if
     
F6::
     WinKill, ahk_exe speedtest.exe
     run, speedtest
return

;cycle through windows using mouse wheel
~XButton1 & WheelDown::AltTab
~XButton1 & WheelUp::ShiftAltTab
;===============================================Media Hotkeys===============================================
~Media_Play_Pause::RapidHotkey("runMedia", 2,,1)

Volume_Up::
     voicemeeter.bus[1].incGain()
     showOSD("Gain: " . voicemeeter.bus[1].getGain() . " dB" )
return

Volume_Down::
     voicemeeter.bus[1].decGain()
     showOSD("Gain: " . voicemeeter.bus[1].getGain() . " dB" )
return

$<^Volume_Down::
     voicemeeter.bus[1].toggleMute()
     showOSD(voicemeeter.bus[1].getMute() ? "Global Audio Muted" : "Global Audio Unmuted")
     KeyWait, LControl 
Return

$<^<+Volume_Down::
     voicemeeter.strip[4].toggleMute()
     showOSD(voicemeeter.strip[4].getMute() ? "Global Audio Muted" : "Global Audio Unmuted")
     KeyWait, LControl 
Return

$#Volume_Down::
     voicemeeter.strip[5].decGain()
     showOSD("Gain: " . voicemeeter.strip[5].getGain() . " dB" )
return

$#Volume_Up::
     voicemeeter.strip[5].incGain()
     showOSD("Gain: " . voicemeeter.strip[5].getGain() . " dB" )
return

F7::
     voicemeeter.bus[1].setDevice(Output1Name,Output1Driver)
return

F8::
     voicemeeter.bus[1].setDevice(Output2Name,Output2Driver)
return
;=============================================Functions=============================================
runMedia:
     Run, %DefaultMediaApp%,, Hide
return
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
     if(!DefaultMediaApp or !Output1Name or !Output1Driver or !Output2Name or !Output2Driver)
          editConfig()
}
editConfig(){
     showDevicesList()
     RunWait, notepad.exe config.ini
     Reload
}
showDevicesList(){
     FileDelete, list.tmp
     outputlist:= voicemeeter.VM_BUS.devices()
     inputlist:= voicemeeter.VM_STRIP.devices()
     FileAppend,[Output Devices]`n, list.tmp
     loop % outputlist.Length()
     {
          name:= outputlist[A_Index].Name
          driver:= outputlist[A_Index].Driver
          FileAppend,%name% : %driver%`n,list.tmp
     }
     FileAppend,`n[Input Devices]`n,list.tmp
     loop % inputlist.Length()
     {
          name:= inputlist[A_Index].Name
          driver:= inputlist[A_Index].Driver
          FileAppend,%name% : %driver%`n,list.tmp 
     }
     Run, notepad.exe list.tmp
}