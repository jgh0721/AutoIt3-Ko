#include <WinAPI.au3>
#include <Constants.au3>

MsgBox($MB_SYSTEMMODAL, "ID", "Get Current Process: " & _WinAPI_GetCurrentProcessID())
