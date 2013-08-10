#include <GuiListBox.au3>
#include <GUIConstantsEx.au3>
#include <Constants.au3>

$Debug_LB = False ; Check ClassName being passed to ListBox functions, set to True and use a handle to another control to see it work

_Main()

Func _Main()
	Local $hListBox

	; Create GUI
	GUICreate("List Box Get Locale", 400, 296)
	$hListBox = GUICtrlCreateList("", 2, 2, 396, 296)
	GUISetState()

	; Show locale, country code, language identifier, primary language id, sub-language id
	MsgBox($MB_SYSTEMMODAL, "Information", _
			"Locale .................: " & _GUICtrlListBox_GetLocale($hListBox) & @CRLF & _
			"Country code ........: " & _GUICtrlListBox_GetLocaleCountry($hListBox) & @CRLF & _
			"Language identifier..: " & _GUICtrlListBox_GetLocaleLang($hListBox) & @CRLF & _
			"Primary Language id : " & _GUICtrlListBox_GetLocalePrimLang($hListBox) & @CRLF & _
			"Sub-Language id ....: " & _GUICtrlListBox_GetLocaleSubLang($hListBox))

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
