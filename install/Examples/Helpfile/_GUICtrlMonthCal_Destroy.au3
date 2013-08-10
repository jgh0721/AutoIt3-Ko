#include <GUIConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>

$Debug_MC = False ; Check ClassName being passed to MonthCal functions, set to True and use a handle to another control to see it work

_Main()

Func _Main()
	Local $hGUI, $HandleBefore, $hMonthCal

	; Create GUI
	$hGUI = GUICreate("Month Calendar Destroy", 400, 300)
	$hMonthCal = _GUICtrlMonthCal_Create($hGUI, 4, 4, $WS_BORDER)
	GUISetState()

	$HandleBefore = $hMonthCal
	MsgBox($MB_SYSTEMMODAL, "Information", "Destroying the Control for Handle: " & $hMonthCal)
	MsgBox($MB_SYSTEMMODAL, "Information", "Control Destroyed: " & _GUICtrlMonthCal_Destroy($hMonthCal) & @CRLF & _
			"Handel Before Destroy: " & $HandleBefore & @CRLF & _
			"Handle After Destroy: " & $hMonthCal)

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
