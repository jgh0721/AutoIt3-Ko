#include <GuiEdit.au3>
#include <GuiStatusBar.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>

$Debug_Ed = False ; Check ClassName being passed to Edit functions, set to True and use a handle to another control to see it work

_Main()

Func _Main()
	Local $hStatusBar, $hEdit, $hGUI
	Local $sWow64 = ""
	If @AutoItX64 Then $sWow64 = "\Wow6432Node"
	Local $sFile = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE" & $sWow64 & "\AutoIt v3\AutoIt", "InstallDir") & "\include\_ReadMe_.txt"
	Local $aPartRightSide[3] = [200, 378, -1]

	; Create GUI
	$hGUI = GUICreate("Edit Replace Sel", 400, 300)
	$hEdit = GUICtrlCreateEdit("", 2, 2, 394, 268, BitOR($ES_WANTRETURN, $WS_VSCROLL))
	$hStatusBar = _GUICtrlStatusBar_Create($hGUI, $aPartRightSide)
	_GUICtrlStatusBar_SetIcon($hStatusBar, 2, 97, "shell32.dll")
	GUISetState()

	; Set Margins
	_GUICtrlEdit_SetMargins($hEdit, BitOR($EC_LEFTMARGIN, $EC_RIGHTMARGIN), 10, 10)

	; Set Text
	_GUICtrlEdit_SetText($hEdit, FileRead($sFile))

	; Set Sel
	_GUICtrlEdit_SetSel($hEdit, 0, 8)

	MsgBox($MB_SYSTEMMODAL, "Information", "Replace Sel")
	_GUICtrlEdit_ReplaceSel($hEdit, StringFormat("%d/%2d/%4d", @MON, @MDAY, @YEAR))

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
