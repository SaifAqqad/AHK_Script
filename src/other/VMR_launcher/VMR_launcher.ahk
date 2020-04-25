#NoEnv
#NoTrayIcon
#include %A_ScriptDir%\..\..\Lib\VMR.ahk
#include %A_ScriptDir%\..\..\Lib\VA.ahk
#SingleInstance Ignore
SendMode Input
SetWorkingDir %A_ScriptDir%
runParams:
    Sleep, 24
    if(A_Args[1]="gain++"){
        VMR_incGain(A_Args[2])
    }else if(A_Args[1]="gain--"){
        VMR_decGain(A_Args[2])
    }else if(A_Args[1]="mute"){
        VMR_muteToggle(A_Args[2])
    }else if(A_Args[1]="setAudioDevice"){
        VMR_setAudioDevice(A_Args[2],A_Args[3],A_Args[4])
    }else if(A_Args[1]="vmEngineRestart"){
        VMR_restart()
    }else if(A_Args[1]=91){
        VA_SetMasterMute(!VA_GetMasterMute(A_Args[2] . ":1"), A_Args[2] . ":1")
    }else if(A_Args[1]="help"){
        txt = `nvoicemeeter "cmd" "Strip/Bus[i]" [ "device type" "device name" ]`n`ncmd: `n              "gain++"             : increases gain by 2 dB`n              "gain--"            : decreases gain by 2 dB`n              "mute"             : toggles mute state`n              "setAudioDevice"  : `n              "vmEngineRestart" : restarts Voicemeeter's engine`n`nAudio device type: `n                  "1"   : mme`n                  "3"   : wdm`n                  "4"   : ks`n                  "5"   : asio`n`nexamples:`n         voicemeeter  gain++  Bus[0] `n         voicemeeter  gain--  Strip[3] `n         voicemeeter  setAudioDevice  Bus[0]  3  nvidia`n  
        MsgBox,,Usage,%txt%
    }
    Sleep,24
    ExitApp
