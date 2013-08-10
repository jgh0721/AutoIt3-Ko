#include <File.au3>
#include <Constants.au3>

If Not _FileCreate("error.log") Then
	MsgBox($MB_SYSTEMMODAL, "Error", " Error Creating/Resetting log.      error:" & @error)
EndIf
