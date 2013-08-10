#include-once

#include "Constants.au3"

; #INDEX# =======================================================================================================================
; Title .........: File
; AutoIt Version : 3.2
; Language ......: English
; Description ...: Functions that assist with files and directories.
; Author(s) .....: Brian Keene, SolidSnake, erifash, Jon, JdeB, Jeremy Landes, MrCreatoR, cdkid, Valik, Erik Pilsits, Kurt, Dale, guinness, DXRW4E, Melba23
; Dll(s) ........: shell32.dll
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _FileCountLines
; _FileCreate
; _FileListToArray
; _FileListToArrayRec
; _FilePrint
; _FileReadToArray
; _FileWriteFromArray
; _FileWriteLog
; _FileWriteToLine
; _PathFull
; _PathGetRelative
; _PathMake
; _PathSplit
; _ReplaceStringInFile
; _TempFile
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
; __FLTAR_ListToMask
; __FLTAR_AddToList
; __FLTAR_AddFileLists
; __FLTAR_FileListSearch
; __FLTAR_ArraySort
; __FLTAR_ArrayConcatenate
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Tylo <tylo at start dot no>
; Modified.......: Xenobiologist, Gary, guinness, DXRW4E
; ===============================================================================================================================
Func _FileCountLines($sFilePath)
	Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
	If $hFileOpen = -1 Then Return SetError(1, 0, 0)

	Local $sFileRead = StringStripWS(FileRead($hFileOpen), $STR_STRIPTRAILING)
	FileClose($hFileOpen)
	Return UBound(StringRegExp($sFileRead, "(*BSR_ANYCRLF)\R", 3)) + 1 - Int($sFileRead = "")
EndFunc   ;==>_FileCountLines

; #FUNCTION# ====================================================================================================================
; Author ........: Brian Keene <brian_keene at yahoo dot com>
; Modified.......:
; ===============================================================================================================================
Func _FileCreate($sFilePath)
	Local $hFileOpen = FileOpen($sFilePath, $FO_OVERWRITE)
	If $hFileOpen = -1 Then Return SetError(1, 0, 0)

	Local $iFileWrite = FileWrite($hFileOpen, "")
	FileClose($hFileOpen)
	If Not $iFileWrite Then Return SetError(2, 0, 0)
	Return 1
EndFunc   ;==>_FileCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Michael Michta
; Modified.......: guinness - Added optional parameter to return the full path.
; ===============================================================================================================================
Func _FileListToArray($sFilePath, $sFilter = "*", $iFlag = 0, $fReturnPath = False)
	Local $sDelimiter = "|", $sFileList = "", $sFileName = "", $sFullPath = ""

	; Check parameters for the Default keyword or they meet a certain criteria
	$sFilePath = StringRegExpReplace($sFilePath, "[\\/]+$", "") & "\" ; Ensure a single trailing backslash
	If $iFlag = Default Then $iFlag = 0
	If $fReturnPath Then $sFullPath = $sFilePath
	If $sFilter = Default Then $sFilter = "*"

	; Check if the directory exists
	If Not FileExists($sFilePath) Then Return SetError(1, 0, 0)
	If StringRegExp($sFilter, "[\\/:><\|]|(?s)^\s*$") Then Return SetError(2, 0, 0)
	If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 0, 0)
	Local $hSearch = FileFindFirstFile($sFilePath & $sFilter)
	If @error Then Return SetError(4, 0, 0)
	While 1
		$sFileName = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If ($iFlag + @extended = 2) Then ContinueLoop
		$sFileList &= $sDelimiter & $sFullPath & $sFileName
	WEnd
	FileClose($hSearch)
	If $sFileList = "" Then Return SetError(4, 0, 0)
	Return StringSplit(StringTrimLeft($sFileList, 1), $sDelimiter)
