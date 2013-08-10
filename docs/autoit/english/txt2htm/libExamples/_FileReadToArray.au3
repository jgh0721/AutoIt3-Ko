#include <Array.au3>
#include <File.au3>
#include <Constants.au3>

Example1()

Func Example1()
	; Define a variable to pass to _FileReadToArray.
	Local $aArray = 0

	; Read the current script file into an array using the variable defined previously.
	If Not _FileReadToArray(@ScriptFullPath, $aArray) Then
		MsgBox($MB_SYSTEMMODAL, "", "There was an error reading the file. @error: " & @error) ; An error occurred reading the current script file.
	EndIf

	; Display the array in _ArrayDisplay.
	_ArrayDisplay($aArray)
EndFunc   ;==>Example1
