#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
op := A_Args[1]
Switch op
{
    case 1:
        FileCreateShortcut, %A_ScriptDir%\OfficeToPDF.exe, %A_AppData%\Microsoft\Windows\SendTo\PDF file.lnk
    case -1:
        FileDelete, %A_AppData%\Microsoft\Windows\SendTo\PDF file.lnk
}
