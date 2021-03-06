#include <Word.au3>
#include <Constants.au3>

; Create application object
Global $oWord = _Word_Create()
If @error <> 0 Then Exit MsgBox($MB_SYSTEMMODAL, "Word UDF: _Word_DocPrint Example", _
		"Error creating a new Word application object." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
; Open test document
Global $oDoc = _Word_DocOpen($oWord, @ScriptDir & "\Extras\Test.doc", Default, Default, True)
If @error <> 0 Then Exit MsgBox($MB_SYSTEMMODAL, "Word UDF: _Word_DocPrint Example", _
		"Error opening '.\Extras\Test.doc'." & @CRLF & "@error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Export a range as PDF/A and display the exported file
; *****************************************************************************
; Set the range to lines 2 and 3
Global $oRange = _Word_DocRangeSet($oDoc, -1, $wdParagraph, 1, $wdParagraph, 2)
Global $sFilename = @TempDir & "\Test2.pdf"
_Word_DocExport($oRange, $sFilename, Default, $wdExportFromTo, Default, Default, True, Default, Default, True)
If @error <> 0 Then Exit MsgBox($MB_SYSTEMMODAL, "Word UDF: _Word_DocExport Example", "Error exporting the document." & _
		@CRLF & "@error = " & @error & ", @extended = " & @extended)
MsgBox($MB_SYSTEMMODAL, "Word UDF: _Word_DocExport Example", _
		"The specified range has successfully been exported to: " & $sFilename)
