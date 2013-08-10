#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include <Constants.au3>

$Debug_CB = False ; Check ClassName being passed to ComboBox/ComboBoxEx functions, set to True and use a handle to another control to see it work

_Main()

Func _Main()
	Local $hCombo

	; Create GUI
	GUICreate("ComboBox Get Locale Sub-Language id", 400, 296)
	$hCombo = GUICtrlCreateCombo("", 2, 2, 396, 296)
	GUISetState()

	; Add files
	_GUICtrlComboBox_BeginUpdate($hCombo)
	_GUICtrlComboBox_AddDir($hCombo, @WindowsDir & "\*.exe")
	_GUICtrlComboBox_EndUpdate($hCombo)

	; Show locale, country code, language identifier, primary language id, sub-language id
	MsgBox($MB_SYSTEMMODAL, "Information", _
			"Locale .................: " & _GUICtrlComboBox_GetLocale($hCombo) & @CRLF & _
			"Country code ........: " & _GUICtrlComboBox_GetLocaleCountry($hCombo) & @CRLF & _
			"Language identifier..: " & _GUICtrlComboBox_GetLocaleLang($hCombo) & @CRLF & _
			"Primary Language id : " & _GUICtrlComboBox_GetLocalePrimLang($hCombo) & @CRLF & _
			"Sub-Language id ....: " & _GUICtrlComboBox_GetLocaleSubLang($hCombo))

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
