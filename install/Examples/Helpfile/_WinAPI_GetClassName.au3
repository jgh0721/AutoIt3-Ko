#include <WinAPI.au3>
#include <Constants.au3>

_Main()

Func _Main()
	Local $hwnd
	$hwnd = GUICreate("test")
	MsgBox($MB_SYSTEMMODAL, "Get ClassName", "ClassName of " & $hwnd & ": " & _WinAPI_GetClassName($hwnd))
EndFunc   ;==>_Main
