#include <Word.au3>
#include <Constants.au3>

; Create application object
Global $oWord = _Word_Create()
If @error <> 0 Then Exit MsgBox($MB_SYSTEMMODAL, "Word UDF: _Word_DocFind Example", _
		"Error creating a new Word application object." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
; Open test document read-only
Global $oDoc = _Word_DocOpen($oWord, @ScriptDir & "\Extras\Test.doc", Default, Default, True)
If @error <> 0 Then Exit MsgBox($MB_SYSTEMMODAL, "Word UDF: _Word_DocFind Example", _
		"Error opening '.\Extras\Test.doc'." & @CRLF & "@error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Underline text "line" in lines 2-4.
; *****************************************************************************
Global $oRangeFound, $oSearchRange
$oSearchRange = _Word_DocRangeSet($oDoc, -1, $wdParagraph, 1, $wdParagraph, 3)
$oRangeFound = _Word_DocFind($oDoc, "line", $oSearchRange)
If @error <> 0 Then Exit MsgBox($MB_SYSTEMMODAL, "Word UDF: _Word_DocFind Example", _
		"Error locating the specified text in the document." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
$oRangeFound.Underline = True
While 1
	$oRangeFound = _Word_DocFind($oDoc, "line", $oSearchRange, $oRangeFound)
	If @error <> 0 Then ExitLoop
	$oRangeFound.Underline = True
WEnd
MsgBox($MB_SYSTEMMODAL, "Word UDF: _Word_DocFind Example", _
		"All occurrences of string 'line' in paragraphs 2-4 marked as underlined.")
