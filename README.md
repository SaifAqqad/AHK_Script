<p align="center">
  <img width="250" height="80" align="center" src="https://www.autohotkey.com/assets/images/ahk-logo-no-text241x78-160.png">
</p>
<h1 align="center">
  AHK_Script
</h1>
<p align="center">
 My personal AHK script With VoiceMeeter Integration using <a style="text-decoration:none" href="https://www.vb-audio.com/Services/developers.htm">VoiceMeeter's API</a>.
</p>
<p align="center">
  <a style="text-decoration:none" href="https://autohotkey.com">
    <img src="https://img.shields.io/badge/AutoHotkey-1.1.30.03-4DB057.svg" alt="AHK link" />
  </a>
  <a style="text-decoration:none" href="https://www.vb-audio.com/Voicemeeter/banana.htm">
   <img src="https://img.shields.io/badge/VoiceMeeter-Banana-FF4427.svg" alt="VM link" />
  </a>
</p>

![VoiceMeeter Integration](https://j.gifs.com/2x2J4A.gif)
## Tips for using [VoiceMeeterIntegration.ahk](../master/Script/Lib/VoiceMeeterIntegration.ahk) in your own script:
1. Use `#include path/to/VoiceMeeterIntegration.ahk`
2. Add a call to `VM_Login()` and `OnExit("VM_Logout")`

**Note: Tooltips won't show up if the currently active windows is fullscreen (e.g. fullscreen games/netflix)**

## Run at Startup Instructions: 
1. [Download Script.exe](https://github.com/SaifAqqad/AHK_Script/releases/latest/download/Script.exe)
2. Copy Script.exe to any directory you want (Preferably C:\AHK\Script)
3. Open Task Scheduler (Windows Search --> Task Scheduler) 
4. Create Basic Task

    4a. Name: *AHK Script*
    
    4b. Trigger: *When I log on*
    
    4c. Action: *Start a program*
    
    4d. Program/Script: *C:\AHK\Script\Script.exe* (or the directory you copied to )
    
5. Click *Finish*
