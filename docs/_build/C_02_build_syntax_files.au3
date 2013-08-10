;
; Builds AutoIt3 Editor Syntax files
#region Includes
#include "include\CompileLib.au3"
#endregion Includes

#region Global Variables
; The name of the project.
Global Const $g_sProjectLang = "english"
Global Const $g_sProject = "syntaxfiles"
Global Const $g_sProjectDir = "docs\autoit\" & $g_sProjectLang & "\txt2htm"
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
	_OutputProgressWrite("Generating syntax files." & @CRLF)

	; Set the build directory based on the rules and the INI file value.
	Local $gBuildDir = _BuildDirSet()

	; Generate macros.htm.
	FileChangeDir($gBuildDir & '\docs\autoit\english')
	_OutputBuildWrite("Creating macros.htm file" & @CRLF)
	RunWait('"' & @AutoItExe & '"' & ' Gen_Macros.au3')

	; Syntax files lists
	FileChangeDir($gBuildDir & '\docs\autoit\english\txt2htm\syntaxfiles')
	RunWait('"' & @AutoItExe & '" gen_lists.au3')

	FileChangeDir($gBuildDir & '\' & $g_sProjectDir & '\' & $g_sProject & '\Crimson')
	RunWait('"' & @AutoItExe & '" gen_syntax.au3')
	FileMove("autoit3.key", $gBuildDir & "\install\Extras\Editors\Crimson\autoit3.key", 1)

	FileChangeDir($gBuildDir & '\' & $g_sProjectDir & '\' & $g_sProject & '\Notepad++')
	RunWait('"' & @AutoItExe & '" gen_syntax.au3')
	FileMove("autoit.xml", $gBuildDir & "\install\Extras\Editors\Notepad++\autoit.xml", 1)

	FileChangeDir($gBuildDir & '\' & $g_sProjectDir & '\' & $g_sProject & '\PSPad')
	RunWait('"' & @AutoItExe & '" gen_syntax.au3') ; Includes gen_def.au3
	; RunWait('"' & @AutoItExe & '" gen_def.au3') ; This is still required for now, due to the stylesheet being different from the rest of the editors.
	FileMove("AutoIt3.ini", $gBuildDir & "\install\Extras\Editors\PSPad\AutoIt3.ini", 1)
	FileMove("AutoIt3.def", $gBuildDir & "\install\Extras\Editors\PSPad\AutoIt3.def", 1)
	; FileDelete("macros.txt")

	FileChangeDir($gBuildDir & '\' & $g_sProjectDir & '\' & $g_sProject & '\Textpad')
	RunWait('"' & @AutoItExe & '" gen_syntax.au3')
	FileMove("autoit_v3.syn", $gBuildDir & "\install\Extras\Editors\TextPad\autoit_v3.syn", 1)

	; Write closing message and wait for close (if applicable).
	_OutputProgressWrite("Finished." & @CRLF & @CRLF) ; Two CRLF's in case of chained output.
	_OutputWaitClosed()

	Return 0
EndFunc   ;==>_Main
#endregion _Main()
