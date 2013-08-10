#include <Array.au3>

Local $aArray[6][2] = [[1, "A"],[2, "B"],[3, "C"],[1, "A"],[2, "B"],[3, "C"]]
_ArrayDisplay($aArray, "$aArray") ; Display the current array.
Local $aArrayUnique = _ArrayUnique($aArray) ; Use default parameters to create a unique array of the first column.
_ArrayDisplay($aArrayUnique, "$aArrayUnique represents the first column of $aArray") ; Display the unique array.

$aArrayUnique = _ArrayUnique($aArray, 2) ; Create a unique array of the second column.
_ArrayDisplay($aArrayUnique, "$aArrayUnique represents the second column of $aArray") ; Display the unique array.