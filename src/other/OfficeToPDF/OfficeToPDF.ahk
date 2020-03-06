#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
inFile := A_Args[1]
SplitPath, inFile,, inDir, inExt, inName
Switch inExt
{
    case "odp","powerpoint","powerpointx","powerpointm","pot","potm","potx","pps","ppsx","ppsm": ;powerpoint
        powerpoint := ComObjCreate("Powerpoint.Application")
        powerpoint := powerpoint.Presentations.Open(inDir . "\" . inName . "." . inExt,,,0)
        powerpoint.SaveAs( inDir . "\" . inName . ".pdf" , 32 )
        powerpoint.Close()
        WinClose , ahk_exe POWERPNT.EXE
    case "rtf","odt","doc","dot","docx","dotx","docm","dotm","txt","html","htm","wpd": ;word
        word := ComObjCreate("Word.Application")
        word := word.Documents.Open(inDir . "\" . inName . "." . inExt,,,,,,,,,,,0)
        word.SaveAs2( inDir . "\" . inName . ".pdf" , 17 )
        word.Close()
        WinClose , ahk_exe WINWORD.EXE
}