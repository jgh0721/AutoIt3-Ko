#include-once

#include "FileConstants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Crypt
; AutoIt Version : 3.3.7.20++
; Language ......: English
; Description ...: Functions for encrypting and hashing data.
; Author(s) .....: Andreas Karlsson (monoceres)
; Dll(s) ........: Advapi32.dll
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _Crypt_Startup
; _Crypt_Shutdown
; _Crypt_DeriveKey
; _Crypt_DestroyKey
; _Crypt_EncryptData
; _Crypt_DecryptData
; _Crypt_HashData
; _Crypt_HashFile
; _Crypt_EncryptFile
; _Crypt_DecryptFile
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __Crypt_RefCount
; __Crypt_RefCountInc
; __Crypt_RefCountDec
; __Crypt_DllHandle
; __Crypt_DllHandleSet
; __Crypt_Context
; __Crypt_ContextSet
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $PROV_RSA_FULL = 0x1
Global Const $PROV_RSA_AES = 24
Global Const $CRYPT_VERIFYCONTEXT = 0xF0000000
Global Const $HP_HASHSIZE = 0x0004
Global Const $HP_HASHVAL = 0x0002
Global Const $CRYPT_EXPORTABLE = 0x00000001
Global Const $CRYPT_USERDATA = 1

Global Const $CALG_MD2 = 0x00008001
Global Const $CALG_MD4 = 0x00008002
Global Const $CALG_MD5 = 0x00008003
Global Const $CALG_SHA1 = 0x00008004
Global Const $CALG_3DES = 0x00006603
Global Const $CALG_AES_128 = 0x0000660e
Global Const $CALG_AES_192 = 0x0000660f
Global Const $CALG_AES_256 = 0x00006610
Global Const $CALG_DES = 0x00006601
Global Const $CALG_RC2 = 0x00006602
Global Const $CALG_RC4 = 0x00006801
Global Const $CALG_USERKEY = 0

; #VARIABLES# ===================================================================================================================
Global $__g_aCryptInternalData[3]

; #FUNCTION# ====================================================================================================================
; Author ........: Andreas Karlsson (monoceres)
; Modified ......:
; ===============================================================================================================================
Func _Crypt_Startup()
	If __Crypt_RefCount() = 0 Then
		Local $hAdvapi32 = DllOpen("Advapi32.dll")
		If @error Then Return SetError(1, 0, False)
		__Crypt_DllHandleSet($hAdvapi32)
		Local $aRet
		Local $iProviderID = $PROV_RSA_AES
		$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptAcquireContext", "handle*", 0, "ptr", 0, "ptr", 0, "dword", $iProviderID, "dword", $CRYPT_VERIFYCONTEXT)
		If @error Or Not $aRet[0] Then
			DllClose(__Crypt_DllHandle())
			Return SetError(2, 0, False)
		Else
			__Crypt_ContextSet($aRet[1])
			; Fall through to success.
		EndIf
	EndIf
	__Crypt_RefCountInc()
	Return True
EndFunc   ;==>_Crypt_Startup

; #FUNCTION# ====================================================================================================================
; Author ........: Andreas Karlsson (monoceres)
; Modified ......:
; ===============================================================================================================================
Func _Crypt_Shutdown()
	__Crypt_RefCountDec()
	If __Crypt_RefCount() = 0 Then
		DllCall(__Crypt_DllHandle(), "bool", "CryptReleaseContext", "handle", __Crypt_Context(), "dword", 0)
		DllClose(__Crypt_DllHandle())
	EndIf
EndFunc   ;==>_Crypt_Shutdown

