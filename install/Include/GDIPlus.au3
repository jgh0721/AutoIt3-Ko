#include-once

#include "GDIPlusConstants.au3"
#include "WinAPI.au3"
#include "StructureConstants.au3"

; #INDEX# =======================================================================================================================
; Title .........: GDIPlus
; AutoIt Version : 3.3.7.20++
; Language ......: English
; Description ...: Functions that assist with Microsoft Windows GDI+ management.
;                  It enables applications to use graphics and formatted text on both the video display and the printer.
;                  Applications based on the Microsoft Win32 API do not access graphics hardware directly.
;                  Instead, GDI+ interacts with device drivers on behalf of applications.
;                  GDI+ can be used in all Windows-based applications.
;                  GDI+ is new technology that is included in Windows XP and  the Windows Server 2003.
; Author ........: Paul Campbell (PaulIA)
; Modified ......: UEZ
; Dll ...........: GDIPlus.dll
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $ghGDIPBrush = 0
Global $ghGDIPDll = 0
Global $ghGDIPPen = 0
Global $giGDIPRef = 0
Global $giGDIPToken = 0
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GDIPlus_ArrowCapCreate
; _GDIPlus_ArrowCapDispose
; _GDIPlus_ArrowCapGetFillState
; _GDIPlus_ArrowCapGetHeight
; _GDIPlus_ArrowCapGetMiddleInset
; _GDIPlus_ArrowCapGetWidth
; _GDIPlus_ArrowCapSetFillState
; _GDIPlus_ArrowCapSetHeight
; _GDIPlus_ArrowCapSetMiddleInset
; _GDIPlus_ArrowCapSetWidth
; _GDIPlus_BitmapCloneArea
; _GDIPlus_BitmapCreateFromFile
; _GDIPlus_BitmapCreateFromGraphics
; _GDIPlus_BitmapCreateFromHBITMAP
; _GDIPlus_BitmapCreateFromScan0
; _GDIPlus_BitmapCreateHBITMAPFromBitmap
; _GDIPlus_BitmapDispose
; _GDIPlus_BitmapLockBits
; _GDIPlus_BitmapUnlockBits
; _GDIPlus_BrushClone
; _GDIPlus_BrushCreateSolid
; _GDIPlus_BrushDispose
; _GDIPlus_BrushGetSolidColor
; _GDIPlus_BrushGetType
; _GDIPlus_BrushSetSolidColor
; _GDIPlus_CustomLineCapCreate
; _GDIPlus_CustomLineCapDispose
; _GDIPlus_Decoders
; _GDIPlus_DecodersGetCount
; _GDIPlus_DecodersGetSize
; _GDIPlus_DrawImagePoints
; _GDIPlus_Encoders
; _GDIPlus_EncodersGetCLSID
; _GDIPlus_EncodersGetCount
; _GDIPlus_EncodersGetParamList
; _GDIPlus_EncodersGetParamListSize
; _GDIPlus_EncodersGetSize
; _GDIPlus_FontCreate
; _GDIPlus_FontDispose
; _GDIPlus_FontFamilyCreate
; _GDIPlus_FontFamilyDispose
; _GDIPlus_GraphicsClear
; _GDIPlus_GraphicsCreateFromHDC
; _GDIPlus_GraphicsCreateFromHWND
; _GDIPlus_GraphicsDispose
; _GDIPlus_GraphicsDrawArc
; _GDIPlus_GraphicsDrawBezier
; _GDIPlus_GraphicsDrawClosedCurve
; _GDIPlus_GraphicsDrawCurve
; _GDIPlus_GraphicsDrawEllipse
; _GDIPlus_GraphicsDrawImage
; _GDIPlus_GraphicsDrawImageRect
; _GDIPlus_GraphicsDrawImageRectRect
; _GDIPlus_GraphicsDrawLine
; _GDIPlus_GraphicsDrawPie
; _GDIPlus_GraphicsDrawPolygon
; _GDIPlus_GraphicsDrawRect
; _GDIPlus_GraphicsDrawString
; _GDIPlus_GraphicsDrawStringEx
; _GDIPlus_GraphicsFillClosedCurve
; _GDIPlus_GraphicsFillEllipse
; _GDIPlus_GraphicsFillPie
; _GDIPlus_GraphicsFillPolygon
; _GDIPlus_GraphicsFillRect
; _GDIPlus_GraphicsGetDC
; _GDIPlus_GraphicsGetSmoothingMode
; _GDIPlus_GraphicsMeasureString
; _GDIPlus_GraphicsReleaseDC
; _GDIPlus_GraphicsSetTransform
; _GDIPlus_GraphicsSetSmoothingMode
; _GDIPlus_ImageDispose
; _GDIPlus_ImageGetFlags
; _GDIPlus_ImageGetGraphicsContext
; _GDIPlus_ImageGetHeight
; _GDIPlus_ImageGetHorizontalResolution
; _GDIPlus_ImageGetPixelFormat
; _GDIPlus_ImageGetRawFormat
; _GDIPlus_ImageGetType
; _GDIPlus_ImageGetVerticalResolution
; _GDIPlus_ImageGetWidth
; _GDIPlus_ImageLoadFromFile
; _GDIPlus_ImageSaveToFile
; _GDIPlus_ImageSaveToFileEx
; _GDIPlus_MatrixCreate
; _GDIPlus_MatrixDispose
; _GDIPlus_MatrixRotate
; _GDIPlus_MatrixScale
; _GDIPlus_MatrixTranslate
; _GDIPlus_ParamAdd
; _GDIPlus_ParamInit
; _GDIPlus_PenCreate
; _GDIPlus_PenDispose
; _GDIPlus_PenGetAlignment
; _GDIPlus_PenGetColor
; _GDIPlus_PenGetCustomEndCap
; _GDIPlus_PenGetDashCap
; _GDIPlus_PenGetDashStyle
; _GDIPlus_PenGetEndCap
; _GDIPlus_PenGetWidth
; _GDIPlus_PenSetAlignment
; _GDIPlus_PenSetColor
; _GDIPlus_PenSetDashCap
; _GDIPlus_PenSetCustomEndCap
; _GDIPlus_PenSetDashStyle
; _GDIPlus_PenSetEndCap
; _GDIPlus_PenSetWidth
; _GDIPlus_RectFCreate
; _GDIPlus_Shutdown
; _GDIPlus_Startup
; _GDIPlus_StringFormatCreate
; _GDIPlus_StringFormatDispose
; _GDIPlus_StringFormatSetAlign
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __GDIPlus_BrushDefCreate
; __GDIPlus_BrushDefDispose
; __GDIPlus_ExtractFileExt
; __GDIPlus_LastDelimiter
; __GDIPlus_PenDefCreate
; __GDIPlus_PenDefDispose
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapCreate($fHeight, $fWidth, $bFilled = True)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateAdjustableArrowCap", "float", $fHeight, "float", $fWidth, "bool", $bFilled, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[4])
EndFunc   ;==>_GDIPlus_ArrowCapCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapDispose($hCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteCustomLineCap", "handle", $hCap)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ArrowCapDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapGetFillState($hArrowCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetAdjustableArrowCapFillState", "handle", $hArrowCap, "bool*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ArrowCapGetFillState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapGetHeight($hArrowCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetAdjustableArrowCapHeight", "handle", $hArrowCap, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ArrowCapGetHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapGetMiddleInset($hArrowCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetAdjustableArrowCapMiddleInset", "handle", $hArrowCap, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ArrowCapGetMiddleInset

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapGetWidth($hArrowCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetAdjustableArrowCapWidth", "handle", $hArrowCap, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ArrowCapGetWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapSetFillState($hArrowCap, $bFilled = True)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetAdjustableArrowCapFillState", "handle", $hArrowCap, "bool", $bFilled)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ArrowCapSetFillState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapSetHeight($hArrowCap, $fHeight)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetAdjustableArrowCapHeight", "handle", $hArrowCap, "float", $fHeight)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ArrowCapSetHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapSetMiddleInset($hArrowCap, $fInset)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetAdjustableArrowCapMiddleInset", "handle", $hArrowCap, "float", $fInset)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ArrowCapSetMiddleInset

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapSetWidth($hArrowCap, $fWidth)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetAdjustableArrowCapWidth", "handle", $hArrowCap, "float", $fWidth)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ArrowCapSetWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapCloneArea($hBmp, $iLeft, $iTop, $iWidth, $iHeight, $iFormat = 0x00021808)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCloneBitmapAreaI", "int", $iLeft, "int", $iTop, "int", $iWidth, "int", $iHeight, _
			"int", $iFormat, "handle", $hBmp, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[7])
