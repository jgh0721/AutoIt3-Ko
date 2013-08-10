#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Example()

Func Example()
	Opt("GUIOnEventMode", 1)

	_GDIPlus_Startup() ;initialize GDI+
	Local Const $iWidth = 600, $iHeight = 600, $iBgColor = 0x202020 ;$iBGColor format RRGGBB

	Global $hGUI = GUICreate("GDI+ example", $iWidth, $iHeight) ;create a test GUI
	GUISetBkColor($iBgColor, $hGUI) ;set GUI background color
	GUISetState()

	;create a faster buffered graphics frame set for smoother gfx object movements
	Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight) ;create an empty bitmap
	Global $hHBITMAP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap) ;convert GDI+ bitmap to GDI bitmap
	_GDIPlus_BitmapDispose($hBitmap) ;delete GDI+ bitmap because not needed anymore

	Global $hDC = _WinAPI_GetDC($hGUI) ;get device context from GUI
	Global $hDC_Backbuffer = _WinAPI_CreateCompatibleDC($hDC) ;creates a memory device context compatible with the specified device
	Global $DC_Obj = _WinAPI_SelectObject($hDC_Backbuffer, $hHBITMAP) ;selects an object into the specified device context
	Global $hGfxCtxt = _GDIPlus_GraphicsCreateFromHDC($hDC_Backbuffer) ;create a graphics object from a device context (DC)
	_GDIPlus_GraphicsSetSmoothingMode($hGfxCtxt, $GDIP_SMOOTHINGMODE_HIGHQUALITY) ;set smoothing mode (8 X 4 box filter)

	Global $hPen = _GDIPlus_PenCreate(0xFFFF8000, 4) ;create a pen object

	GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

	Local Const $ifDeg = ACos(-1) / 180 ;ACos(-1) is nearly pi
	Local $iX_Center = $iWidth / 2, $iY_Center = $iHeight / 2, $ifXPos, $ifYPos, $ifAngle = 0
	Local Const $iDots = 8, $ifAngelDist = 360 / $iDots, $iRadius = 200
	Local $aCoordinates[$iDots][2] ;create an array to save coordinates of the x/y coordinates
	Do
		_GDIPlus_GraphicsClear($hGfxCtxt, 0xFF000000 + $iBgColor) ;clear bitmap with given color (AARRGGBB format)
		For $i = 0 To $iDots - 1
			$ifXPos = $iX_Center + Cos($ifAngle * $ifDeg) * $iRadius
			$ifYPos = $iY_Center + Sin($ifAngle * $ifDeg) * $iRadius
			$aCoordinates[$i][0] = $ifXPos
			$aCoordinates[$i][1] = $ifYPos
			$ifAngle += $ifAngelDist ;increase angle to next dot
		Next
		For $i = 0 To $iDots - 2 ;draw each line to next point
			_GDIPlus_GraphicsDrawLine($hGfxCtxt, $aCoordinates[$i][0], $aCoordinates[$i][1], $aCoordinates[$i + 1][0], $aCoordinates[$i + 1][1], $hPen)
		Next
		;draw last line to 1st line
		_GDIPlus_GraphicsDrawLine($hGfxCtxt, $aCoordinates[$i][0], $aCoordinates[$i][1], $aCoordinates[0][0], $aCoordinates[0][1], $hPen)

		_WinAPI_BitBlt($hDC, 0, 0, $iWidth, $iHeight, $hDC_Backbuffer, 0, 0, $SRCCOPY) ;copy backbuffer to screen (GUI)
		$ifAngle -= 1 ;decrease overall angle

	Until Not Sleep(30) ;Sleep() always returns 1 and Not 1 is 0

	_Exit()
EndFunc   ;==>Example

Func _Exit() ;cleanup GDI+ resources
	_GDIPlus_PenDispose($hPen)
	_WinAPI_SelectObject($hDC_Backbuffer, $DC_Obj)
	_GDIPlus_GraphicsDispose($hGfxCtxt)
	_WinAPI_DeleteObject($hHBITMAP)
	_WinAPI_ReleaseDC($hGUI, $hDC)
	GUIDelete($hGUI)
	Exit
EndFunc   ;==>_Exit
