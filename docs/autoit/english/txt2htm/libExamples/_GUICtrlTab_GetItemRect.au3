#include <GUIConstantsEx.au3>
#include <GuiTab.au3>
#include <Constants.au3>

$Debug_TAB = False ; Check ClassName being passed to functions, set to True and use a handle to another control to see it work

_Main()

Func _Main()
	Local $aRect, $sRect, $hTab

	; Create GUI
	GUICreate("Tab Control Get Item Rect", 400, 300)
	$hTab = GUICtrlCreateTab(2, 2, 396, 296)
	GUISetState()

	; Add tabs
	_GUICtrlTab_InsertItem($hTab, 0, "Tab 1")
	_GUICtrlTab_InsertItem($hTab, 1, "Tab 2")
	_GUICtrlTab_InsertItem($hTab, 2, "Tab 3")

	; Get tab 0 rectangle
	$aRect = _GUICtrlTab_GetItemRect($hTab, 0)
	$sRect = StringFormat("[%d, %d, %d, %d]", $aRect[0], $aRect[1], $aRect[2], $aRect[3])
	MsgBox($MB_SYSTEMMODAL, "Information", "Tab 0 rectangle: " & $sRect)

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
