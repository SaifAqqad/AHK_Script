#NoEnv
#NoTrayIcon
#include <VMR>
#include <VA>
#SingleInstance Ignore
SendMode Input
SetWorkingDir %A_ScriptDir%
runParams()
runParams(){
    Sleep, 24
    if(A_Args[1]=22){
        VMR_incGain(A_Args[2])
    }else if(A_Args[1]=23){
        VMR_decGain(A_Args[2])
    }else if(A_Args[1]=25){
        VMR_muteToggle(A_Args[2])
    }else if(A_Args[1]=31){
        VMR_setAudioDevice(A_Args[2],3,A_Args[3])
    }else if(A_Args[1]=13){
        VMR_restart()
    }else if(A_Args[1]=91){
        VA_SetMasterMute(!VA_GetMasterMute(A_Args[2] . ":1"), A_Args[2] . ":1")
    }
    Sleep,24
    ExitApp
}