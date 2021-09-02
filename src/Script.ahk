;@Ahk2Exe-SetMainIcon Script.ico
#Include <VMR\VMR>
#Include <OSD>
#Include <RapidHotkey>
#MaxThreadsBuffer, On

Menu, Tray, NoStandard
fObj:= Func("tray_suspend")
Menu, Tray, add, Suspend Hotkeys, % fObj
fObj:= Func("tray_reload")
Menu, Tray, add, Reload Script, % fObj
fObj:= Func("tray_exit")
Menu, Tray, add, Exit Script, % fObj

global vm := new VMR().login()
, osd_obj:= new OSD("",1)
, tts:= ComObjCreate("SAPI.SpVoice")
osd_obj.setTheme("0A0E14")

#Include, %A_ScriptDir%\hotkeys
#Include, voicemeeter.ahk
#Include, spotify.ahk
#Include, valorant.ahk
#Include, wt.ahk
#Include, speedtest.ahk
#Include, clipboardSearch.ahk

tray_reload(){
    Reload
}

tray_suspend(){
    Suspend, -1
}

tray_exit(){
    ExitApp, 0
}