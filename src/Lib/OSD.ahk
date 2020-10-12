;*******************************************************************************************************************************************;
;*                                                                  OSD                                                                    *;
;*  OSD_spawn(txt, OSD_Theme, OSD_Accent) Displays a custom OSD in the bottom center area of the screen containing the txt string          *;
;*  OSD_Theme, OSD_Accent are optional paramters, both can be any color in any format supported by AHK, by default they are the current    *;
;*  system theme and accent, see https://www.autohotkey.com/docs/commands/Gui.htm#Color for more info                                      *;
;*******************************************************************************************************************************************;
Global OSD_hwnd:=, OSD_state:= 0, OSD_txt:=, OSD_prog, OSD_sysTheme:=, OSD_sysAccent:=
getSysTheme()

OSD_spawn(txt, OSD_Theme:=-1, OSD_Accent:=-1, exclude_fullscreen:=0, prog:=-1){
    if (exclude_fullscreen && isActiveWinFullscreen())
        return
    OSD_Theme:= ( OSD_Theme = -1 ? OSD_sysTheme : OSD_Theme  )
    OSD_Accent:= ( OSD_Accent = -1 ? OSD_sysAccent : OSD_Accent )
    if (OSD_state = 0){
        SetFormat, integer, d
        Gui, New, +HwndOSD_hwnd
        Gui, Color, %OSD_Theme%, %OSD_Accent%
        Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption -Border
        WinSet, Transparent, 230, ahk_id %OSD_hwnd%
        Gui, Font, s11 w500 c%OSD_Accent%, Segoe UI
        Gui, Add, Text, vOSD_txt W165 Center, %txt%
        if (prog!=-1)
            Gui, Add, Progress, W165 c%OSD_Accent% Background%OSD_Theme% vOSD_prog, %prog%
        SysGet, MonitorWorkArea, MonitorWorkArea, 0
        OSD_yPos:= MonitorWorkAreaBottom * 0.95
        Gui, Show, AutoSize NoActivate xCenter y%OSD_yPos%
        OSD_state:= 1
    }else{
        Gui, %OSD_hwnd%:Default
        Gui, Font, s11 w500 c%OSD_Accent%
        GuiControl, Font, OSD_txt
        GuiControl, Text, OSD_txt, %txt%
        if (prog!=-1)
            GuiControl,, OSD_prog, %prog%
        else
            GuiControl, Hide, OSD_prog
    }
    SetTimer, OSD_destroy, -1500
}
OSD_destroy(){
    Gui, %OSD_hwnd%:Default
    Gui, Destroy
    OSD_state := 0
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
isActiveWinFullscreen(){ ;returns true if the active window is fullscreen
    winID := WinExist( "A" )
    if ( !winID )
        Return false
    WinGet style, Style, ahk_id %WinID%
    WinGetPos ,,,winW,winH, %winTitle%
    return !((style & 0x20800000) or WinActive("ahk_class Progman") 
    or WinActive("ahk_class WorkerW") or winH < A_ScreenHeight or winW < A_ScreenWidth)
}