; After opening a workbook and returning its object identifier, Delete a Worksheet by String Name

#include <Excel.au3>
#include <Constants.au3>

Local $oExcel = _ExcelBookNew() ;Create new book, make it visible

_ExcelSheetDelete($oExcel, "Sheet1") ;Delete Sheet by string name of SheetName

MsgBox($MB_SYSTEMMODAL, "Sheet 1 deleted by name", "Press OK to Save File and Exit")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; Now we save it into the temp directory; overwrite existing file if necessary
_ExcelBookClose($oExcel) ; And finally we close out
