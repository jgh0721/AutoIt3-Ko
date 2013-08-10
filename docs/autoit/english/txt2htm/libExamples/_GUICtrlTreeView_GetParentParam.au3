#include <GUIConstantsEx.au3>
#include <GuiTreeView.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>

$Debug_TV = False ; Check ClassName being passed to functions, set to True and use a handle to another control to see it work

Example_Internal()

Func Example_Internal()

	Local $hItem, $hChild, $hTreeView
	Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)

	GUICreate("TreeView Get Parent Param", 400, 300)

	$hTreeView = GUICtrlCreateTreeView(2, 2, 396, 268, $iStyle, $WS_EX_CLIENTEDGE)
	GUISetState()

	_GUICtrlTreeView_BeginUpdate($hTreeView)
	For $x = 0 To 20
		$hItem = GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $x), $hTreeView)
		For $y = 0 To 2
			$hChild = GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $y), $hItem)
		Next
	Next
	_GUICtrlTreeView_EndUpdate($hTreeView)

	_GUICtrlTreeView_SelectItem($hTreeView, $hChild)
	MsgBox($MB_SYSTEMMODAL, "Information", "Parent Param/ID: " & _GUICtrlTreeView_GetParentParam($hTreeView, $hChild)) ; same as controlId

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example_Internal
