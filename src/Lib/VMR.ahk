;********************************************************************************************************************;
;*                                            VoiceMeeterRemote Wrapper                                             *;
;******************************************************USAGE*********************************************************;
;*  VMR_login()  loads VoiceMeeter's Library and calls VM's login function                                          *;
;*  VMR_logout() Calls VM's logout function                                                                         *;
;*  VMR_restart() Restarts VoiceMeeter's Engine                                                                     *;
;*  VMR_checkParams() Calls VM's IsParametersDirty function                                                         *;
;*******                                                                                                      *******;
;*                  AudioBus: "Strip[i]" or "Bus[i]" ;i is zero based ;0-4 for VMBanana ;"Bus[0]" by default        *;
;*  VMR_getCurrentGain(AudioBus) returns the current Gain for AudioBus                                              *;
;*  VMR_incGain(AudioBus) Increases the AudioBus Gain by 2dB                                                        *;
;*  VMR_decGain(AudioBus) Decreases the AudioBus Gain by 2dB                                                        *;
;*  VMR_setGain(AudioBus, Gain) Sets AudioBus Gain                                                                  *;
;*  VMR_muteToggle(AudioBus) Mutes AudioBus                                                                         *;
;*  VMR_getMuteState(AudioBus) Returns current mute status for AudioBus                                             *;
;*******                                                                                                      *******;
;*                  AudioBus: "Strip[i]" or "Bus[i]" ;Physical Buses/Strips ;0-2 for VMBanana                       *;
;*                  AudioDriver:  1 for mme / 3 for wdm / 4 for ks / 5 for asio                                     *;
;*                  AudioDevice: any substring of an audio device's full name that's shown in VoiceMeeter's GUI     *;
;*  VMR_setAudioDevice(AudioBus, AudioDriver, AudioDevice)                                                          *;
;********************************************************************************************************************;
Global VM_Path := "C:\Program Files\VB\Voicemeeter\"
Global VM_DLL := "VoicemeeterRemote"
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
VMR_getCurrentGain(AudioBus:="Bus[0]"){
     CurrentGain := 0.0
     NumPut(0.0, CurrentGain, 0, "Float")
     DllCall(VM_DLL . "\VBVMR_GetParameterFloat", "AStr" , AudioBus . ".Gain" , "Ptr" , &CurrentGain, "Int")
     CurrentGain := NumGet(CurrentGain, 0, "Float")
     return CurrentGain
}
VMR_incGain(AudioBus:="Bus[0]"){
     local Gain := VMR_getCurrentGain(AudioBus)
     Gain := ( Gain != 0.0 ? Gain+2 : 0.0)
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Gain" , "Float" , Gain , "Int")
     SetFormat, FloatFast, 4.1
     return Gain . "dB" 
}
VMR_decGain(AudioBus:="Bus[0]"){
     local Gain := VMR_getCurrentGain(AudioBus)
     Gain := ( Gain != -60.0 ? Gain-2 : -60.0 )
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Gain" , "Float" , Gain , "Int")
     SetFormat, FloatFast, 4.1
     return Gain . "dB" 
}
VMR_setGain(AudioBus:="Bus[0]", Gain:=0.0){
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Gain" , "Float" , Gain , "Int")
     SetFormat, FloatFast, 4.1
     return Gain . "dB" 
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
     numDevices := DllCall(VM_DLL . "\VBVMR_Output_GetDeviceNumber","Int")
     loop %numDevices%
     {
          VarSetCapacity(dName, 1000)
          VarSetCapacity(dType, 1000)
          DllCall(VM_DLL . "\VBVMR_Output_GetDeviceDescW", "Int", A_Index-1, "Ptr" , &dType , "Ptr", &dName, "Ptr", 0, "Int")
          dType := NumGet(dType, 0, "UInt")
          if (dType = AudioDriver)
               if dName Contains %AudioDevice%
                    break
     }
     AudioDriver := (AudioDriver=3 ? "wdm" : (AudioDriver=4 ? "ks" : (AudioDriver=5 ? "asio" : "mme"))) 
     return DllCall(VM_DLL . "\VBVMR_SetParameterStringW", "AStr", AudioBus . ".Device." . AudioDriver , "WStr" , dName , "Int")  
}
