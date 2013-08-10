#include <Constants.au3>

; Register Example1 and Example2 to be called when AutoIt starts.

#OnAutoItStartRegister "Example1"
#OnAutoItStartRegister "Example2"

Sleep(1000)

Func Example1()
	MsgBox($MB_SYSTEMMODAL, "", "Function 'Example1' is called first.")
EndFunc   ;==>Example1

Func Example2()
	MsgBox($MB_SYSTEMMODAL, "", "Function 'Example2' is called second.")
EndFunc   ;==>Example2
