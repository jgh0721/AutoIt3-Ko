#include <Constants.au3>

; Result of when Min and Max are the same value.

Example4()

Func Example4()
	Local $iRandom = Random(10, 10)
	If @error Then
		MsgBox($MB_SYSTEMMODAL, "", "An error occurred, due to the fact both values are exactly the same: " & $iRandom)
	EndIf
EndFunc   ;==>Example4
