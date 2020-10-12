#NoEnv
#Include %A_ScriptDir%\Lib\VMR.ahk\VMR.ahk
#Include <RapidHotkey>
#Include <OSD>
SendMode Input
SetNumLockState AlwaysOff
if (FileExist("Script.ico")) {
     Menu, Tray, Icon, Script.ico
}
OSD_spawn("AHK starting up..")
Global DefaultMediaApp, Output1Name, Output1Driver, Output2Name, Output2Driver, voicemeeter:= new VMR()
voicemeeter.login()
globalAudio:= voicemeeter.bus[1], mediaAudio:= voicemeeter.strip[5], micInput:= voicemeeter.strip[2], chatAudio:= voicemeeter.strip[1]
if (!FileExist("config.ini")) {
     IniWrite, DefaultMediaApp=""`n, config.ini, settings
     IniWrite, Output1Name=""`nOutput1Driver=""`nOutput2Name=""`nOutput2Driver=""`n, config.ini, devices
     editConfig()
}
readconfig()
;===============================================Global Hotkeys===============================================
<^<+R::voicemeeter.command.restart()

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

^+B::
     ClipWait
     SplitPath, Clipboard,,,,fName
     fName:= StrReplace(fName, "%20", A_Space)
     if Clipboard contains file:// 
          FileCreateShortcut, C:\Program Files\Mozilla Firefox\firefox.exe, %A_Desktop%\%fName%.lnk,, %Clipboard%
return

#if, (isActiveWinFullscreen())
CapsLock::Return
#if
     
F6::
     WinKill, ahk_exe speedtest.exe
     run, speedtest
return

Alt & WheelDown::SendInput, {PgDn}

Alt & WheelUp::SendInput, {PgUp}

;cycle through windows using mouse wheel
#If, (!isActiveWinFullscreen())
~XButton1 & WheelDown::AltTab
~XButton1 & WheelUp::ShiftAltTab
#If
;===============================================Media Hotkeys===============================================
~Media_Play_Pause::RapidHotkey("runMedia", 2,,1)
;--------------------Voicemeeter-------------------------
; global audio
Volume_Up::
gain:= globalAudio.getPercentage(++globalAudio.gain)
OSD_spawn("Global gain: " . gain . "%",,, 1, gain)
return

Volume_Down::
gain:= globalAudio.getPercentage(--globalAudio.gain)
OSD_spawn("Global gain: " . gain . "%",,, 1, gain)
return

<^M::OSD_spawn("Global Audio " . ((globalAudio.mute:=-1)? "muted" : "unmuted"),,, 1)

!1::OSD_spawn("A1: " . globalAudio.device[Output1Driver]:=Output1Name,,, 1)

!2::OSD_spawn("A1: " . globalAudio.device[Output2Driver]:=Output2Name,,, 1)
;---------------------------------------
; media audio
!Volume_Up::
gain:= mediaAudio.getPercentage(++mediaAudio.gain)
OSD_spawn(mediaAudio.getParameter("Label") . ":" . gain . "%",,, 1, gain)
return

!Volume_Down::
gain:= mediaAudio.getPercentage(--mediaAudio.gain)
OSD_spawn(mediaAudio.getParameter("Label") . ":" . gain . "%",,, 1, gain)
return

<!M::OSD_spawn(mediaAudio.getParameter("Label") . ((mediaAudio.mute:=-1)? " muted" : " unmuted"),,, 1)
;---------------------------------------
; mic audio
#If, (GetKeyState("Alt"))
A & Volume_Up::
gain:= micInput.getPercentage(++micInput.gain)
OSD_spawn(micInput.getParameter("Label") . ":" . gain . "%",,, 1, gain)
return

A & Volume_Down::
gain:= micInput.getPercentage(--micInput.gain)
OSD_spawn(micInput.getParameter("Label") . ":" . gain . "%",,, 1, gain)
return
#If

!F1::
     micInput.setParameter("fx_x","0")
     micInput.setParameter("fx_y","0")
return

!F2::
     micInput.setParameter("fx_x","0.23")
     micInput.setParameter("fx_y","0.5")
return
;---------------------------------------
; chat audio
#If, (GetKeyState("Alt"))
Q & Volume_Up::
gain:= chatAudio.getPercentage(++chatAudio.gain)
OSD_spawn(chatAudio.getParameter("Label") . ":" . gain . "%",,, 1, gain)
return

Q & Volume_Down::
gain:= chatAudio.getPercentage(--chatAudio.gain)
OSD_spawn(chatAudio.getParameter("Label") . ":" . gain . "%",,, 1, gain)
return
#If

!`::OSD_spawn(chatAudio.getParameter("Label") . ((chatAudio.mute:=-1)? " muted" : " unmuted"),,, 1)
;---------------------------------------
; recorder hotkeys
<!R::
     if(voicemeeter.recorder.record)
          return
     voicemeeter.recorder.armStrips(1)
     voicemeeter.recorder.record:=1
     OSD_spawn("Recording started",,, 1)
return

<!S::
     voicemeeter.recorder.stop:=1
     voicemeeter.command.eject()
     OSD_spawn("Recording stopped",,, 1)
return
;=============================================Functions=============================================
runMedia:
     Run, %DefaultMediaApp%,, Hide
return
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
     RunWait, notepad.exe config.ini
     Reload
}