EndFunc   ;==>_GDIPlus_BitmapCloneArea

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromFile($sFileName)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateBitmapFromFile", "wstr", $sFileName, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_BitmapCreateFromFile

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $hGraphics)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateBitmapFromGraphics", "int", $iWidth, "int", $iHeight, "handle", $hGraphics, _
			"ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[4])
EndFunc   ;==>_GDIPlus_BitmapCreateFromGraphics

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromHBITMAP($hBmp, $hPal = 0)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateBitmapFromHBITMAP", "handle", $hBmp, "handle", $hPal, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[3])
EndFunc   ;==>_GDIPlus_BitmapCreateFromHBITMAP

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight, $iStride = 0, $iPixelFormat = $GDIP_PXF32ARGB, $pScan0 = 0)
	Local $aResult = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iWidth, "int", $iHeight, "int", $iStride, "int", $iPixelFormat, "ptr", $pScan0, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[6]
EndFunc   ;==>_GDIPlus_BitmapCreateFromScan0

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap, $iARGB = 0xFF000000)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateHBITMAPFromBitmap", "handle", $hBitmap, "ptr*", 0, "dword", $iARGB)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_BitmapCreateHBITMAPFromBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapDispose($hBitmap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDisposeImage", "handle", $hBitmap)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_BitmapDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapLockBits($hBitmap, $iLeft, $iTop, $iWidth, $iHeight, $iFlags = $GDIP_ILMREAD, $iFormat = $GDIP_PXF32RGB)
	Local $tData = DllStructCreate($tagGDIPBITMAPDATA)
	Local $tRect = DllStructCreate($tagRECT)

	; The RECT is initialized strange for this function.  It wants the Left and
	; Top members set as usual but instead of Right and Bottom also being
	; coordinates they are expected to be the Width and Height sizes
	; respectively.
	DllStructSetData($tRect, "Left", $iLeft)
	DllStructSetData($tRect, "Top", $iTop)
	DllStructSetData($tRect, "Right", $iWidth)
	DllStructSetData($tRect, "Bottom", $iHeight)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipBitmapLockBits", "handle", $hBitmap, "struct*", $tRect, "uint", $iFlags, "int", $iFormat, "struct*", $tData)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tData)
