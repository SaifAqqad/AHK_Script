;********************************************************************************************************************;
;*                                                  GUI                                                             *;
;*  GUI_spawn(txt) Displays a custom GUI in the bottom center area of the screen containing the txt string          *;
;*  GUI_getSysTheme() runs at startup to get the system theme + acccent color                                       *;
;********************************************************************************************************************;
Global GUI_state := "closed"
Global GUI_txt :=
Global GUI_AccentColor:=
Global GUI_sysTheme:= ;0 --> Dark theme ;1 --> light theme
GUI_getSysTheme()
GUI_spawn(txt){
     if (GUI_state = "closed"){
        Gui, Color, % (GUI_sysTheme ? CDCED2 : 191919), %GUI_AccentColor%
        Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption -Border
        WinSet, Transparent, 240, ahk_class AutoHotkeyGUI
        Gui, Font, s11, Segoe UI
        Gui, Add, Text, c%GUI_AccentColor% vGUI_txt W160 Center, %txt%
        Gui, Show, xCenter Y980 AutoSize NoActivate 
        GUI_state:= "open"
    }else{
        GuiControl, Text, GUI_txt, %txt% 
    }
    SetTimer, GUI_destroy, 700
}
GUI_getSysTheme(){
    RegRead, GUI_AccentColor, HKCU\SOFTWARE\Microsoft\Windows\DWM, ColorizationColor 
    RegRead, GUI_sysTheme, HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize, SystemUsesLightTheme
    SetFormat, integer, hex
    GUI_AccentColor := GUI_AccentColor+0
    StringRight, GUI_AccentColor, GUI_AccentColor, 6
}
GUI_destroy(){
    Gui, Destroy
    GUI_state:= "closed"
    SetTimer, GUI_destroy, Off
}