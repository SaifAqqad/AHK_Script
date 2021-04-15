;@Ahk2Exe-SetMainIcon Script.ico
#Include <VMR>
#Include <OSD>
#Include <RapidHotkey>

global vm := new VMR()
, osd_obj:= new OSD("",1)
, tts:= ComObjCreate("SAPI.SpVoice")
vm.login()
osd_obj.setTheme("2D2C2C")

#Include, %A_ScriptDir%\hotkeys
#Include, voicemeeter.ahk
#Include, spotify.ahk
#Include, valorant.ahk
#Include, wt.ahk
#Include, speedtest.ahk
#Include, clipboardSearch.ahk