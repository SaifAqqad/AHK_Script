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

![VoiceMeeter Interface](https://user-images.githubusercontent.com/47293197/68070055-bfea4580-fd60-11e9-825e-3ae075367f5a.gif)
## Instructions for using [VoiceMeeterInterface](./src/Lib/VMI.ahk) in your own script:
1. Add VMI.ahk to *YourScriptDir*/Lib/
2. Add the following to the top of your script: 
      ```AutoHotKey
      #include <VMI>
      ```
[**Examples**](https://github.com/SaifAqqad/AHK_Script/blob/a429ec17c231006ac389933e7a67f06dc0f23ea9/src/Script.ahk#L44)

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
