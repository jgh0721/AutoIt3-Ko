#include <Array.au3>
#include <Constants.au3>

Local $avArray = StringSplit("4,2,06,8,12,5", ",")

MsgBox($MB_SYSTEMMODAL, 'Max String value', _ArrayMax($avArray, 0, 1))
MsgBox($MB_SYSTEMMODAL, 'Max Numeric value', _ArrayMax($avArray, 1, 1))
