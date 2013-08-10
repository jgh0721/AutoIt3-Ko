#include <Math.au3>
#include <Constants.au3>

Local $degrees = 35
Local $radians = _Radian($degrees)

MsgBox($MB_SYSTEMMODAL, "Degrees to Radians", $degrees & " degrees = " & $radians & " radians")
