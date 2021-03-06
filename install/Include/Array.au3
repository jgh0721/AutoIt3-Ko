#include-Once

; #INDEX# =======================================================================================================================
; Title .........: Array
; AutoIt Version : 3.2.10++
; Language ......: English
; Description ...: Functions for manipulating arrays.
; Author(s) .....: JdeB, Erik Pilsits, Ultima, Dale (Klaatu) Thompson, Cephas,randallc, Gary Frost, GEOSoft,
;                  Helias Gerassimou(hgeras), Brian Keene, SolidSnake, gcriaco, LazyCoder, Tylo, David Nuttall,
;                  Adam Moore (redndahead), SmOke_N, litlmike, Valik, Melba23
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _ArrayAdd
; _ArrayBinarySearch
; _ArrayCombinations
; _ArrayConcatenate
; _ArrayDelete
; _ArrayDisplay
; _ArrayFindAll
; _ArrayInsert
; _ArrayMax
; _ArrayMaxIndex
; _ArrayMin
; _ArrayMinIndex
; _ArrayPermute
; _ArrayPop
; _ArrayPush
; _ArrayReverse
; _ArraySearch
; _ArraySort
; _ArraySwap
; _ArrayToClip
; _ArrayToString
; _ArrayTranspose
; _ArrayTrim
; _ArrayUnique
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __ArrayQuickSort1D
; __ArrayQuickSort2D
; __Array_ExeterInternal
; __Array_Combinations
; __Array_GetNext
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - code cleanup
; ===============================================================================================================================
Func _ArrayAdd(ByRef $avArray, $vValue)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	If UBound($avArray, 0) <> 1 Then Return SetError(2, 0, -1)

	Local $iUBound = UBound($avArray)
	ReDim $avArray[$iUBound + 1]
	$avArray[$iUBound] = $vValue
	Return $iUBound
EndFunc   ;==>_ArrayAdd

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - added $iEnd as parameter, code cleanup; Melba23 - added support for empty arrays
; ===============================================================================================================================
Func _ArrayBinarySearch(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	If UBound($avArray, 0) <> 1 Then Return SetError(5, 0, -1)

	Local $iUBound = UBound($avArray) - 1
	If $iUBound = -1 Then Return SetError(6, 0, -1)

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)

	Local $iMid = Int(($iEnd + $iStart) / 2)

	If $avArray[$iStart] > $vValue Or $avArray[$iEnd] < $vValue Then Return SetError(2, 0, -1)

	; Search
	While $iStart <= $iMid And $vValue <> $avArray[$iMid]
		If $vValue < $avArray[$iMid] Then
			$iEnd = $iMid - 1
		Else
			$iStart = $iMid + 1
		EndIf
		$iMid = Int(($iEnd + $iStart) / 2)
	WEnd

	If $iStart > $iEnd Then Return SetError(3, 0, -1) ; Entry not found

	Return $iMid
EndFunc   ;==>_ArrayBinarySearch

; #FUNCTION# ====================================================================================================================
; Author ........: Erik Pilsits
; Modified.......: 07/08/2008
; ===============================================================================================================================
Func _ArrayCombinations(Const ByRef $avArray, $iSet, $sDelim = "")

	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) <> 1 Then Return SetError(2, 0, 0)

	Local $iN = UBound($avArray)
	Local $iR = $iSet
	Local $aIdx[$iR]
	For $i = 0 To $iR - 1
		$aIdx[$i] = $i
	Next
	Local $iTotal = __Array_Combinations($iN, $iR)
	Local $iLeft = $iTotal
	Local $aResult[$iTotal + 1]
	$aResult[0] = $iTotal

	Local $iCount = 1
	While $iLeft > 0
		__Array_GetNext($iN, $iR, $iLeft, $iTotal, $aIdx)
		For $i = 0 To $iSet - 1
			$aResult[$iCount] &= $avArray[$aIdx[$i]] & $sDelim
		Next
		If $sDelim <> "" Then $aResult[$iCount] = StringTrimRight($aResult[$iCount], 1)
		$iCount += 1
	WEnd
	Return $aResult
EndFunc   ;==>_ArrayCombinations

; #FUNCTION# ====================================================================================================================
; Author ........: Ultima
; Modified.......: Partypooper - added target start index
; ===============================================================================================================================
Func _ArrayConcatenate(ByRef $avArrayTarget, Const ByRef $avArraySource, $iStart = 0)
	If Not IsArray($avArrayTarget) Then Return SetError(1, 0, 0)
	If Not IsArray($avArraySource) Then Return SetError(2, 0, 0)
	If UBound($avArrayTarget, 0) <> 1 Then
		If UBound($avArraySource, 0) <> 1 Then Return SetError(5, 0, 0)
		Return SetError(3, 0, 0)
	EndIf
	If UBound($avArraySource, 0) <> 1 Then Return SetError(4, 0, 0)

	Local $iUBoundTarget = UBound($avArrayTarget) - $iStart, $iUBoundSource = UBound($avArraySource)
	ReDim $avArrayTarget[$iUBoundTarget + $iUBoundSource]
	For $i = $iStart To $iUBoundSource - 1
		$avArrayTarget[$iUBoundTarget + $i] = $avArraySource[$i]
	Next

	Return $iUBoundTarget + $iUBoundSource
EndFunc   ;==>_ArrayConcatenate

