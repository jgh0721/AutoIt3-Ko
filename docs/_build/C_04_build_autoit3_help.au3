;
; Builds AutoIt3 help file
;

#region Includes
#include "include\CompileLib.au3"
#include "include\DocLib.au3"
#endregion Includes

#region Global Variables
; The name of the project.
Global Const $g_sProjectLang = "english"
Global Const $g_sProject = "autoit3 help"
Global Const $g_sProjectDir = "docs\autoit"
;Global Const $g_aBuildFiles[1] = [ "AutoIt.chm" ]
;Global Const $g_aInstallFiles[1] = [ "AutoIt.chm" ]
#endregion Global Variables

#region Main body of code
Global $g_nExitCode = _Main()
Exit $g_nExitCode
#endregion Main body of code

#region _Main()
; ===================================================================
; _Main()
;
; The main function responsible for generating the syntax files.
; Parameters:
;	None.
; Returns:
;	0 on success, non-zero on failure.
; ===================================================================
Func _Main()
	; Create the output window and initial message.
	_OutputWindowCreate()
	_OutputProgressWrite("==== Output for " & StringTrimRight(@ScriptName, 4) & " (" & $g_sProject & ") ====" & @CRLF)
	_OutputProgressWrite("Generating AutoIt3.chm..." & @CRLF)

	; Set the build directory based on the rules and the INI file value.
	Local $gBuildDir = _BuildDirSet()

	; Delete files in the install dir that we are about to change
	FileDelete('install\AutoIt3.chm')

	; Update the helpfile
	FileChangeDir($gBuildDir & "\" & $g_sProjectDir & "\" & $g_sProjectLang)
	RunWait('"' & @AutoItExe & '" All_Gen_AutoIt3.au3')

	; Udpate index_chm.htm based on index.htm
	Local $sFileread = FileRead("html\index.htm")
	$sFileread = StringReplace($sFileread, "history.htm", "history_chm.htm")
	FileDelete("html\index_chm.htm")
	FileWrite("html\index_chm.htm", $sFileRead)

	; Holds the return value.
	Local $nReturn = 0

	; Create the helpfile.
	CompileDocumentation("AutoIt3.hhp")
	If @error Then
		_OutputProgressWrite("Error: Unable to compile documentation." & @CRLF)
		$nReturn = 1
	Else
		; Copy the files install
		FileChangeDir($gBuildDir)
		FileMove($g_sProjectDir & "\" & $g_sProjectLang & "\AutoIt3.chm", "install\AutoIt3.chm", 1)

		; Delete all temp files ready for source code packaging
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\Debug.log")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\_errorlog3.txt")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\fileList.tmp")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\genindex.log")

		; Write closing message and wait for close (if applicable).
		_OutputProgressWrite("Finished." & @CRLF & @CRLF) ; Two CRLF's in case of chained output.
	EndIf

	_OutputWaitClosed($nReturn)

	Return $nReturn
EndFunc   ;==>_Main
#endregion _Main()
