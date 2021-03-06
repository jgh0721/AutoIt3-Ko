#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <Constants.au3>

Example()

Func Example()
	; Create a GUI with an edit control.
	Local $hGUI = GUICreate("Example")
	Local $iEdit = GUICtrlCreateEdit("Line 0" & @CRLF, 0, 0, 400, 350)
	Local $iOK = GUICtrlCreateButton("OK", 310, 370, 85, 25)

	; Set data of the edit control.
	For $i = 1 To 25
		GUICtrlSetData($iEdit, "Line " & $i & @CRLF, 1)
	Next

	; Set focus to the edit control.
	GUICtrlSetState($iEdit, $GUI_FOCUS)

	; Display the GUI.
	GUISetState(@SW_SHOW, $hGUI)

	; Initialize the variable $aCtrlRecvMsg for storing the value returned by GUICtrlRecvMsg.
	Local $aCtrlRecvMsg = 0
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop

			Case $iOK
				; Send the message EM_GETSEL, to retrieve the current selection of the edit control.
				$aCtrlRecvMsg = GUICtrlRecvMsg($iEdit, $EM_GETSEL)

				; Set focus to the edit control.
				GUICtrlSetState($iEdit, $GUI_FOCUS)

				; If GUICtrlRecvMsg returned the value of 0, then an error occurred otherwise display the contents of the array.
				If $aCtrlRecvMsg = 0 Then
					MsgBox($MB_SYSTEMMODAL, "", "An error occurred. The value returned was - " & $aCtrlRecvMsg)
				Else
					MsgBox($MB_SYSTEMMODAL, "", "Start: " & $aCtrlRecvMsg[0] & " End: " & $aCtrlRecvMsg[1])
				EndIf

		EndSwitch
	WEnd

	; Delete the previous GUI and all controls.
	GUIDelete($hGUI)
EndFunc   ;==>Example
