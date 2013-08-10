#include <WinAPI.au3>
#include <Constants.au3>

_Main()

Func _Main()
	Local $iWord = 11 * 65535
	MsgBox($MB_SYSTEMMODAL, $iWord, "HiWord: " & _WinAPI_HiWord($iWord) & @CRLF & "LoWord: " & _WinAPI_LoWord($iWord))
EndFunc   ;==>_Main
