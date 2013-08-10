#include <Constants.au3>

; Roll a die.

Example2()

Func Example2()
	MsgBox($MB_SYSTEMMODAL, "", "The die landed on number " & Random(1, 6, 1) & ".") ; Return an integer between 1 and 6.
EndFunc   ;==>Example2
