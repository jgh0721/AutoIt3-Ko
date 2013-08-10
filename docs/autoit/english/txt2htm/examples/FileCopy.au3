#include <FileConstants.au3>

FileCopy("C:\*.au3", "D:\mydir\*.*")

; Method to copy a folder (with its contents)
; DirCreate("C:\new")
; FileCopy("C:\old\*.*", "C:\new\")

FileCopy("C:\Temp\*.txt", "C:\Temp\TxtFiles\", $FC_CREATEPATH)
; RIGHT - 'TxtFiles' is now the target directory and the file names are given by the source names

FileCopy("C:\Temp\*.txt", "C:\Temp\TxtFiles\", BitOR($FC_OVERWRITE, $FC_CREATEPATH)) ; Overwrite + create target directory structure
; Copy the txt-files from source to target and overwrite target files with same name
