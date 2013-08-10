; moves all txt-files from temp to txtfiles and prechecks if
; target directory structure exists, if not then automatically creates it

#include <FileConstants.au3>

FileMove(@TempDir & "\*.txt", @TempDir & "\TxtFiles\", $FC_OVERWRITE + $FC_CREATEPATH)
