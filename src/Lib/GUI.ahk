;********************************************************************************************************************;
;*                                                  GUI                                                             *;
;*  GUI_spawn(txt) Displays a custom GUI in the bottom center area of the screen containing the txt string       *;
;********************************************************************************************************************;
Global GUI_state := "closed"
Global GUI_txt :=
Global GUI_AccentColor:=
GUI_spawn(txt){
     if (GUI_state = "closed"){
        Gui, Color, 191919, %GUI_AccentColor%
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
GUI_getAccentColor(){
     RegRead, GUI_AccentColor, HKCU\SOFTWARE\Microsoft\Windows\DWM, ColorizationColor 
     SetFormat, integer, hex
     GUI_AccentColor := GUI_AccentColor+0
     StringRight, GUI_AccentColor, GUI_AccentColor, 6
}
GUI_destroy(){
    Gui, Destroy
    GUI_state:= "closed"
    SetTimer, GUI_destroy, Off
}