; #FUNCTION# ====================================================================================================================
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - array passed ByRef
; ===============================================================================================================================
Func _ArrayDelete(ByRef $avArray, $iElement)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	Local $iUBound = UBound($avArray, 1) - 1
	; Bounds checking
	If $iElement < 0 Then $iElement = 0
	If $iElement > $iUBound Then $iElement = $iUBound

	; Move items after $iElement up by 1
	Switch UBound($avArray, 0)
		Case 1
			For $i = $iElement To $iUBound - 1
				$avArray[$i] = $avArray[$i + 1]
			Next
			ReDim $avArray[$iUBound]
		Case 2
			Local $iSubMax = UBound($avArray, 2) - 1
			For $i = $iElement To $iUBound - 1
				For $j = 0 To $iSubMax
					$avArray[$i][$j] = $avArray[$i + 1][$j]
				Next
			Next
			ReDim $avArray[$iUBound][$iSubMax + 1]
		Case Else
			Return SetError(3, 0, 0)
	EndSwitch

	Return $iUBound
EndFunc   ;==>_ArrayDelete

; #FUNCTION# ====================================================================================================================
; Author ........: randallc, Ultima
; Modified.......: Gary Frost (gafrost), Ultima, Zedna, jpm, Melba23
; ===============================================================================================================================
Func _ArrayDisplay(Const ByRef $avArray, $sTitle = Default, $iItemLimit = Default, $iTranspose = Default, $sSeparator = Default, $sReplace = Default, $sHeader = Default)
	If (Not IsArray($avArray)) Then Return SetError(1, 0, 0)

	; Default values
	If $sTitle = Default Then $sTitle = "Array: ListView Display"
	If $iItemLimit = Default Then $iItemLimit = -1
	If $iTranspose = Default Then $iTranspose = 0
	If $sSeparator = Default Then $sSeparator = ""
	If $sReplace = Default Then $sReplace = "|"
	If $sHeader = Default Then $sHeader = ""

	; Dimension checking
	Local $iDimension = UBound($avArray, 0), $iUBound = UBound($avArray, 1) - 1, $iSubMax = UBound($avArray, 2) - 1
	If $iDimension > 2 Then Return SetError(2, 0, 0)

	; Separator handling
	If $sSeparator = "" Then $sSeparator = Chr(124)

	;  Check the separator to make sure it's not used literally in the array
	If _ArraySearch($avArray, $sSeparator, 0, 0, 0, 1) <> -1 Then
		For $x = 1 To 255
			If $x >= 32 And $x <= 127 Then ContinueLoop
			Local $sFind = _ArraySearch($avArray, Chr($x), 0, 0, 0, 1)
			If $sFind = -1 Then
				$sSeparator = Chr($x)
				ExitLoop
			EndIf
		Next
	EndIf

	; Declare variables
	Local $vTmp, $iBuffer = 4094 ; AutoIt max item size
	Local $iColLimit = 250
	Local $iOnEventMode = Opt("GUIOnEventMode", 0), $sDataSeparatorChar = Opt("GUIDataSeparatorChar", $sSeparator)

	; Swap dimensions if transposing
	If $iSubMax < 0 Then $iSubMax = 0
	If $iTranspose Then
		$vTmp = $iUBound
		$iUBound = $iSubMax
		$iSubMax = $vTmp
	EndIf

	; Set limits for dimensions
	If $iSubMax > $iColLimit Then $iSubMax = $iColLimit
	If $iItemLimit < 1 Then $iItemLimit = $iUBound
	If $iUBound > $iItemLimit Then $iUBound = $iItemLimit

	; Set header up
	If $sHeader = "" Then
		$sHeader = "Row  " ; blanks added to adjust column size for big number of rows
		For $i = 0 To $iSubMax
			$sHeader &= $sSeparator & "Col " & $i
		Next
	ElseIf $sDataSeparatorChar <> $sSeparator Then
		$sHeader = StringReplace($sHeader, $sDataSeparatorChar, $sSeparator)
	EndIf

	; Convert array into text for listview
	Local $avArrayText[$iUBound + 1]
	For $i = 0 To $iUBound
		$avArrayText[$i] = "[" & $i & "]"
		For $j = 0 To $iSubMax
			; Get current item
			If $iDimension = 1 Then
				If $iTranspose Then
					$vTmp = $avArray[$j]
				Else
					$vTmp = $avArray[$i]
				EndIf
			Else
				If $iTranspose Then
					$vTmp = $avArray[$j][$i]
				Else
					$vTmp = $avArray[$i][$j]
				EndIf
			EndIf

			; Add to text array
			$vTmp = StringReplace($vTmp, $sSeparator, $sReplace, 0, 1)

			; Set max buffer size
			If StringLen($vTmp) > $iBuffer Then $vTmp = StringLeft($vTmp, $iBuffer)

			$avArrayText[$i] &= $sSeparator & $vTmp
		Next
	Next

	; GUI Constants
	Local Const $_ARRAYCONSTANT_GUI_DOCKBORDERS = 0x66
	Local Const $_ARRAYCONSTANT_GUI_DOCKBOTTOM = 0x40
	Local Const $_ARRAYCONSTANT_GUI_DOCKHEIGHT = 0x0200
	Local Const $_ARRAYCONSTANT_GUI_DOCKLEFT = 0x2
	Local Const $_ARRAYCONSTANT_GUI_DOCKRIGHT = 0x4
	Local Const $_ARRAYCONSTANT_GUI_EVENT_CLOSE = -3
	Local Const $_ARRAYCONSTANT_LVM_GETCOLUMNWIDTH = (0x1000 + 29)
	Local Const $_ARRAYCONSTANT_LVM_GETITEMCOUNT = (0x1000 + 4)
	Local Const $_ARRAYCONSTANT_LVM_GETITEMSTATE = (0x1000 + 44)
	Local Const $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE = (0x1000 + 54)
	Local Const $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT = 0x20
	Local Const $_ARRAYCONSTANT_LVS_EX_GRIDLINES = 0x1
	Local Const $_ARRAYCONSTANT_LVS_SHOWSELALWAYS = 0x8
	Local Const $_ARRAYCONSTANT_WS_EX_CLIENTEDGE = 0x0200
	Local Const $_ARRAYCONSTANT_WS_MAXIMIZEBOX = 0x00010000
	Local Const $_ARRAYCONSTANT_WS_MINIMIZEBOX = 0x00020000
	Local Const $_ARRAYCONSTANT_WS_SIZEBOX = 0x00040000
	Local Const $_ARRAYCONSTANT_WM_SETREDRAW = 11

	; Set interface up
	Local $iWidth = 640, $iHeight = 480
	Local $hGUI = GUICreate($sTitle, $iWidth, $iHeight, Default, Default, BitOR($_ARRAYCONSTANT_WS_SIZEBOX, $_ARRAYCONSTANT_WS_MINIMIZEBOX, $_ARRAYCONSTANT_WS_MAXIMIZEBOX))
	Local $aiGUISize = WinGetClientSize($hGUI)
	Local $hListView = GUICtrlCreateListView($sHeader, 0, 0, $aiGUISize[0], $aiGUISize[1] - 26, $_ARRAYCONSTANT_LVS_SHOWSELALWAYS)
	Local $hCopy = GUICtrlCreateButton("Copy Selected", 3, $aiGUISize[1] - 23, $aiGUISize[0] - 6, 20)
	GUICtrlSetResizing($hListView, $_ARRAYCONSTANT_GUI_DOCKBORDERS)
	GUICtrlSetResizing($hCopy, $_ARRAYCONSTANT_GUI_DOCKLEFT + $_ARRAYCONSTANT_GUI_DOCKRIGHT + $_ARRAYCONSTANT_GUI_DOCKBOTTOM + $_ARRAYCONSTANT_GUI_DOCKHEIGHT)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_GRIDLINES, $_ARRAYCONSTANT_LVS_EX_GRIDLINES)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE)

	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_WM_SETREDRAW, 0, 0)
	; Fill listview
	For $i = 0 To $iUBound
		GUICtrlCreateListViewItem($avArrayText[$i], $hListView)
	Next
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_WM_SETREDRAW, 1, 0)

	; adjust window width
	$iWidth = 0
	For $i = 0 To $iSubMax + 1
		$iWidth += GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETCOLUMNWIDTH, $i, 0)
	Next
	If $iWidth < 250 Then $iWidth = 230
	$iWidth += 20

	If $iWidth > @DesktopWidth Then $iWidth = @DesktopWidth - 100

	WinMove($hGUI, "", (@DesktopWidth - $iWidth) / 2, Default, $iWidth)

	; Show dialog
	GUISetState(@SW_SHOW, $hGUI)

	While 1
		Switch GUIGetMsg()
			Case $_ARRAYCONSTANT_GUI_EVENT_CLOSE
				ExitLoop

			Case $hCopy
				Local $sClip = ""

				; Get selected indices [ _GUICtrlListView_GetSelectedIndices($hListView, True) ]
				Local $aiCurItems[1] = [0]
				For $i = 0 To GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETITEMCOUNT, 0, 0)
					If GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETITEMSTATE, $i, 0x2) Then
						$aiCurItems[0] += 1
						ReDim $aiCurItems[$aiCurItems[0] + 1]
						$aiCurItems[$aiCurItems[0]] = $i
					EndIf
				Next

				; Generate clipboard text
				If Not $aiCurItems[0] Then
					For $sItem In $avArrayText
						$sClip &= $sItem & @CRLF
					Next
				Else
					For $i = 1 To UBound($aiCurItems) - 1
						$sClip &= $avArrayText[$aiCurItems[$i]] & @CRLF
					Next
				EndIf
				ClipPut($sClip)
		EndSwitch
	WEnd
	GUIDelete($hGUI)

	Opt("GUIOnEventMode", $iOnEventMode)
	Opt("GUIDataSeparatorChar", $sDataSeparatorChar)

	Return 1
