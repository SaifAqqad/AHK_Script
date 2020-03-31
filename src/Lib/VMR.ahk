;********************************************************************************************************************;
;*                                            VoiceMeeterRemote Wrapper                                             *;
;******************************************************USAGE*********************************************************;
;*  11 VMR_login()  loads VoiceMeeter's Library and calls VM's login function                                       *;
;*  12 VMR_logout() Calls VM's logout function                                                                      *;
;*  13 VMR_restart() Restarts VoiceMeeter's Engine                                                                  *;
;*  14 VMR_checkParams() Calls VM's IsParametersDirty function                                                      *;
;*******                                                                                                      *******;
;*               AudioBus: "Strip[i]" or "Bus[i]" ;i is zero based ;0-4 for VMBanana ;"Bus[0]" by default           *;
;*               returnPercentage: boolean value (0,1); if set to 1,the function returns the Gain % instead of dB   *;
;*  21 VMR_getCurrentGain(AudioBus, returnPercentage) returns the current Gain for AudioBus                         *;
;*  22 VMR_incGain(AudioBus, returnPercentage) Increases the AudioBus Gain by 2dB                                   *;
;*  23 VMR_decGain(AudioBus, returnPercentage) Decreases the AudioBus Gain by 2dB                                   *;
;*  24 VMR_setGain(AudioBus, Gain, returnPercentage) Sets AudioBus Gain                                             *;
;*  25 VMR_muteToggle(AudioBus) Mutes AudioBus                                                                      *;
;*  26 VMR_getMuteState(AudioBus) Returns current mute status for AudioBus                                          *;
;*******                                                                                                      *******;
;*               AudioBus: "Strip[i]" or "Bus[i]" ;Physical Buses/Strips ;0-2 for VMBanana                          *;
;*               AudioType:  1 for mme / 3 for wdm / 4 for ks / 5 for asio                                          *;
;*               AudioDevice: any substring of an audio device's full name that's shown in VoiceMeeter's GUI        *;
;*  31 VMR_setAudioDevice(AudioBus, AudioType, AudioDevice)                                                         *;
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
VMR_getCurrentGain(AudioBus:="Bus[0]", returnPercentage:=0){
     local CurrentGain := 0.0
     NumPut(0.0, CurrentGain, 0, "Float")
     DllCall(VM_DLL . "\VBVMR_GetParameterFloat", "AStr" , AudioBus . ".Gain" , "Ptr" , &CurrentGain, "Int")
     CurrentGain := NumGet(CurrentGain, 0, "Float")
     return (returnPercentage? CurrentGain/0.6+100 . "%" : CurrentGain)
}
VMR_incGain(AudioBus:="Bus[0]", returnPercentage:=0){
     local Gain := VMR_getCurrentGain(AudioBus)
     Gain := ( Gain != 0.0 ? Gain+2 : 0.0)
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Gain" , "Float" , Gain , "Int")
     SetFormat, FloatFast, 4.1
     return (returnPercentage? Gain/0.6+100 . "%" : Gain . "dB" )
}
VMR_decGain(AudioBus:="Bus[0]", returnPercentage:=0){
     local Gain := VMR_getCurrentGain(AudioBus)
     Gain := ( Gain != -60.0 ? Gain-2 : -60.0 )
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Gain" , "Float" , Gain , "Int")
     SetFormat, FloatFast, 4.1
     return (returnPercentage? Gain/0.6+100 . "%" : Gain . "dB" )
}
VMR_setGain(AudioBus:="Bus[0]", Gain:=0.0, returnPercentage:=0){
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Gain" , "Float" , Gain , "Int")
     SetFormat, FloatFast, 4.1
     return (returnPercentage? Gain/0.6+100 . "%" : Gain . "dB" )
}
VMR_getMuteState(AudioBus:="Bus[0]"){
     local MuteState := 0
     NumPut(0, MuteState, 0, "Float")
     DllCall(VM_DLL . "\VBVMR_GetParameterFloat", "AStr" , AudioBus . ".Mute" , "Ptr" , &MuteState , "Int")
     MuteState := NumGet(MuteState, 0, "Float")
     return MuteState
}
VMR_muteToggle(AudioBus:="Bus[0]"){
     local MuteState := !VMR_getMuteState(AudioBus)
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Mute" , "Float" , MuteState, "Int")    
     return MuteState
}
VMR_setMuteState(AudioBus:="Bus[0]", MuteState:=1){
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Mute" , "Float" , MuteState, "Int")
     return MuteState
}
VMR_setAudioDevice(AudioBus, AudioType, AudioDevice){
     numDevices := DllCall(VM_DLL . "\VBVMR_Output_GetDeviceNumber","Int")
     loop %numDevices%
     {
          VarSetCapacity(dName, 1000)
          VarSetCapacity(dType, 1000)
          DllCall(VM_DLL . "\VBVMR_Output_GetDeviceDescW", "Int", A_Index-1, "Ptr" , &dType , "Ptr", &dName, "Ptr", 0, "Int")
          dType := NumGet(dType, 0, "UInt")
          if (dType = AudioType)
               if dName Contains %AudioDevice%
                    break
     }
     AudioType := (AudioType=3 ? "wdm" : (AudioType=4 ? "ks" : (AudioType=5 ? "asio" : "mme"))) 
     return DllCall(VM_DLL . "\VBVMR_SetParameterStringW", "AStr", AudioBus . ".Device." . AudioType , "WStr" , dName , "Int")  
}
