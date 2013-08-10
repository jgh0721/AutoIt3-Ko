#include <WinAPI.au3>
#include <Constants.au3>

_Main()

Func _Main()
	Local $hwnd, $hDC
	$hwnd = GUICreate("test")
	$hDC = _WinAPI_GetDC($hwnd)
	MsgBox($MB_SYSTEMMODAL, "Handle", "Display Device: " & $hDC)
	_WinAPI_ReleaseDC($hwnd, $hDC)
EndFunc   ;==>_Main
