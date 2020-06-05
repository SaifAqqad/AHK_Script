#Include, %A_ScriptDir%\..\..\Lib\JSON.ahk
Global totalms:= 0
Global dir:= ""
MsgBox, 0, SpotifyListenTime, Select json file(s)
IfMsgBox, OK
    FileSelectFile, files, M3,, Select StreamingHistory#.json file(s), *.json
Loop, parse, files, `n
{
    if (A_Index = 1)
        dir:= A_LoopField
    else
    {
        FileRead jsonString, %dir%\%A_LoopField%
        Data:= JSON.Load(jsonString)
        Loop % Data.Length()
        {
            totalms:= totalms + Data[A_Index].msPlayed
        }
    }
}
totalSec:=Mod((totalms/1000), 60)
totalSec:= Format("{:d}", totalSec)
totalmin:=Mod((totalms/1000)/60, 60)
totalmin:= Format("{:d}", totalmin)
totalhr:=Mod((totalms/1000)/3600, 24)
totalhr:= Format("{:d}", totalhr)
totalDays:=(totalms/1000)/86400
totalDays:= Format("{:d}", totalDays)
totalTime:= totalDays . " days, " . totalhr . " hours, " . totalmin . " minutes and " . totalSec . "seconds"
MsgBox, % "You spent " . totalTime .  " listening to spotify"