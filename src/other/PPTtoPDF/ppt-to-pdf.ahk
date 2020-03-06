#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
inFile := A_Args[1]
SplitPath, inFile,, inDir, inExt, inName
powerpoint := ComObjCreate("Powerpoint.Application")
ppt := powerpoint.Presentations.Open(inDir . "\" . inName . "." . inExt,,,0)
ppt.SaveAs( inDir . "\" . inName . ".pdf" , 32 )
ppt.Close()
WinClose , ahk_exe POWERPNT.EXE