; #FUNCTION# ====================================================================================================================
; Author ........: Andreas Karlsson (monoceres)
; Modified ......:
; ===============================================================================================================================
Func _Crypt_DeriveKey($vPassword, $iALG_ID, $iHash_ALG_ID = $CALG_MD5)
	Local $aRet
	Local $hCryptHash
	Local $hBuff
	Local $iError
	Local $vReturn

	_Crypt_Startup()
	Do
		; Create Hash object
		$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptCreateHash", "handle", __Crypt_Context(), "uint", $iHash_ALG_ID, "ptr", 0, "dword", 0, "handle*", 0)
		If @error Or Not $aRet[0] Then
			$iError = 1
			$vReturn = -1
			ExitLoop
		EndIf

		$hCryptHash = $aRet[5]
		$hBuff = DllStructCreate("byte[" & BinaryLen($vPassword) & "]")
		DllStructSetData($hBuff, 1, $vPassword)
		$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptHashData", "handle", $hCryptHash, "struct*", $hBuff, "dword", DllStructGetSize($hBuff), "dword", $CRYPT_USERDATA)
		If @error Or Not $aRet[0] Then
			$iError = 2
			$vReturn = -1
			ExitLoop
		EndIf

		; Create key
		$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptDeriveKey", "handle", __Crypt_Context(), "uint", $iALG_ID, "handle", $hCryptHash, "dword", $CRYPT_EXPORTABLE, "handle*", 0)
		If @error Or Not $aRet[0] Then
			$iError = 3
			$vReturn = -1
			ExitLoop
		EndIf
		$iError = 0
		$vReturn = $aRet[5]
	Until True
	If $hCryptHash <> 0 Then DllCall(__Crypt_DllHandle(), "bool", "CryptDestroyHash", "handle", $hCryptHash)

	Return SetError($iError, 0, $vReturn)
EndFunc   ;==>_Crypt_DeriveKey

; #FUNCTION# ====================================================================================================================
; Author ........: Andreas Karlsson (monoceres)
; Modified ......:
; ===============================================================================================================================
Func _Crypt_DestroyKey($hCryptKey)
	;_Crypt_Startup()
	Local $aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptDestroyKey", "handle", $hCryptKey)
	Local $nError = @error
	_Crypt_Shutdown()
	If $nError Or Not $aRet[0] Then
		Return SetError(1, 0, False)
	Else
		Return SetError(0, 0, True)
	EndIf
EndFunc   ;==>_Crypt_DestroyKey

; #FUNCTION# ====================================================================================================================
; Author ........: Andreas Karlsson (monoceres)
; Modified ......:
; ===============================================================================================================================
Func _Crypt_EncryptData($vData, $vCryptKey, $iALG_ID, $fFinal = True)
	Local $hBuff
	Local $iError
	Local $vReturn
	Local $ReqBuffSize
	Local $aRet
	_Crypt_Startup()

	Do
		If $iALG_ID <> $CALG_USERKEY Then
			$vCryptKey = _Crypt_DeriveKey($vCryptKey, $iALG_ID)
			If @error Then
				$iError = 1
				$vReturn = -1
				ExitLoop
			EndIf
		EndIf

		$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptEncrypt", "handle", $vCryptKey, "handle", 0, "bool", $fFinal, "dword", 0, "ptr", 0, _
				"dword*", BinaryLen($vData), "dword", 0)
		If @error Or Not $aRet[0] Then
			$iError = 2
			$vReturn = -1
			ExitLoop
		EndIf

		$ReqBuffSize = $aRet[6]
		$hBuff = DllStructCreate("byte[" & $ReqBuffSize & "]")
		DllStructSetData($hBuff, 1, $vData)
		$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptEncrypt", "handle", $vCryptKey, "handle", 0, "bool", $fFinal, "dword", 0, "struct*", $hBuff, _
				"dword*", BinaryLen($vData), "dword", DllStructGetSize($hBuff))
		If @error Or Not $aRet[0] Then
			$iError = 3
			$vReturn = -1
			ExitLoop
		EndIf
		$iError = 0
		$vReturn = DllStructGetData($hBuff, 1)
	Until True

	If $iALG_ID <> $CALG_USERKEY Then _Crypt_DestroyKey($vCryptKey)
	_Crypt_Shutdown()
	Return SetError($iError, 0, $vReturn)
EndFunc   ;==>_Crypt_EncryptData

