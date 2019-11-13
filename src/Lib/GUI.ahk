;*******************************************************************************************************************************************;
;*                                                                  GUI                                                                    *;
;*  GUI_spawn(txt, GUI_Theme, GUI_Accent) Displays a custom GUI in the bottom center area of the screen containing the txt string          *;
;*  GUI_Theme, GUI_Accent are optional paramters, both can be any color in any format supported by AHK, by default they are the current    *;
;*  system theme and accent, see https://www.autohotkey.com/docs/commands/Gui.htm#Color for more info                                      *;
;*******************************************************************************************************************************************;
Global GUI_state := "closed"
Global GUI_txt :=
GUI_spawn(txt, GUI_Theme:="sys", GUI_Accent:="sys" ){
    if (GUI_state = "closed"){
        GUI_Theme:= ( GUI_Theme != "sys" ? GUI_Theme : GUI_getSysTheme() )
        GUI_Accent:= ( GUI_Accent != "sys" ? GUI_Accent : GUI_getSysAccent() )
        SetFormat, integer, d
        Gui, Color, %GUI_Theme%, %GUI_Accent%
        Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption -Border
        WinSet, Transparent, 230, ahk_class AutoHotkeyGUI
        Gui, Font, s11, Segoe UI
        Gui, Add, Text, c%GUI_Accent% vGUI_txt W165 Center, %txt%
        GUI_yPos:= GUI_getYpos()
        Gui, Show, AutoSize NoActivate xCenter y%GUI_yPos%
        GUI_state:= "open"
    }else{
        GuiControl, Text, GUI_txt, %txt% 
    }
    SetTimer, GUI_destroy, 700
}
GUI_getYpos(){
    SysGet, Monitor, Monitor, 0
    SysGet, MonitorWorkArea, MonitorWorkArea, 0
    Return (MonitorWorkAreaBottom * 0.95)
}
GUI_getSysTheme(){
    RegRead, GUI_sysTheme, HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize, SystemUsesLightTheme 
    Return (GUI_sysTheme ? CDCED2 : 191919) ;GUI_sysTheme:  1 --> light theme, 0 --> Dark theme
}
GUI_getSysAccent(){
    RegRead, GUI_sysAccent, HKCU\SOFTWARE\Microsoft\Windows\DWM, ColorizationColor 
    SetFormat, integer, hex
    GUI_sysAccent := GUI_sysAccent+0
    StringRight, GUI_sysAccent, GUI_sysAccent, 6
    Return GUI_sysAccent
}
GUI_destroy(){
    Gui, Destroy
    GUI_state:= "closed"
    SetTimer, GUI_destroy, Off
}