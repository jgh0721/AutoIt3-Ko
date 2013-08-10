#include <GUIConstantsEx.au3>
#include <DateTimeConstants.au3>
#include <Constants.au3>

Example2()

Func Example2()
	Local $n, $msg

	GUICreate("My GUI get date", 200, 200, 800, 200)
	$n = GUICtrlCreateDate("", 10, 10, 100, 20, $DTS_SHORTDATEFORMAT)
	GUISetState()

	; Run the GUI until the dialog is closed
	Do
		$msg = GUIGetMsg()
	Until $msg = $GUI_EVENT_CLOSE

	MsgBox($MB_SYSTEMMODAL, "Date", GUICtrlRead($n))
	GUIDelete()
EndFunc   ;==>Example2
