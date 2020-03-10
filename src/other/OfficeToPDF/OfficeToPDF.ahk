#SingleInstance, off
#Include GUI.ahk
SetWorkingDir, %A_ScriptDir%
params := A_Args.Length()
SetFormat, FloatFast, 0.2
Loop, %params%
{
    prog:= (A_Index / params)*100
    GUI_spawn(prog)
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