#include <Date.au3>
#include <Constants.au3>

Local $iDays = _DateDaysInMonth(@YEAR, @MON)
MsgBox($MB_SYSTEMMODAL, "Days in Month", "This month has " & String($iDays) & " days in it.")