EndFunc   ;==>_GDIPlus_BitmapLockBits

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapUnlockBits($hBitmap, $tBitmapData)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipBitmapUnlockBits", "handle", $hBitmap, "struct*", $tBitmapData)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_BitmapUnlockBits

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BrushClone($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCloneBrush", "handle", $hBrush, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_BrushClone

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BrushCreateSolid($iARGB = 0xFF000000)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateSolidFill", "int", $iARGB, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_BrushCreateSolid

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BrushDispose($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteBrush", "handle", $hBrush)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_BrushDispose

; #FUNCTION# ====================================================================================================================
; Author ........:
; Modified.......: smashly
; ===============================================================================================================================
Func _GDIPlus_BrushGetSolidColor($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetSolidFillColor", "handle", $hBrush, "dword*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_BrushGetSolidColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BrushGetType($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetBrushType", "handle", $hBrush, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_BrushGetType

; #FUNCTION# ====================================================================================================================
; Author ........:
; Modified.......: smashly
; ===============================================================================================================================
Func _GDIPlus_BrushSetSolidColor($hBrush, $iARGB = 0xFF000000)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetSolidFillColor", "handle", $hBrush, "dword", $iARGB)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_BrushSetSolidColor

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_CustomLineCapCreate($hPathFill, $hPathStroke, $iLineCap = 0, $inBaseInset = 0)
	Local $aResult = DllCall($ghGDIPDll, "uint", "GdipCreateCustomLineCap", "handle", $hPathFill, "handle", $hPathStroke, "int", $iLineCap, "float", $inBaseInset, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[5]
EndFunc   ;==>_GDIPlus_CustomLineCapCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_CustomLineCapDispose($hCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteCustomLineCap", "handle", $hCap)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_CustomLineCapDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_Decoders()
	Local $iCount = _GDIPlus_DecodersGetCount()
	Local $iSize = _GDIPlus_DecodersGetSize()
	Local $tBuffer = DllStructCreate("byte[" & $iSize & "]")
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageDecoders", "uint", $iCount, "uint", $iSize, "struct*", $tBuffer)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] <> 0 Then Return SetError($aResult[0], 0, 0)

	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tCodec, $aInfo[$iCount + 1][14]
	$aInfo[0][0] = $iCount
	For $iI = 1 To $iCount
		$tCodec = DllStructCreate($tagGDIPIMAGECODECINFO, $pBuffer)
		$aInfo[$iI][1] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "CLSID"))
		$aInfo[$iI][2] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "FormatID"))
		$aInfo[$iI][3] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "CodecName"))
		$aInfo[$iI][4] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "DllName"))
		$aInfo[$iI][5] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FormatDesc"))
		$aInfo[$iI][6] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FileExt"))
		$aInfo[$iI][7] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "MimeType"))
		$aInfo[$iI][8] = DllStructGetData($tCodec, "Flags")
		$aInfo[$iI][9] = DllStructGetData($tCodec, "Version")
		$aInfo[$iI][10] = DllStructGetData($tCodec, "SigCount")
		$aInfo[$iI][11] = DllStructGetData($tCodec, "SigSize")
		$aInfo[$iI][12] = DllStructGetData($tCodec, "SigPattern")
		$aInfo[$iI][13] = DllStructGetData($tCodec, "SigMask")
		$pBuffer += DllStructGetSize($tCodec)
	Next
	Return $aInfo
EndFunc   ;==>_GDIPlus_Decoders

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_DecodersGetCount()
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageDecodersSize", "uint*", 0, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[1])
EndFunc   ;==>_GDIPlus_DecodersGetCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_DecodersGetSize()
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageDecodersSize", "uint*", 0, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_DecodersGetSize

; #FUNCTION# ====================================================================================================================
; Author ........: Malkey
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_DrawImagePoints($hGraphic, $hImage, $nULX, $nULY, $nURX, $nURY, $nLLX, $nLLY, $count = 3)
	Local $tPoint = DllStructCreate("float X;float Y;float X2;float Y2;float X3;float Y3")
	DllStructSetData($tPoint, "X", $nULX)
	DllStructSetData($tPoint, "Y", $nULY)
	DllStructSetData($tPoint, "X2", $nURX)
	DllStructSetData($tPoint, "Y2", $nURY)
	DllStructSetData($tPoint, "X3", $nLLX)
	DllStructSetData($tPoint, "Y3", $nLLY)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawImagePoints", "handle", $hGraphic, "handle", $hImage, "struct*", $tPoint, "int", $count)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_DrawImagePoints

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_Encoders()
	Local $iCount = _GDIPlus_EncodersGetCount()
	Local $iSize = _GDIPlus_EncodersGetSize()
	Local $tBuffer = DllStructCreate("byte[" & $iSize & "]")
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageEncoders", "uint", $iCount, "uint", $iSize, "struct*", $tBuffer)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] <> 0 Then Return SetError($aResult[0], 0, 0)

	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tCodec, $aInfo[$iCount + 1][14]
	$aInfo[0][0] = $iCount
	For $iI = 1 To $iCount
		$tCodec = DllStructCreate($tagGDIPIMAGECODECINFO, $pBuffer)
		$aInfo[$iI][1] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "CLSID"))
		$aInfo[$iI][2] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "FormatID"))
		$aInfo[$iI][3] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "CodecName"))
		$aInfo[$iI][4] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "DllName"))
		$aInfo[$iI][5] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FormatDesc"))
		$aInfo[$iI][6] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FileExt"))
		$aInfo[$iI][7] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "MimeType"))
		$aInfo[$iI][8] = DllStructGetData($tCodec, "Flags")
		$aInfo[$iI][9] = DllStructGetData($tCodec, "Version")
		$aInfo[$iI][10] = DllStructGetData($tCodec, "SigCount")
		$aInfo[$iI][11] = DllStructGetData($tCodec, "SigSize")
		$aInfo[$iI][12] = DllStructGetData($tCodec, "SigPattern")
		$aInfo[$iI][13] = DllStructGetData($tCodec, "SigMask")
		$pBuffer += DllStructGetSize($tCodec)
	Next
	Return $aInfo
EndFunc   ;==>_GDIPlus_Encoders

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_EncodersGetCLSID($sFileExt)
	Local $aEncoders = _GDIPlus_Encoders()
	For $iI = 1 To $aEncoders[0][0]
		If StringInStr($aEncoders[$iI][6], "*." & $sFileExt) > 0 Then Return $aEncoders[$iI][1]
	Next
	Return SetError(-1, -1, "")
