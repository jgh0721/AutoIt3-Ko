#include <GUIConstantsEx.au3>
#include <GuiTab.au3>
#include <Constants.au3>

$Debug_TAB = False ; Check ClassName being passed to functions, set to True and use a handle to another control to see it work

_Main()

Func _Main()
	Local $hTab

	; Create GUI
	GUICreate("Tab Control Get Extended Style", 400, 300)
	$hTab = GUICtrlCreateTab(2, 2, 396, 296, BitOR($TCS_BUTTONS, $TCS_FLATBUTTONS))
	GUISetState()

	; Add tabs
	_GUICtrlTab_InsertItem($hTab, 0, "Tab 1")
	_GUICtrlTab_InsertItem($hTab, 1, "Tab 2")
	_GUICtrlTab_InsertItem($hTab, 2, "Tab 3")

	; Get/Set extended styles
	_GUICtrlTab_SetExtendedStyle($hTab, $TCS_EX_FLATSEPARATORS)
	MsgBox($MB_SYSTEMMODAL, "Information", "Extended styles: 0x" & Hex(_GUICtrlTab_GetExtendedStyle($hTab)))

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
