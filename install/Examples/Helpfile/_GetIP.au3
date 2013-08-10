#include <Constants.au3>
#include <Inet.au3>

Local $sPublicIP = _GetIP()
MsgBox($MB_SYSTEMMODAL, "", "Your external IP address is: " & $sPublicIP)
