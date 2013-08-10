; Example of using ATan with degrees
#include <Constants.au3>
#include <Math.au3>

Local $x = _Degree(ATan(1))

MsgBox($MB_SYSTEMMODAL, Default, "ATan(1) = " & $x & " degrees")
