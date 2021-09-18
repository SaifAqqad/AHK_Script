;@Ahk2Exe-SetMainIcon Script.ico
;@Ahk2Exe-Base Unicode 64*

#Include <JSON>
#Include <SpotifyAPI>
#Include <OSD>
#Include <RapidHotkey>
#MaxThreadsBuffer, On
tray_init()

if(!FileExist("config.json"))
    tray_editConfig()

global config:= JSON.Load(FileOpen("config.json","R").Read())
, spotify:= new SpotifyAPI(config.token)
, osd_obj:= new OSD("",1)
, tts:= ComObjCreate("SAPI.SpVoice")
osd_obj.setTheme("0A0E14")

#Include, %A_ScriptDir%\hotkeys
#Include, spotify.ahk
#Include, valorant.ahk
#Include, wt.ahk
#Include, speedtest.ahk
#Include, clipboardSearch.ahk


tray_init(){
    Menu, Tray, NoStandard
    fObj:= Func("tray_toggleAutoStart")
    Menu, Tray, add, Start on boot, % fObj
    Menu, Tray, % tray_autoStartEnabled()? "Check" : "Uncheck", Start on boot
    fObj:= Func("tray_suspend")
    Menu, Tray, add, Suspend Hotkeys, % fObj
    fObj:= Func("tray_reload")
    Menu, Tray, add, Reload Script, % fObj
    fObj:= Func("tray_editConfig")
    Menu, Tray, add, Edit Config, % fObj
    fObj:= Func("tray_exit")
    Menu, Tray, add, Exit, % fObj
}

tray_reload(){
    Reload
}

tray_suspend(){
    Suspend, -1
}

tray_exit(){
    ExitApp, 0
}

tray_editConfig(){
    RunWait, Notepad.exe "%A_ScriptDir%\config.json"
    Reload
}

tray_toggleAutoStart(){
    if(tray_autoStartEnabled())
        RegDelete, HKCU\Software\Microsoft\Windows\CurrentVersion\Run, AHK_Script
    else
        RegWrite, REG_SZ, HKCU\Software\Microsoft\Windows\CurrentVersion\Run, AHK_Script, "%A_ScriptFullPath%"
    Menu, Tray, % tray_autoStartEnabled()? "Check" : "Uncheck", Start on boot
}

tray_autoStartEnabled(){
    Try RegRead, val, HKCU\Software\Microsoft\Windows\CurrentVersion\Run, AHK_Script
    return val? 1 : 0
}