EndFunc   ;==>_FileListToArray

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23 - with credits for code snippets to Ultima, Partypooper, Spiff59, guinness, wraithdu
; Modified ......:
; ===============================================================================================================================
Func _FileListToArrayRec($sInitialPath, $sMask = "*", $iReturn = 0, $iRecur = 0, $iSort = 0, $iReturnPath = 1)
	Local $asReturnList[100] = [0], $asFileMatchList[100] = [0], $asRootFileMatchList[100] = [0], $asFolderMatchList[100] = [0], $asFolderSearchList[100] = [1]
	Local $sInclude_List = "*", $sExclude_List, $sExclude_List_Folder, $sInclude_File_Mask = ".+", $sExclude_File_Mask = ":", $sInclude_Folder_Mask = ".+", $sExclude_Folder_Mask = ":"
	Local $sFolderSlash = "", $iMaxLevel, $hSearch, $fFolder, $sRetPath = "", $sCurrentPath, $sName, $iAttribs, $iHide_HS = 0, $iHide_Link = 0, $fLongPath = False
	Local $asFolderFileSectionList[100][2] = [[0, 0]], $sFolderToFind, $iFileSectionStartIndex, $iFileSectionEndIndex

	; Check for valid path
	If StringLeft($sInitialPath, 4) == "\\?\" Then
		$fLongPath = True
	EndIf
	If Not FileExists($sInitialPath) Then Return SetError(1, 1, "")

	; Check if folders should have trailing \ and ensure that initial path does have one
	If StringRight($sInitialPath, 1) = "\" Then
		$sFolderSlash = "\"
	Else
		$sInitialPath = $sInitialPath & "\"
	EndIf
	; Add path to folder search list
	$asFolderSearchList[1] = $sInitialPath

	; Check for Default keyword
	If $sMask = Default Then $sMask = "*"
	If $iReturn = Default Then $iReturn = 0
	If $iRecur = Default Then $iRecur = 0
	If $iSort = Default Then $iSort = 0
	If $iReturnPath = Default Then $iReturnPath = 1

	; Check for H or S omitted
	If BitAND($iReturn, 4) Then
		$iHide_HS += 2
		$iReturn -= 4
	EndIf
	If BitAND($iReturn, 8) Then
		$iHide_HS += 4
		$iReturn -= 8
	EndIf

	; Check for link/junction omitted
	If BitAND($iReturn, 16) Then
		$iHide_HS = 0x406
		$iReturn -= 16
	EndIf

	; Check for valid recur value
	If $iRecur > 1 Or Not IsInt($iRecur) Then Return SetError(1, 6, "")
	; If required, determine \ count for max recursive level setting
	If $iRecur < 0 Then
		StringReplace($sInitialPath, "\", "", 0, 2)
		$iMaxLevel = @extended - $iRecur
	EndIf

	; Check mask parameter
	Local $aMaskSplit = StringSplit($sMask, "|")
	; Check for multiple sections and set values
	Switch $aMaskSplit[0]
		Case 3
			$sExclude_List_Folder = $aMaskSplit[3]
			ContinueCase
		Case 2
			$sExclude_List = $aMaskSplit[2]
			ContinueCase
		Case 1
			$sInclude_List = $aMaskSplit[1]
	EndSwitch

	; Create Include mask for files
	If $sInclude_List <> "*" Then
		If Not __FLTAR_ListToMask($sInclude_File_Mask, $sInclude_List) Then Return SetError(1, 2, "")
	EndIf
	; Set Include mask for folders
	Switch $iReturn
		Case 0
			; Folders affected by mask if not recursive
			Switch $iRecur
				Case 0
					; Folders match mask for compatibility
					$sInclude_Folder_Mask = $sInclude_File_Mask
			EndSwitch
		Case 2
			; Folders affected by mask
			$sInclude_Folder_Mask = $sInclude_File_Mask
	EndSwitch

	; Create Exclude List mask for files
	If $sExclude_List <> "" Then
		If Not __FLTAR_ListToMask($sExclude_File_Mask, $sExclude_List) Then Return SetError(1, 3, "")
	EndIf

	; Create Exclude mask for folders
	If $iRecur Then
		If $sExclude_List_Folder Then
			If Not __FLTAR_ListToMask($sExclude_Folder_Mask, $sExclude_List_Folder) Then Return SetError(1, 4, "")
		EndIf
		; If folders only
		If $iReturn = 2 Then
			; Folders affected by normal mask
			$sExclude_Folder_Mask = $sExclude_File_Mask
		EndIf
	Else
		; Folders affected by normal mask
		$sExclude_Folder_Mask = $sExclude_File_Mask
	EndIf

	; Verify other parameters
	If Not ($iReturn = 0 Or $iReturn = 1 Or $iReturn = 2) Then Return SetError(1, 5, "")
	If Not ($iSort = 0 Or $iSort = 1 Or $iSort = 2) Then Return SetError(1, 7, "")
	If Not ($iReturnPath = 0 Or $iReturnPath = 1 Or $iReturnPath = 2) Then Return SetError(1, 8, "")

	; Prepare for DllCall if required
	If $iHide_HS Or $iHide_Link Then
		Local $tFile_Data = DllStructCreate("struct;align 4;dword FileAttributes;uint64 CreationTime;uint64 LastAccessTime;uint64 LastWriteTime;" & _
				"dword FileSizeHigh;dword FileSizeLow;dword Reserved0;dword Reserved1;wchar FileName[260];wchar AlternateFileName[14];endstruct")
		Local $pFile_Data = DllStructGetPtr($tFile_Data), $hDLL = DllOpen('kernel32.dll'), $aDLL_Ret
	EndIf

	; Search within listed folders
	While $asFolderSearchList[0] > 0

		; Set path to search
		$sCurrentPath = $asFolderSearchList[$asFolderSearchList[0]]
		; Reduce folder search list count
		$asFolderSearchList[0] -= 1
		; Determine return path to add to file/folder name
		Switch $iReturnPath
			; Case 0 ; Name only
			; Leave as ""
			Case 1 ;Relative to initial path
				$sRetPath = StringReplace($sCurrentPath, $sInitialPath, "")
			Case 2 ; Full path
				If $fLongPath Then
					$sRetPath = StringTrimLeft($sCurrentPath, 4)
				Else
					$sRetPath = $sCurrentPath
				EndIf
		EndSwitch

		; Get search handle - use code matched to required listing
		If $iHide_HS Or $iHide_Link Then
			; Use DLL code
			$aDLL_Ret = DllCall($hDLL, 'ptr', 'FindFirstFileW', 'wstr', $sCurrentPath & "*", 'ptr', $pFile_Data)
			If @error Or Not $aDLL_Ret[0] Then
				ContinueLoop
			EndIf
			$hSearch = $aDLL_Ret[0]
		Else
			; Use native code
			$hSearch = FileFindFirstFile($sCurrentPath & "*")
			; If folder empty move to next in list
			If $hSearch = -1 Then
				ContinueLoop
			EndIf
		EndIf

		; If sorting files and folders with paths then store folder name and position of associated files in list
		If $iReturn = 0 And $iSort And $iReturnPath Then
			__FLTAR_AddToList($asFolderFileSectionList, $sRetPath, $asFileMatchList[0] + 1)
		EndIf

		; Search folder - use code matched to required listing
		While 1
			; Use DLL code
			If $iHide_HS Or $iHide_Link Then
				; Use DLL code
				$aDLL_Ret = DllCall($hDLL, 'int', 'FindNextFileW', 'ptr', $hSearch, 'ptr', $pFile_Data)
				; Check for end of folder
				If @error Or Not $aDLL_Ret[0] Then
					ExitLoop
				EndIf
				; Extract data
				$sName = DllStructGetData($tFile_Data, "FileName")
				; Check for .. return - only returned by the DllCall
				If $sName = ".." Then
					ContinueLoop
				EndIf
				$iAttribs = DllStructGetData($tFile_Data, "FileAttributes")
				; Check for hidden/system attributes and skip if found
				If $iHide_HS And BitAND($iAttribs, $iHide_HS) Then
					ContinueLoop
				EndIf
				; Check for link attribute and skip if found
				If $iHide_Link And BitAND($iAttribs, $iHide_Link) Then
					ContinueLoop
				EndIf
				; Set subfolder flag
				$fFolder = 0
				If BitAND($iAttribs, 16) Then
					$fFolder = 1
				EndIf
			Else
				; Use native code
				$sName = FileFindNextFile($hSearch)
				; Check for end of folder
				If @error Then
					ExitLoop
				EndIf
				; Set subfolder flag - @extended set in 3.3.1.1 +
				$fFolder = @extended
			EndIf

			; If folder then check whether to add to search list
			If $fFolder Then
				Select
					Case $iRecur < 0 ; Check recur depth
						StringReplace($sCurrentPath, "\", "", 0, 2)
						If @extended < $iMaxLevel Then
							ContinueCase ; Check if matched to masks
						EndIf
					Case $iRecur = 1 ; Full recur
						If Not StringRegExp($sName, $sExclude_Folder_Mask) Then ; Add folder unless excluded
							__FLTAR_AddToList($asFolderSearchList, $sCurrentPath & $sName & "\")
						EndIf
						; Case $iRecur = 0 ; Never add
						; Do nothing
				EndSelect
			EndIf

			If $iSort Then ; Save in relevant folders for later sorting
				If $fFolder Then
					If StringRegExp($sName, $sInclude_Folder_Mask) And Not StringRegExp($sName, $sExclude_Folder_Mask) Then
						__FLTAR_AddToList($asFolderMatchList, $sRetPath & $sName & $sFolderSlash)
					EndIf
				Else
					If StringRegExp($sName, $sInclude_File_Mask) And Not StringRegExp($sName, $sExclude_File_Mask) Then
						; Select required list for files
						If $sCurrentPath = $sInitialPath Then
							__FLTAR_AddToList($asRootFileMatchList, $sRetPath & $sName)
						Else
							__FLTAR_AddToList($asFileMatchList, $sRetPath & $sName)
						EndIf
					EndIf
				EndIf
			Else ; Save directly in return list
				If $fFolder Then
					If $iReturn <> 1 And StringRegExp($sName, $sInclude_Folder_Mask) And Not StringRegExp($sName, $sExclude_Folder_Mask) Then
						__FLTAR_AddToList($asReturnList, $sRetPath & $sName & $sFolderSlash)
					EndIf
				Else
					If $iReturn <> 2 And StringRegExp($sName, $sInclude_File_Mask) And Not StringRegExp($sName, $sExclude_File_Mask) Then
						__FLTAR_AddToList($asReturnList, $sRetPath & $sName)
					EndIf
				EndIf
			EndIf

		WEnd

		; Close current search
		FileClose($hSearch)

	WEnd

	; Close the DLL if needed
	If $iHide_HS Then
		DllClose($hDLL)
	EndIf

	; Sort results if required
	If $iSort Then
		Switch $iReturn
			Case 2 ; Folders only
				; Check if any folders found
				If $asFolderMatchList[0] = 0 Then Return SetError(1, 9, "")
				; Correctly size folder match list
				ReDim $asFolderMatchList[$asFolderMatchList[0] + 1]
				; Copy size folder match array
				$asReturnList = $asFolderMatchList
				; Simple sort list
				__FLTAR_ArraySort($asReturnList, 1, $asReturnList[0])
			Case 1 ; Files only
				; Check if any files found
				If $asRootFileMatchList[0] = 0 And $asFileMatchList[0] = 0 Then Return SetError(1, 9, "")
				If $iReturnPath = 0 Then ; names only so simple sort suffices
					; Combine file match lists
					__FLTAR_AddFileLists($asReturnList, $asRootFileMatchList, $asFileMatchList)
					; Simple sort combined file list
					__FLTAR_ArraySort($asReturnList, 1, $asReturnList[0])
				Else
					; Combine sorted file match lists
					__FLTAR_AddFileLists($asReturnList, $asRootFileMatchList, $asFileMatchList, 1)
				EndIf
			Case 0 ; Both files and folders
				; Check if any root files or folders found
				If $asRootFileMatchList[0] = 0 And $asFolderMatchList[0] = 0 Then Return SetError(1, 9, "")
				If $iReturnPath = 0 Then ; names only so simple sort suffices
					; Combine file match lists
					__FLTAR_AddFileLists($asReturnList, $asRootFileMatchList, $asFileMatchList)
					; Set correct count for folder add
					$asReturnList[0] += $asFolderMatchList[0]
					; Resize and add file match array
					ReDim $asFolderMatchList[$asFolderMatchList[0] + 1]
					__FLTAR_ArrayConcatenate($asReturnList, $asFolderMatchList)
					; Simple sort final list
					__FLTAR_ArraySort($asReturnList, 1, $asReturnList[0])
				Else
					; Size return list
					Local $asReturnList[$asFileMatchList[0] + $asRootFileMatchList[0] + $asFolderMatchList[0] + 1]
					$asReturnList[0] = $asFileMatchList[0] + $asRootFileMatchList[0] + $asFolderMatchList[0]
					; Sort root file list
					__FLTAR_ArraySort($asRootFileMatchList, 1, $asRootFileMatchList[0])
					; Add the sorted root files at the top
					For $i = 1 To $asRootFileMatchList[0]
						$asReturnList[$i] = $asRootFileMatchList[$i]
					Next
					; Set next insertion index
					Local $iNextInsertionIndex = $asRootFileMatchList[0] + 1
					; Sort folder list
					__FLTAR_ArraySort($asFolderMatchList, 1, $asFolderMatchList[0])
					; Work through folder list
					For $i = 1 To $asFolderMatchList[0]
						; Add folder to return list
						$asReturnList[$iNextInsertionIndex] = $asFolderMatchList[$i]
						$iNextInsertionIndex += 1
						; Format folder name for search
						If $sFolderSlash Then
							$sFolderToFind = $asFolderMatchList[$i]
						Else
							$sFolderToFind = $asFolderMatchList[$i] & "\"
						EndIf
						; Find folder in FolderFileSectionList
						For $j = 1 To $asFolderFileSectionList[0][0]
							; If found then deal with files
							If $sFolderToFind = $asFolderFileSectionList[$j][0] Then
								; Set file list indexes
								$iFileSectionStartIndex = $asFolderFileSectionList[$j][1]
								If $j = $asFolderFileSectionList[0][0] Then
									$iFileSectionEndIndex = $asFileMatchList[0]
								Else
									$iFileSectionEndIndex = $asFolderFileSectionList[$j + 1][1] - 1
								EndIf
								; Sort files
								__FLTAR_ArraySort($asFileMatchList, $iFileSectionStartIndex, $iFileSectionEndIndex)
								; Add files to return list
								For $k = $iFileSectionStartIndex To $iFileSectionEndIndex
									$asReturnList[$iNextInsertionIndex] = $asFileMatchList[$k]
									$iNextInsertionIndex += 1
								Next
								ExitLoop
							EndIf
						Next
					Next
				EndIf
		EndSwitch

	Else ; No sort

		; Check if any file/folders have been added
		If $asReturnList[0] = 0 Then Return SetError(1, 9, "")
		; Remove any unused return list elements from last ReDim
		ReDim $asReturnList[$asReturnList[0] + 1]

	EndIf
	Return $asReturnList
EndFunc   ;==>_FileListToArrayRec

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __FLTAR_ListToMask
; Description ...: Convert include/exclude lists to SRE format
; Syntax ........: __FLTAR_ListToMask(ByRef $sMask, $sList)
; Parameters ....: $asMask - Include/Exclude mask to create
;                  $asList - Include/Exclude list to convert
; Return values .: Success: 1
;                  Failure: 0
; Author ........: SRE patterns developed from those posted by various forum members and Spiff59 in particular
; Remarks .......: This function is used internally by _FileListToArrayRec
; ===============================================================================================================================
Func __FLTAR_ListToMask(ByRef $sMask, $sList)
	; Check for invalid characters within list
	If StringRegExp($sList, "\\|/|:|\<|\>|\|") Then Return 0
	; Strip WS and insert | for ;
	$sList = StringReplace(StringStripWS(StringRegExpReplace($sList, "\s*;\s*", ";"), 3), ";", "|")
	; Convert to SRE pattern
	$sList = StringReplace(StringReplace(StringRegExpReplace($sList, "[][$^.{}()+\-]", "\\$0"), "?", "."), "*", ".*?")
	; Add prefix and suffix
	$sMask = "(?i)^(" & $sList & ")\z"
	Return 1
EndFunc   ;==>__FLTAR_ListToMask

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __FLTAR_AddToList
; Description ...: Add element to [?] or [?][2] list which is resized if necessary
; Syntax ........: __FLTAR_AddToList(ByRef $asList, $vValue_0, [$vValue_1])
; Parameters ....: $aList - List to be added to
;                  $vValue_0 - Value to add to array  - if $vValue_1 exists value added to [?][0] element in [?][2] array
;                  $vValue_1 - Value to add to [?][1] element in [?][2] array (optional)
; Return values .: None - array modified ByRef
; Author ........: Melba23
; Remarks .......: This function is used internally by _FileListToArrayRec
; ===============================================================================================================================
Func __FLTAR_AddToList(ByRef $aList, $vValue_0, $vValue_1 = -1)
	If $vValue_1 = -1 Then ; [?] array
		; Increase list count
		$aList[0] += 1
		; Double list size if too small (fewer ReDim needed)
		If UBound($aList) <= $aList[0] Then ReDim $aList[UBound($aList) * 2]
		; Add value
		$aList[$aList[0]] = $vValue_0
	Else ; [?][2] array
		$aList[0][0] += 1
		If UBound($aList) <= $aList[0][0] Then ReDim $aList[UBound($aList) * 2][2]
		$aList[$aList[0][0]][0] = $vValue_0
		$aList[$aList[0][0]][1] = $vValue_1
	EndIf
EndFunc   ;==>__FLTAR_AddToList

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __FLTAR_AddFileLists
; Description ...: Add internal lists after resizing and optional sorting
; Syntax ........: __FLTAR_AddFileLists(ByRef $asTarget, $asSource_1, $asSource_2[, $iSort = 0])
; Parameters ....: $asReturnList - Base list
;                  $asRootFileMatchList - First list to add
;                  $asFileMatchList - Second list to add
;                  $iSort - (Optional) Whether to sort lists before adding
;                  |$iSort = 0 (Default) No sort
;                  |$iSort = 1 Sort in descending alphabetical order
; Return values .: None - array modified ByRef
; Author ........: Melba23
; Remarks .......: This function is used internally by _FileListToArrayRec
; ===============================================================================================================================
Func __FLTAR_AddFileLists(ByRef $asTarget, $asSource_1, $asSource_2, $iSort = 0)
	; Correctly size root file match array
	ReDim $asSource_1[$asSource_1[0] + 1]
	; Simple sort root file match array if required
	If $iSort = 1 Then __FLTAR_ArraySort($asSource_1, 1, $asSource_1[0])
	; Copy root file match array
	$asTarget = $asSource_1
	; Add file match count
	$asTarget[0] += $asSource_2[0]
	; Correctly size file match array
	ReDim $asSource_2[$asSource_2[0] + 1]
	; Simple sort file match array if required
	If $iSort = 1 Then __FLTAR_ArraySort($asSource_2, 1, $asSource_2[0])
	; Add file match array
	__FLTAR_ArrayConcatenate($asTarget, $asSource_2)
EndFunc   ;==>__FLTAR_AddFileLists

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __FLTAR_FileListSearch
; Description ...: Search file array for beginning and end indices of folder associated files
; Syntax ........: __FLTAR_FileListSearch(Const ByRef $avArray, $vValue)
; Parameters ....: $avArray - Array to search ($asFileMatchList)
;                  $vValue  - Value to search for (Folder name from $asFolderMatchList)
;                  $iIndex  - Index to begin search (search down from here - and then from here to top if not found)
;                  $sSlash  - \ if folder names end in \ - else empty string
; Return values .: Success: Array holding top and bottom indices of folder associated files
;                  Failure: Returns -1
; Author ........: Melba23
; Modified.......:
; Remarks .......: This function is used internally by _FileListToArrayRec
; ===============================================================================================================================
Func __FLTAR_FileListSearch(Const ByRef $avArray, $vValue, $iIndex, $sSlash)
	Local $aRet[2]

	; Add final \ if required
	If Not $sSlash Then $vValue &= "\"
	; Start by getting top match - search down from start index
	For $i = $iIndex To $avArray[0]
		; SRE gives path less filename
		If StringRegExpReplace($avArray[$i], "(^.*\\)(.*)", "\1") = $vValue Then ExitLoop
	Next
	If $i > $avArray[0] Then
		; No match found so look from start index upwards
		If $iIndex = $avArray[0] Then $iIndex -= 1
		For $i = $iIndex + 1 To 1 Step -1
			If StringRegExpReplace($avArray[$i], "(^.*\\)(.*)", "\1") = $vValue Then ExitLoop
		Next
		; If still no match - return " nothing found" for empty folder
		If $i = 0 Then Return SetError(1, 0, "")
		; Set index of bottom file
		$aRet[1] = $i
		; Now look for top match
		For $i = $aRet[1] To 1 Step -1
			If StringRegExpReplace($avArray[$i], "(^.*\\)(.*)", "\1") <> $vValue Then ExitLoop
		Next
		; Set top match
		$aRet[0] = $i + 1
	Else
		; Set index of top associated file
		$aRet[0] = $i
		; Now look for bottom match - find first file which does not match
		For $i = $aRet[0] To $avArray[0]
			If StringRegExpReplace($avArray[$i], "(^.*\\)(.*)", "\1") <> $vValue Then ExitLoop
		Next
		; Set bottom match
		$aRet[1] = $i - 1
	EndIf

	Return $aRet
EndFunc   ;==>__FLTAR_FileListSearch

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __FLTAR_ArraySort
; Description ...: Sort passed array using DualPivot sort
; Syntax ........: __FLTAR_ArraySort(ByRef $avArray, $iStart, $iEnd))
; Parameters ....: $avArray - Array to sort
;                  $iStart  - Index to start sort
;                  $iEnd    - Index to end sort
; Return values .: None - array modified ByRef
; Author ........: wraithdu
; Modified.......: Melba23
; Remarks .......: This function is used internally by _FileListToArrayRec
; ===============================================================================================================================
Func __FLTAR_ArraySort(ByRef $aArray, $iPivot_Left, $iPivot_Right, $fLeftMost = True)
	If $iPivot_Left > $iPivot_Right Then Return
	Local $iLength = $iPivot_Right - $iPivot_Left + 1
	Local $i, $j, $k, $ai, $ak, $a1, $a2, $last
	If $iLength < 45 Then ; Use insertion sort for small arrays - value chosen empirically
		If $fLeftMost Then
			$i = $iPivot_Left
			While $i < $iPivot_Right
				$j = $i
				$ai = $aArray[$i + 1]
				While $ai < $aArray[$j]
					$aArray[$j + 1] = $aArray[$j]
					$j -= 1
					If $j + 1 = $iPivot_Left Then ExitLoop
				WEnd
				$aArray[$j + 1] = $ai
				$i += 1
			WEnd
		Else
			While 1
				If $iPivot_Left >= $iPivot_Right Then Return 1
				$iPivot_Left += 1
				If $aArray[$iPivot_Left] < $aArray[$iPivot_Left - 1] Then ExitLoop
			WEnd
			While 1
				$k = $iPivot_Left
				$iPivot_Left += 1
				If $iPivot_Left > $iPivot_Right Then ExitLoop
				$a1 = $aArray[$k]
				$a2 = $aArray[$iPivot_Left]
				If $a1 < $a2 Then
					$a2 = $a1
					$a1 = $aArray[$iPivot_Left]
				EndIf
				$k -= 1
				While $a1 < $aArray[$k]
					$aArray[$k + 2] = $aArray[$k]
					$k -= 1
				WEnd
				$aArray[$k + 2] = $a1
				While $a2 < $aArray[$k]
					$aArray[$k + 1] = $aArray[$k]
					$k -= 1
				WEnd
				$aArray[$k + 1] = $a2
				$iPivot_Left += 1
			WEnd
			$last = $aArray[$iPivot_Right]
			$iPivot_Right -= 1
			While $last < $aArray[$iPivot_Right]
				$aArray[$iPivot_Right + 1] = $aArray[$iPivot_Right]
				$iPivot_Right -= 1
			WEnd
			$aArray[$iPivot_Right + 1] = $last
		EndIf
		Return 1
	EndIf
	Local $iSeventh = BitShift($iLength, 3) + BitShift($iLength, 6) + 1
	Local $e1, $e2, $e3, $e4, $e5, $t
	$e3 = Ceiling(($iPivot_Left + $iPivot_Right) / 2)
	$e2 = $e3 - $iSeventh
	$e1 = $e2 - $iSeventh
	$e4 = $e3 + $iSeventh
	$e5 = $e4 + $iSeventh
	If $aArray[$e2] < $aArray[$e1] Then
		$t = $aArray[$e2]
		$aArray[$e2] = $aArray[$e1]
		$aArray[$e1] = $t
	EndIf
	If $aArray[$e3] < $aArray[$e2] Then
		$t = $aArray[$e3]
		$aArray[$e3] = $aArray[$e2]
		$aArray[$e2] = $t
		If $t < $aArray[$e1] Then
			$aArray[$e2] = $aArray[$e1]
			$aArray[$e1] = $t
		EndIf
	EndIf
	If $aArray[$e4] < $aArray[$e3] Then
		$t = $aArray[$e4]
		$aArray[$e4] = $aArray[$e3]
		$aArray[$e3] = $t
		If $t < $aArray[$e2] Then
			$aArray[$e3] = $aArray[$e2]
			$aArray[$e2] = $t
			If $t < $aArray[$e1] Then
				$aArray[$e2] = $aArray[$e1]
				$aArray[$e1] = $t
			EndIf
		EndIf
	EndIf
	If $aArray[$e5] < $aArray[$e4] Then
		$t = $aArray[$e5]
		$aArray[$e5] = $aArray[$e4]
		$aArray[$e4] = $t
		If $t < $aArray[$e3] Then
			$aArray[$e4] = $aArray[$e3]
			$aArray[$e3] = $t
			If $t < $aArray[$e2] Then
				$aArray[$e3] = $aArray[$e2]
				$aArray[$e2] = $t
				If $t < $aArray[$e1] Then
					$aArray[$e2] = $aArray[$e1]
					$aArray[$e1] = $t
				EndIf
			EndIf
		EndIf
	EndIf
	Local $iLess = $iPivot_Left
	Local $iGreater = $iPivot_Right
	If (($aArray[$e1] <> $aArray[$e2]) And ($aArray[$e2] <> $aArray[$e3]) And ($aArray[$e3] <> $aArray[$e4]) And ($aArray[$e4] <> $aArray[$e5])) Then
		Local $iPivot_1 = $aArray[$e2]
		Local $iPivot_2 = $aArray[$e4]
		$aArray[$e2] = $aArray[$iPivot_Left]
		$aArray[$e4] = $aArray[$iPivot_Right]
		Do
			$iLess += 1
		Until $aArray[$iLess] >= $iPivot_1
		Do
			$iGreater -= 1
		Until $aArray[$iGreater] <= $iPivot_2
		$k = $iLess
		While $k <= $iGreater
			$ak = $aArray[$k]
			If $ak < $iPivot_1 Then
				$aArray[$k] = $aArray[$iLess]
				$aArray[$iLess] = $ak
				$iLess += 1
			ElseIf $ak > $iPivot_2 Then
				While $aArray[$iGreater] > $iPivot_2
					$iGreater -= 1
					If $iGreater + 1 = $k Then ExitLoop 2
				WEnd
				If $aArray[$iGreater] < $iPivot_1 Then
					$aArray[$k] = $aArray[$iLess]
					$aArray[$iLess] = $aArray[$iGreater]
					$iLess += 1
				Else
					$aArray[$k] = $aArray[$iGreater]
				EndIf
				$aArray[$iGreater] = $ak
				$iGreater -= 1
			EndIf
			$k += 1
		WEnd
		$aArray[$iPivot_Left] = $aArray[$iLess - 1]
		$aArray[$iLess - 1] = $iPivot_1
		$aArray[$iPivot_Right] = $aArray[$iGreater + 1]
		$aArray[$iGreater + 1] = $iPivot_2
		__FLTAR_ArraySort($aArray, $iPivot_Left, $iLess - 2, True)
		__FLTAR_ArraySort($aArray, $iGreater + 2, $iPivot_Right, False)
		If ($iLess < $e1) And ($e5 < $iGreater) Then
			While $aArray[$iLess] = $iPivot_1
				$iLess += 1
			WEnd
			While $aArray[$iGreater] = $iPivot_2
				$iGreater -= 1
			WEnd
			$k = $iLess
			While $k <= $iGreater
				$ak = $aArray[$k]
				If $ak = $iPivot_1 Then
					$aArray[$k] = $aArray[$iLess]
					$aArray[$iLess] = $ak
					$iLess += 1
				ElseIf $ak = $iPivot_2 Then
					While $aArray[$iGreater] = $iPivot_2
						$iGreater -= 1
						If $iGreater + 1 = $k Then ExitLoop 2
					WEnd
					If $aArray[$iGreater] = $iPivot_1 Then
						$aArray[$k] = $aArray[$iLess]
						$aArray[$iLess] = $iPivot_1
						$iLess += 1
					Else
						$aArray[$k] = $aArray[$iGreater]
					EndIf
					$aArray[$iGreater] = $ak
					$iGreater -= 1
				EndIf
				$k += 1
			WEnd
		EndIf
		__FLTAR_ArraySort($aArray, $iLess, $iGreater, False)
	Else
		Local $iPivot = $aArray[$e3]
		$k = $iLess
		While $k <= $iGreater
			If $aArray[$k] = $iPivot Then
				$k += 1
				ContinueLoop
			EndIf
			$ak = $aArray[$k]
			If $ak < $iPivot Then
				$aArray[$k] = $aArray[$iLess]
				$aArray[$iLess] = $ak
				$iLess += 1
			Else
				While $aArray[$iGreater] > $iPivot
					$iGreater -= 1
				WEnd
				If $aArray[$iGreater] < $iPivot Then
					$aArray[$k] = $aArray[$iLess]
					$aArray[$iLess] = $aArray[$iGreater]
					$iLess += 1
				Else
					$aArray[$k] = $iPivot
				EndIf
				$aArray[$iGreater] = $ak
				$iGreater -= 1
			EndIf
			$k += 1
		WEnd
		__FLTAR_ArraySort($aArray, $iPivot_Left, $iLess - 1, True)
		__FLTAR_ArraySort($aArray, $iGreater + 1, $iPivot_Right, False)
	EndIf
EndFunc   ;==>__FLTAR_ArraySort

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __FLTAR_ArrayConcatenate
; Description ...: Joins 2 arrays
; Syntax ........: __FLTAR_ArrayConcatenate(ByRef $avArrayTarget, Const ByRef $avArraySource)
; Parameters ....: $avArrayTarget - Base array
;                  $avArraySource - Array to add from element 1 onwards
; Return values .: None - array modified ByRef
; Author ........: Ultima, PartyPooper
; Modified.......: Melba23
; Remarks .......: This function is used internally by _FileListToArrayRec
; ===============================================================================================================================
Func __FLTAR_ArrayConcatenate(ByRef $avArrayTarget, Const ByRef $avArraySource)
	Local $iUBoundTarget = UBound($avArrayTarget) - 1, $iUBoundSource = UBound($avArraySource)
	ReDim $avArrayTarget[$iUBoundTarget + $iUBoundSource]
	For $i = 1 To $iUBoundSource - 1
		$avArrayTarget[$iUBoundTarget + $i] = $avArraySource[$i]
	Next
EndFunc   ;==>__FLTAR_ArrayConcatenate

; #FUNCTION# ====================================================================================================================
; Author ........: erifash <erifash [at] gmail [dot] com>
; Modified.......: guinness - Use the native ShellExecute function.
; ===============================================================================================================================
Func _FilePrint($sFilePath, $iShow = @SW_HIDE)
	If $iShow = Default Then $iShow = @SW_HIDE
	Return ShellExecute($sFilePath, "", @WorkingDir, "print", $iShow)
EndFunc   ;==>_FilePrint

; #FUNCTION# ====================================================================================================================
; Author ........: Jonathan Bennett <jon at autoitscript dot com>, Valik - Support Windows Unix and Mac line separator
; Modified ......: Jpm - fixed empty line at the end, Gary Fixed file contains only 1 line, guinness - Optional flag to return the array count.
; ===============================================================================================================================
Func _FileReadToArray($sFilePath, ByRef $aArray, $iFlag = 1)
	Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
	If $hFileOpen = -1 Then Return SetError(1, 0, 0)
	Local $sFileRead = FileRead($hFileOpen)
	FileClose($hFileOpen)

	; Check if to return the array count in the 0th index
	Local $sFlag = ""
	If $iFlag = Default Or $iFlag Then
		$sFlag = @LF
	EndIf
	$aArray = StringRegExp($sFlag & $sFileRead & @LF, "([^\r\n]*)(?:\r\n|\n|\r)(?:[\r\n]$)?", 3)
	If @error Then
		If StringLen($sFileRead) Then
			Local $aReturn[2] = [1, $sFileRead]
			$aArray = $aReturn
		Else
			Return SetError(2, 0, 0)
		EndIf
	Else
		If $sFlag Then $aArray[0] = UBound($aArray) - 1
	EndIf
	Return 1
EndFunc   ;==>_FileReadToArray

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Updated for file handles by PsaltyDS, @error = 4 msg and 2-dimension capability added by Spiff59 and fixed by guinness.
; ===============================================================================================================================
Func _FileWriteFromArray($sFilePath, Const ByRef $aArray, $iBase = Default, $iUBound = Default, $sDelimeter = "|")
	; Check if we have a valid array as input
	If Not IsArray($aArray) Then Return SetError(2, 0, 0)

	; Check the number of dimensions
	Local $iDims = UBound($aArray, 0)
	If $iDims > 2 Then Return SetError(4, 0, 0)

	; Determine last entry of the array
	Local $iLast = UBound($aArray) - 1
	If $iUBound = Default Or $iUBound > $iLast Then $iUBound = $iLast
	If $iBase < 0 Or $iBase = Default Then $iBase = 0
	If $iBase > $iUBound Then Return SetError(5, 0, 0)
	If $sDelimeter = Default Then $sDelimeter = "|"

	; Open output file for overwrite by default, or use input file handle if passed
	Local $hFileOpen = 0
	If IsString($sFilePath) Then
		$hFileOpen = FileOpen($sFilePath, $FO_OVERWRITE)
	Else
		$hFileOpen = $sFilePath
	EndIf
	If $hFileOpen = -1 Then Return SetError(1, 0, 0)

	; Write array data to file
	Local $iError = 0
	Switch $iDims
		Case 1
			For $i = $iBase To $iUBound
				If FileWrite($hFileOpen, $aArray[$i] & @CRLF) = 0 Then
					$iError = 3
					ExitLoop
				EndIf
			Next
		Case 2
			Local $sTemp
			Local $iCols = UBound($aArray, 2)
			For $i = $iBase To $iUBound
				$sTemp = $aArray[$i][0]
				For $j = 1 To $iCols - 1
					$sTemp &= $sDelimeter & $aArray[$i][$j]
				Next
				If FileWrite($hFileOpen, $sTemp & @CRLF) = 0 Then
					$iError = 3
					ExitLoop
				EndIf
			Next
	EndSwitch

	; Close file only if specified by a string path
	If IsString($sFilePath) Then FileClose($hFileOpen)

	; Return results
	If $iError Then Return SetError($iError, 0, 0)
	Return 1
EndFunc   ;==>_FileWriteFromArray

; #FUNCTION# ====================================================================================================================
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......: MrCreatoR - added $iFlag parameter
; ===============================================================================================================================
Func _FileWriteLog($sLogPath, $sLogMsg, $iFlag = -1)
	Local $hFileOpen = $sLogPath, $iOpenMode = $FO_APPEND

	Local $sDateNow = @YEAR & "-" & @MON & "-" & @MDAY
	Local $sTimeNow = @HOUR & ":" & @MIN & ":" & @SEC
	Local $sMsg = $sDateNow & " " & $sTimeNow & " : " & $sLogMsg

	If $iFlag = Default Then $iFlag = -1
	If $iFlag <> -1 Then
		$sMsg &= @CRLF & FileRead($sLogPath)
		$iOpenMode = $FO_OVERWRITE
	EndIf

	; Open output file for appending to the end/overwriting, or use input file handle if passed
	If IsString($sLogPath) Then
		$hFileOpen = FileOpen($sLogPath, $iOpenMode)
		If $hFileOpen = -1 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	Local $iReturn = FileWriteLine($hFileOpen, $sMsg)

	; Close file only if specified by a string path
	If IsString($sLogPath) Then
		$iReturn = FileClose($hFileOpen)
	EndIf
	If $iReturn <= 0 Then
		Return SetError(2, $iReturn, 0)
	EndIf
	Return $iReturn
EndFunc   ;==>_FileWriteLog

; #FUNCTION# ====================================================================================================================
; Author ........: cdkid
; Modified.......: partypooper, MrCreatoR
; ===============================================================================================================================
Func _FileWriteToLine($sFile, $iLine, $sText, $fOverWrite = 0)
	If $iLine <= 0 Then Return SetError(4, 0, 0)
	If Not IsString($sText) Then
		$sText = String($sText)
		If $sText = "" Then Return SetError(6, 0, 0)
	EndIf
	If $fOverWrite <> 0 And $fOverWrite <> 1 Then Return SetError(5, 0, 0)
	If Not FileExists($sFile) Then Return SetError(2, 0, 0)

	Local $sRead_File = FileRead($sFile)
	Local $aSplit_File = StringSplit(StringStripCR($sRead_File), @LF)
	If UBound($aSplit_File) < $iLine Then Return SetError(1, 0, 0)
	Local $iEncoding = FileGetEncoding($sFile)
	Local $hFile = FileOpen($sFile, $iEncoding + $FO_OVERWRITE)
	If $hFile = -1 Then Return SetError(3, 0, 0)

	$sRead_File = ""

	For $i = 1 To $aSplit_File[0]
		If $i = $iLine Then
			If $fOverWrite = 1 Then
				If $sText <> '' Then $sRead_File &= $sText & @CRLF
			Else
				$sRead_File &= $sText & @CRLF & $aSplit_File[$i] & @CRLF
			EndIf
		ElseIf $i < $aSplit_File[0] Then
			$sRead_File &= $aSplit_File[$i] & @CRLF
		ElseIf $i = $aSplit_File[0] Then
			$sRead_File &= $aSplit_File[$i]
		EndIf
	Next

	FileWrite($hFile, $sRead_File)
	FileClose($hFile)

	Return 1
EndFunc   ;==>_FileWriteToLine

; #FUNCTION# ====================================================================================================================
; Author ........: Valik (Original function and modification to rewrite), tittoproject (Rewrite)
; Modified.......:
; ===============================================================================================================================
Func _PathFull($sRelativePath, $sBasePath = @WorkingDir)
	If Not $sRelativePath Or $sRelativePath = "." Then Return $sBasePath

	; Normalize slash direction.
	Local $sFullPath = StringReplace($sRelativePath, "/", "\") ; Holds the full path (later, minus the root)
	Local Const $sFullPathConst = $sFullPath ; Holds a constant version of the full path.
	Local $sPath ; Holds the root drive/server
	Local $bRootOnly = StringLeft($sFullPath, 1) = "\" And StringMid($sFullPath, 2, 1) <> "\"

	If $sBasePath = Default Then $sBasePath = @WorkingDir

	; Check for UNC paths or local drives.  We run this twice at most.  The
	; first time, we check if the relative path is absolute.  If it's not, then
	; we use the base path which should be absolute.
	For $i = 1 To 2
		$sPath = StringLeft($sFullPath, 2)
		If $sPath = "\\" Then
			$sFullPath = StringTrimLeft($sFullPath, 2)
			Local $nServerLen = StringInStr($sFullPath, "\") - 1
			$sPath = "\\" & StringLeft($sFullPath, $nServerLen)
			$sFullPath = StringTrimLeft($sFullPath, $nServerLen)
			ExitLoop
		ElseIf StringRight($sPath, 1) = ":" Then
			$sFullPath = StringTrimLeft($sFullPath, 2)
			ExitLoop
		Else
			$sFullPath = $sBasePath & "\" & $sFullPath
		EndIf
	Next

	; If this happens, we've found a funky path and don't know what to do
	; except for get out as fast as possible.  We've also screwed up our
	; variables so we definitely need to quit.
	; If $i = 3 Then Return ""

	; A path with a drive but no slash (e.g. C:Path\To\File) has the following
	; behavior.  If the relative drive is the same as the $BasePath drive then
	; insert the base path.  If the drives differ then just insert a leading
	; slash to make the path valid.
	If StringLeft($sFullPath, 1) <> "\" Then
		If StringLeft($sFullPathConst, 2) = StringLeft($sBasePath, 2) Then
			$sFullPath = $sBasePath & "\" & $sFullPath
		Else
			$sFullPath = "\" & $sFullPath
		EndIf
	EndIf

	; Build an array of the path parts we want to use.
	Local $aTemp = StringSplit($sFullPath, "\")
	Local $aPathParts[$aTemp[0]], $j = 0
	For $i = 2 To $aTemp[0]
		If $aTemp[$i] = ".." Then
			If $j Then $j -= 1
		ElseIf Not ($aTemp[$i] = "" And $i <> $aTemp[0]) And $aTemp[$i] <> "." Then
			$aPathParts[$j] = $aTemp[$i]
			$j += 1
		EndIf
	Next

	; Here we re-build the path from the parts above.  We skip the
	; loop if we are only returning the root.
	$sFullPath = $sPath
	If Not $bRootOnly Then
		For $i = 0 To $j - 1
			$sFullPath &= "\" & $aPathParts[$i]
		Next
	Else
		$sFullPath &= $sFullPathConst
		; If we detect more relative parts, remove them by calling ourself recursively.
		If StringInStr($sFullPath, "..") Then $sFullPath = _PathFull($sFullPath)
	EndIf

	; Clean up the path.
	Do
		$sFullPath = StringReplace($sFullPath, ".\", "\")
	Until @extended = 0
	Return $sFullPath
EndFunc   ;==>_PathFull

; #FUNCTION# ====================================================================================================================
; Author ........: Erik Pilsits
; Modified.......:
; ===============================================================================================================================
Func _PathGetRelative($sFrom, $sTo)
	If StringRight($sFrom, 1) <> "\" Then $sFrom &= "\" ; add missing trailing \ to $sFrom path
	If StringRight($sTo, 1) <> "\" Then $sTo &= "\" ; add trailing \ to $sTo
	If $sFrom = $sTo Then Return SetError(1, 0, StringTrimRight($sTo, 1)) ; $sFrom equals $sTo
	Local $asFrom = StringSplit($sFrom, "\")
	Local $asTo = StringSplit($sTo, "\")
	If $asFrom[1] <> $asTo[1] Then Return SetError(2, 0, StringTrimRight($sTo, 1)) ; drives are different, rel path not possible
	; create rel path
	Local $i = 2
	Local $iDiff = 1
	While 1
		If $asFrom[$i] <> $asTo[$i] Then
			$iDiff = $i
			ExitLoop
		EndIf
		$i += 1
	WEnd
	$i = 1
	Local $sRelPath = ""
	For $j = 1 To $asTo[0]
		If $i >= $iDiff Then
			$sRelPath &= "\" & $asTo[$i]
		EndIf
		$i += 1
	Next
	$sRelPath = StringTrimLeft($sRelPath, 1)
	$i = 1
	For $j = 1 To $asFrom[0]
		If $i > $iDiff Then
			$sRelPath = "..\" & $sRelPath
		EndIf
		$i += 1
	Next
	If StringRight($sRelPath, 1) == "\" Then $sRelPath = StringTrimRight($sRelPath, 1) ; remove trailing \
	Return $sRelPath
EndFunc   ;==>_PathGetRelative

; #FUNCTION# ====================================================================================================================
; Author ........: Valik
; Modified.......: guinness
; ===============================================================================================================================
Func _PathMake($sDrive, $sDir, $sFileName, $sExtension)
	; Format $sDrive, if it's not a UNC server name, then just get the drive letter and add a colon
	If StringLen($sDrive) Then
		If Not (StringLeft($sDrive, 2) = "\\") Then $sDrive = StringLeft($sDrive, 1) & ":"
	EndIf

	; Format the directory by adding any necessary slashes
	If StringLen($sDir) Then
		If Not (StringRight($sDir, 1) = "\") And Not (StringRight($sDir, 1) = "/") Then $sDir = $sDir & "\"
	EndIf

	If StringLen($sDir) Then
		; Append a backslash to the start of the directory if required
		If Not (StringLeft($sDir, 1) = "\") And Not (StringLeft($sDir, 1) = "/") Then $sDir = "\" & $sDir
	EndIf

	; Nothing to be done for the filename

	; Add the period to the extension if necessary
	If StringLen($sExtension) Then
		If Not (StringLeft($sExtension, 1) = ".") Then $sExtension = "." & $sExtension
	EndIf

	Return $sDrive & $sDir & $sFileName & $sExtension
EndFunc   ;==>_PathMake

; #FUNCTION# ====================================================================================================================
; Author ........: Valik
; Modified.......: DXRW4E - Re-wrote to use a regular expression; guinness - Update syntax and structure.
; ===============================================================================================================================
Func _PathSplit($sFilePath, ByRef $sDrive, ByRef $sDir, ByRef $sFileName, ByRef $sExtension)
	Local $aArray = StringRegExp($sFilePath, "^\h*((?:\\\\\?\\)*(\\\\[^\?\/\\]+|[A-Za-z]:)?(.*[\/\\]\h*)?((?:[^\.\/\\]|(?(?=\.[^\/\\]*\.)\.))*)?([^\/\\]*))$", 1)
	If @error Then ; This error should never happen.
		ReDim $aArray[5]
		$aArray[0] = $sFilePath
	EndIf
	$sDrive = $aArray[1]
	$sDir = StringRegExpReplace($aArray[2], "\h*[\/\\]+\h*", StringLeft($aArray[2], 1) == "/" ? "\/" : "\\") ; StringRegExpReplace($aArray[2], "[\/\\]+\h*", "\" & ((StringLeft($aArray[2], 1) == "/") ? "/" : "\"))
	$sFileName = $aArray[3]
	$sExtension = $aArray[4]
	Return $aArray
EndFunc   ;==>_PathSplit

; #FUNCTION# ====================================================================================================================
; Author ........: Kurt (aka /dev/null) and JdeB
; Modified ......: guinness - Re-wrote the function entirely for improvements in readability.
; ===============================================================================================================================
Func _ReplaceStringInFile($sFilePath, $sSearchString, $sReplaceString, $iCaseSensitive = 0, $iOccurance = 1)
	If StringInStr(FileGetAttrib($sFilePath), "R") Then Return SetError(1, 0, -1)

	; Open the file for reading.
	Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
	If $hFileOpen = -1 Then Return SetError(2, 0, -1)

	; Read the contents of the file and stores in a variable
	Local $sFileRead = FileRead($hFileOpen)
	FileClose($hFileOpen) ; Close the open file after reading

	; Set the default parameters
	If $iCaseSensitive = Default Then $iCaseSensitive = 0
	If $iOccurance = Default Then $iOccurance = 1

	; Replace strings
	$sFileRead = StringReplace($sFileRead, $sSearchString, $sReplaceString, 1 - $iOccurance, $iCaseSensitive)
	Local $iReturn = @extended

	; If there are replacements then overwrite the file
	If $iReturn Then
		; Retrieve the file encoding
		Local $iFileEncoding = FileGetEncoding($sFilePath)

		; Open the file for writing and set the overwrite flag
		$hFileOpen = FileOpen($sFilePath, $iFileEncoding + $FO_OVERWRITE)
		If $hFileOpen = -1 Then Return SetError(3, 0, -1)

		; Write to the open file
		FileWrite($hFileOpen, $sFileRead)
		FileClose($hFileOpen) ; Close the open file after writing
	EndIf
	Return $iReturn
EndFunc   ;==>_ReplaceStringInFile

; #FUNCTION# ====================================================================================================================
; Author ........: Dale (Klaatu) Thompson
; Modified.......: Hans Harder - Added Optional parameters, guinness - Fixed using non-supported characters in the file prefix.
; ===============================================================================================================================
Func _TempFile($sDirectoryName = @TempDir, $sFilePrefix = "~", $sFileExtension = ".tmp", $iRandomLength = 7)
	; Check parameters for the Default keyword or they meet a certain criteria
	If $iRandomLength = Default Or $iRandomLength <= 0 Then $iRandomLength = 7
	If $sDirectoryName = Default Or (Not FileExists($sDirectoryName)) Then $sDirectoryName = @TempDir
	If $sFileExtension = Default Then $sFileExtension = ".tmp"
	If $sFilePrefix = Default Then $sFilePrefix = "~"

	; Check if the directory exists or use the current script directory
	If Not FileExists($sDirectoryName) Then $sDirectoryName = @ScriptDir

	; Remove the appending backslash
	$sDirectoryName = StringRegExpReplace($sDirectoryName, "[\\/]+$", "")
	; Remove the initial dot (.) from the file extension
	$sFileExtension = StringRegExpReplace($sFileExtension, "^\.+", "")
	; Remove any non-supported characters in the file prefix
	$sFilePrefix = StringRegExpReplace($sFilePrefix, '[\\/:*?"<>|]', "")

	; Create the temporary file path without writing to the selected directory
	Local $sTempName = ""
	Do
		; Create a random filename
		$sTempName = ""
		While StringLen($sTempName) < $iRandomLength
			$sTempName &= Chr(Random(97, 122, 1))
		WEnd
		; Temporary filepath
		$sTempName = $sDirectoryName & "\" & $sFilePrefix & $sTempName & "." & $sFileExtension
	Until Not FileExists($sTempName) ; Exit the loop if no file with the same name is present
	Return $sTempName
EndFunc   ;==>_TempFile
