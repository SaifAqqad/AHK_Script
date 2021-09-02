; mic gain limit
vm.strip[2].gain_limit:= -10
cMode:=0

Volume_Up::osd_obj.showAndHide("A1 gain: " ++vm.bus[1].gain,1,2)
Volume_Down::osd_obj.showAndHide("A1 gain: " --vm.bus[1].gain,0,2)

<!Volume_Up::osd_obj.showAndHide("Media gain: " ++vm.strip[5].gain,1,2)
<!Volume_Down::osd_obj.showAndHide("Media gain: " --vm.strip[5].gain,0,2)

;set A1 to headphones
*<!1::
vm.bus[1].device["ks"]:="Corsair"
osd_obj.showAndHide("Headphone audio")
Sleep, 1000
tts.Speak("Headphone audio")
return

;set A1 to monitor
*<!2::
vm.bus[1].device["wdm"]:="AMD"
osd_obj.showAndHide("Monitor audio")
Sleep, 1000
tts.Speak("Monitor audio")
return

;reverse A1
<^<!F::
_str:=""
switch vm.bus[1].mono {
    case 0: _str:="reverse"
            vm.bus[1].Mono:=2
    case 2: _str:="Stereo"
            vm.bus[1].Mono:=0
}
osd_obj.showAndHide("A1 set to " _str)
tts.Speak("Audio set to " _str)
return

; hold-to-mute A1 and mic
~*Esc::
osd_obj.show("EMERGENCY MUTE")
vm.bus[1].mute:=1
vm.strip[2].mute:=1
KeyWait, Esc
vm.bus[1].mute:=0
vm.strip[2].mute:=0
osd_obj.hide()
return

; VALORANT specific
#If, WinExist("ahk_exe VALORANT-Win64-Shipping.exe")
;clutch mode
<^<!C::
if(cMode){
    vm.strip[4].solo:=vm.strip[4].gain:=vm.strip[2].mute:= 0
    tts.speak("clutch mode off")
}else{
    vm.strip[4].solo:= vm.strip[2].mute:= 1
    vm.strip[4].gain:= 3
    tts.speak("clutch mode on")
}
cMode:= !cMode
return
#If

; toggle recording
<^CtrlBreak::
if(!vm.recorder.record){ ;not recording
    vm.recorder.record:= 1
    tts.speak("Recording")
}else { ; recording
    vm.recorder.stop:= 1
    tts.speak("Recording stopped")
}
return

Pause::vm.recorder.replay:=1