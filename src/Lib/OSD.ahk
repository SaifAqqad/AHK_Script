;*******************************************************************************************************************************************;
;*                                                                  OSD                                                                    *;
;*  OSD_spawn(txt, OSD_Theme, OSD_Accent) Displays a custom OSD in the bottom center area of the screen containing the txt string          *;
;*  OSD_Theme, OSD_Accent are optional paramters, both can be any color in any format supported by AHK, by default they are the current    *;
;*  system theme and accent, see https://www.autohotkey.com/docs/commands/Gui.htm#Color for more info                                      *;
;*******************************************************************************************************************************************;
Global OSD_state:= 0 ;0 -> closed ;1 -> open
Global OSD_txt:=
OSD_spawn(txt, OSD_Theme:=-1, OSD_Accent:=-1 ){
    if (OSD_state = 0){
        OSD_Theme:= ( OSD_Theme = -1 ? OSD_getSysTheme() : OSD_Theme  )
        OSD_Accent:= ( OSD_Accent = -1 ? OSD_getSysAccent() : OSD_Accent )
        SetFormat, integer, d
        Gui, Color, %OSD_Theme%, %OSD_Accent%
        Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption -Border
        WinSet, Transparent, 230, ahk_class AutoHotkeyGUI
        Gui, Font, s11, Segoe UI
        Gui, Add, Text, c%OSD_Accent% vOSD_txt W165 Center, %txt%
        SysGet, MonitorWorkArea, MonitorWorkArea, 0
        OSD_yPos:= MonitorWorkAreaBottom * 0.95
        Gui, Show, AutoSize NoActivate xCenter y%OSD_yPos%
        OSD_state:= 1
    }else{
        GuiControl, Text, OSD_txt, %txt% 
    }
    SetTimer, OSD_destroy, 700
}
OSD_getSysTheme(){
    RegRead, OSD_sysTheme, HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize, SystemUsesLightTheme 
    Return (OSD_sysTheme ? CDCED2 : 191919) ;OSD_sysTheme:  1 --> light theme, 0 --> Dark theme
}
OSD_getSysAccent(){
    RegRead, OSD_sysAccent, HKCU\SOFTWARE\Microsoft\Windows\DWM, ColorizationColor 
    SetFormat, integer, hex
    OSD_sysAccent := OSD_sysAccent+0
    StringRight, OSD_sysAccent, OSD_sysAccent, 6
    Return OSD_sysAccent
}
OSD_destroy(){
    Gui, Destroy
    OSD_state := 0
    SetTimer, OSD_destroy, Off
}