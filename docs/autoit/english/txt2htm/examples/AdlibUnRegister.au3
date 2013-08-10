AdlibRegister("MyAdlib")

; Messages from MyAdlib will show during this sleep
Sleep(1000)

AdlibUnRegister("MyAdlib")

; MyAdlib is no longer active, so no messages will be printed
ConsoleWrite("2 Second Pause" & @CRLF)
Sleep(2000)

; Re-register MyAdlib
AdlibRegister("MyAdlib")

; Now the adlib messages will start again
Sleep(1000)

Func MyAdlib()
	;... execution must be non blocking, avoid ...Wait(), MsgBox(), InputBox() functions

	Local Static $iCounter = 0
	$iCounter += 1

	ConsoleWrite("Hello from Adlib! " & $iCounter & @CRLF)
EndFunc   ;==>MyAdlib
