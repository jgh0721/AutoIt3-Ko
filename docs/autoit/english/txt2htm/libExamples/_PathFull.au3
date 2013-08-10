#include <File.au3>
#include <Constants.au3>

Local $TestPath = _PathFull(@ScriptDir & "..\..\test")
MsgBox($MB_SYSTEMMODAL, "demo _PathFull", @ScriptDir & @CRLF & $TestPath)
