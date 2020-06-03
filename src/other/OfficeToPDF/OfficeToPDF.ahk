#SingleInstance, off
#Include GUI.ahk
Global fCount := A_Args.Length()
Global sCount := 0
SetFormat, FloatFast, 0.2
Loop, %fCount%
{
    fProg:= ((A_Index-1) / fCount)*100
    GUI_spawn(fProg,"Converting file " . A_Index . "/" . fCount)
    if (handle(A_Args[A_Index]))
        sCount+=1
    else{
        GUI_spawn(-1,"Unsupported file :(")
        Sleep,1500
    }
}
GUI_spawn(100, sCount . "/" . fCount . " File(s) converted")
Sleep, 2500
GUI_destroy()
ExitApp

handle(inFile){
    SplitPath, inFile,, inDir, inExt, inName
    Switch inExt
    {
        case "pdf":
            pdfOptimizer(inFile,inDir,inName)
        case "pptx","ppt","odp","powerpoint","powerpointx","powerpointm","pot","potm","potx","pps","ppsx","ppsm": ;powerpoint
            pptTopdf(inFile,inDir,inName)
        case "rtf","odt","doc","dot","docx","dotx","docm","dotm","txt","html","htm","wpd": ;word
            wrdTopdf(inFile,inDir,inName)
        case "xls","xlsx","xl","xlsm","xlsb","xlam","xltx","xltm","xlt","htm","html","mht","mhtml","xml","xla","xlm","xlw": ;excel
            excelTopdf(inFile,inDir,inName)
        Default:
            return 0
    }
    return 1
}
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
excelTopdf(fPath,path,name){
    excel := ComObjCreate("Excel.Application")
    excel.Visible := 0
    excel.DisplayAlerts := 0
    excelFile := excel.Workbooks.open(fPath)
    excelFile.ExportAsFixedFormat(0, path . "\" . name . ".pdf")
    excel.Quit()
}
pdfOptimizer(fPath,path,name){
    outputFileName := path . "\" . name . "-optimized.pdf"
    RunWait, gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dFastWebView -sOUTPUTFILE=%outputFileName%  %fPath%,,Hide
}