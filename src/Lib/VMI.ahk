;===================================================VoiceMeeter Integration===================================================
;VMI_login()  loads VoiceMeeter's Library and calls the login function
;VMI_logout() Calls VM's logout function 
;VMI_restart() Restarts VoiceMeeter's Engine
;VMI_checkParams() Calls VM api's IsParametersDirty 
;VMI_getCurrentAudioDevice() Returns VMI_currentAudioDevice, necessary for using VMI as a library
;AudioDevice Should be given as: "Strip[i]" or "Bus[i]" where i is zero based, 0-4 for VMBanana
;    VMI_getCurrentVol(AudioDevice) returns the current volume for AudioDevice
;    VMI_volUp(AudioDevice) Increases the AudioDevice volume by 2dB
;    VMI_volDown(AudioDevice) Decreases the AudioDevice volume by 2dB
;    VMI_setVol(AudioDevice, Vol) Sets AudioDevice volume to a specific Vol, Vol is given in dB
;    VMI_muteToggle(AudioDevice) Mutes AudioDevice
;    VMI_getMuteState(AudioDevice) Returns current mute status for AudioDevice
;AudioBus is given as: Bus[i]/Strip[i] i = 0-2 // AudioDriver is: "mme"/"wdm"/"ks"/"asio" // AudioDevice is the Device name given as a string
;    VMI_setAudioDevice(AudioBus, AudioDriver, AudioDevice)
VMI_login()
OnExit("VMI_logout")
SetTimer, VMI_checkParams, 20 ;calls VMI_checkParams() periodically
Global VMI_DefaultAudioDevice := "Bus[0]"
VMI_login(){
     VBVMRDLL := DllCall("LoadLibrary", "str", "C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")
     return DllCall("VoicemeeterRemote64\VBVMR_Login")
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
VMI_getCurrentVol(AudioDevice){
     CurrentVol := 0.0
     NumPut(0.0, CurrentVol, 0, "Float")
     DllCall("VoicemeeterRemote64\VBVMR_GetParameterFloat", "AStr" , AudioDevice . ".Gain" , "Ptr" , &CurrentVol, "Int")
     CurrentVol := NumGet(CurrentVol, 0, "Float")
     return CurrentVol
}
VMI_volUp(AudioDevice){
     local Vol := VMI_getCurrentVol(AudioDevice)
     Vol := ( Vol != 0.0 ? Vol+2 : 0.0)
     DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr" , AudioDevice . ".Gain" , "Float" , Vol , "Int")
     SetFormat, FloatFast, 4.1
     return Vol
}
VMI_volDown(AudioDevice){
     local Vol := VMI_getCurrentVol(AudioDevice)
     Vol := ( Vol != -60.0 ? Vol-2 : -60.0 )
     DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr" , AudioDevice . ".Gain" , "Float" , Vol , "Int")
     SetFormat, FloatFast, 4.1
     return Vol     
}
VMI_setVol(AudioDevice, Vol){
     DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr" , AudioDevice . ".Gain" , "Float" , Vol , "Int")
     SetFormat, FloatFast, 4.1
     return Vol
}
VMI_getMuteState(AudioDevice){
     local MuteState := 0.0
     NumPut(0.0, MuteState, 0, "Float")
     DllCall("VoicemeeterRemote64\VBVMR_GetParameterFloat", "AStr" , AudioDevice . ".Mute" , "Ptr" , &MuteState , "Int")
     MuteState := NumGet(MuteState, 0, "Float")
     return MuteState
}
VMI_muteToggle(AudioDevice){
     local Mute := VMI_getMuteState(AudioDevice)
     DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr" , AudioDevice . ".Mute" , "Float" , !Mute, "Int")    
     return VMI_getMuteState(AudioDevice)
}
VMI_setAudioDevice(AudioBus, AudioDriver, AudioDevice){
     return DllCall("VoicemeeterRemote64\VBVMR_SetParameterStringA", "AStr", AudioBus . ".Device." . AudioDriver , "AStr" , AudioDevice , "Int")  
}
VMI_showTooltip(Message){ ;Shows the tooltip and returns true if the currently active window is not fullscreen
     winID := WinExist( "A" )
     if ( !winID )
          Return false
     WinGet style, Style, ahk_id %WinID%
     WinGetPos ,,,winW,winH, %winTitle%
     if ((style & 0x20800000) or WinActive("ahk_class Progman") or winH < A_ScreenHeight or winW < A_ScreenWidth){ 
          #Persistent
          ToolTip, %Message%
          SetTimer, VMI_removeTooltip, 700
          return true 
     }else{
          return false
     }
}
VMI_removeTooltip(){
     SetTimer, VMI_removeTooltip, Off
     ToolTip
}
