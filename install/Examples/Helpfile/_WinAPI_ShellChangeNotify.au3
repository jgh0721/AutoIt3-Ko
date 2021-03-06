#include <WinAPIShellEx.au3>
#include <APIShellExConstants.au3>
#include <Constants.au3>

Local $Icon = RegRead('HKCR\AutoIt3Script\DefaultIcon', '')

If Not @error Then
	RegWrite('HKCR\AutoIt3Script\DefaultIcon', '', 'REG_SZ', @SystemDir & '\shell32.dll,-152')
	_WinAPI_ShellChangeNotify($SHCNE_ASSOCCHANGED, $SHCNF_FLUSH)
	MsgBox($MB_SYSTEMMODAL, '', 'The icon for .au3 files has been changed. Press OK to restore it.')
	RegWrite('HKCR\AutoIt3Script\DefaultIcon', '', 'REG_SZ', $Icon)
	_WinAPI_ShellChangeNotify($SHCNE_ASSOCCHANGED, $SHCNF_FLUSH)
EndIf
