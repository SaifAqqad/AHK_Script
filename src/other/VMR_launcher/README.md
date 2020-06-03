<h1 align="center">
  VMR_launcher
</h1>
<p align="center">
 Control VoiceMeeter from any app that can run executables.
</p>

## Install using Scoop:

1. Install scoop.sh using powershell
    
        iwr -useb get.scoop.sh | iex
2. Add my bucket to scoop
        
        scoop bucket add utils https://github.com/SaifAqqad/utils.git
3. Install VMR_launcher

        scoop install vmr_launcher

## Usage: 
      voicemeeter "command" "Strip[i]/Bus[i]" [ "Audio device type" "Substring of an audio device'name" ]
      command: 
                    "gain++"          : increases gain by 2 dB
                    "gain--"          : decreases gain by 2 dB
                    "mute"            : toggles mute state
                    "setOutputDevice" : Sets Bus[0/1/2] to the passed Device and Driver
                    "setInputDevice"  : Sets Strip[0/1/2] to the passed Device and Driver
                    "vmEngineRestart" : restarts Voicemeeter's engine
      Audio device type: 
                        mme
                        wdm
                        ks
                        asio
      examples:
               voicemeeter gain++ Bus[0]   
               voicemeeter gain-- Strip[3] 
               voicemeeter setAudioDevice Bus[0] nvidia wdm