EndFunc   ;==>_ArrayDisplay

; #FUNCTION# ====================================================================================================================
; Author ........: GEOSoft, Ultima
; Modified.......:
; ===============================================================================================================================
Func _ArrayFindAll(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iCompare = 0, $iSubItem = 0)
	$iStart = _ArraySearch($avArray, $vValue, $iStart, $iEnd, $iCase, $iCompare, 1, $iSubItem)
	If @error Then Return SetError(@error, 0, -1)

	Local $iIndex = 0, $avResult[UBound($avArray)]
	Do
		$avResult[$iIndex] = $iStart
		$iIndex += 1
		$iStart = _ArraySearch($avArray, $vValue, $iStart + 1, $iEnd, $iCase, $iCompare, 1, $iSubItem)
	Until @error

	ReDim $avResult[$iIndex]
	Return $avResult
EndFunc   ;==>_ArrayFindAll

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>: Ultima - code cleanup; Melba23 - element position check
; ===============================================================================================================================
Func _ArrayInsert(ByRef $avArray, $iElement, $vValue = "")
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) <> 1 Then Return SetError(2, 0, 0)

	; Check element in array bounds + 1
	If $iElement > UBound($avArray) Then Return SetError(3, 0, 0)

	; Add 1 to the array
	Local $iUBound = UBound($avArray) + 1
	ReDim $avArray[$iUBound]

	; Move all entries over til the specified element
	For $i = $iUBound - 1 To $iElement + 1 Step -1
		$avArray[$i] = $avArray[$i - 1]
	Next

	; Add the value in the specified element
	$avArray[$iElement] = $vValue
	Return $iUBound
EndFunc   ;==>_ArrayInsert

