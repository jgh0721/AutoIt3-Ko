#include <WinAPI.au3>
#include <Constants.au3>

_Main()

Func _Main()
	Local $hwnd, $button
	$hwnd = GUICreate("test")
	$button = GUICtrlCreateButton("button", 0, 0)
	MsgBox($MB_SYSTEMMODAL, "Handle", "Get Dialog Item: " & _WinAPI_GetDlgItem($hwnd, $button))
EndFunc   ;==>_Main
