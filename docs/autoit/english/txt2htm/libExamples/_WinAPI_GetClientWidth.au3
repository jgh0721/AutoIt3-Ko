#include <WinAPI.au3>
#include <Constants.au3>

_Main()

Func _Main()
	Local $hwnd
	$hwnd = GUICreate("test")
	MsgBox($MB_SYSTEMMODAL, "Client", "Client Width: " & _WinAPI_GetClientWidth($hwnd))
EndFunc   ;==>_Main
