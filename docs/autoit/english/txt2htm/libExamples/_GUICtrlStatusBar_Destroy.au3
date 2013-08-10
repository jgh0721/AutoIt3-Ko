#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <Constants.au3>

$Debug_SB = False ; Check ClassName being passed to functions, set to True and use a handle to another control to see it work

_Main()

Func _Main()

	Local $hGUI, $HandleBefore, $hStatus
	Local $aParts[3] = [75, 150, -1]

	; Create GUI
	$hGUI = GUICreate("StatusBar Destroy", 400, 300)

	;===============================================================================
	; defaults to 1 part, no text
	$hStatus = _GUICtrlStatusBar_Create($hGUI)
	;===============================================================================
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)

	GUISetState()

	$HandleBefore = $hStatus
	MsgBox($MB_SYSTEMMODAL, "Information", "Destroying the Control for Handle: " & $hStatus)
	MsgBox($MB_SYSTEMMODAL, "Information", "Control Destroyed: " & _GUICtrlStatusBar_Destroy($hStatus) & @CRLF & _
			"Handel Before Destroy: " & $HandleBefore & @CRLF & _
			"Handle After Destroy: " & $hStatus)

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