EndFunc   ;==>_GDIPlus_EncodersGetCLSID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_EncodersGetCount()
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageEncodersSize", "uint*", 0, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[1])
EndFunc   ;==>_GDIPlus_EncodersGetCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_EncodersGetParamList($hImage, $sEncoder)
	Local $iSize = _GDIPlus_EncodersGetParamListSize($hImage, $sEncoder)
	If @error Then Return SetError(@error, -1, 0)
	Local $tGUID = _WinAPI_GUIDFromString($sEncoder)
	Local $tBuffer = DllStructCreate("dword Count;byte Params[" & $iSize - 4 & "]")
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetEncoderParameterList", "handle", $hImage, "struct*", $tGUID, "uint", $iSize, "struct*", $tBuffer)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tBuffer)
EndFunc   ;==>_GDIPlus_EncodersGetParamList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_EncodersGetParamListSize($hImage, $sEncoder)
	Local $tGUID = _WinAPI_GUIDFromString($sEncoder)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetEncoderParameterListSize", "handle", $hImage, "struct*", $tGUID, "uint*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[3])
EndFunc   ;==>_GDIPlus_EncodersGetParamListSize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_EncodersGetSize()
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageEncodersSize", "uint*", 0, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_EncodersGetSize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_FontCreate($hFamily, $fSize, $iStyle = 0, $iUnit = 3)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateFont", "handle", $hFamily, "float", $fSize, "int", $iStyle, "int", $iUnit, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[5])
EndFunc   ;==>_GDIPlus_FontCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_FontDispose($hFont)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteFont", "handle", $hFont)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_FontDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_FontFamilyCreate($sFamily)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateFontFamilyFromName", "wstr", $sFamily, "ptr", 0, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[3])
EndFunc   ;==>_GDIPlus_FontFamilyCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_FontFamilyDispose($hFamily)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteFontFamily", "handle", $hFamily)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_FontFamilyDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsClear($hGraphics, $iARGB = 0xFF000000)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGraphicsClear", "handle", $hGraphics, "dword", $iARGB)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsClear

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsCreateFromHDC($hDC)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateFromHDC", "handle", $hDC, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_GraphicsCreateFromHDC

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsCreateFromHWND($hWnd)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateFromHWND", "hwnd", $hWnd, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_GraphicsCreateFromHWND

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsDispose($hGraphics)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteGraphics", "handle", $hGraphics)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawArc($hGraphics, $iX, $iY, $iWidth, $iHeight, $fStartAngle, $fSweepAngle, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawArcI", "handle", $hGraphics, "handle", $hPen, "int", $iX, "int", $iY, _
			"int", $iWidth, "int", $iHeight, "float", $fStartAngle, "float", $fSweepAngle)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawArc

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawBezier($hGraphics, $iX1, $iY1, $iX2, $iY2, $iX3, $iY3, $iX4, $iY4, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawBezierI", "handle", $hGraphics, "handle", $hPen, "int", $iX1, "int", $iY1, _
			"int", $iX2, "int", $iY2, "int", $iX3, "int", $iY3, "int", $iX4, "int", $iY4)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawBezier

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawClosedCurve($hGraphics, $aPoints, $hPen = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("long[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next

	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawClosedCurveI", "handle", $hGraphics, "handle", $hPen, "struct*", $tPoints, "int", $iCount)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawClosedCurve

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawCurve($hGraphics, $aPoints, $hPen = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("long[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next

	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawCurveI", "handle", $hGraphics, "handle", $hPen, "struct*", $tPoints, "int", $iCount)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawCurve

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawEllipse($hGraphics, $iX, $iY, $iWidth, $iHeight, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawEllipseI", "handle", $hGraphics, "handle", $hPen, "int", $iX, "int", $iY, _
			"int", $iWidth, "int", $iHeight)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawEllipse

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawImage($hGraphics, $hImage, $iX, $iY)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawImageI", "handle", $hGraphics, "handle", $hImage, "int", $iX, "int", $iY)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawImage

; #FUNCTION# ====================================================================================================================
; Author ........: smashly
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawImageRect($hGraphics, $hImage, $iX, $iY, $iW, $iH)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawImageRectI", "handle", $hGraphics, "handle", $hImage, "int", $iX, "int", $iY, _
			"int", $iW, "int", $iH)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawImageRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawImageRectRect($hGraphics, $hImage, $iSrcX, $iSrcY, $iSrcWidth, $iSrcHeight, $iDstX, $iDstY, $iDstWidth, $iDstHeight, $iUnit = 2)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawImageRectRectI", "handle", $hGraphics, "handle", $hImage, "int", $iDstX, _
			"int", $iDstY, "int", $iDstWidth, "int", $iDstHeight, "int", $iSrcX, "int", $iSrcY, "int", $iSrcWidth, _
			"int", $iSrcHeight, "int", $iUnit, "int", 0, "int", 0, "int", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawImageRectRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawLine($hGraphics, $iX1, $iY1, $iX2, $iY2, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawLineI", "handle", $hGraphics, "handle", $hPen, "int", $iX1, "int", $iY1, _
			"int", $iX2, "int", $iY2)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawLine

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawPie($hGraphics, $iX, $iY, $iWidth, $iHeight, $fStartAngle, $fSweepAngle, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawPieI", "handle", $hGraphics, "handle", $hPen, "int", $iX, "int", $iY, _
			"int", $iWidth, "int", $iHeight, "float", $fStartAngle, "float", $fSweepAngle)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawPie

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawPolygon($hGraphics, $aPoints, $hPen = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("long[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next

	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawPolygonI", "handle", $hGraphics, "handle", $hPen, "struct*", $tPoints, "int", $iCount)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawPolygon

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawRect($hGraphics, $iX, $iY, $iWidth, $iHeight, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawRectangleI", "handle", $hGraphics, "handle", $hPen, "int", $iX, "int", $iY, _
			"int", $iWidth, "int", $iHeight)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawString($hGraphics, $sString, $nX, $nY, $sFont = "Arial", $nSize = 10, $iFormat = 0)
	Local $hBrush = _GDIPlus_BrushCreateSolid()
	Local $hFormat = _GDIPlus_StringFormatCreate($iFormat)
	Local $hFamily = _GDIPlus_FontFamilyCreate($sFont)
	Local $hFont = _GDIPlus_FontCreate($hFamily, $nSize)
	Local $tLayout = _GDIPlus_RectFCreate($nX, $nY, 0, 0)
	Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphics, $sString, $hFont, $tLayout, $hFormat)
	Local $aResult = _GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $aInfo[0], $hFormat, $hBrush)
	Local $iError = @error
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrush)
	Return SetError($iError, 0, $aResult)
EndFunc   ;==>_GDIPlus_GraphicsDrawString

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $tLayout, $hFormat, $hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawString", "handle", $hGraphics, "wstr", $sString, "int", -1, "handle", $hFont, _
			"struct*", $tLayout, "handle", $hFormat, "handle", $hBrush)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawStringEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillClosedCurve($hGraphics, $aPoints, $hBrush = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("long[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next

	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipFillClosedCurveI", "handle", $hGraphics, "handle", $hBrush, "struct*", $tPoints, "int", $iCount)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_BrushDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsFillClosedCurve

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillEllipse($hGraphics, $iX, $iY, $iWidth, $iHeight, $hBrush = 0)
	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipFillEllipseI", "handle", $hGraphics, "handle", $hBrush, "int", $iX, "int", $iY, _
			"int", $iWidth, "int", $iHeight)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_BrushDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsFillEllipse

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillPie($hGraphics, $iX, $iY, $iWidth, $iHeight, $fStartAngle, $fSweepAngle, $hBrush = 0)
	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipFillPieI", "handle", $hGraphics, "handle", $hBrush, "int", $iX, "int", $iY, _
			"int", $iWidth, "int", $iHeight, "float", $fStartAngle, "float", $fSweepAngle)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_BrushDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsFillPie

; #FUNCTION# ====================================================================================================================
; Author ........:
; Modified.......: smashly
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillPolygon($hGraphics, $aPoints, $hBrush = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("long[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next

	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipFillPolygonI", "handle", $hGraphics, "handle", $hBrush, _
			"struct*", $tPoints, "int", $iCount, "int", "FillModeAlternate")
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_BrushDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsFillPolygon

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillRect($hGraphics, $iX, $iY, $iWidth, $iHeight, $hBrush = 0)
	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipFillRectangleI", "handle", $hGraphics, "handle", $hBrush, "int", $iX, "int", $iY, _
			"int", $iWidth, "int", $iHeight)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_BrushDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsFillRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsGetDC($hGraphics)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetDC", "handle", $hGraphics, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_GraphicsGetDC

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ
; ===============================================================================================================================
Func _GDIPlus_GraphicsGetSmoothingMode($hGraphics)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetSmoothingMode", "handle", $hGraphics, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Switch $aResult[2]
		Case $GDIP_SMOOTHINGMODE_NONE
			Return SetExtended($aResult[0], 0)
		Case $GDIP_SMOOTHINGMODE_HIGHQUALITY, $GDIP_SMOOTHINGMODE_ANTIALIAS8X4
			Return SetExtended($aResult[0], 1)
		Case $GDIP_SMOOTHINGMODE_ANTIALIAS8X8
			Return SetExtended($aResult[0], 2)
		Case Else
			Return SetExtended($aResult[0], 0)
	EndSwitch
EndFunc   ;==>_GDIPlus_GraphicsGetSmoothingMode

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsMeasureString($hGraphics, $sString, $hFont, $tLayout, $hFormat)
	Local $tRectF = DllStructCreate($tagGDIPRECTF)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipMeasureString", "handle", $hGraphics, "wstr", $sString, "int", -1, "handle", $hFont, _
			"struct*", $tLayout, "handle", $hFormat, "struct*", $tRectF, "int*", 0, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aInfo[3]
	$aInfo[0] = $tRectF
	$aInfo[1] = $aResult[8]
	$aInfo[2] = $aResult[9]
	Return SetExtended($aResult[0], $aInfo)
EndFunc   ;==>_GDIPlus_GraphicsMeasureString

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsReleaseDC($hGraphics, $hDC)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipReleaseDC", "handle", $hGraphics, "handle", $hDC)
	If @error Then Return SetError(@error, @extended, False)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_GraphicsReleaseDC

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetTransform($hGraphics, $hMatrix)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetWorldTransform", "handle", $hGraphics, "handle", $hMatrix)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsSetTransform

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetSmoothingMode($hGraphics, $iSmooth)
	If $iSmooth < $GDIP_SMOOTHINGMODE_DEFAULT Or $iSmooth > $GDIP_SMOOTHINGMODE_ANTIALIAS8X8 Then $iSmooth = $GDIP_SMOOTHINGMODE_DEFAULT
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetSmoothingMode", "handle", $hGraphics, "int", $iSmooth)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsSetSmoothingMode

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ImageDispose($hImage)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDisposeImage", "handle", $hImage)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ImageDispose

; #FUNCTION# ====================================================================================================================
; Author ........: rover
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_ImageGetFlags($hImage)
	Local $aFlag[2] = [0, ""]
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(10, 1, $aFlag)
	Local $aImageFlags[13][2] = _
			[["Pixel data Cacheable", $GDIP_IMAGEFLAGS_CACHING], _
			["Pixel data read-only", $GDIP_IMAGEFLAGS_READONLY], _
			["Pixel size in image", $GDIP_IMAGEFLAGS_HASREALPIXELSIZE], _
			["DPI info in image", $GDIP_IMAGEFLAGS_HASREALDPI], _
			["YCCK color space", $GDIP_IMAGEFLAGS_COLORSPACE_YCCK], _
			["YCBCR color space", $GDIP_IMAGEFLAGS_COLORSPACE_YCBCR], _
			["Grayscale image", $GDIP_IMAGEFLAGS_COLORSPACE_GRAY], _
			["CMYK color space", $GDIP_IMAGEFLAGS_COLORSPACE_CMYK], _
			["RGB color space", $GDIP_IMAGEFLAGS_COLORSPACE_RGB], _
			["Partially scalable", $GDIP_IMAGEFLAGS_PARTIALLYSCALABLE], _
			["Alpha values other than 0 (transparent) and 255 (opaque)", $GDIP_IMAGEFLAGS_HASTRANSLUCENT], _
			["Alpha values", $GDIP_IMAGEFLAGS_HASALPHA], _
			["Scalable", $GDIP_IMAGEFLAGS_SCALABLE]]
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageFlags", "handle", $hImage, "long*", 0)
	If @error Then Return SetError(@error, 2, $aFlag)
	If $aResult[2] = $GDIP_IMAGEFLAGS_NONE Then
		$aFlag[1] = "No pixel data"
		Return SetError($aResult[0], 3, $aFlag)
	EndIf
	$aFlag[0] = $aResult[2]
	For $i = 0 To 12
		If BitAND($aResult[2], $aImageFlags[$i][1]) = $aImageFlags[$i][1] Then
			If StringLen($aFlag[1]) Then $aFlag[1] &= "|"
			$aResult[2] -= $aImageFlags[$i][1]
			$aFlag[1] &= $aImageFlags[$i][0]
		EndIf
	Next
	Return SetExtended($aResult[0], $aFlag)
EndFunc   ;==>_GDIPlus_ImageGetFlags

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ImageGetGraphicsContext($hImage)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageGraphicsContext", "handle", $hImage, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ImageGetGraphicsContext

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ImageGetHeight($hImage)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageHeight", "handle", $hImage, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ImageGetHeight

; #FUNCTION# ====================================================================================================================
; Author ........: rover
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_ImageGetHorizontalResolution($hImage)
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(10, 1, 0)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageHorizontalResolution", "handle", $hImage, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], Round($aResult[2]))
EndFunc   ;==>_GDIPlus_ImageGetHorizontalResolution

; #FUNCTION# ====================================================================================================================
; Author ........: rover
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_ImageGetPixelFormat($hImage)
	Local $aFormat[2] = [0, ""]
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(10, 1, $aFormat)
	Local $aPixelFormat[14][2] = _
			[["1 Bpp Indexed", $GDIP_PXF01INDEXED], _
			["4 Bpp Indexed", $GDIP_PXF04INDEXED], _
			["8 Bpp Indexed", $GDIP_PXF08INDEXED], _
			["16 Bpp Grayscale", $GDIP_PXF16GRAYSCALE], _
			["16 Bpp RGB 555", $GDIP_PXF16RGB555], _
			["16 Bpp RGB 565", $GDIP_PXF16RGB565], _
			["16 Bpp ARGB 1555", $GDIP_PXF16ARGB1555], _
			["24 Bpp RGB", $GDIP_PXF24RGB], _
			["32 Bpp RGB", $GDIP_PXF32RGB], _
			["32 Bpp ARGB", $GDIP_PXF32ARGB], _
			["32 Bpp PARGB", $GDIP_PXF32PARGB], _
			["48 Bpp RGB", $GDIP_PXF48RGB], _
			["64 Bpp ARGB", $GDIP_PXF64ARGB], _
			["64 Bpp PARGB", $GDIP_PXF64PARGB]]
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImagePixelFormat", "handle", $hImage, "int*", 0)
	If @error Then Return SetError(@error, @extended, $aFormat)
	For $i = 0 To 13
		If $aPixelFormat[$i][1] = $aResult[2] Then
			$aFormat[0] = $aPixelFormat[$i][1]
			$aFormat[1] = $aPixelFormat[$i][0]
			Return SetExtended($aResult[0], $aFormat)
		EndIf
	Next
	Return SetExtended($aResult[0], $aFormat)
EndFunc   ;==>_GDIPlus_ImageGetPixelFormat

; #FUNCTION# ====================================================================================================================
; Author ........: rover
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_ImageGetRawFormat($hImage)
	Local $aGuid[2]
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(10, 1, $aGuid)
	Local $aImageType[11][2] = _
			[["UNDEFINED", $GDIP_IMAGEFORMAT_UNDEFINED], _
			["MEMORYBMP", $GDIP_IMAGEFORMAT_MEMORYBMP], _
			["BMP", $GDIP_IMAGEFORMAT_BMP], _
			["EMF", $GDIP_IMAGEFORMAT_EMF], _
			["WMF", $GDIP_IMAGEFORMAT_WMF], _
			["JPEG", $GDIP_IMAGEFORMAT_JPEG], _
			["PNG", $GDIP_IMAGEFORMAT_PNG], _
			["GIF", $GDIP_IMAGEFORMAT_GIF], _
			["TIFF", $GDIP_IMAGEFORMAT_TIFF], _
			["EXIF", $GDIP_IMAGEFORMAT_EXIF], _
			["ICON", $GDIP_IMAGEFORMAT_ICON]]
	Local $tStruct = DllStructCreate("byte[16]")
	Local $aResult1 = DllCall($ghGDIPDll, "int", "GdipGetImageRawFormat", "handle", $hImage, "struct*", $tStruct)
	If @error Then Return SetError(@error, @extended, $aGuid)
	If (Not IsArray($aResult1)) Then Return SetError(1, 3, $aGuid)
	Local $sResult2 = _WinAPI_StringFromGUID($aResult1[2])
	If @error Then Return SetError(@error, 4, $aGuid)
	For $i = 0 To 10
		If $aImageType[$i][1] == $sResult2 Then
			$aGuid[0] = $aImageType[$i][1]
			$aGuid[1] = $aImageType[$i][0]
			Return SetExtended($aResult1[0], $aGuid)
		EndIf
	Next
	Return SetError(-1, 5, $aGuid)
EndFunc   ;==>_GDIPlus_ImageGetRawFormat

; #FUNCTION# ====================================================================================================================
; Author ........: rover
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_ImageGetType($hImage)
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(10, 0, -1)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageType", "handle", $hImage, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ImageGetType

; #FUNCTION# ====================================================================================================================
; Author ........: rover
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_ImageGetVerticalResolution($hImage)
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(10, 0, 0)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageVerticalResolution", "handle", $hImage, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], Round($aResult[2]))
EndFunc   ;==>_GDIPlus_ImageGetVerticalResolution

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ImageGetWidth($hImage)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageWidth", "handle", $hImage, "uint*", -1)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ImageGetWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost/martin
; ===============================================================================================================================
Func _GDIPlus_ImageLoadFromFile($sFileName)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipLoadImageFromFile", "wstr", $sFileName, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ImageLoadFromFile

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ImageSaveToFile($hImage, $sFileName)
	Local $sExt = __GDIPlus_ExtractFileExt($sFileName)
	Local $sCLSID = _GDIPlus_EncodersGetCLSID($sExt)
	If $sCLSID = "" Then Return SetError(-1, 0, False)
	Return _GDIPlus_ImageSaveToFileEx($hImage, $sFileName, $sCLSID, 0)
EndFunc   ;==>_GDIPlus_ImageSaveToFile

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ImageSaveToFileEx($hImage, $sFileName, $sEncoder, $pParams = 0)
	Local $tGUID = _WinAPI_GUIDFromString($sEncoder)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSaveImageToFile", "handle", $hImage, "wstr", $sFileName, "struct*", $tGUID, "struct*", $pParams)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ImageSaveToFileEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_MatrixCreate()
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateMatrix", "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[1])
EndFunc   ;==>_GDIPlus_MatrixCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_MatrixDispose($hMatrix)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteMatrix", "handle", $hMatrix)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_MatrixDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_MatrixRotate($hMatrix, $fAngle, $bAppend = False)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipRotateMatrix", "handle", $hMatrix, "float", $fAngle, "int", $bAppend)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_MatrixRotate

