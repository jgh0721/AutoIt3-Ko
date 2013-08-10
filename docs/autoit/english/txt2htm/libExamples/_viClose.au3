; - This assumes that you have instrument set to GPIB address 1
; It shows how to use the _viExecCommand function in stand alone mode and combined
; with _viOpen and _viClose.
; It also shows the _viGTL function

#include <Visa.au3>
#include <Constants.au3>

Local $h_session = 0

; Query the ID of the instrument in GPIB address 3
MsgBox($MB_SYSTEMMODAL, "Step 1", "Open the instrument connection with _viOpen")
Local $h_instr = _viOpen("GPIB::3::0")
MsgBox($MB_SYSTEMMODAL, "Instrument Handle obtained", "$h_instr = " & $h_instr) ; Show the Session Handle
; Query the instrument

MsgBox($MB_SYSTEMMODAL, "Step 2", "Query the instrument using the VISA instrument handle")
Local $s_answer = _viExecCommand($h_instr, "*IDN?") ; $h_instr is NOT A STRING now!
MsgBox($MB_SYSTEMMODAL, "GPIB QUERY result", $s_answer) ; Show the answer
; Query again. There is no need to OPEN the link again

MsgBox($MB_SYSTEMMODAL, "Step 3", "Query again. There is no need to OPEN the link again")
$s_answer = _viExecCommand($h_instr, "*IDN?")
MsgBox($MB_SYSTEMMODAL, "GPIB QUERY result", $s_answer) ; Show the answer

MsgBox($MB_SYSTEMMODAL, "Step 4", "Close the instrument connection using _viClose")
_viClose($h_instr) ; Close the instrument connection
