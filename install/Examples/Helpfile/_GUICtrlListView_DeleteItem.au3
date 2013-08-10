#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <Constants.au3>

$Debug_LV = False ; Check ClassName being passed to ListView functions, set to True and use a handle to another control to see it work

Example1()

Func Example1()
	Local $hListView

	GUICreate("ListView Delete Item", 400, 300)
	$hListView = GUICtrlCreateListView("col1|col2|col3", 2, 2, 394, 268)
	GUISetState()

	; 3 column load
	For $iI = 0 To 9
		GUICtrlCreateListViewItem("Item " & $iI & "|Item " & $iI & "-1|Item " & $iI & "-2", $hListView)
	Next

	MsgBox($MB_SYSTEMMODAL, "Information", "Delete Item")
	; Delete the selected item.
	MsgBox($MB_SYSTEMMODAL, "Deleted?", _GUICtrlListView_DeleteItem(GUICtrlGetHandle($hListView), 1))

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example1
