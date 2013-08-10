#include <WinAPI.au3>
#include <Constants.au3>

_Main()

Func _Main()
	Local $hwnd, $tRect
	$hwnd = GUICreate("test")
	$tRect = _WinAPI_GetClientRect($hwnd)
	MsgBox($MB_SYSTEMMODAL, "Rect", _
			"Left..: " & DllStructGetData($tRect, "Left") & @CRLF & _
			"Right.: " & DllStructGetData($tRect, "Right") & @CRLF & _
			"Top...: " & DllStructGetData($tRect, "Top") & @CRLF & _
			"Bottom: " & DllStructGetData($tRect, "Bottom"))
EndFunc   ;==>_Main
