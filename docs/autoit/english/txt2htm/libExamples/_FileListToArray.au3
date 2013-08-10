#include <Array.au3>
#include <File.au3>
#include <Constants.au3>

Example1()

Func Example1()
	; List all the files and folders in the desktop directory using the default parameters.
	Local $aFileList = _FileListToArray(@DesktopDir, "*")
	If @error = 1 Then
		MsgBox($MB_SYSTEMMODAL, "", "Path was invalid.")
		Exit
	EndIf
	If @error = 4 Then
		MsgBox($MB_SYSTEMMODAL, "", "No file(s) were found.")
		Exit
	EndIf
	; Display the results returned by _FileListToArray.
	_ArrayDisplay($aFileList, "$aFileList")
EndFunc   ;==>Example1
