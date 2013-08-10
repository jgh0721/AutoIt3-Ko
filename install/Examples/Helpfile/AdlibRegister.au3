#include <Constants.au3>

AdlibRegister("MyAdlib")

; Sleep does not stop adlib functions from running
Sleep(1000)

; Adlib functions won't run while MsgBox is showing
MsgBox($MB_SYSTEMMODAL, Default, "No console messages while this is showing!")

; Now the adlib function will start again
Sleep(1000)

Func MyAdlib()
	;... execution must be non blocking, avoid ...Wait(), MsgBox(), InputBox() functions

	Local Static $iCounter = 0
	$iCounter += 1

	ConsoleWrite("Hello from Adlib! " & $iCounter & @CRLF)
EndFunc   ;==>MyAdlib
