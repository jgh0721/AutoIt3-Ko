#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <Constants.au3>

$Debug_LV = False ; Check ClassName being passed to ListView functions, set to True and use a handle to another control to see it work

_Main()

Func _Main()

	Local $GUI, $HandleBefore, $hListView

	$GUI = GUICreate("(UDF Created) ListView Destroy", 400, 300)

	$hListView = _GUICtrlListView_Create($GUI, "", 2, 2, 394, 268)
	$HandleBefore = $hListView
	GUISetState()

	; Add columns
	_GUICtrlListView_InsertColumn($hListView, 0, "Column 1", 100)
	_GUICtrlListView_InsertColumn($hListView, 1, "Column 2", 100)
	_GUICtrlListView_InsertColumn($hListView, 2, "Column 3", 100)

	; Add items
	_GUICtrlListView_AddItem($hListView, "Row 1: Col 1")
	_GUICtrlListView_AddSubItem($hListView, 0, "Row 1: Col 2", 1)
	_GUICtrlListView_AddSubItem($hListView, 0, "Row 1: Col 3", 2)
	_GUICtrlListView_AddItem($hListView, "Row 2: Col 1")
	_GUICtrlListView_AddSubItem($hListView, 1, "Row 2: Col 2", 1)
	_GUICtrlListView_AddItem($hListView, "Row 3: Col 1")

	MsgBox($MB_SYSTEMMODAL, "Information", "Destroying the Control for Handle: " & $hListView)
	MsgBox($MB_SYSTEMMODAL, "Information", "Control Destroyed: " & _GUICtrlListView_Destroy($hListView) & @CRLF & _
			"Handel Before Destroy: " & $HandleBefore & @CRLF & _
			"Handle After Destroy: " & $hListView)

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main