; #FUNCTION# ====================================================================================================================
; Author ........: Andreas Karlsson (monoceres)
; Modified ......:
; ===============================================================================================================================
Func _Crypt_DecryptData($vData, $vCryptKey, $iALG_ID, $fFinal = True)
	Local $hBuff
	Local $iError
	Local $vReturn
	Local $hTempStruct
	Local $iPlainTextSize
	Local $aRet
	_Crypt_Startup()

	Do
		If $iALG_ID <> $CALG_USERKEY Then
			$vCryptKey = _Crypt_DeriveKey($vCryptKey, $iALG_ID)
			If @error Then
				$iError = 1
				$vReturn = -1
				ExitLoop
			EndIf
		EndIf

		$hBuff = DllStructCreate("byte[" & BinaryLen($vData) + 1000 & "]")
		DllStructSetData($hBuff, 1, $vData)
		$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptDecrypt", "handle", $vCryptKey, "handle", 0, "bool", $fFinal, "dword", 0, "struct*", $hBuff, "dword*", BinaryLen($vData))
		If @error Or Not $aRet[0] Then
			$iError = 2
			$vReturn = -1
			ExitLoop
		EndIf

		$iPlainTextSize = $aRet[6]
		$hTempStruct = DllStructCreate("byte[" & $iPlainTextSize & "]", DllStructGetPtr($hBuff))
		$iError = 0
		$vReturn = DllStructGetData($hTempStruct, 1)
	Until True

	If $iALG_ID <> $CALG_USERKEY Then _Crypt_DestroyKey($vCryptKey)
	_Crypt_Shutdown()
	Return SetError($iError, 0, $vReturn)
EndFunc   ;==>_Crypt_DecryptData

; #FUNCTION# ====================================================================================================================
; Author ........: Andreas Karlsson (monoceres)
; Modified ......:
; ===============================================================================================================================
Func _Crypt_HashData($vData, $iALG_ID, $fFinal = True, $hCryptHash = 0)
	Local $iError
	Local $vReturn = 0
	Local $iHashSize
	Local $aRet
	Local $hBuff = 0

	_Crypt_Startup()
	Do
		If $hCryptHash = 0 Then
			; Create Hash object
			$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptCreateHash", "handle", __Crypt_Context(), "uint", $iALG_ID, "ptr", 0, "dword", 0, "handle*", 0)
			If @error Or Not $aRet[0] Then
				$iError = 1
				$vReturn = -1
				ExitLoop
			EndIf
			$hCryptHash = $aRet[5]
		EndIf

		$hBuff = DllStructCreate("byte[" & BinaryLen($vData) & "]")
		DllStructSetData($hBuff, 1, $vData)

		$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptHashData", "handle", $hCryptHash, "struct*", $hBuff, "dword", DllStructGetSize($hBuff), "dword", $CRYPT_USERDATA)
		If @error Or Not $aRet[0] Then
			$iError = 2
			$vReturn = -1
			ExitLoop
		EndIf

		If $fFinal Then
			$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptGetHashParam", "handle", $hCryptHash, "dword", $HP_HASHSIZE, "dword*", 0, "dword*", 4, "dword", 0)
			If @error Or Not $aRet[0] Then
				$iError = 3
				$vReturn = -1
				ExitLoop
			EndIf
			$iHashSize = $aRet[3]

			; Get Hash
			$hBuff = DllStructCreate("byte[" & $iHashSize & "]")
			$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptGetHashParam", "handle", $hCryptHash, "dword", $HP_HASHVAL, "struct*", $hBuff, "dword*", DllStructGetSize($hBuff), "dword", 0)
			If @error Or Not $aRet[0] Then
				$iError = 4
				$vReturn = -1
				ExitLoop
			EndIf
			$iError = 0
			$vReturn = DllStructGetData($hBuff, 1)
		Else
			$vReturn = $hCryptHash
		EndIf
	Until True

	; Cleanup and return hash
	If $hCryptHash <> 0 And $fFinal Then DllCall(__Crypt_DllHandle(), "bool", "CryptDestroyHash", "handle", $hCryptHash)

	_Crypt_Shutdown()
	Return SetError($iError, 0, $vReturn)
EndFunc   ;==>_Crypt_HashData

; #FUNCTION# ====================================================================================================================
; Author ........: Andreas Karlsson (monoceres)
; Modified ......:
; ===============================================================================================================================
Func _Crypt_HashFile($sFile, $iALG_ID)
	Local $hFile
	Local $iError, $vReturn
	Local $hHashObject = 0
	Local $bTempData
	_Crypt_Startup()

	Do
		$hFile = FileOpen($sFile, $FO_BINARY)
		If $hFile = -1 Then
			$iError = 1
			$vReturn = -1
			ExitLoop
		EndIf

		Do
			$bTempData = FileRead($hFile, 512 * 1024)
			If @error Then
				$vReturn = _Crypt_HashData($bTempData, $iALG_ID, True, $hHashObject)
				If @error Then
					$vReturn = -1
					$iError = 2
					ExitLoop 2
				EndIf
				ExitLoop 2
			Else
				$hHashObject = _Crypt_HashData($bTempData, $iALG_ID, False, $hHashObject)
				If @error Then
					$vReturn = -1
					$iError = 3
					ExitLoop 2
				EndIf
			EndIf
		Until False
	Until True

	_Crypt_Shutdown()
	If $hFile <> -1 Then FileClose($hFile)
	Return SetError($iError, 0, $vReturn)
