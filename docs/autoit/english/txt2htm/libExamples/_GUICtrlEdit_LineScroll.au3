#include <GuiEdit.au3>
#include <GuiStatusBar.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

$Debug_Ed = False ; Check ClassName being passed to Edit functions, set to True and use a handle to another control to see it work

_Main()

Func _Main()
	Local $hStatusBar, $hEdit, $hGUI, $sText

	; Create GUI
	$hGUI = GUICreate("Edit Line Scroll", 400, 300)
	$hEdit = GUICtrlCreateEdit("", 2, 2, 394, 268, BitOR($ES_WANTRETURN, $WS_VSCROLL))
	$hStatusBar = _GUICtrlStatusBar_Create($hGUI)
	GUISetState()

	; Set Text
	For $i = 1 To 50
		$sText &= $i & @CRLF
	Next
	_GUICtrlEdit_SetText($hEdit, $sText)

	; Scroll
	_GUICtrlStatusBar_SetText($hStatusBar, "Scrolled: " & _GUICtrlEdit_LineScroll($hEdit, 0, _GUICtrlEdit_GetLineCount($hEdit)))

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
