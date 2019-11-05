;********************************************************************************************************************;
;*                                            VoiceMeeter Interface                                                 *;
;******************************************************USAGE*********************************************************;
;*  VMI_login()  loads VoiceMeeter's Library and calls VM's login function                                          *;
;*  VMI_logout() Calls VM's logout function                                                                         *;
;*  VMI_restart() Restarts VoiceMeeter's Engine                                                                     *;
;*  VMI_checkParams() Calls VM's IsParametersDirty function                                                         *;
;*******                                                                                                      *******;
;*                  AudioBus: "Strip[i]" or "Bus[i]" ;i is zero based ;0-4 for VMBanana ;"Bus[0]" by default                            *;
;*  VMI_getCurrentVol(AudioBus) returns the current volume for AudioBus                                             *;
;*  VMI_volUp(AudioBus) Increases the AudioBus volume by 2dB                                                        *;
;*  VMI_volDown(AudioBus) Decreases the AudioBus volume by 2dB                                                      *;
;*  VMI_setVol(AudioBus, Vol) Sets AudioBus volume to a specific Vol, Vol is given in dB                            *;
;*  VMI_muteToggle(AudioBus) Mutes AudioBus                                                                         *;
;*  VMI_getMuteState(AudioBus) Returns current mute status for AudioBus                                             *;
;*******                                                                                                      *******;
;*                  AudioBus: "Strip[i]" or "Bus[i]" ;Physical Buses/Strips ;0-2 for VMBanana                       *;
;*                  AudioDriver: "mme"/"wdm"/"ks"/"asio"                                                            *;
;*                  AudioDevice: The full Device name as shown in VoiceMeeter's GUI                                 *;
;*  VMI_setAudioDevice(AudioBus, AudioDriver, AudioDevice) Sets AudioDevice to the given AudioBus using AudioDriver *;
;*******                                                                                                      *******;
;*                                                  GUI                                                             *;
;*  VMI_GUIspawn(txt) Displays a custom GUI in the bottom center area of the screen containing the txt string       *;
;********************************************************************************************************************;
Global VM_Path := "C:\Program Files (x86)\VB\Voicemeeter\"
Global VMI_VolType := "%"
Global VMI_GUIstate := "closed"
Global VMI_GUItxt :=
Global AccentColor:=
VMI_login()
VMI_login(){
     VBVMRDLL := DllCall("LoadLibrary", "str", VM_Path . "VoicemeeterRemote64.dll")
     DllCall("VoicemeeterRemote64\VBVMR_Login")
     SetTimer, VMI_checkParams, 20 ;calls VMI_checkParams() periodically
     OnExit("VMI_logout")
     VMI_GUIgetAccentColor()
}
VMI_logout(){
     DllCall("VoicemeeterRemote64\VBVMR_Logout")
     DllCall("FreeLibrary", "Ptr", VBVMRDLL) 
}
VMI_restart(){
     return DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat","AStr","Command.Restart","Float","1.0f", "Int")
}
VMI_checkParams(){
     return DllCall("VoicemeeterRemote64\VBVMR_IsParametersDirty")
}
VMI_getCurrentVol(AudioBus:="Bus[0]"){
     CurrentVol := 0.0
     NumPut(0.0, CurrentVol, 0, "Float")
     DllCall("VoicemeeterRemote64\VBVMR_GetParameterFloat", "AStr" , AudioBus . ".Gain" , "Ptr" , &CurrentVol, "Int")
     CurrentVol := NumGet(CurrentVol, 0, "Float")
     return CurrentVol
}
VMI_volUp(AudioBus:="Bus[0]"){
     local Vol := VMI_getCurrentVol(AudioBus)
     Vol := ( Vol != 0.0 ? Vol+2 : 0.0)
     DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Gain" , "Float" , Vol , "Int")
     SetFormat, FloatFast, 4.1
     return (VMI_VolType = "%" ? ((Vol+60)/60)*100 . "%" : Vol )
}
VMI_volDown(AudioBus:="Bus[0]"){
     local Vol := VMI_getCurrentVol(AudioBus)
     Vol := ( Vol != -60.0 ? Vol-2 : -60.0 )
     DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Gain" , "Float" , Vol , "Int")
     SetFormat, FloatFast, 4.1
     return (VMI_VolType = "%" ? ((Vol+60)/60)*100 . "%" : Vol )     
}
VMI_setVol(AudioBus:="Bus[0]", Vol:=0.0){
     DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Gain" , "Float" , Vol , "Int")
     SetFormat, FloatFast, 4.1
     return (VMI_VolType = "%" ? ((Vol+60)/60)*100 . "%" : Vol )
}
VMI_getMuteState(AudioBus:="Bus[0]"){
     local MuteState := 0.0
     NumPut(0.0, MuteState, 0, "Float")
     DllCall("VoicemeeterRemote64\VBVMR_GetParameterFloat", "AStr" , AudioBus . ".Mute" , "Ptr" , &MuteState , "Int")
     MuteState := NumGet(MuteState, 0, "Float")
     return MuteState
}
VMI_muteToggle(AudioBus:="Bus[0]"){
     local Mute := VMI_getMuteState(AudioBus)
     DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Mute" , "Float" , !Mute, "Int")    
     return VMI_getMuteState(AudioBus)
}
VMI_setAudioDevice(AudioBus, AudioDriver, AudioDevice){
     return DllCall("VoicemeeterRemote64\VBVMR_SetParameterStringA", "AStr", AudioBus . ".Device." . AudioDriver , "AStr" , AudioDevice , "Int")  
}
VMI_GUIspawn(txt){
     if (VMI_GUIstate = "closed"){
        Gui, Color, 191919, %AccentColor%
        Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption -Border
        WinSet, Transparent, 240, ahk_class AutoHotkeyGUI
        Gui, Font, s11, Segoe UI
        Gui, Add, Text, c%AccentColor% vVMI_GUItxt W160 Center, %txt%
        Gui, Show, xCenter Y980 AutoSize NoActivate 
        VMI_GUIstate:= "open"
    }else{
        GuiControl, Text, VMI_GUItxt, %txt% 
    }
    SetTimer, VMI_GUIdestroy, 700
}
VMI_GUIgetAccentColor(){
     RegRead, AccentColor, HKCU\SOFTWARE\Microsoft\Windows\DWM, ColorizationColor 
     SetFormat, integer, hex
     AccentColor := AccentColor+0
     StringRight, AccentColor, AccentColor, 6
}
VMI_GUIdestroy(){
    Gui, Destroy
    VMI_GUIstate:= "closed"
    SetTimer, VMI_GUIdestroy, Off
}