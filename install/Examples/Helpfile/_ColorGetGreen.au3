#include <Color.au3>
#include <Constants.au3>

Local $iGreenColor = _ColorGetGreen(0x8080ff)
MsgBox($MB_SYSTEMMODAL, "AutoIt", $iGreenColor)
