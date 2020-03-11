#SingleInstance, off
#Include GUI.ahk
SetWorkingDir, %A_ScriptDir%
fCount := A_Args.Length()
SetFormat, FloatFast, 0.2
Loop, %fCount%
{
    fProg:= ((A_Index-1) / fCount)*100
    GUI_spawn(fProg,"Converting file " . A_Index . "/" . fCount)
    inFile := A_Args[A_Index]
    SplitPath, inFile,, inDir, inExt, inName
    Switch inExt
    {
        case "pptx","ppt","odp","powerpoint","powerpointx","powerpointm","pot","potm","potx","pps","ppsx","ppsm": ;powerpoint
            pptTopdf(inFile,inDir,inName)
        case "rtf","odt","doc","dot","docx","dotx","docm","dotm","txt","html","htm","wpd": ;word
            wrdTopdf(inFile,inDir,inName)
    }
}
GUI_spawn(100,"File(s) converted :D")
Sleep, 2000
GUI_destroy()
ExitApp
pptTopdf(fPath,path,name){
    powerpoint := ComObjCreate("Powerpoint.Application")
    powerpointFile := powerpoint.Presentations.Open(fPath,,,0)
    powerpointFile.SaveAs( path . "\" . name . ".pdf" , 32 )
    powerpoint.Quit()
}
wrdTopdf(fPath,path,name){
    word := ComObjCreate("Word.Application")
    wordFile := word.Documents.Open(fPath,,,,,,,,,,,0)
    wordFile.SaveAs2( path . "\" . name . ".pdf" , 17 )
    word.Quit()
}