; #FUNCTION# ====================================================================================================================
; Author ........: monoceres
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_MatrixScale($hMatrix, $fScaleX, $fScaleY, $bOrder = False)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipScaleMatrix", "handle", $hMatrix, "float", $fScaleX, "float", $fScaleY, "int", $bOrder)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_MatrixScale

; #FUNCTION# ====================================================================================================================
; Author ........: monoceres
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_MatrixTranslate($hMatrix, $fOffsetX, $fOffsetY, $bAppend = False)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipTranslateMatrix", "handle", $hMatrix, "float", $fOffsetX, "float", $fOffsetY, "int", $bAppend)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_MatrixTranslate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_ParamAdd(ByRef $tParams, $sGUID, $iCount, $iType, $pValues)
	Local $tParam = DllStructCreate($tagGDIPENCODERPARAM, DllStructGetPtr($tParams, "Params") + (DllStructGetData($tParams, "Count") * 28))
	_WinAPI_GUIDFromStringEx($sGUID, DllStructGetPtr($tParam, "GUID"))
	DllStructSetData($tParam, "Type", $iType)
	DllStructSetData($tParam, "Count", $iCount)
	DllStructSetData($tParam, "Values", $pValues)
	DllStructSetData($tParams, "Count", DllStructGetData($tParams, "Count") + 1)
