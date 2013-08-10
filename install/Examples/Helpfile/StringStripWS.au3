#include <Constants.au3>

; Strip leading and trailing whitespace as well as the double spaces (or more) in between the words.
Local $sString = StringStripWS("   This   is   a   sentence   with   whitespace.    ", 1 + 2 + 4)
MsgBox($MB_SYSTEMMODAL, "", $sString)
