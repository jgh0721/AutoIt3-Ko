#include <Constants.au3>

Local $aMem = MemGetStats()
MsgBox($MB_SYSTEMMODAL, "", "Total physical RAM (KB): " & $aMem[1])
