;*******************************************************************************************************************************************;
;*                                                                  OSD                                                                    *;
;*  OSD_spawn(txt, OSD_Theme, OSD_Accent) Displays a custom OSD in the bottom center area of the screen containing the txt string          *;
;*  OSD_Theme, OSD_Accent are optional paramters, both can be any color in any format supported by AHK, by default they are the current    *;
;*  system theme and accent, see https://www.autohotkey.com/docs/commands/Gui.htm#Color for more info                                      *;
;*******************************************************************************************************************************************;
Global OSD_state:= 0 ;0 -> closed ;1 -> open
Global OSD_txt:=
Global OSD_sysTheme:=
Global OSD_sysAccent:=
getSysTheme()

OSD_spawn(txt, OSD_Theme:=-1, OSD_Accent:=-1 ){
    OSD_Theme:= ( OSD_Theme = -1 ? OSD_sysTheme : OSD_Theme  )
    OSD_Accent:= ( OSD_Accent = -1 ? OSD_sysAccent : OSD_Accent )
    if (OSD_state = 0){
        SetFormat, integer, d
        Gui, Color, %OSD_Theme%, %OSD_Accent%
        Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption -Border
        WinSet, Transparent, 230, ahk_class AutoHotkeyGUI
        Gui, Font, s11 w500 c%OSD_Accent%, Segoe UI
        Gui, Add, Text, vOSD_txt W165 Center, %txt%
        SysGet, MonitorWorkArea, MonitorWorkArea, 0
        OSD_yPos:= MonitorWorkAreaBottom * 0.95
        Gui, Show, AutoSize NoActivate xCenter y%OSD_yPos%
        OSD_state:= 1
    }else{
        Gui, Font, s11 w500 c%OSD_Accent%
        GuiControl, Font, OSD_txt
        GuiControl, Text, OSD_txt, %txt% 
    }
    SetTimer, OSD_destroy, 1000
}
OSD_destroy(){
    Gui, Destroy
    OSD_state := 0
    SetTimer, OSD_destroy, Off
}
getSysTheme(){
    RegRead, reg, HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize, SystemUsesLightTheme 
    OSD_sysTheme:= (reg ? 0xE6E6E6 : 0x191919)
    RegRead, reg, HKCU\SOFTWARE\Microsoft\Windows\DWM, ColorizationColor 
    SetFormat, integer, hex
    reg := reg+0
    StringRight, reg, reg, 6
    OSD_sysAccent:=reg
}