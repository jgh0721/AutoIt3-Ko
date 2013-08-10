#include <Constants.au3>
#include <File.au3>

; Create a path.
Local $sFilePath = _PathMake("C:", "\Temp", "Boot", "ini")
MsgBox($MB_SYSTEMMODAL, "", $sFilePath)