; #FUNCTION# ====================================================================================================================
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic, Ultima - added $iEnd parameter, code cleanup
; ===============================================================================================================================
Func _ArrayMax(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = 0)
	Local $iResult = _ArrayMaxIndex($avArray, $iCompNumeric, $iStart, $iEnd)
	If @error Then Return SetError(@error, 0, "")
	Return $avArray[$iResult]
EndFunc   ;==>_ArrayMax

; #FUNCTION# ====================================================================================================================
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic
; ===============================================================================================================================
Func _ArrayMaxIndex(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	If UBound($avArray, 0) <> 1 Then Return SetError(3, 0, -1)
	If Not UBound($avArray) Then Return SetError(4, 0, -1)

	Local $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, -1)

	Local $iMaxIndex = $iStart

	; Search
	If $iCompNumeric Then
		For $i = $iStart To $iEnd
			If Number($avArray[$iMaxIndex]) < Number($avArray[$i]) Then $iMaxIndex = $i
		Next
	Else
		For $i = $iStart To $iEnd
			If $avArray[$iMaxIndex] < $avArray[$i] Then $iMaxIndex = $i
		Next
	EndIf

	Return $iMaxIndex
EndFunc   ;==>_ArrayMaxIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic, Ultima - added $iEnd parameter, code cleanup
; ===============================================================================================================================
Func _ArrayMin(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = 0)
	Local $iResult = _ArrayMinIndex($avArray, $iCompNumeric, $iStart, $iEnd)
	If @error Then Return SetError(@error, 0, "")
	Return $avArray[$iResult]
EndFunc   ;==>_ArrayMin

; #FUNCTION# ====================================================================================================================
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic
; ===============================================================================================================================
Func _ArrayMinIndex(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	If UBound($avArray, 0) <> 1 Then Return SetError(3, 0, -1)
	If Not UBound($avArray) Then Return SetError(4, 0, -1)

	Local $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, -1)

	Local $iMinIndex = $iStart

	; Search
	If $iCompNumeric Then
		For $i = $iStart To $iEnd
			If Number($avArray[$iMinIndex]) > Number($avArray[$i]) Then $iMinIndex = $i
		Next
	Else
		For $i = $iStart To $iEnd
			If $avArray[$iMinIndex] > $avArray[$i] Then $iMinIndex = $i
		Next
	EndIf

	Return $iMinIndex
EndFunc   ;==>_ArrayMinIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Erik Pilsits
; Modified.......: Melba23 - added support for empty arrays
; ===============================================================================================================================
Func _ArrayPermute(ByRef $avArray, $sDelim = "")
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $iSize = UBound($avArray), $iFactorial = 1, $aIdx[$iSize], $aResult[1], $iCount = 1

	If UBound($avArray) Then
		For $i = 0 To $iSize - 1
			$aIdx[$i] = $i
		Next
		For $i = $iSize To 1 Step -1
			$iFactorial *= $i
		Next
		ReDim $aResult[$iFactorial + 1]
		$aResult[0] = $iFactorial
		__Array_ExeterInternal($avArray, 0, $iSize, $sDelim, $aIdx, $aResult, $iCount)
	Else
		$aResult[0] = 0
	EndIf
	Return $aResult
EndFunc   ;==>_ArrayPermute

; #FUNCTION# ====================================================================================================================
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Ultima - code cleanup; Melba23 - added support for empty arrays
; ===============================================================================================================================
Func _ArrayPop(ByRef $avArray)
	If (Not IsArray($avArray)) Then Return SetError(1, 0, "")
	If UBound($avArray, 0) <> 1 Then Return SetError(2, 0, "")

	Local $iUBound = UBound($avArray) - 1
	If $iUBound = -1 Then Return SetError(3, 0, "")
	Local $sLastVal = $avArray[$iUBound]

	; Remove last item
	If $iUBound > -1 Then
		ReDim $avArray[$iUBound]
	EndIf

	; Return last item
	Return $sLastVal
EndFunc   ;==>_ArrayPop

; #FUNCTION# ====================================================================================================================
; Author ........: Helias Gerassimou(hgeras), Ultima - code cleanup/rewrite (major optimization), fixed support for $vValue as an array
; Modified.......:
; ===============================================================================================================================
Func _ArrayPush(ByRef $avArray, $vValue, $iDirection = 0)
	If (Not IsArray($avArray)) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) <> 1 Then Return SetError(3, 0, 0)
	Local $iUBound = UBound($avArray) - 1

	If IsArray($vValue) Then ; $vValue is an array
		Local $iUBoundS = UBound($vValue)
		If ($iUBoundS - 1) > $iUBound Then Return SetError(2, 0, 0)

		; $vValue is an array smaller than $avArray
		If $iDirection Then ; slide right, add to front
			For $i = $iUBound To $iUBoundS Step -1
				$avArray[$i] = $avArray[$i - $iUBoundS]
			Next
			For $i = 0 To $iUBoundS - 1
				$avArray[$i] = $vValue[$i]
			Next
		Else ; slide left, add to end
			For $i = 0 To $iUBound - $iUBoundS
				$avArray[$i] = $avArray[$i + $iUBoundS]
			Next
			For $i = 0 To $iUBoundS - 1
				$avArray[$i + $iUBound - $iUBoundS + 1] = $vValue[$i]
			Next
		EndIf
	Else
		; Check for empty array
		If $iUBound > -1 Then
			If $iDirection Then ; slide right, add to front
				For $i = $iUBound To 1 Step -1
					$avArray[$i] = $avArray[$i - 1]
				Next
				$avArray[0] = $vValue
			Else ; slide left, add to end
				For $i = 0 To $iUBound - 1
					$avArray[$i] = $avArray[$i + 1]
				Next
				$avArray[$iUBound] = $vValue
			EndIf
		EndIf
	EndIf

	Return 1
