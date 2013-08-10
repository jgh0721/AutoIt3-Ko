#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>

Example()

Func Example()
	Opt("GUIOnEventMode", 1)

	_GDIPlus_Startup() ;initialize GDI+
	Global Const $iWidth = 600, $iHeight = 600, $iBgColor = 0x303030 ;$iBGColor format RRGGBB

	Global $hGUI = GUICreate("GDI+ example", $iWidth, $iHeight) ;create a test GUI
	GUISetBkColor($iBgColor, $hGUI) ;set GUI background color
	GUISetState()

	;create buffered graphics frame set for smoother gfx object movements
	Global $hGfx = _GDIPlus_GraphicsCreateFromHWND($hGUI) ;create a graphics object from a window handle
	Global $hBitmap = _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $hGfx) ;create a Bitmap object based on a graphics object
	Global $hGfxCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap) ;get the graphics context of the image / bitmap to draw on image / bitmap
	_GDIPlus_GraphicsSetSmoothingMode($hGfxCtxt, $GDIP_SMOOTHINGMODE_HIGHQUALITY) ;sets the graphics object rendering quality (antialiasing)

	Global $hBrush = _GDIPlus_BrushCreateSolid(0xFF8080FF) ;create a solid Brush object

	GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

	Global Const $fDeg = ACos(-1) / 180 ;ACos(-1) is nearly pi
	Global $i, $iSize = 50, $iX_Center = ($iWidth - $iSize) / 2, $iY_Center = ($iHeight - $iSize) / 2, $fXPos, $fYPos, $fAngle = 0
	Global Const $iDots = 16, $fAngelDist = 360 / $iDots, $iRadius = 200

	Do
		_GDIPlus_GraphicsClear($hGfxCtxt, 0xFF000000 + $iBgColor) ;clear bitmap with given color (AARRGGBB format)
		For $i = 1 To $iDots
			$fXPos = $iX_Center + Cos($fAngle * $fDeg) * $iRadius
			$fYPos = $iY_Center + Sin($fAngle * $fDeg) * $iRadius
			_GDIPlus_GraphicsFillEllipse($hGfxCtxt, $fXPos, $fYPos, $iSize, $iSize, $hBrush) ;draw dots in a circle
			$fAngle += $fAngelDist ;increase angle to next dot
		Next
		$fAngle += 1 ;increase overall angle
		_GDIPlus_GraphicsDrawImageRect($hGfx, $hBitmap, 0, 0, $iWidth, $iHeight) ;copy drawn bitmap to GUI
	Until Not Sleep(20) ;Sleep() always returns 1 and Not 1 is 0
EndFunc   ;==>Example

Func _Exit() ;cleanup GDI+ resources
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_GraphicsDispose($hGfxCtxt)
	_GDIPlus_GraphicsDispose($hGfx)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_Shutdown()
	GUIDelete($hGUI)
	Exit
EndFunc   ;==>_Exit
