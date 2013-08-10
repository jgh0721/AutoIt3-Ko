#include <Constants.au3>

; Download a file in the background.
; Wait for the download to complete.

Example2()

Func Example2()
	; Save the downloaded file to the temporary folder.
	Local $sFilePath = @TempDir & "\update.dat"

	; Download the file by waiting for it to complete. The option of 'get the file from the local cache' has been selected.
	Local $iBytesSize = InetGet("http://www.autoitscript.com/autoit3/files/beta/update.dat", @TempDir & "\update.dat", 1)

	; Retrieve the filesize.
	Local $iFileSize = FileGetSize($sFilePath)

	; Display details about the total number of bytes read and the filesize.
	MsgBox($MB_SYSTEMMODAL, "", "The total download size: " & $iBytesSize & @CRLF & _
			"The total filesize: " & $iFileSize)

	; Delete the file.
	FileDelete($sFilePath)
EndFunc   ;==>Example2
