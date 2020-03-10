Global GUI_state:=0
Global GUI_prog:=
GUI_spawn(prog,GUI_theme:=-1,GUI_accent:=-1){
    if (GUI_state = 0){
        GUI_Theme:= ( GUI_Theme = -1 ? GUI_getSysTheme() : GUI_Theme  )
        GUI_Accent:= ( GUI_Accent = -1 ? GUI_getSysAccent() : GUI_Accent )
        SetFormat, integer, d
        Gui, Color, %GUI_Theme%, %GUI_Accent%
        Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption -Border
        WinSet, Transparent, 230, ahk_class AutoHotkeyGUI
        Gui, Font, s11, Segoe UI
        Gui, Add, Progress, W165 c%GUI_Accent% Background%GUI_Theme% vGUI_prog, %prog%
        SysGet, MonitorWorkArea, MonitorWorkArea, 0
        GUI_yPos:= MonitorWorkAreaBottom * 0.95
        Gui, Show, AutoSize NoActivate xCenter y%GUI_yPos%
        GUI_state:= 1
    }else{
        GuiControl,, GUI_prog, %prog%
    }
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
    GUI_state := 0
}