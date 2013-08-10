#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>

Example()

Func Example()
	Local $sRegPath = "HKLM\SOFTWARE\AutoIt v3\AutoIt"
	If StringInStr("X64IA64", @OSArch) Then $sRegPath = StringReplace($sRegPath, "SOFTWARE", "SOFTWARE\Wow6432Node") ;get AutoIt install dir

	Local $sFile = RegRead($sRegPath, "InstallDir") & "\Examples\GUI\logo4.gif"
	If Not FileExists($sFile) Then
		MsgBox(BitOR($MB_SYSTEMMODAL, $MB_ICONHAND), "", $sFile & " not found!", 30)
		Return False
	EndIf

	_GDIPlus_Startup()
	Local $hImage = _GDIPlus_ImageLoadFromFile($sFile) ;create an image object based on a file
	If @error Then
		_GDIPlus_Shutdown()
		MsgBox(BitOR($MB_SYSTEMMODAL, $MB_ICONHAND), "", "An error has occured - unable to load image!", 30)
		Return False
	EndIf

	Local $iW = _GDIPlus_ImageGetWidth($hImage), $iH = _GDIPlus_ImageGetHeight($hImage) ;get width and height of the image

	Local $tBitmapData = _GDIPlus_BitmapLockBits($hImage, 0, 0, $iW, $iH, $GDIP_ILMWRITE, $GDIP_PXF32ARGB) ;locks a portion of a bitmap for reading and writing. More infor at http://msdn.microsoft.com/en-us/library/windows/desktop/ms536298(v=vs.85).aspx
	Local $iStride = DllStructGetData($tBitmapData, "Stride") ;get stride (byte offset between the beginning of one scan line and the next) from locked bitmap
	Local $iScan0 = DllStructGetData($tBitmapData, "Scan0") ;get scan0 (pixel data) from locked bitmap
	Local $iSearchPixel = 0xFF000080, $iReplaceColor = 0x00000000 ;color format 0xAARRGGBB
	Local $tPixel = 0, $iPixel = 0

	For $iY = 0 To $iH - 1
		For $iX = 0 To $iW - 1 ;get each pixel in each line and row
			$tPixel = DllStructCreate("int", $iScan0 + ($iY * $iStride) + ($iX * 4)) ;read pixel at appropriate coordinate
			$iPixel = DllStructGetData($tPixel, 1) ;get pixel color
			If $iPixel = $iSearchPixel Then DllStructSetData($tPixel, 1, $iReplaceColor) ;compare and replace pixel color (blue with transparent color)
		Next
	Next
	_GDIPlus_BitmapUnlockBits($hImage, $tBitmapData) ;unlocks a portion of a bitmap that was locked by _GDIPlus_BitmapLockBits

	;to save manipulated image just use _GDIPlus_ImageSaveToFile()

	;display manipulated image
	Local $hGUI = GUICreate("_GDIPlus_BitmapUnlockBits Demo",  $iW, $iH)
	GUISetState()

	Local $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI) ;create a Graphics object from a window handle
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hImage, 0, 0, $iW, $iH) ;copy manipulated image to graphics handle
	ShellExecute($sFile) ;display original image just to compare with manipulated one

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	;cleanup resources
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	GUIDelete($hGUI)
EndFunc