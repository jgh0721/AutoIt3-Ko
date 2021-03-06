#include <GuiListBox.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>

$Debug_LB = False ; Check ClassName being passed to ListBox functions, set to True and use a handle to another control to see it work

_Main()

Func _Main()
	Local $hListBox

	; Create GUI
	GUICreate("List Box Update HScroll", 400, 296)
	$hListBox = GUICtrlCreateList("", 2, 2, 396, 296, BitOR($LBS_NOTIFY, $LBS_SORT, $WS_HSCROLL, $WS_VSCROLL))
	GUISetState()

	; Add long string
	_GUICtrlListBox_AddString($hListBox, "AutoIt v3 is a freeware BASIC-like scripting language designed for automating the Windows GUI.")

	; Show current horizontal extent
	MsgBox($MB_SYSTEMMODAL, "Information", "Horizontal Extent: " & _GUICtrlListBox_GetHorizontalExtent($hListBox))

	; Adjust horizontal scroll bars
	_GUICtrlListBox_UpdateHScroll($hListBox)

	; Show current horizontal extent
	MsgBox($MB_SYSTEMMODAL, "Information", "Horizontal Extent: " & _GUICtrlListBox_GetHorizontalExtent($hListBox))

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
