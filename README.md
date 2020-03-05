<p align="center">
  <img width="250" height="80" align="center" src="https://www.autohotkey.com/assets/images/ahk-logo-no-text241x78-160.png">
</p>
<h1 align="center">
  AHK_Script
</h1>
<p align="center">
 My personal AHK script With VoiceMeeter hotkeys.
</p>

# [VMR.ahk](./src/Lib/VMR.ahk)
  ### AHK Wrapper for <a style="text-decoration:none" href="https://www.vb-audio.com/Services/developers.htm">Voicemeeter Remote API</a>
  ![VoiceMeeterRemote Demo](https://user-images.githubusercontent.com/47293197/68070055-bfea4580-fd60-11e9-825e-3ae075367f5a.gif)

### [**Examples**](https://github.com/SaifAqqad/AHK_Script/blob/c5dbb3c96ec036125261e28b62f3ade15329bf9b/src/Script.ahk#L38)

# [VMR_launcher.ahk](./src/VMR_launcher.ahk)
  ### CLI for [VMR.ahk](./src/Lib/VMR.ahk) 
  #### Can be used to control VoiceMeeter from any app that can run executables (like [Deckboard](https://deckboard.app/)).
  ### USAGE:
          VMR_launcher.exe "function name" "Strip[i]/Bus[i]" "Substring of an audio device's name (if needed)"
          function name: 
                        "gain++"          : increases gain by 2 dB
                        "gain--"          : decreases gain by 2 dB
                        "mute"            : toggles mute state
                        "setAudioDevice"  : 
                        "vmEngineRestart" : restarts Voicemeeter's engine
          examples:
                   VMR_launcher.exe "gain++" "Bus[0]"    
                   VMR_launcher.exe "gain--" "Strip[3]" 
                   VMR_launcher.exe "setAudioDevice" "Bus[0]" "nvidia"
#### [download latest executable](https://github.com/SaifAqqad/AHK_Script/releases/latest)
    
# [OSD.ahk](./src/Lib/OSD.ahk)
  ### A simple OSD that follows the user's system theme
  ![GUIlight Demo](https://user-images.githubusercontent.com/47293197/68298049-55067a80-0090-11ea-877c-9f2964873c96.gif) ![GUIdark Demo](https://user-images.githubusercontent.com/47293197/68298037-50da5d00-0090-11ea-854b-54731a5ffcd8.gif)

### [**Examples**](https://github.com/SaifAqqad/AHK_Script/blob/c5dbb3c96ec036125261e28b62f3ade15329bf9b/src/Script.ahk#L39)
