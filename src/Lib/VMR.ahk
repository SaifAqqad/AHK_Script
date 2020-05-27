;****************************************************************************************************************************************************************************************************;
;*                                                                                VoiceMeeterRemote Wrapper                                                                                         *;
;****************************************************************************************************************************************************************************************************;
Global VM_Path := "C:\Program Files\VB\Voicemeeter\"
Global VM_DLL := "VoicemeeterRemote"
VMR_login()

/*
     VMR_login()
     loads VoiceMeeter's Library and calls VM's login function 
     if '#include <VMR>' is used, this function will be called implicitly, otherwise it needs to be called at script startup
*/
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

/*
     VMR_logout() 
     Calls VoiceMeeter's logout function
*/
VMR_logout(){
     DllCall(VM_DLL . "\VBVMR_Logout")
     DllCall("FreeLibrary", "Ptr", VBVMRDLL) 
}

/*
     VMR_restart() 
     Restarts VoiceMeeter's Audio Engine  
*/
VMR_restart(){
     return DllCall(VM_DLL . "\VBVMR_SetParameterFloat","AStr","Command.Restart","Float","1.0f", "Int")
}

/*
     VMR_getCurrentGain(AudioBus, returnPercentage) 
     returns the current Gain for AudioBus; AudioBus is "Bus[i]" or "Strip[i]" where i is 0-4
     returnPercentage is a boolean value (0/1); if set to 1, the function returns the Gain percentage instead of dB value
*/
VMR_getCurrentGain(AudioBus:="Bus[0]", returnPercentage:=0){
     local CurrentGain := 0.0
     NumPut(0.0, CurrentGain, 0, "Float")
     DllCall(VM_DLL . "\VBVMR_GetParameterFloat", "AStr" , AudioBus . ".Gain" , "Ptr" , &CurrentGain, "Int")
     CurrentGain := NumGet(CurrentGain, 0, "Float")
     return (returnPercentage? CurrentGain/0.6+100 . "%" : CurrentGain)
}

/*
     VMR_incGain(AudioBus, returnPercentage) 
     Increases the AudioBus Gain by 2dB 
*/
VMR_incGain(AudioBus:="Bus[0]", returnPercentage:=0){
     local Gain := VMR_getCurrentGain(AudioBus)
     Gain := ( Gain != 0.0 ? Gain+2 : 0.0)
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Gain" , "Float" , Gain , "Int")
     SetFormat, FloatFast, 4.1
     return (returnPercentage? Gain/0.6+100 . "%" : Gain . "dB" )
}

/*
     VMR_decGain(AudioBus, returnPercentage) 
     Decreases the AudioBus Gain by 2dB
*/
VMR_decGain(AudioBus:="Bus[0]", returnPercentage:=0){
     local Gain := VMR_getCurrentGain(AudioBus)
     Gain := ( Gain != -60.0 ? Gain-2 : -60.0 )
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Gain" , "Float" , Gain , "Int")
     SetFormat, FloatFast, 4.1
     return (returnPercentage? Gain/0.6+100 . "%" : Gain . "dB" )
}

/*
     VMR_setGain(AudioBus, Gain, returnPercentage) 
     Sets AudioBus Gain to a specific value in dB
*/
VMR_setGain(AudioBus:="Bus[0]", Gain:=0.0, returnPercentage:=0){
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Gain" , "Float" , Gain , "Int")
     SetFormat, FloatFast, 4.1
     return (returnPercentage? Gain/0.6+100 . "%" : Gain . "dB" )
}

/*
     VMR_getMuteState(AudioBus) 
     Returns current mute state for AudioBus
*/
VMR_getMuteState(AudioBus:="Bus[0]"){
     local MuteState := 0
     NumPut(0, MuteState, 0, "Float")
     DllCall(VM_DLL . "\VBVMR_GetParameterFloat", "AStr" , AudioBus . ".Mute" , "Ptr" , &MuteState , "Int")
     MuteState := NumGet(MuteState, 0, "Float")
     return MuteState
}

/*
     VMR_muteToggle(AudioBus) Toggles mute state for AudioBus
*/
VMR_muteToggle(AudioBus:="Bus[0]"){
     local MuteState := !VMR_getMuteState(AudioBus)
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Mute" , "Float" , MuteState, "Int")    
     return MuteState
}

/*
     VMR_setMuteState(AudioBus, MuteState) 
     Sets mute state for AudioBus; MuteState is a boolean value (0/1)
*/
VMR_setMuteState(AudioBus:="Bus[0]", MuteState:=1){
     DllCall(VM_DLL . "\VBVMR_SetParameterFloat", "AStr" , AudioBus . ".Mute" , "Float" , MuteState, "Int")
     return MuteState
}