EndFunc   ;==>_ArrayPush

; #FUNCTION# ====================================================================================================================
; Author ........: Brian Keene
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> -  added $iStart parameter and logic; Tylo - added $iEnd parameter and rewrote it for speed
; ===============================================================================================================================
Func _ArrayReverse(ByRef $avArray, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) <> 1 Then Return SetError(3, 0, 0)
	If Not UBound($avArray) Then Return SetError(4, 0, 0)

	Local $vTmp, $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)

	; Reverse
	For $i = $iStart To Int(($iStart + $iEnd - 1) / 2)
		$vTmp = $avArray[$i]
		$avArray[$i] = $avArray[$iEnd]
		$avArray[$iEnd] = $vTmp
		$iEnd -= 1
	Next

	Return 1
EndFunc   ;==>_ArrayReverse

; #FUNCTION# ====================================================================================================================
; Author ........: SolidSnake <MetalGX91 at GMail dot com>
; Modified.......: gcriaco <gcriaco at gmail dot com>; Ultima - 2D arrays supported, directional search, code cleanup, optimization; Melba23 - added support for empty arrays; BrunoJ - Added compare option 3 to use a regex pattern.
; ===============================================================================================================================
Func _ArraySearch(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iCompare = 0, $iForward = 1, $iSubItem = -1)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	If UBound($avArray, 0) > 2 Or UBound($avArray, 0) < 1 Then Return SetError(2, 0, -1)

	Local $iUBound = UBound($avArray) - 1
	If $iUBound = -1 Then Return SetError(3, 0, -1)

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)

	; Direction (flip if $iForward = 0)
	Local $iStep = 1
	If Not $iForward Then
		Local $iTmp = $iStart
		$iStart = $iEnd
		$iEnd = $iTmp
		$iStep = -1
	EndIf

	; same var Type of comparison
	Local $iCompType = False
	If $iCompare = 2 Then
		$iCompare = 0
		$iCompType = True
	EndIf

	; Search
	Switch UBound($avArray, 0)
		Case 1 ; 1D array search
			If Not $iCompare Then
				If Not $iCase Then
					For $i = $iStart To $iEnd Step $iStep
						If $iCompType And VarGetType($avArray[$i]) <> VarGetType($vValue) Then ContinueLoop
						If $avArray[$i] = $vValue Then Return $i
					Next
				Else
					For $i = $iStart To $iEnd Step $iStep
						If $iCompType And VarGetType($avArray[$i]) <> VarGetType($vValue) Then ContinueLoop
						If $avArray[$i] == $vValue Then Return $i
					Next
				EndIf
			Else
				For $i = $iStart To $iEnd Step $iStep
					If $iCompare = 3 Then
						If StringRegExp($avArray[$i], $vValue) Then Return $i
					Else
						If StringInStr($avArray[$i], $vValue, $iCase) > 0 Then Return $i
					EndIf
				Next
			EndIf
		Case 2 ; 2D array search
			Local $iUBoundSub = UBound($avArray, 2) - 1
			If $iSubItem > $iUBoundSub Then $iSubItem = $iUBoundSub
			If $iSubItem < 0 Then
				; will search for all Col
				$iSubItem = 0
			Else
				$iUBoundSub = $iSubItem
			EndIf

			For $j = $iSubItem To $iUBoundSub
				If Not $iCompare Then
					If Not $iCase Then
						For $i = $iStart To $iEnd Step $iStep
							If $iCompType And VarGetType($avArray[$i][$j]) <> VarGetType($vValue) Then ContinueLoop
							If $avArray[$i][$j] = $vValue Then Return $i
						Next
					Else
						For $i = $iStart To $iEnd Step $iStep
							If $iCompType And VarGetType($avArray[$i][$j]) <> VarGetType($vValue) Then ContinueLoop
							If $avArray[$i][$j] == $vValue Then Return $i
						Next
					EndIf
				Else
					For $i = $iStart To $iEnd Step $iStep
						If $iCompare = 3 Then
							If StringRegExp($avArray[$i][$j], $vValue) Then Return $i
						Else
							If StringInStr($avArray[$i][$j], $vValue, $iCase) > 0 Then Return $i
						EndIf
					Next
				EndIf
			Next
		Case Else
			Return SetError(7, 0, -1)
	EndSwitch

	Return SetError(6, 0, -1)
EndFunc   ;==>_ArraySearch

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: LazyCoder - added $iSubItem option; Tylo - implemented stable QuickSort algo; Jos van der Zande - changed logic to correctly Sort arrays with mixed Values and Strings
; ===============================================================================================================================
Func _ArraySort(ByRef $avArray, $iDescending = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $iUBound = UBound($avArray) - 1
	If $iUBound = -1 Then Return SetError(5, 0, 0)

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)

	; Sort
	Switch UBound($avArray, 0)
		Case 1
			__ArrayQuickSort1D($avArray, $iStart, $iEnd)
			If $iDescending Then _ArrayReverse($avArray, $iStart, $iEnd)
		Case 2
			Local $iSubMax = UBound($avArray, 2) - 1
			If $iSubItem > $iSubMax Then Return SetError(3, 0, 0)

			If $iDescending Then
				$iDescending = -1
			Else
				$iDescending = 1
			EndIf

			__ArrayQuickSort2D($avArray, $iDescending, $iStart, $iEnd, $iSubItem, $iSubMax)
		Case Else
			Return SetError(4, 0, 0)
	EndSwitch

	Return 1
