#include <Constants.au3>

Example2()

Func Example2()
	Local $sText = "This\nline\ncontains\nC-style breaks." ; Define a variable with a string of text.
	Local $aArray = StringSplit($sText, '\n', 1) ; Pass the variable to StringSplit and using the delimeter "\n". Note that flag paramter is set to 1.
	#cs
		The array returned will contain the following values:
		$aArray[1] = "This"
		$aArray[2] = "line"
		...
		$aArray[4] = "C-style breaks."
	#ce

	For $i = 1 To $aArray[0] ; Loop through the array returned by StringSplit to display the individual values.
		MsgBox($MB_SYSTEMMODAL, "Example2", "$aArray[" & $i & "] - " & $aArray[$i])
	Next
EndFunc   ;==>Example2
