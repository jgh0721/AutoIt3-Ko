#include <GuiEdit.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>

$Debug_Ed = False ; Check ClassName being passed to Edit functions, set to True and use a handle to another control to see it work

_Main()

Func _Main()
	Local $hEdit
	Local $sWow64 = ""
	If @AutoItX64 Then $sWow64 = "\Wow6432Node"
	Local $sFile = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE" & $sWow64 & "\AutoIt v3\AutoIt", "InstallDir") & "\include\_ReadMe_.txt"
	Local $sBefore, $sAfter

	; Create GUI
	GUICreate("Edit FmtLines", 400, 300)
	$hEdit = GUICtrlCreateEdit("", 2, 2, 394, 268, BitOR($ES_WANTRETURN, $WS_VSCROLL))
	GUISetState()

	; Set Text
	_GUICtrlEdit_SetText($hEdit, FileRead($sFile, 500))

	; Text retrieved in default format
	$sBefore = _GUICtrlEdit_GetText($hEdit)

	; insert soft line-breaks
	_GUICtrlEdit_FmtLines($hEdit, True)

	; Text with soft line breaks
	$sAfter = _GUICtrlEdit_GetText($hEdit)

	MsgBox($MB_SYSTEMMODAL, "Information", "Before:" & @CRLF & @CRLF & $sBefore & @CRLF & _
			'--------------------------------------------------------------' & @CRLF & _
			"After:" & @CRLF & @CRLF & $sAfter)

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