EndFunc   ;==>_Crypt_HashFile

; #FUNCTION# ====================================================================================================================
; Author ........: Andreas Karlsson (monoceres)
; Modified ......:
; ===============================================================================================================================
Func _Crypt_EncryptFile($sSourceFile, $sDestinationFile, $vCryptKey, $iALG_ID)
	Local $hInFile, $hOutFile
	Local $iError = 0, $vReturn = True
	Local $bTempData
	Local $iFileSize = FileGetSize($sSourceFile)
	Local $iRead = 0

	_Crypt_Startup()

	Do
		If $iALG_ID <> $CALG_USERKEY Then
			$vCryptKey = _Crypt_DeriveKey($vCryptKey, $iALG_ID)
			If @error Then
				$iError = 1
				$vReturn = -1
				ExitLoop
			EndIf
		EndIf

		$hInFile = FileOpen($sSourceFile, $FO_BINARY)
		If @error Then
			$iError = 2
			$vReturn = -1
			ExitLoop
		EndIf
		$hOutFile = FileOpen($sDestinationFile, $FO_OVERWRITE + $FD_PROMPTCREATENEW + $FO_BINARY)
		If @error Then
			$iError = 3
			$vReturn = -1
			ExitLoop
		EndIf

		Do
			$bTempData = FileRead($hInFile, 1024 * 1024)
			$iRead += BinaryLen($bTempData)
			If $iRead = $iFileSize Then
				$bTempData = _Crypt_EncryptData($bTempData, $vCryptKey, $CALG_USERKEY, True)
				If @error Then
					$iError = 4
					$vReturn = -1
				EndIf
				FileWrite($hOutFile, $bTempData)
				ExitLoop 2
			Else
				$bTempData = _Crypt_EncryptData($bTempData, $vCryptKey, $CALG_USERKEY, False)
				If @error Then
					$iError = 5
					$vReturn = -1
					ExitLoop 2
				EndIf
				FileWrite($hOutFile, $bTempData)
			EndIf
		Until False
	Until True

	If $iALG_ID <> $CALG_USERKEY Then _Crypt_DestroyKey($vCryptKey)
	_Crypt_Shutdown()
	If $hInFile <> -1 Then FileClose($hInFile)
	If $hOutFile <> -1 Then FileClose($hOutFile)
	Return SetError($iError, 0, $vReturn)
EndFunc   ;==>_Crypt_EncryptFile

; #FUNCTION# ====================================================================================================================
; Author ........: Andreas Karlsson (monoceres)
; Modified ......:
; ===============================================================================================================================
Func _Crypt_DecryptFile($sSourceFile, $sDestinationFile, $vCryptKey, $iALG_ID)
	Local $hInFile, $hOutFile
	Local $iError = 0, $vReturn = True
	Local $bTempData
	Local $iFileSize = FileGetSize($sSourceFile)
	Local $iRead = 0

	_Crypt_Startup()

	Do
		If $iALG_ID <> $CALG_USERKEY Then
			$vCryptKey = _Crypt_DeriveKey($vCryptKey, $iALG_ID)
			If @error Then
				$iError = 1
				$vReturn = -1
				ExitLoop
			EndIf
		EndIf

		$hInFile = FileOpen($sSourceFile, $FO_BINARY)
		If @error Then
			$iError = 2
			$vReturn = -1
			ExitLoop
		EndIf
		$hOutFile = FileOpen($sDestinationFile, $FO_OVERWRITE + $FD_PROMPTCREATENEW + $FO_BINARY)
		If @error Then
			$iError = 3
			$vReturn = -1
			ExitLoop
		EndIf

		Do
			$bTempData = FileRead($hInFile, 1024 * 1024)
			$iRead += BinaryLen($bTempData)
			If $iRead = $iFileSize Then
				$bTempData = _Crypt_DecryptData($bTempData, $vCryptKey, $CALG_USERKEY, True)
				If @error Then
					$iError = 4
					$vReturn = -1
				EndIf
				FileWrite($hOutFile, $bTempData)
				ExitLoop 2
			Else
				$bTempData = _Crypt_DecryptData($bTempData, $vCryptKey, $CALG_USERKEY, False)
				If @error Then
					$iError = 5
					$vReturn = -1
					ExitLoop 2
				EndIf
				FileWrite($hOutFile, $bTempData)
			EndIf
		Until False
	Until True

	If $iALG_ID <> $CALG_USERKEY Then _Crypt_DestroyKey($vCryptKey)
	_Crypt_Shutdown()
	If $hInFile <> -1 Then FileClose($hInFile)
	If $hOutFile <> -1 Then FileClose($hOutFile)
	Return SetError($iError, 0, $vReturn)
