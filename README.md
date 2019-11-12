<p align="center">
  <img width="250" height="80" align="center" src="https://www.autohotkey.com/assets/images/ahk-logo-no-text241x78-160.png">
</p>
<h1 align="center">
  AHK_Script
</h1>
<p align="center">
 My personal AHK script With VoiceMeeter Integration using <a style="text-decoration:none" href="https://www.vb-audio.com/Services/developers.htm">Voicemeeter Remote API</a>.
</p>
<p align="center">
  <a style="text-decoration:none" href="https://autohotkey.com">
    <img src="https://img.shields.io/badge/AutoHotkey-1.1.31.00-4DB057.svg" alt="AHK link" />
  </a>
  <a style="text-decoration:none" href="https://www.vb-audio.com/Voicemeeter/banana.htm">
   <img src="https://img.shields.io/badge/VoiceMeeter-Banana-FF4427.svg" alt="VM link" />
  </a>
</p>

# [VoiceMeeterRemote](./src/Lib/VMR.ahk)
  ### AHK Wrapper for <a style="text-decoration:none" href="https://www.vb-audio.com/Services/developers.htm">Voicemeeter Remote API</a>
  ![VoiceMeeterRemote Demo](https://user-images.githubusercontent.com/47293197/68070055-bfea4580-fd60-11e9-825e-3ae075367f5a.gif)

[**Examples**](https://github.com/SaifAqqad/AHK_Script/blob/7d4bda111a368e04fc99e6283665e903c4a2170f/src/Script.ahk#L36)

# [GUI.ahk](./src/Lib/GUI.ahk)
  ### A simple OSD GUI that follows the user's system theme
  ![GUIlight Demo](https://user-images.githubusercontent.com/47293197/68298049-55067a80-0090-11ea-877c-9f2964873c96.gif) ![GUIdark Demo](https://user-images.githubusercontent.com/47293197/68298037-50da5d00-0090-11ea-854b-54731a5ffcd8.gif)

[**Examples**](https://github.com/SaifAqqad/AHK_Script/blob/7d4bda111a368e04fc99e6283665e903c4a2170f/src/Script.ahk#L37)

## 

### You can use any of the above files in your own script using the [#Include Directive](https://www.autohotkey.com/docs/commands/_Include.htm) or by adding the code to your Script


## Run at Startup Instructions: 
  1. [Download Script.exe](https://github.com/SaifAqqad/AHK_Script/releases/latest/download/Script.exe)
  2. Copy Script.exe to any directory you want (Preferably *C:\AHK\Script*)
  3. Open **Task Scheduler** (Windows Search --> Task Scheduler) 
  4. **Create Basic Task**
  
      4a. Name: *AHK Script*
      
      4b. Trigger: *When I log on*
      
      4c. Action: *Start a program*
      
      4d. Program/Script: *C:\AHK\Script\Script.exe* (or the directory you copied to )
          
  5. Click **Finish**