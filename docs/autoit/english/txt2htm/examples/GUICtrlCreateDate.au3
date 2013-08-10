#include <GUIConstantsEx.au3>
#include <Constants.au3>

Example1()

Func Example1()
	Local $date, $msg

	GUICreate("My GUI get date", 200, 200, 800, 200)
	$date = GUICtrlCreateDate("1953/04/25", 10, 10, 185, 20)
	GUISetState()

	; Run the GUI until the dialog is closed
	Do
		$msg = GUIGetMsg()
	Until $msg = $GUI_EVENT_CLOSE

	MsgBox($MB_SYSTEMMODAL, "Date", GUICtrlRead($date))
	GUIDelete()
EndFunc   ;==>Example1
