#include <Constants.au3>

Example()

Func Example()
	; Save the downloaded file to the temporary folder.
	Local $sFilePath = @TempDir & "\update.dat"

	; Download the file in the background with the selected option of 'force a reload from the remote site.'
	Local $hDownload = InetGet("http://www.autoitscript.com/autoit3/files/beta/update.dat", @TempDir & "\update.dat", 1, 1)

	; Wait for the download to complete by monitoring when the 2nd index value of InetGetInfo returns True.
	Do
		Sleep(250)
	Until InetGetInfo($hDownload, 2)

	; Retrieve details about the download file.
	Local $aData = InetGetInfo($hDownload)
	If @error Then Return SetError(1, 0, FileDelete($sFilePath)) ; If an error occurred the return from the function and delete the file.

	; Close the handle returned by InetGet.
	InetClose($hDownload)

	; Display details about the downloaded file.
	MsgBox($MB_SYSTEMMODAL, "", "Bytes read: " & $aData[0] & @CRLF & _
			"Size: " & $aData[1] & @CRLF & _
			"Complete: " & $aData[2] & @CRLF & _
			"successful: " & $aData[3] & @CRLF & _
			"@error: " & $aData[4] & @CRLF & _
			"@extended: " & $aData[5] & @CRLF)

	; Delete the file.
	FileDelete($sFilePath)
EndFunc   ;==>Example
