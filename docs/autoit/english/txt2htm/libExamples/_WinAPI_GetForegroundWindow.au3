#include <WinAPI.au3>
#include <Constants.au3>

MsgBox($MB_SYSTEMMODAL, "Handle", "Get Foreground Window: " & _WinAPI_GetForegroundWindow())
