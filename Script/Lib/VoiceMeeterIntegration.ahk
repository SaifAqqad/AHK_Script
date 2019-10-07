;===================================================VoiceMeeter Integration===================================================
;VM_Login()  loads VoiceMeeter's Library and calls the login function
;VM_Logout() Calls VM's logout function 
;VM_Restart() Restarts VoiceMeeter's Engine
;VM_CheckParams() Calls VM api's IsParametersDirty 
;AudioDevice Should be given as: "Strip[i]." or "Bus[i]." where i is zero based, 0-4 for VMBanana
;    getCurrentVol(AudioDevice) returns the current volume for AudioDevice
;    VolUp(AudioDevice) Increases the AudioDevice volume by 2dB
;    VolDown(AudioDevice) Decreases the AudioDevice volume by 2dB
;    MuteToggle(AudioDevice) Mutes AudioDevice
;    getMuteState(AudioDevice) Returns current mute status for AudioDevice
;DeviceNum is zero based, 0-4 for VMBanana, 
;    SwitchAudioDevice(DeviceNum) Mutes CurrentAudioDevice then changes CurrentAudioDevice to "Bus[DeviceNum]." then unmutes it
Global CurrentAudioDevice := "Bus[0]."
SetTimer, VM_CheckParams, 20 ;calls VM_CheckParams() periodically
VM_Login() {
     VBVMRDLL := DllCall("LoadLibrary", "str", "C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")
     DllCall("VoicemeeterRemote64\VBVMR_Login")
}
VM_Logout() {
     DllCall("VoicemeeterRemote64\VBVMR_Logout")
     DllCall("FreeLibrary", "Ptr", VBVMRDLL) 
}
VM_Restart(){
     DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat","AStr","Command.Restart","Float","1.0f", "Int")
     Return
}
VM_CheckParams(){
     DllCall("VoicemeeterRemote64\VBVMR_IsParametersDirty")
}
getCurrentVol(AudioDevice){
     CurrentVol := 0.0
     NumPut(0.0, CurrentVol, 0, "Float")
     DllCall("VoicemeeterRemote64\VBVMR_GetParameterFloat", "AStr" , AudioDevice . "Gain" , "Ptr" , &CurrentVol, "Int")
     CurrentVol := NumGet(CurrentVol, 0, "Float")
     return CurrentVol
}
VolUp(AudioDevice){
     local Vol := getCurrentVol(AudioDevice)
     Vol := ( Vol != 0.0 ? Vol+2 : 0.0)
     DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr" , AudioDevice . "Gain" , "Float" , Vol , "Int")
     SetFormat, FloatFast, 4.1
     ShowTooltip(Vol . " db")
}
VolDown(AudioDevice){
     local Vol := getCurrentVol(AudioDevice)
     Vol := ( Vol != -60.0 ? Vol-2 : -60.0 )
     DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr" , AudioDevice . "Gain" , "Float" , Vol , "Int")
     SetFormat, FloatFast, 4.1
     ShowTooltip(Vol . " db")
     
}
getMuteState(AudioDevice){
     local MuteState := 0.0
     NumPut(0.0, MuteState, 0, "Float")
     DllCall("VoicemeeterRemote64\VBVMR_GetParameterFloat", "AStr" , AudioDevice . "Mute" , "Ptr" , &MuteState , "Int")
     MuteState := NumGet(MuteState, 0, "Float")
     return MuteState
}
MuteToggle(AudioDevice){
     local Mute := getMuteState(AudioDevice)
     DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr" , AudioDevice . "Mute" , "Float" , !Mute, "Int")    
     Mute := getMuteState(AudioDevice)
     if (AudioDevice != CurrentAudioDevice ) {
          ShowTooltip( Mute = 0.0 ? "Strip Audio Muted" : "Strip Audio Unmuted" )
     }else{ 
          ShowTooltip( Mute = 0.0 ? "Audio Muted" : "Audio Unmuted" )
     }
}
SwitchAudioDevice(DeviceNum){
     if ((CurrentAudioDevice = "Bus[" . DeviceNum . "].")) {
          ShowTooltip("Already using this Device")
          return
     }
     if (getMuteState(CurrentAudioDevice) = 1.0){
          CurrentAudioDevice := "Bus[" . DeviceNum . "]."
          MuteToggle(CurrentAudioDevice)
     }else{
          MuteToggle(CurrentAudioDevice)
          CurrentAudioDevice := "Bus[" . DeviceNum . "]."
          MuteToggle(CurrentAudioDevice)
     }
     RemoveTooltip()
     ShowTooltip( DeviceNum = "0" ? "Headphone Audio" : "Monitor Audio" )
     Sleep, 100
     VM_Restart()
}
ShowTooltip(Message){ ;Shows the tooltip and returns true if the currently active window is not fullscreen
     winID := WinExist( "A" )
     if ( !winID )
          Return false
     WinGet style, Style, ahk_id %WinID%
     WinGetPos ,,,winW,winH, %winTitle%
     if ((style & 0x20800000) or WinActive("ahk_class Progman") or winH < A_ScreenHeight or winW < A_ScreenWidth){ 
          #Persistent
          ToolTip, %Message%
          SetTimer, RemoveTooltip, 700
          return true 
     }else{
          return false
     }
}
RemoveTooltip(){
     SetTimer, RemoveTooltip, Off
     ToolTip
     Return
}

