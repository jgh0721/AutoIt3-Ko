#include <WinAPI.au3>
#include <Constants.au3>

_Main()

Func _Main()
	Local $win = _WinAPI_GetDesktopWindow()
	MsgBox($MB_SYSTEMMODAL, "", WinGetTitle($win))
	MsgBox($MB_SYSTEMMODAL, "", $win)
EndFunc   ;==>_Main
