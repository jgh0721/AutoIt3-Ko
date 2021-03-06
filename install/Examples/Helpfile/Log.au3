#include <Constants.au3>

Example()

Func Example()
	; Assign a Local variable the natural logarithm of 1000.
	Local $iLog1 = Log(1000)

	; Display the result.
	MsgBox($MB_SYSTEMMODAL, "", $iLog1)


	; Assign a Local variable the base-10 natural logarithm of 1000.
	Local $iLog2 = Log10(1000)

	; Display the result.
	MsgBox($MB_SYSTEMMODAL, "", $iLog2)
EndFunc

; User-defined function for common log
Func Log10($iNb)
    Return Log($iNb) / Log(10) ; 10 is the base
EndFunc   ;==>Log10
