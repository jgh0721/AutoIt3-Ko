#include <Constants.au3>

Example()

Func Example()
	; Assign a Local constant variable the approximate PI number.
	Local Const $PI = 3.141592653589793

	; Assign a Local variable the tangent of PI / 4.
	Local $iTan1 = Tan($PI / 4)

	; Display the result.
	MsgBox($MB_SYSTEMMODAL, "", $iTan1)


	; Assign a Local variable the formula to switch from radian to degree (equals to one degree in radian).
	Local $iDegToRad = $PI / 180

	; Assign a Local variable the tangent of 90 degrees (firstly converted to radians).
	Local $iTan2 = Tan(90 * $iDegToRad)

	; Display the result.
	MsgBox($MB_SYSTEMMODAL, "", $iTan2)
EndFunc   ;==>Example