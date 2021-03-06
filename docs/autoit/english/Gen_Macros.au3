#cs
	Credit: Created by guinness - 2013/07/28
#ce
#include '..\..\_build\include\OutputLib.au3'
#include <Array.au3>
#include <File.au3>
#include <Constants.au3>

Opt('TrayIconDebug', 1)

OnAutoItExitRegister('OnQuit') ; ### Debug Console
_OutputWindowCreate() ; ### Debug Console

_OutputProgressWrite('macros.htm Creation...')

FileChangeDir(@ScriptDir)

HTMLMacro(@ScriptDir & '\html\macros', @ScriptDir & '\html\macros.htm')

_OutputProgressWrite('Finished.' & @CRLF) ;### Debug Console

Exit

Func OnQuit()
	_OutputWaitClosed() ; ### Debug Console
EndFunc   ;==>OnQuit

Func HTMLMacro($sMacroPath, $sHTMLOutPath)
	Local $aFileList = _FileListToArray($sMacroPath, '*.htm')
	If @error Then
		_OutputProgressWrite('Missing macro files - please re-generate the html files for the individual marcos.' & @CRLF) ; ### Debug Console
		Return False
	EndIf

	Local $sHTML = ''

	; HTML header.
	$sHTML &= '<!DOCTYPE html>' & @CRLF
	$sHTML &= '<html>' & @CRLF
	$sHTML &= '<head>' & @CRLF
	$sHTML &= @TAB & '<title>Macros</title>' & @CRLF
	$sHTML &= @TAB & '<meta charset="ISO-8859-1">' & @CRLF
	$sHTML &= @TAB & '<link href="css/default.css" rel="stylesheet" type="text/css">' & @CRLF
	$sHTML &= '</head>' & @CRLF
	$sHTML &= '<body>' & @CRLF
	$sHTML &= @TAB & '<h1>Macro Reference</h1>' & @CRLF
	$sHTML &= @TAB & '<p>Below is an alphabetized list of all the macros available in AutoIt.<br></p>' & @CRLF
	$sHTML &= @TAB & '<p>&nbsp;</p>' & @CRLF
	$sHTML &= @TAB & '<table>' & @CRLF
	$sHTML &= @TAB & '<tr>' & @CRLF
	$sHTML &= @TAB & @TAB & '<th>Macro</th>' & @CRLF
	$sHTML &= @TAB & @TAB & '<th>Description</th>' & @CRLF
	$sHTML &= @TAB & '</tr>' & @CRLF

	Local $sData = ''
	; Read the macro files.
	For $i = 1 To $aFileList[0]
		$sData &= FileRead($sMacroPath & '\' & $aFileList[$i])
	Next

	; Convert & to &amp;.
	$sData = StringRegExpReplace($sData, '&(?!(?:amp|gt|lt);)', '&amp;') ; Convert &.

	Local $aMacroList = 0, $hMacroList = 0
	; Generate a 2d array of macros.
	_MacroListToArray($sData, $aMacroList, $hMacroList)
	; Sort the macro array in descending order.
	_ArraySort($aMacroList, 0, 1)
	For $i = 1 To $aMacroList[0][0]
		$hMacroList($aMacroList[$i][0]) = _URLsToRelative($hMacroList($aMacroList[$i][0]))
		$sHTML &= @TAB & '<tr>' & @CRLF
		$sHTML &= @TAB & @TAB & '<td><a name="' & $aMacroList[$i][0] & '"></a><strong>' & $aMacroList[$i][0] & '</strong></td>' & @CRLF
		$sHTML &= @TAB & @TAB & '<td>' & $hMacroList($aMacroList[$i][0]) & '</td>' & @CRLF
		$sHTML &= @TAB & '</tr>' & @CRLF
	Next

	$sHTML &= @TAB & '</table>' & @CRLF
	$sHTML &= '</body>' & @CRLF
	$sHTML &= '</html>' & @CRLF
	Local $hFileOpen = FileOpen($sHTMLOutPath, $FO_OVERWRITE)
	If $hFileOpen > -1 Then
		FileWrite($sHTMLOutPath, $sHTML)
		FileClose($hFileOpen)
	Else
		_OutputProgressWrite('There was an error creating the macros.htm file.' & @CRLF) ; ### Debug Console
	EndIf
	Return True
EndFunc   ;==>HTMLMacro

#Obfuscator_Off
Func _AssociativeArray_Startup(ByRef $aArray, $fIsCaseSensitive = False) ; Idea from MilesAhead.
	$aArray = ObjCreate('Scripting.Dictionary')
	ObjEvent('AutoIt.Error', '__AssociativeArray_Error\\\')
	If IsObj($aArray) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	$aArray.CompareMode = Int(Not $fIsCaseSensitive)
EndFunc   ;==>_AssociativeArray_Startup
#Obfuscator_On

Func _MacroListToArray(ByRef $sData, ByRef $aArray, ByRef $hAssocArray)
	Local $aSRE = StringRegExp($sData, '(?s)</a><strong>(\@\w+)</strong></td>\R\s*<td>(.*?)</td>', 3), _
			$iUBound = UBound($aSRE)
	If $iUBound Then
		_AssociativeArray_Startup($hAssocArray, True)
		Local $aMerge[Ceiling($iUBound / 2) + 1][2]
		For $i = 0 To $iUBound - 1 Step 2
			$aMerge[0][0] += 1
			$aMerge[$aMerge[0][0]][0] = $aSRE[$i]
			$aMerge[$aMerge[0][0]][1] = $aSRE[$i + 1]
			$hAssocArray($aMerge[$aMerge[0][0]][0]) = $aMerge[$aMerge[0][0]][1]
		Next
		$aArray = $aMerge
	EndIf
EndFunc   ;==>_MacroListToArray

Func _URLsToRelative($sData)
	Return StringReplace($sData, '<a href="../', '<a href="')
EndFunc   ;==>_URLsToRelative
