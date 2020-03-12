Global GUI_state:=0
Global GUI_prog:=
Global GUI_txt:=
GUI_spawn(prog,txt,GUI_accent:=-1){
    if (GUI_state = 0){
        GUI_Theme:=191919
        GUI_Accent:= ( GUI_Accent = -1 ? GUI_getSysAccent() : GUI_Accent )
        SetFormat, integer, d
        Gui, Color, %GUI_Theme%, %GUI_Accent%
        Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption -Border
        WinSet, Transparent, 230, ahk_class AutoHotkeyGUI
        Gui, Font, s11, Segoe UI
        Gui, Add, Text, c%GUI_Accent% vGUI_txt W165 Center, %txt%
        if (prog!=-1)
            Gui, Add, Progress, W165 c%GUI_Accent% Background%GUI_Theme% vGUI_prog, %prog%
        SysGet, MonitorWorkArea, MonitorWorkArea, 0
        GUI_yPos:= MonitorWorkAreaBottom * 0.90
        Gui, Show, AutoSize NoActivate xCenter y%GUI_yPos%
        GUI_state:= 1
    }else{
        if (prog!=-1)
            GuiControl,, GUI_prog, %prog%
        GuiControl,, GUI_txt, %txt%
    }
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