EndFunc   ;==>_ArraySort

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __ArrayQuickSort1D
; Description ...: Helper function for sorting 1D arrays
; Syntax.........: __ArrayQuickSort1D ( ByRef $avArray, ByRef $iStart, ByRef $iEnd )
; Parameters ....: $avArray - Array to sort
;                  $iStart  - Index of array to start sorting at
;                  $iEnd    - Index of array to stop sorting at
; Return values .: None
; Author ........: Jos van der Zande, LazyCoder, Tylo, Ultima
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __ArrayQuickSort1D(ByRef $avArray, Const ByRef $iStart, Const ByRef $iEnd)
	If $iEnd <= $iStart Then Return

	Local $vTmp

	; InsertionSort (faster for smaller segments)
	If ($iEnd - $iStart) < 15 Then
		Local $vCur
		For $i = $iStart + 1 To $iEnd
			$vTmp = $avArray[$i]

			If IsNumber($vTmp) Then
				For $j = $i - 1 To $iStart Step -1
					$vCur = $avArray[$j]
					; If $vTmp >= $vCur Then ExitLoop
					If ($vTmp >= $vCur And IsNumber($vCur)) Or (Not IsNumber($vCur) And StringCompare($vTmp, $vCur) >= 0) Then ExitLoop
					$avArray[$j + 1] = $vCur
				Next
			Else
				For $j = $i - 1 To $iStart Step -1
					If (StringCompare($vTmp, $avArray[$j]) >= 0) Then ExitLoop
					$avArray[$j + 1] = $avArray[$j]
				Next
			EndIf

			$avArray[$j + 1] = $vTmp
		Next
		Return
	EndIf

	; QuickSort
	Local $L = $iStart, $R = $iEnd, $vPivot = $avArray[Int(($iStart + $iEnd) / 2)], $fNum = IsNumber($vPivot)
	Do
		If $fNum Then
			; While $avArray[$L] < $vPivot
			While ($avArray[$L] < $vPivot And IsNumber($avArray[$L])) Or (Not IsNumber($avArray[$L]) And StringCompare($avArray[$L], $vPivot) < 0)
				$L += 1
			WEnd
			; While $avArray[$R] > $vPivot
			While ($avArray[$R] > $vPivot And IsNumber($avArray[$R])) Or (Not IsNumber($avArray[$R]) And StringCompare($avArray[$R], $vPivot) > 0)
				$R -= 1
			WEnd
		Else
			While (StringCompare($avArray[$L], $vPivot) < 0)
				$L += 1
			WEnd
			While (StringCompare($avArray[$R], $vPivot) > 0)
				$R -= 1
			WEnd
		EndIf

		; Swap
		If $L <= $R Then
			$vTmp = $avArray[$L]
			$avArray[$L] = $avArray[$R]
			$avArray[$R] = $vTmp
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R

	__ArrayQuickSort1D($avArray, $iStart, $R)
	__ArrayQuickSort1D($avArray, $L, $iEnd)
EndFunc   ;==>__ArrayQuickSort1D

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __ArrayQuickSort2D
; Description ...: Helper function for sorting 2D arrays
; Syntax.........: __ArrayQuickSort2D ( ByRef $avArray, ByRef $iStep, ByRef $iStart, ByRef $iEnd, ByRef $iSubItem, ByRef $iSubMax )
; Parameters ....: $avArray  - Array to sort
;                  $iStep    - Step size (should be 1 to sort ascending, -1 to sort descending!)
;                  $iStart   - Index of array to start sorting at
;                  $iEnd     - Index of array to stop sorting at
;                  $iSubItem - Sub-index to sort on in 2D arrays
;                  $iSubMax  - Maximum sub-index that array has
; Return values .: None
; Author ........: Jos van der Zande, LazyCoder, Tylo, Ultima
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __ArrayQuickSort2D(ByRef $avArray, Const ByRef $iStep, Const ByRef $iStart, Const ByRef $iEnd, Const ByRef $iSubItem, Const ByRef $iSubMax)
	If $iEnd <= $iStart Then Return

	; QuickSort
	Local $vTmp, $L = $iStart, $R = $iEnd, $vPivot = $avArray[Int(($iStart + $iEnd) / 2)][$iSubItem], $fNum = IsNumber($vPivot)
	Do
		If $fNum Then
			; While $avArray[$L][$iSubItem] < $vPivot
			While ($iStep * ($avArray[$L][$iSubItem] - $vPivot) < 0 And IsNumber($avArray[$L][$iSubItem])) Or (Not IsNumber($avArray[$L][$iSubItem]) And $iStep * StringCompare($avArray[$L][$iSubItem], $vPivot) < 0)
				$L += 1
			WEnd
			; While $avArray[$R][$iSubItem] > $vPivot
			While ($iStep * ($avArray[$R][$iSubItem] - $vPivot) > 0 And IsNumber($avArray[$R][$iSubItem])) Or (Not IsNumber($avArray[$R][$iSubItem]) And $iStep * StringCompare($avArray[$R][$iSubItem], $vPivot) > 0)
				$R -= 1
			WEnd
		Else
			While ($iStep * StringCompare($avArray[$L][$iSubItem], $vPivot) < 0)
				$L += 1
			WEnd
			While ($iStep * StringCompare($avArray[$R][$iSubItem], $vPivot) > 0)
				$R -= 1
			WEnd
		EndIf

		; Swap
		If $L <= $R Then
			For $i = 0 To $iSubMax
				$vTmp = $avArray[$L][$i]
				$avArray[$L][$i] = $avArray[$R][$i]
				$avArray[$R][$i] = $vTmp
			Next
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R

	__ArrayQuickSort2D($avArray, $iStep, $iStart, $R, $iSubItem, $iSubMax)
	__ArrayQuickSort2D($avArray, $iStep, $L, $iEnd, $iSubItem, $iSubMax)
