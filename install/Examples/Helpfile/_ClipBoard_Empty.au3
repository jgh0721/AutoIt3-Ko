#include <GUIConstantsEx.au3>
#include <Clipboard.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Global $iMemo

_Main()

Func _Main()
	Local $hGUI

	; Create GUI
	$hGUI = GUICreate("Clipboard", 600, 400)
	$iMemo = GUICtrlCreateEdit("", 2, 2, 596, 396, $WS_VSCROLL)
	GUICtrlSetFont($iMemo, 9, 400, 0, "Courier New")
	GUISetState()

	; Open the clipboard
	If _ClipBoard_Open($hGUI) Then
		ShowData($hGUI)

		; Empty the clipboard
		If Not _ClipBoard_Empty() Then _WinAPI_ShowError("_ClipBoard_Empty failed")

		; Close the clipboard
		_ClipBoard_Close()
	Else
		_WinAPI_ShowError("_ClipBoard_Open failed")
	EndIf

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE

EndFunc   ;==>_Main

; Show clipboard statistics
Func ShowData($hGUI)
	MemoWrite("GUI handle ............: " & $hGUI)
	MemoWrite("Clipboard owner .......: " & _ClipBoard_GetOwner())
	MemoWrite("Clipboard open window .: " & _ClipBoard_GetOpenWindow())
	MemoWrite("Clipboard sequence ....: " & _ClipBoard_GetSequenceNumber())
	MemoWrite()
EndFunc   ;==>ShowData

; Write message to memo
Func MemoWrite($sMessage = "")
	GUICtrlSetData($iMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite