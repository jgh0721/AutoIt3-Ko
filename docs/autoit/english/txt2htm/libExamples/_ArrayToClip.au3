#include <Array.au3>
#include <Constants.au3>

Local $avArray = StringSplit("a,b,c,d,e,f,g,h,i", ",")
_ArrayToClip($avArray, 1)
MsgBox($MB_SYSTEMMODAL, "_ArrayToClip() Test", ClipGet())