/*
     VMR_setOutputDevice(AudioBus, DeviceName, DeviceDriver)
     Sets Bus[0/1/2] to the passed Device and Driver; AudioBus can be 0,1,2 ; DeviceName can be any substring of the full device name; DeviceDriver can be "wdm","mme","ks","asio"
*/
VMR_setOutputDevice(AudioBus, DeviceName, DeviceDriver := "wdm"){
     if AudioBus not in 0, 1, 2 
          return -4
     if DeviceDriver not in wdm,mme,ks,asio
          return -5
     DeviceName := VMR_getOutputDeviceName(DeviceName, DeviceDriver)
     return DllCall(VM_DLL . "\VBVMR_SetParameterStringW", "AStr","Bus[" . AudioBus . "].Device." . DeviceDriver , "WStr" , DeviceName , "Int") 
}

/*
     VMR_getOutputDevicesList()
     Returns an array of output Device objects, each Device has both 'Name' and 'Driver' properties
*/
VMR_getOutputDevicesList(){
     Device := {Name:"",Driver:""}
     DeviceList := Array()
     loop % DllCall(VM_DLL . "\VBVMR_Output_GetDeviceNumber","Int")
     {
          VarSetCapacity(Name, 1000)
          VarSetCapacity(Driver, 1000)
          DllCall(VM_DLL . "\VBVMR_Output_GetDeviceDescW", "Int", A_Index-1, "Ptr" , &Driver , "Ptr", &Name, "Ptr", 0, "Int")
          Driver := NumGet(Driver, 0, "UInt")
          device := new Device
          device.Name := Name
          device.Driver := (Driver=3 ? "wdm" : (Driver=4 ? "ks" : (Driver=5 ? "asio" : "mme"))) 
          DeviceList.Push(device)
     }
     return DeviceList
}

/*
     VMR_setInputDevice(AudioStrip, DeviceName, DeviceDriver)
     Sets Strip[0/1/2] to the passed Device and Driver; AudioStrip can be 0,1,2 ; DeviceName can be any substring of the full device name; DeviceDriver can be "wdm","mme","ks","asio"
*/
VMR_setInputDevice(AudioStrip, DeviceName, DeviceDriver := "wdm"){
     if AudioStrip not in 0, 1, 2 
          return -4
     if DeviceDriver not in wdm,mme,ks,asio
          return -5
     DeviceName := VMR_getInputDeviceName(DeviceName, DeviceDriver)
     return DllCall(VM_DLL . "\VBVMR_SetParameterStringW", "AStr","Strip[" . AudioStrip . "].Device." . DeviceDriver , "WStr" , DeviceName , "Int") 
}

/*
     VMR_getInputDevicesList()
     Returns an array of input Device objects, each Device has both 'Name' and 'Driver' properties
*/
VMR_getInputDevicesList(){
     Device := {Name:"",Driver:""}
     DeviceList := Array()
     loop % DllCall(VM_DLL . "\VBVMR_Input_GetDeviceNumber","Int")
     {
          VarSetCapacity(Name, 1000)
          VarSetCapacity(Driver, 1000)
          DllCall(VM_DLL . "\VBVMR_Input_GetDeviceDescW", "Int", A_Index-1, "Ptr" , &Driver , "Ptr", &Name, "Ptr", 0, "Int")
          Driver := NumGet(Driver, 0, "UInt")
          device := new Device
          device.Name := Name
          device.Driver := (Driver=3 ? "wdm" : (Driver=4 ? "ks" : (Driver=5 ? "asio" : "mme"))) 
          DeviceList.Push(device)
     }
     return DeviceList
}

VMR_getInputDeviceName(substring, Driver){
     loop % DllCall(VM_DLL . "\VBVMR_Input_GetDeviceNumber","Int")
     {
          VarSetCapacity(ptrName, 1000)
          DllCall(VM_DLL . "\VBVMR_Input_GetDeviceDescW", "Int", A_Index-1, "Ptr" , ptrDriver , "Ptr", &ptrName, "Ptr", 0, "Int")
          if ptrDriver = Driver
               if ptrName Contains %substring%
                    return ptrName
     }
}

VMR_getOutputDeviceName(substring, Driver){
     loop % DllCall(VM_DLL . "\VBVMR_Output_GetDeviceNumber","Int")
     {
          VarSetCapacity(ptrName, 1000)
          DllCall(VM_DLL . "\VBVMR_Output_GetDeviceDescW", "Int", A_Index-1, "Ptr" , ptrDriver , "Ptr", &ptrName, "Ptr", 0, "Int")
          if ptrDriver = Driver
               if ptrName Contains %substring%
                    return ptrName
     }
}

VMR_checkParams(){
     return DllCall(VM_DLL . "\VBVMR_IsParametersDirty")
}