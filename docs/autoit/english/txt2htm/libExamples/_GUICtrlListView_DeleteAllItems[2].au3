#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <Constants.au3>

$Debug_LV = False ; Check ClassName being passed to ListView functions, set to True and use a handle to another control to see it work

Example2()

Func Example2()
	Local $hListView, $aItems[10][3]

	GUICreate("ListView Delete All Items", 400, 300)

	$hListView = GUICtrlCreateListView("col1|col2|col3", 2, 2, 394, 268)
	GUISetState()

	; 3 column load
	For $iI = 0 To UBound($aItems) - 1
		$aItems[$iI][0] = "Item " & $iI
		$aItems[$iI][1] = "Item " & $iI & "-1"
		$aItems[$iI][2] = "Item " & $iI & "-2"
	Next

	_GUICtrlListView_AddArray($hListView, $aItems)

	MsgBox($MB_SYSTEMMODAL, "Information", "Delete All Items")
	; Items created using UDF function(s), pass the handle to the control
	MsgBox($MB_SYSTEMMODAL, "Deleted?", _GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListView)))

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example2
