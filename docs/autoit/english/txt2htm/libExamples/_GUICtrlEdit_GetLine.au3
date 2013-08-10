#include <GuiEdit.au3>
#include <GUIConstantsEx.au3>
#include <Constants.au3>

$Debug_Ed = False ; Check ClassName being passed to Edit functions, set to True and use a handle to another control to see it work

_Main()

Func _Main()
	Local $hEdit
	Local $sWow64 = ""
	If @AutoItX64 Then $sWow64 = "\Wow6432Node"
	Local $sFile = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE" & $sWow64 & "\AutoIt v3\AutoIt", "InstallDir") & "\include\_ReadMe_.txt"

	; Create GUI
	GUICreate("Edit Get Line", 400, 300)
	$hEdit = GUICtrlCreateEdit("", 2, 2, 394, 268)
	GUISetState()

	_GUICtrlEdit_SetText($hEdit, FileRead($sFile))

	MsgBox($MB_SYSTEMMODAL, "Information", _GUICtrlEdit_GetLine($hEdit, 2))

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
