;********************************************************************************************************************;
;*                                            VoiceMeeterRemote Wrapper                                             *;
;******************************************************USAGE*********************************************************;
;*  VMR_login()  loads VoiceMeeter's Library and calls VM's login function                                          *;
;*  VMR_logout() Calls VM's logout function                                                                         *;
;*  VMR_restart() Restarts VoiceMeeter's Engine                                                                     *;
;*  VMR_checkParams() Calls VM's IsParametersDirty function                                                         *;
;*******                                                                                                      *******;
;*                  AudioBus: "Strip[i]" or "Bus[i]" ;i is zero based ;0-4 for VMBanana ;"Bus[0]" by default        *;
;*  VMR_getCurrentVol(AudioBus) returns the current volume for AudioBus                                             *;
;*  VMR_volUp(AudioBus) Increases the AudioBus volume by 2dB                                                        *;
;*  VMR_volDown(AudioBus) Decreases the AudioBus volume by 2dB                                                      *;
;*  VMR_setVol(AudioBus, Vol) Sets AudioBus volume to a specific Vol, Vol is given in dB                            *;
;*  VMR_muteToggle(AudioBus) Mutes AudioBus                                                                         *;
;*  VMR_getMuteState(AudioBus) Returns current mute status for AudioBus                                             *;
;*******                                                                                                      *******;
;*                  AudioBus: "Strip[i]" or "Bus[i]" ;Physical Buses/Strips ;0-2 for VMBanana                       *;
;*                  AudioDriver: "mme"/"wdm"/"ks"/"asio"                                                            *;
;*                  AudioDevice: The full Device name as shown in VoiceMeeter's GUI                                 *;
;*  VMR_setAudioDevice(AudioBus, AudioDriver, AudioDevice) Sets AudioDevice to the given AudioBus using AudioDriver *;
;********************************************************************************************************************;
Global VM_Path := "C:\Program Files\VB\Voicemeeter\"
Global VM_DLL := "VoicemeeterRemote"
Global VMR_VolType := 1 ;1 -> returns Vol as a percentage ;0 -> returns Vol in dB
VMR_login()
VMR_login(){
     if(A_Is64bitOS){
          VM_Path := "C:\Program Files (x86)\VB\Voicemeeter\"
          VM_DLL := "VoicemeeterRemote64"
     }
     VBVMRDLL := DllCall("LoadLibrary", "str", VM_Path . VM_DLL . ".dll")
     DllCall(VM_DLL . "\VBVMR_Login")
     SetTimer, VMR_checkParams, 20 ;calls VMR_checkParams() periodically
     OnExit("VMR_logout")
}
VMR_logout(){
     DllCall(VM_DLL . "\VBVMR_Logout")
     DllCall("FreeLibrary", "Ptr", VBVMRDLL) 
}
VMR_restart(){
     return DllCall(VM_DLL . "\VBVMR_SetParameterFloat","AStr","Command.Restart","Float","1.0f", "Int")
}
VMR_checkParams(){
     return DllCall(VM_DLL . "\VBVMR_IsParametersDirty")
}
VMR_getCurrentVol(AudioBus:="Bus[0]"){
     CurrentVol := 0.0
     NumPut(0.0, CurrentVol, 0, "Float")
     DllCall(VM_DLL . "\VBVMR_GetParameterFloat", "AStr" , AudioBus . ".Gain" , "Ptr" , &CurrentVol, "Int")
     CurrentVol := NumGet(CurrentVol, 0, "Float")
     return CurrentVol
}
VMR_volUp(AudioBus:="Bus[0]"){
     local Vol := VMR_getCurrentVol(AudioBus)
     Vol := ( Vol != 0.0 ? Vol+2 : 0.0)
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Gain" , "Float" , Vol , "Int")
     SetFormat, FloatFast, 4.1
     return (VMR_VolType ? ((Vol+60)/0.6) . "%" : Vol . "dB" )
}
VMR_volDown(AudioBus:="Bus[0]"){
     local Vol := VMR_getCurrentVol(AudioBus)
     Vol := ( Vol != -60.0 ? Vol-2 : -60.0 )
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Gain" , "Float" , Vol , "Int")
     SetFormat, FloatFast, 4.1
     return (VMR_VolType ? ((Vol+60)/0.6) . "%" : Vol . "dB" )     
}
VMR_setVol(AudioBus:="Bus[0]", Vol:=0.0){
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Gain" , "Float" , Vol , "Int")
     SetFormat, FloatFast, 4.1
     return (VMR_VolType ? ((Vol+60)/0.6) . "%" : Vol . "dB" )
}
VMR_getMuteState(AudioBus:="Bus[0]"){
     local MuteState := 0.0
     NumPut(0.0, MuteState, 0, "Float")
     DllCall(VM_DLL . "\VBVMR_GetParameterFloat", "AStr" , AudioBus . ".Mute" , "Ptr" , &MuteState , "Int")
     MuteState := NumGet(MuteState, 0, "Float")
     return MuteState
}
VMR_muteToggle(AudioBus:="Bus[0]"){
     local Mute := VMR_getMuteState(AudioBus)
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Mute" , "Float" , !Mute, "Int")    
     return VMR_getMuteState(AudioBus)
}
VMR_setAudioDevice(AudioBus, AudioDriver, AudioDevice){
     return DllCall("VoicemeeterRemote64\VBVMR_SetParameterStringA", "AStr", AudioBus . ".Device." . AudioDriver , "AStr" , AudioDevice , "Int")  
}
