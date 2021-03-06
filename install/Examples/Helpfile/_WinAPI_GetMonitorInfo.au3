#include <WinAPISys.au3>
#include <WinAPIGdi.au3>

Local $tPos = _WinAPI_GetMousePos()
Local $hMonitor = _WinAPI_MonitorFromPoint($tPos)

Local $Data = _WinAPI_GetMonitorInfo($hMonitor)
If IsArray($Data) Then
	ConsoleWrite('Handle:      ' & $hMonitor & @CRLF)
	ConsoleWrite('Rectangle:   ' & DllStructGetData($Data[0], 1) & ', ' & DllStructGetData($Data[0], 2) & ', ' & DllStructGetData($Data[0], 3) & ', ' & DllStructGetData($Data[0], 4) & @CRLF)
	ConsoleWrite('Work area:   ' & DllStructGetData($Data[1], 1) & ', ' & DllStructGetData($Data[1], 2) & ', ' & DllStructGetData($Data[1], 3) & ', ' & DllStructGetData($Data[1], 4) & @CRLF)
	ConsoleWrite('Primary:     ' & $Data[2] & @CRLF)
	ConsoleWrite('Device name: ' & $Data[3] & @CRLF)
EndIf
