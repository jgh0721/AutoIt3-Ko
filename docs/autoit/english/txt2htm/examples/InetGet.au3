#include <Constants.au3>

; Download a file in the background.
; Wait for the download to complete.

Example1()

Func Example1()
	; Save the downloaded file to the temporary folder.
	Local $sFilePath = @TempDir & "\update.dat"

	; Download the file in the background with the selected option of 'force a reload from the remote site.'
	Local $hDownload = InetGet("http://www.autoitscript.com/autoit3/files/beta/update.dat", @TempDir & "\update.dat", 1, 1)

	; Wait for the download to complete by monitoring when the 2nd index value of InetGetInfo returns True.
	Do
		Sleep(250)
	Until InetGetInfo($hDownload, 2)

	; Retrieve the number of total bytes received and the filesize.
	Local $iBytesSize = InetGetInfo($hDownload, 0)
	Local $iFileSize = FileGetSize($sFilePath)

	; Close the handle returned by InetGet.
	InetClose($hDownload)

	; Display details about the total number of bytes read and the filesize.
	MsgBox($MB_SYSTEMMODAL, "", "The total download size: " & $iBytesSize & @CRLF & _
			"The total filesize: " & $iFileSize)

	; Delete the file.
	FileDelete($sFilePath)
EndFunc   ;==>Example1
