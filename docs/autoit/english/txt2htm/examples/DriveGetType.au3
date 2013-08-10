#include <Constants.au3>

; Check the drive type for C:\
Local $sInfo = DriveGetType("C:\")
MsgBox($MB_SYSTEMMODAL, "", "Drive Type: " & $sInfo)

; Check the SSD status for C:\
$sInfo = DriveGetType("C:\", 2)
MsgBox($MB_SYSTEMMODAL, "", "Drive SSD: " & $sInfo)

; Check the SSD status for disk 0
$sInfo = DriveGetType(0, 2)
MsgBox($MB_SYSTEMMODAL, "", "Drive SSD: " & $sInfo)

; Check the bus type status for disk 0
$sInfo = DriveGetType(0, 3)
MsgBox($MB_SYSTEMMODAL, "", "Drive Bus: " & $sInfo)