EndFunc   ;==>__ArrayQuickSort2D

; #FUNCTION# ====================================================================================================================
; Author ........: David Nuttall <danuttall at rocketmail dot com>
; Modified.......: Ultima - minor optimization
; ===============================================================================================================================
Func _ArraySwap(ByRef $vItem1, ByRef $vItem2)
	Local $vTmp = $vItem1
	$vItem1 = $vItem2
	$vItem2 = $vTmp
EndFunc   ;==>_ArraySwap

; #FUNCTION# ====================================================================================================================
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - added $iStart parameter and logic, Ultima - added $iEnd parameter, make use of _ArrayToString() instead of duplicating efforts
; ===============================================================================================================================
Func _ArrayToClip(Const ByRef $avArray, $iStart = 0, $iEnd = 0)
	Local $sResult = _ArrayToString($avArray, @CR, $iStart, $iEnd)
	If @error Then Return SetError(@error, 0, 0)
	If ClipPut($sResult) Then Return 1
	Return SetError(-1, 0, 0)
EndFunc   ;==>_ArrayToClip

; #FUNCTION# ====================================================================================================================
; Author ........: Brian Keene <brian_keene at yahoo dot com>, Valik - rewritten
; Modified.......: Ultima - code cleanup; Melba23 - added support for empty arrays
; ===============================================================================================================================
Func _ArrayToString(Const ByRef $avArray, $sDelim = "|", $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, "")
	If UBound($avArray, 0) <> 1 Then Return SetError(3, 0, "")
	If Not UBound($avArray) Then Return SetError(4, 0, "")

	Local $sResult, $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, "")

	; Combine
	For $i = $iStart To $iEnd
		$sResult &= $avArray[$i] & $sDelim
	Next

	Return StringTrimRight($sResult, StringLen($sDelim))
EndFunc   ;==>_ArrayToString

; #FUNCTION# ====================================================================================================================
; Author ........: jchd
; Modified.......:
; ===============================================================================================================================
Func _ArrayTranspose(ByRef $avArray)
	If UBound($avArray, 0) <> 2 Then Return SetError(1, 0, 0)

	Local $vElement = 0, $iDim_1 = UBound($avArray, 1), $iDim_2 = UBound($avArray, 2), $iDim_Max = $iDim_2
	If $iDim_1 > $iDim_2 Then $iDim_Max = $iDim_1

	ReDim $avArray[$iDim_Max][$iDim_Max]
	For $i = 0 To $iDim_Max - 2
		For $j = $i + 1 To $iDim_Max - 1
			$vElement = $avArray[$i][$j]
			$avArray[$i][$j] = $avArray[$j][$i]
			$avArray[$j][$i] = $vElement
		Next
	Next
	ReDim $avArray[$iDim_2][$iDim_1]
	Return 1
EndFunc   ;==>_ArrayTranspose

; #FUNCTION# ====================================================================================================================
; Author ........: Adam Moore (redndahead)
; Modified.......: Ultima - code cleanup, optimization
; ===============================================================================================================================
Func _ArrayTrim(ByRef $avArray, $iTrimNum, $iDirection = 0, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) <> 1 Then Return SetError(2, 0, 0)
	If Not UBound($avArray) Then Return SetError(3, 0, 0)

	Local $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(5, 0, 0)

	; Trim
	If $iDirection Then
		For $i = $iStart To $iEnd
			$avArray[$i] = StringTrimRight($avArray[$i], $iTrimNum)
		Next
	Else
		For $i = $iStart To $iEnd
			$avArray[$i] = StringTrimLeft($avArray[$i], $iTrimNum)
		Next
	EndIf

	Return 1
EndFunc   ;==>_ArrayTrim

; #FUNCTION# ====================================================================================================================
; Author ........: SmOke_N
; Modified.......: litlmike; Melba23 - added support for empty arrays
; ===============================================================================================================================
Func _ArrayUnique($aArray, $iDimension = 1, $iBase = 0, $iCase = 0, $vDelim = "|")
	Local $iUboundDim
	;$aArray used to be ByRef, but litlmike altered it to allow for the choosing of 1 Array Dimension, without altering the original array
	If $vDelim = "|" Then $vDelim = Chr(01) ; by SmOke_N, modified by litlmike
	If Not IsArray($aArray) Then Return SetError(1, 0, 0) ;Check to see if it is valid array
	If UBound($aArray) = 0 Then Return SetError(4, 0, 0) ; Check if array empty

	;Checks that the given Dimension is Valid
	If Not $iDimension > 0 Then
		Return SetError(3, 0, 0) ;Check to see if it is valid array dimension, Should be greater than 0
	Else
		;If Dimension Exists, then get the number of "Rows"
		$iUboundDim = UBound($aArray, 1) ;Get Number of "Rows"
		If @error Then Return SetError(3, 0, 0) ;2 = Array dimension is invalid.

		;If $iDimension Exists, And the number of "Rows" is Valid:
		If $iDimension > 1 Then ;Makes sure the Array dimension desired is more than 1-dimensional
			Local $aArrayTmp[1] ;Declare blank array, which will hold the dimension declared by user
			For $i = 0 To $iUboundDim - 1 ;Loop through "Rows"
				_ArrayAdd($aArrayTmp, $aArray[$i][$iDimension - 1]) ;$iDimension-1 to match Dimension
			Next
			_ArrayDelete($aArrayTmp, 0) ;Get rid of 1st-element which is blank
		Else ;Makes sure the Array dimension desired is 1-dimensional
			;If Dimension Exists, And the number of "Rows" is Valid, and the Dimension desired is not > 1, then:
			;For the Case that the array is 1-Dimensional
			If UBound($aArray, 0) = 1 Then ;Makes sure the Array is only 1-Dimensional
				Dim $aArrayTmp[1] ;Declare blank array, which will hold the dimension declared by user
				For $i = 0 To $iUboundDim - 1
					_ArrayAdd($aArrayTmp, $aArray[$i])
				Next
				_ArrayDelete($aArrayTmp, 0) ;Get rid of 1st-element which is blank
			Else ;For the Case that the array is 2-Dimensional
				Dim $aArrayTmp[1] ;Declare blank array, which will hold the dimension declared by user
				For $i = 0 To $iUboundDim - 1
					_ArrayAdd($aArrayTmp, $aArray[$i][$iDimension - 1]) ;$iDimension-1 to match Dimension
				Next
				_ArrayDelete($aArrayTmp, 0) ;Get rid of 1st-element which is blank
			EndIf
		EndIf
	EndIf

	Local $sHold ;String that holds the Unique array info
	For $iCC = $iBase To UBound($aArrayTmp) - 1 ;Loop Through array
		;If Not the case that the element is already in $sHold, then add it
		If Not StringInStr($vDelim & $sHold, $vDelim & $aArrayTmp[$iCC] & $vDelim, $iCase) Then _
				$sHold &= $aArrayTmp[$iCC] & $vDelim
	Next
	If $sHold Then
		$aArrayTmp = StringSplit(StringTrimRight($sHold, StringLen($vDelim)), $vDelim, 1) ;Split the string into an array
		Return $aArrayTmp ;SmOke_N's version used to Return SetError(0, 0, 0)
	EndIf
	Return SetError(2, 0, 0) ;If the script gets this far, it has failed