EndFunc   ;==>_Crypt_DecryptFile

; #FUNCTION# ====================================================================================================================
; Author ........: Erik Pilsits (wraithdu)
; Modified ......:
; ===============================================================================================================================
Func _Crypt_GenRandom($pBuffer, $iSize)
	_Crypt_Startup()
	Local $aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptGenRandom", "handle", __Crypt_Context(), "dword", $iSize, "struct*", $pBuffer)
	Local $nError = @error
	_Crypt_Shutdown()
	If $nError Or (Not $aRet[0]) Then
		Return SetError(1, 0, False)
	Else
		Return True
	EndIf
EndFunc   ;==>_Crypt_GenRandom

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Crypt_RefCount
; Description ...: Retrieves the internal reference count.
; Syntax.........: __Crypt_RefCount ( )
; Parameters ....:
; Return values .: The current internal reference count.
; Author ........: Valik
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Crypt_RefCount()
	Return $__g_aCryptInternalData[0]
EndFunc   ;==>__Crypt_RefCount

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Crypt_RefCountInc
; Description ...: Increments the internal reference count.
; Syntax.........: __Crypt_RefCountInc ( )
; Parameters ....:
; Return values .:
; Author ........: Valik
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Crypt_RefCountInc()
	$__g_aCryptInternalData[0] += 1
EndFunc   ;==>__Crypt_RefCountInc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Crypt_RefCountDec
; Description ...: Decrements the internal reference count.
; Syntax.........: __Crypt_RefCountDec ( )
; Parameters ....:
; Return values .:
; Author ........: Valik
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Crypt_RefCountDec()
	If $__g_aCryptInternalData[0] > 0 Then $__g_aCryptInternalData[0] -= 1
EndFunc   ;==>__Crypt_RefCountDec

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Crypt_DllHandle
; Description ...: Retrieves the internal DLL handle.
; Syntax.........: __Crypt_DllHandle ( )
; Parameters ....:
; Return values .: The current internal DLL handle.
; Author ........: Valik
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Crypt_DllHandle()
	Return $__g_aCryptInternalData[1]
EndFunc   ;==>__Crypt_DllHandle

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Crypt_DllHandleSet
; Description ...: Stores the internal DLL handle.
; Syntax.........: __Crypt_DllHandleSet ( $hAdvapi32 )
; Parameters ....: $hAdvapi32 - The new handle to store.
; Return values .:
; Author ........: Valik
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Crypt_DllHandleSet($hAdvapi32)
	$__g_aCryptInternalData[1] = $hAdvapi32
EndFunc   ;==>__Crypt_DllHandleSet

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Crypt_Context
; Description ...: Retrieves the internal crypt context.
; Syntax.........: __Crypt_Context ( )
; Parameters ....:
; Return values .: The current internal crypt context.
; Author ........: Valik
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Crypt_Context()
	Return $__g_aCryptInternalData[2]
EndFunc   ;==>__Crypt_Context

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Crypt_ContextSet
; Description ...: Stores the internal crypt context.
; Syntax.........: __Crypt_ContextSet ( $hCryptContext )
; Parameters ....: $hCryptContext - The new crypt context to store.
; Return values .:
; Author ........: Valik
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Crypt_ContextSet($hCryptContext)
	$__g_aCryptInternalData[2] = $hCryptContext
EndFunc   ;==>__Crypt_ContextSet
