#include <WinAPI.au3>
#include <Constants.au3>

_Main()

Func _Main()
	Local $button
	GUICreate("test")
	$button = GUICtrlCreateButton("testing", 0, 0)
	MsgBox($MB_SYSTEMMODAL, "ID", "Dialog Control ID: " & _WinAPI_GetDlgCtrlID(GUICtrlGetHandle($button)))
EndFunc   ;==>_Main