EndFunc   ;==>_ArrayUnique

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Array_ExeterInternal
; Description ...: Permute Function based on an algorithm from Exeter University.
; Syntax.........: __Array_ExeterInternal ( ByRef $avArray, $iStart, $iSize, $sDelim, ByRef $aIdx, ByRef $aResult )
; Parameters ....: $avArray - The Array to get Permutations
;                  $iStart - Starting Point for Loop
;                  $iSize - End Point for Loop
;                  $sDelim - String result separator
;                  $aIdx - Array Used in Rotations
;                  $aResult - Resulting Array
; Return values .: Success      - Computer name
; Author ........: Erik Pilsits
; Modified.......: 07/08/2008
; Remarks .......: This function is used internally. Permute Function based on an algorithm from Exeter University.
; +
;                   http://www.bearcave.com/random_hacks/permute.html
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Array_ExeterInternal(ByRef $avArray, $iStart, $iSize, $sDelim, ByRef $aIdx, ByRef $aResult, ByRef $iCount)

	If $iStart == $iSize - 1 Then
		For $i = 0 To $iSize - 1
			$aResult[$iCount] &= $avArray[$aIdx[$i]] & $sDelim
		Next
		If $sDelim <> "" Then $aResult[$iCount] = StringTrimRight($aResult[$iCount], 1)
		$iCount += 1
	Else
		Local $iTemp
		For $i = $iStart To $iSize - 1
			$iTemp = $aIdx[$i]

			$aIdx[$i] = $aIdx[$iStart]
			$aIdx[$iStart] = $iTemp
			__Array_ExeterInternal($avArray, $iStart + 1, $iSize, $sDelim, $aIdx, $aResult, $iCount)
			$aIdx[$iStart] = $aIdx[$i]
			$aIdx[$i] = $iTemp
		Next
	EndIf
EndFunc   ;==>__Array_ExeterInternal

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Array_Combinations
; Description ...: Creates Combination
; Syntax.........: __Array_Combinations ( $iN, $iR )
; Parameters ....: $iN - Value passed on from UBound($avArray)
;                  $iR - Size of the combinations set
; Return values .: Integer value of the number of combinations
; Author ........: Erik Pilsits
; Modified.......: 07/08/2008
; Remarks .......: This function is used internally. PBased on an algorithm by Kenneth H. Rosen.
; +
;                   http://www.bearcave.com/random_hacks/permute.html
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Array_Combinations($iN, $iR)
	Local $i_Total = 1

	For $i = $iR To 1 Step -1
		$i_Total *= ($iN / $i)
		$iN -= 1
	Next
	Return Round($i_Total)
EndFunc   ;==>__Array_Combinations

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Array_GetNext
; Description ...: Creates Combination
; Syntax.........: __Array_GetNext ( $iN, $iR, ByRef $iLeft, $iTotal, ByRef $aIdx )
; Parameters ....: $iN - Value passed on from UBound($avArray)
;                  $iR - Size of the combinations set
;                  $iLeft - Remaining number of combinations
;                  $iTotal - Total number of combinations
;                  $aIdx - Array containing combinations
; Return values .: Function only changes values ByRef
; Author ........: Erik Pilsits
; Modified.......: 07/08/2008
; Remarks .......: This function is used internally. PBased on an algorithm by Kenneth H. Rosen.
; +
;                   http://www.bearcave.com/random_hacks/permute.html
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Array_GetNext($iN, $iR, ByRef $iLeft, $iTotal, ByRef $aIdx)
	If $iLeft == $iTotal Then
		$iLeft -= 1
		Return
	EndIf

	Local $i = $iR - 1
	While $aIdx[$i] == $iN - $iR + $i
		$i -= 1
	WEnd

	$aIdx[$i] += 1
	For $j = $i + 1 To $iR - 1
		$aIdx[$j] = $aIdx[$i] + $j - $i
	Next

	$iLeft -= 1
EndFunc   ;==>__Array_GetNext
