#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $gui, $guiPos, $pic, $picPos

Example2()

Func Example2()
	Local $msg

	$gui = GUICreate("test transparentpic", 200, 100)
	$pic = GUICreate("", 68, 71, 10, 20, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $gui)
	GUICtrlCreatePic("..\GUI\merlin.gif", 0, 0, 0, 0)

	GUISetState(@SW_SHOW, $pic)
	GUISetState(@SW_SHOW, $gui)

	HotKeySet("{ESC}", "main")
	HotKeySet("{LEFT}", "left")
	HotKeySet("{RIGHT}", "right")
	HotKeySet("{DOWN}", "down")
	HotKeySet("{UP}", "up")
	$picPos = WinGetPos($pic)
	$guiPos = WinGetPos($gui)

	Do
		$msg = GUIGetMsg()
	Until $msg = $GUI_EVENT_CLOSE

	HotKeySet("{ESC}")
	HotKeySet("{LEFT}")
	HotKeySet("{RIGHT}")
	HotKeySet("{DOWN}")
	HotKeySet("{UP}")
EndFunc   ;==>Example2

Func main()
	$guiPos = WinGetPos($gui)
	WinMove($gui, "", $guiPos[0] + 10, $guiPos[1] + 10)
EndFunc   ;==>main

Func left()
	$picPos = WinGetPos($pic)
	WinMove($pic, "", $picPos[0] - 10, $picPos[1])
EndFunc   ;==>left

Func right()
	$picPos = WinGetPos($pic)
	WinMove($pic, "", $picPos[0] + 10, $picPos[1])
EndFunc   ;==>right

Func down()
	$picPos = WinGetPos($pic)
	WinMove($pic, "", $picPos[0], $picPos[1] + 10)
EndFunc   ;==>down

Func up()
	$picPos = WinGetPos($pic)
	WinMove($pic, "", $picPos[0], $picPos[1] - 10)
EndFunc   ;==>up
