#include <WinAPI.au3>
#include <Constants.au3>

MsgBox($MB_SYSTEMMODAL, "Environment string", "%windir% = " & _WinAPI_ExpandEnvironmentStrings("%windir%"))