EndFunc   ;==>_GDIPlus_ParamAdd

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_ParamInit($iCount)
	If $iCount <= 0 Then Return SetError(-1, -1, 0)
	Return DllStructCreate("dword Count;byte Params[" & $iCount * 28 & "]")
EndFunc   ;==>_GDIPlus_ParamInit

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenCreate($iARGB = 0xFF000000, $fWidth = 1, $iUnit = 2)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreatePen1", "dword", $iARGB, "float", $fWidth, "int", $iUnit, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[4])
EndFunc   ;==>_GDIPlus_PenCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenDispose($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeletePen", "handle", $hPen)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenGetAlignment($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetPenMode", "handle", $hPen, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_PenGetAlignment

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenGetColor($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetPenColor", "handle", $hPen, "dword*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_PenGetColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenGetCustomEndCap($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetPenCustomEndCap", "handle", $hPen, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_PenGetCustomEndCap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenGetDashCap($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetPenDashCap197819", "handle", $hPen, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_PenGetDashCap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenGetDashStyle($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetPenDashStyle", "handle", $hPen, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_PenGetDashStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenGetEndCap($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetPenEndCap", "handle", $hPen, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_PenGetEndCap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenGetWidth($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetPenWidth", "handle", $hPen, "float*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_PenGetWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenSetAlignment($hPen, $iAlignment = 0)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetPenMode", "handle", $hPen, "int", $iAlignment)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenSetAlignment

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenSetColor($hPen, $iARGB)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetPenColor", "handle", $hPen, "dword", $iARGB)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenSetColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenSetDashCap($hPen, $iDash = 0)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetPenDashCap197819", "handle", $hPen, "int", $iDash)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenSetDashCap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenSetCustomEndCap($hPen, $hEndCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetPenCustomEndCap", "handle", $hPen, "handle", $hEndCap)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenSetCustomEndCap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenSetDashStyle($hPen, $iStyle = 0)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetPenDashStyle", "handle", $hPen, "int", $iStyle)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenSetDashStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenSetEndCap($hPen, $iEndCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetPenEndCap", "handle", $hPen, "int", $iEndCap)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenSetEndCap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenSetWidth($hPen, $fWidth)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetPenWidth", "handle", $hPen, "float", $fWidth)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenSetWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_RectFCreate($nX = 0, $nY = 0, $nWidth = 0, $nHeight = 0)
	Local $tRectF = DllStructCreate($tagGDIPRECTF)
	DllStructSetData($tRectF, "X", $nX)
	DllStructSetData($tRectF, "Y", $nY)
	DllStructSetData($tRectF, "Width", $nWidth)
	DllStructSetData($tRectF, "Height", $nHeight)
	Return $tRectF
EndFunc   ;==>_GDIPlus_RectFCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_Shutdown()
	If $ghGDIPDll = 0 Then Return SetError(-1, -1, False)

	$giGDIPRef -= 1
	If $giGDIPRef = 0 Then
		DllCall($ghGDIPDll, "none", "GdiplusShutdown", "ulong_ptr", $giGDIPToken)
		DllClose($ghGDIPDll)
		$ghGDIPDll = 0
	EndIf
	Return True
EndFunc   ;==>_GDIPlus_Shutdown

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_Startup()
	$giGDIPRef += 1
	If $giGDIPRef > 1 Then Return True

	$ghGDIPDll = DllOpen("GDIPlus.dll")
	If $ghGDIPDll = -1 Then
		$giGDIPRef = 0
		Return SetError(1, 2, False)
	EndIf
	Local $tInput = DllStructCreate($tagGDIPSTARTUPINPUT)
	Local $tToken = DllStructCreate("ulong_ptr Data")
	DllStructSetData($tInput, "Version", 1)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdiplusStartup", "struct*", $tToken, "struct*", $tInput, "ptr", 0)
	If @error Then Return SetError(@error, @extended, False)
	$giGDIPToken = DllStructGetData($tToken, "Data")
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_Startup

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_StringFormatCreate($iFormat = 0, $iLangID = 0)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateStringFormat", "int", $iFormat, "word", $iLangID, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[3])
EndFunc   ;==>_GDIPlus_StringFormatCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_StringFormatDispose($hFormat)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteStringFormat", "handle", $hFormat)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_StringFormatDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_StringFormatSetAlign($hStringFormat, $iFlag)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetStringFormatAlign", "handle", $hStringFormat, "int", $iFlag)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_StringFormatSetAlign

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_BrushDefCreate
; Description ...: Create a default Brush object if needed
; Syntax.........: __GDIPlus_BrushDefCreate ( ByRef $hBrush )
; Parameters ....: $hBrush      - Handle to a Brush object
; Return values .: Success      - $hBrush or a default Brush object
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_BrushDefCreate(ByRef $hBrush)
	If $hBrush = 0 Then
		$ghGDIPBrush = _GDIPlus_BrushCreateSolid()
		$hBrush = $ghGDIPBrush
	EndIf
EndFunc   ;==>__GDIPlus_BrushDefCreate

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_BrushDefDispose
; Description ...: Free default Brush object
; Syntax.........: __GDIPlus_BrushDefDispose ( )
; Parameters ....:
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_BrushDefDispose()
	If $ghGDIPBrush <> 0 Then
		_GDIPlus_BrushDispose($ghGDIPBrush)
		$ghGDIPBrush = 0
	EndIf
EndFunc   ;==>__GDIPlus_BrushDefDispose

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_ExtractFileExt
; Description ...: Extracts the extension part of the given filename
; Syntax.........: __GDIPlus_ExtractFileExt ( $sFileName [, $fNoDot = True] )
; Parameters ....: $sFileName   - Filename
;                  $fNoDot      - Determines whether the filename/extension separator is returned
;                  |True  - The separator is returned with the extension
;                  |False - The separator is not returned with the extension
; Return values .: Success      - Extension part
;                  Failure      - Empty string
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_ExtractFileExt($sFileName, $fNoDot = True)
	Local $iIndex = __GDIPlus_LastDelimiter(".\:", $sFileName)
	If ($iIndex > 0) And (StringMid($sFileName, $iIndex, 1) = '.') Then
		If $fNoDot Then
			Return StringMid($sFileName, $iIndex + 1)
		Else
			Return StringMid($sFileName, $iIndex)
		EndIf
	Else
		Return ""
	EndIf
EndFunc   ;==>__GDIPlus_ExtractFileExt

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_LastDelimiter
; Description ...: Returns the index of the right most whole character that matches any character in a delimiter string
; Syntax.........: __GDIPlus_LastDelimiter ( $sDelimiters, $sString )
; Parameters ....: $sDelimiters - Delimiters
;                  $String      - String to be searched
; Return values .: Success      - Right most whole character that matches one of the delimiters
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_LastDelimiter($sDelimiters, $sString)
	Local $sDelimiter, $iN

	For $iI = 1 To StringLen($sDelimiters)
		$sDelimiter = StringMid($sDelimiters, $iI, 1)
		$iN = StringInStr($sString, $sDelimiter, 0, -1)
		If $iN > 0 Then Return $iN
	Next
EndFunc   ;==>__GDIPlus_LastDelimiter

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_PenDefCreate
; Description ...: Create a default Pen object if needed
; Syntax.........: __GDIPlus_PenDefCreate ( ByRef $hPen )
; Parameters ....: $hPen        - Handle to a pen object
; Return values .: Success      - $hPen or a default pen object
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_PenDefCreate(ByRef $hPen)
	If $hPen = 0 Then
		$ghGDIPPen = _GDIPlus_PenCreate()
		$hPen = $ghGDIPPen
	EndIf
EndFunc   ;==>__GDIPlus_PenDefCreate

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_PenDefDispose
; Description ...: Free default Pen object
; Syntax.........: __GDIPlus_PenDefDispose ( )
; Parameters ....:
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_PenDefDispose()
	If $ghGDIPPen <> 0 Then
		_GDIPlus_PenDispose($ghGDIPPen)
		$ghGDIPPen = 0
	EndIf
EndFunc   ;==>__GDIPlus_PenDefDispose
