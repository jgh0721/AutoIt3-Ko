#include <WinAPI.au3>
#include <Constants.au3>

MsgBox($MB_SYSTEMMODAL, "ID", "Get Current Thread: " & _WinAPI_GetCurrentThreadId())
