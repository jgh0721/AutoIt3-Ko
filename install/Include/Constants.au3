#include-once

#include "ProcessConstants.au3"
#include "FileConstants.au3"
#include "DirConstants.au3"
#include "ColorConstants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Constants
; AutoIt Version : 3.2
; Language ......: English
; Description ...: Constants to be included in an AutoIt v3 script.
; Author(s) .....: JLandes, Nutster, CyberSlug, Holger, ...
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; Sets the way coords are used in the mouse and pixel functions
Global Const $OPT_COORDSRELATIVE = 0 ; Relative coords to the active window
Global Const $OPT_COORDSABSOLUTE = 1 ; Absolute screen coordinates (default)
Global Const $OPT_COORDSCLIENT = 2 ; Relative coords to client area

; Sets how errors are handled if a Run/RunWait function fails
Global Const $OPT_ERRORSILENT = 0 ; Silent error (@error set to 1)
Global Const $OPT_ERRORFATAL = 1 ; Fatal error (default)

; Alters the use of Caps Lock
Global Const $OPT_CAPSNOSTORE = 0 ; Don't store/restore Caps Lock state
Global Const $OPT_CAPSSTORE = 1 ; Store/restore Caps Lock state (default)

; Alters the method that is used to match window titles
Global Const $OPT_MATCHSTART = 1 ; Match the title from the start (default)
Global Const $OPT_MATCHANY = 2 ; Match any substring in the title
Global Const $OPT_MATCHEXACT = 3 ; Match the title exactly
Global Const $OPT_MATCHADVANCED = 4 ; Use advanced window matching (deprecated)

; Common Control Styles
Global Const $CCS_TOP = 0x01
Global Const $CCS_NOMOVEY = 0x02
Global Const $CCS_BOTTOM = 0x03
Global Const $CCS_NORESIZE = 0x04
Global Const $CCS_NOPARENTALIGN = 0x08
Global Const $CCS_NOHILITE = 0x10
Global Const $CCS_ADJUSTABLE = 0x20
Global Const $CCS_NODIVIDER = 0x40
Global Const $CCS_VERT = 0x0080
Global Const $CCS_LEFT = 0x0081
Global Const $CCS_NOMOVEX = 0x0082
Global Const $CCS_RIGHT = 0x0083

; DrawIconEx Constants
; in WinAPIConstants.au3

; EnumDisplayDevice Constants
; in WinAPIConstants.au3

; Dir Constants
; in DirConstants.au3

; File Constants
; in FileConstants.au3

; FlashWindowEx Constants
; in WinAPIConstants.au3

; FormatMessage Constants
; in WinAPIConstants.au3

; GetWindows Constants
; in WinAPIConstants.au3

; GetWindowLong Constants
; in WinAPIConstants.au3

; Standard Icon Index Constants
; in WinAPIConstants.au3

; Image Load Constants
; in WinAPIConstants.au3

; Image Type Constants
; in WinAPIConstants.au3

; Keyboard Constants
; Changes how keys are processed
; in WinAPIConstants.au3

; Sets the state of the Caps Lock key
; in WinAPIConstants.au3

; LoadLibraryEx Constants
; in WinAPIConstants.au3

; Reserved IDs for System Objects
; in MenuConstants.au3
; in ScrollBarsConstants.au3
Global Const $OBJID_WINDOW = 0x00000000
Global Const $OBJID_TITLEBAR = 0xFFFFFFFE
Global Const $OBJID_SIZEGRIP = 0xFFFFFFF9
Global Const $OBJID_CARET = 0xFFFFFFF8
Global Const $OBJID_CURSOR = 0xFFFFFFF7
Global Const $OBJID_ALERT = 0xFFFFFFF6
Global Const $OBJID_SOUND = 0xFFFFFFF5

; Virtual Keys Constants
; in WinAPIvkeysConstants.au3

; Message Box Constants
; Indicates the buttons displayed in the message box
Global Const $MB_OK = 0 ; One push button: OK
Global Const $MB_OKCANCEL = 1 ; Two push buttons: OK and Cancel
Global Const $MB_ABORTRETRYIGNORE = 2 ; Three push buttons: Abort, Retry, and Ignore
Global Const $MB_YESNOCANCEL = 3 ; Three push buttons: Yes, No, and Cancel
Global Const $MB_YESNO = 4 ; Two push buttons: Yes and No
Global Const $MB_RETRYCANCEL = 5 ; Two push buttons: Retry and Cancel
Global Const $MB_CANCELTRYCONTINUE = 6 ; Three buttons: Cancel, Try Again and Continue
Global Const $MB_HELP = 0x4000 ; Adds a Help button to the message box. When the user clicks the Help button or presses F1, the system sends a WM_HELP message to the owner.

; Displays an icon in the message box
Global Const $MB_ICONSTOP = 16 ; Stop-sign icon
Global Const $MB_ICONERROR = 16 ; Stop-sign icon
Global Const $MB_ICONHAND = 16 ; Stop-sign icon
Global Const $MB_ICONQUESTION = 32 ; Question-mark icon
Global Const $MB_ICONEXCLAMATION = 48 ; Exclamation-point icon
Global Const $MB_ICONWARNING = 48 ; Exclamation-point icon
Global Const $MB_ICONINFORMATION = 64 ; Icon consisting of an 'i' in a circle
Global Const $MB_ICONASTERISK = 64 ; Icon consisting of an 'i' in a circle
Global Const $MB_USERICON = 0x00000080

; Indicates the default button
Global Const $MB_DEFBUTTON1 = 0 ; The first button is the default button
Global Const $MB_DEFBUTTON2 = 256 ; The second button is the default button
Global Const $MB_DEFBUTTON3 = 512 ; The third button is the default button
Global Const $MB_DEFBUTTON4 = 768 ; The fourth button is the default button.

; Indicates the modality of the dialog box
Global Const $MB_APPLMODAL = 0 ; Application modal
Global Const $MB_SYSTEMMODAL = 4096 ; System modal
Global Const $MB_TASKMODAL = 8192 ; Task modal

; Indicates miscellaneous message box attributes
Global Const $MB_DEFAULT_DESKTOP_ONLY = 0x00020000 ; Same as desktop of the interactive window station
Global Const $MB_RIGHT = 0x00080000 ; The text is right-justified.
Global Const $MB_RTLREADING = 0x00100000 ; Displays message and caption text using right-to-left reading order on Hebrew and Arabic systems.
Global Const $MB_SETFOREGROUND = 0x00010000 ; The message box becomes the foreground window
Global Const $MB_TOPMOST = 0x00040000 ; The message box is created with the WS_EX_TOPMOST window style.
Global Const $MB_SERVICE_NOTIFICATION = 0x00200000 ; The caller is a service notifying the user of an event.

Global Const $MB_RIGHTJUSTIFIED = $MB_RIGHT ; Do not use, see $MB_RIGHT. Included for backwards compatibility.

; Indicates the button selected in the message box
Global Const $IDTIMEOUT = -1 ; The message box timed out
Global Const $IDOK = 1 ; OK button was selected
Global Const $IDCANCEL = 2 ; Cancel button was selected
Global Const $IDABORT = 3 ; Abort button was selected
Global Const $IDRETRY = 4 ; Retry button was selected
Global Const $IDIGNORE = 5 ; Ignore button was selected
Global Const $IDYES = 6 ; Yes button was selected
Global Const $IDNO = 7 ; No button was selected
Global Const $IDCLOSE = 8 ; Close button was selected
Global Const $IDHELP = 9 ; Help button was selected
Global Const $IDTRYAGAIN = 10 ; Try Again button was selected
Global Const $IDCONTINUE = 11 ; Continue button was selected

; Progress and Splash Constants
; Indicates properties of the displayed progress or splash dialog
Global Const $DLG_NOTITLE = 1 ; Titleless window
Global Const $DLG_NOTONTOP = 2 ; Without "always on top" attribute
Global Const $DLG_TEXTLEFT = 4 ; Left justified text
Global Const $DLG_TEXTRIGHT = 8 ; Right justified text
Global Const $DLG_MOVEABLE = 16 ; Window can be moved
Global Const $DLG_TEXTVCENTER = 32 ; Splash text centered vertically

; Tray Tip Constants
; Indicates the type of Balloon Tip to display
Global Const $TIP_ICONNONE = 0 ; No icon (default)
Global Const $TIP_ICONASTERISK = 1 ; Info icon
Global Const $TIP_ICONEXCLAMATION = 2 ; Warning icon
Global Const $TIP_ICONHAND = 3 ; Error icon
Global Const $TIP_NOSOUND = 16 ; No sound

; Mouse Constants
; Indicates current mouse cursor
Global Const $IDC_UNKNOWN = 0 ; Unknown cursor
Global Const $IDC_APPSTARTING = 1 ; Standard arrow and small hourglass
Global Const $IDC_ARROW = 2 ; Standard arrow
Global Const $IDC_CROSS = 3 ; Crosshair
Global Const $IDC_HAND = 32649 ; Hand cursor
Global Const $IDC_HELP = 4 ; Arrow and question mark
Global Const $IDC_IBEAM = 5 ; I-beam
Global Const $IDC_ICON = 6 ; Obsolete
Global Const $IDC_NO = 7 ; Slashed circle
Global Const $IDC_SIZE = 8 ; Obsolete
Global Const $IDC_SIZEALL = 9 ; Four-pointed arrow pointing N, S, E, and W
Global Const $IDC_SIZENESW = 10 ; Double-pointed arrow pointing NE and SW
Global Const $IDC_SIZENS = 11 ; Double-pointed arrow pointing N and S
Global Const $IDC_SIZENWSE = 12 ; Double-pointed arrow pointing NW and SE
Global Const $IDC_SIZEWE = 13 ; Double-pointed arrow pointing W and E
Global Const $IDC_UPARROW = 14 ; Vertical arrow
Global Const $IDC_WAIT = 15 ; Hourglass

Global Const $IDI_APPLICATION = 32512 ; Application icon
Global Const $IDI_ASTERISK = 32516 ; Asterisk icon
Global Const $IDI_EXCLAMATION = 32515 ; Exclamation point icon
Global Const $IDI_HAND = 32513 ; Stop sign icon
Global Const $IDI_QUESTION = 32514 ; Question-mark icon
Global Const $IDI_WINLOGO = 32517 ; Windows logo icon. Windows XP: Application icon
Global Const $IDI_SHIELD = 32518
Global Const $IDI_ERROR = $IDI_HAND
Global Const $IDI_INFORMATION = $IDI_ASTERISK
Global Const $IDI_WARNING = $IDI_EXCLAMATION

; Process Constants
; Indicates the type of shutdown
Global Const $SD_LOGOFF = 0 ; Logoff
Global Const $SD_SHUTDOWN = 1 ; Shutdown
Global Const $SD_REBOOT = 2 ; Reboot
Global Const $SD_FORCE = 4 ; Force
Global Const $SD_POWERDOWN = 8 ; Power down
Global Const $SD_FORCEHUNG = 16 ; Force shutdown if hung
Global Const $SD_STANDBY = 32 ; Standby
Global Const $SD_HIBERNATE = 64 ; Hibernate

; OpenProcess Constants
; in ProcessConstants.au3

; String Constants
; Indicates if string operations should be case sensitive
Global Const $STR_NOCASESENSE = 0 ; Not case sensitive (default)
Global Const $STR_CASESENSE = 1 ; Case sensitive
Global Const $STR_NOCASESENSEBASIC = 2 ; Not case sensitive, using a basic comparison

; Indicates the type of stripping that should be performed
Global Const $STR_STRIPLEADING = 1 ; Strip leading whitespace
Global Const $STR_STRIPTRAILING = 2 ; Strip trailing whitespace
Global Const $STR_STRIPSPACES = 4 ; Strip double (or more) spaces between words
Global Const $STR_STRIPALL = 8 ; Strip all spaces (over-rides all other flags)

; Token Constants
; in SecurityConstants.au3

; Tray Constants
; Tray predefined ID's
Global Const $TRAY_ITEM_EXIT = 3
Global Const $TRAY_ITEM_PAUSE = 4
Global Const $TRAY_ITEM_FIRST = 7

; Tray menu/item state values
Global Const $TRAY_CHECKED = 1
Global Const $TRAY_UNCHECKED = 4
Global Const $TRAY_ENABLE = 64
Global Const $TRAY_DISABLE = 128
Global Const $TRAY_FOCUS = 256
Global Const $TRAY_DEFAULT = 512

; Tray event values
Global Const $TRAY_EVENT_SHOWICON = -3
Global Const $TRAY_EVENT_HIDEICON = -4
Global Const $TRAY_EVENT_FLASHICON = -5
Global Const $TRAY_EVENT_NOFLASHICON = -6
Global Const $TRAY_EVENT_PRIMARYDOWN = -7
Global Const $TRAY_EVENT_PRIMARYUP = -8
Global Const $TRAY_EVENT_SECONDARYDOWN = -9
Global Const $TRAY_EVENT_SECONDARYUP = -10
Global Const $TRAY_EVENT_MOUSEOVER = -11
Global Const $TRAY_EVENT_MOUSEOUT = -12
Global Const $TRAY_EVENT_PRIMARYDOUBLE = -13
Global Const $TRAY_EVENT_SECONDARYDOUBLE = -14

; Run Constants
Global Const $STDIN_CHILD = 1
Global Const $STDOUT_CHILD = 2
Global Const $STDERR_CHILD = 4
Global Const $STDERR_MERGED = 8
Global Const $STDIO_INHERIT_PARENT = 0x10
Global Const $RUN_CREATE_NEW_CONSOLE = 0x00010000

; Colour Constants
; in ColorConstants.au3

; Mouse Event Constants
Global Const $MOUSEEVENTF_ABSOLUTE = 0x8000 ; Specifies that the dx and dy parameters contain normalized absolute coordinates
Global Const $MOUSEEVENTF_MOVE = 0x0001 ; Specifies that movement occurred
Global Const $MOUSEEVENTF_LEFTDOWN = 0x0002 ; Specifies that the left button changed to down
Global Const $MOUSEEVENTF_LEFTUP = 0x0004 ; Specifies that the left button changed to up
Global Const $MOUSEEVENTF_RIGHTDOWN = 0x0008 ; Specifies that the right button changed to down
Global Const $MOUSEEVENTF_RIGHTUP = 0x0010 ; Specifies that the right button changed to up
Global Const $MOUSEEVENTF_MIDDLEDOWN = 0x0020 ; Specifies that the middle button changed to down
Global Const $MOUSEEVENTF_MIDDLEUP = 0x0040 ; Specifies that the middle button changed to up
Global Const $MOUSEEVENTF_WHEEL = 0x0800 ; Specifies that the wheel has been moved, if the mouse has a wheel
Global Const $MOUSEEVENTF_XDOWN = 0x0080 ; Specifies that an X button was pressed
Global Const $MOUSEEVENTF_XUP = 0x0100 ; Specifies that an X button was released

; Reg Value type Constants
Global Const $REG_NONE = 0
Global Const $REG_SZ = 1
Global Const $REG_EXPAND_SZ = 2
Global Const $REG_BINARY = 3
Global Const $REG_DWORD = 4
Global Const $REG_DWORD_LITTLE_ENDIAN = 4
Global Const $REG_DWORD_BIG_ENDIAN = 5
Global Const $REG_LINK = 6
Global Const $REG_MULTI_SZ = 7
Global Const $REG_RESOURCE_LIST = 8
Global Const $REG_FULL_RESOURCE_DESCRIPTOR = 9
Global Const $REG_RESOURCE_REQUIREMENTS_LIST = 10
Global Const $REG_QWORD = 11
Global Const $REG_QWORD_LITTLE_ENDIAN = 11

; Z order
Global Const $HWND_BOTTOM = 1 ; Places the window at the bottom of the Z order
Global Const $HWND_NOTOPMOST = -2 ; Places the window above all non-topmost windows
Global Const $HWND_TOP = 0 ; Places the window at the top of the Z order
Global Const $HWND_TOPMOST = -1 ; Places the window above all non-topmost windows

; SetWindowPos Constants
Global Const $SWP_NOSIZE = 0x0001
Global Const $SWP_NOMOVE = 0x0002
Global Const $SWP_NOZORDER = 0x0004
Global Const $SWP_NOREDRAW = 0x0008
Global Const $SWP_NOACTIVATE = 0x0010
Global Const $SWP_FRAMECHANGED = 0x0020
Global Const $SWP_DRAWFRAME = 0x0020
Global Const $SWP_SHOWWINDOW = 0x0040
Global Const $SWP_HIDEWINDOW = 0x0080
Global Const $SWP_NOCOPYBITS = 0x0100
Global Const $SWP_NOOWNERZORDER = 0x0200
Global Const $SWP_NOREPOSITION = 0x0200
Global Const $SWP_NOSENDCHANGING = 0x0400
Global Const $SWP_DEFERERASE = 0x2000
Global Const $SWP_ASYNCWINDOWPOS = 0x4000

; Keywords (returned from the IsKeyword() function
Global Const $KEYWORD_DEFAULT = 1
Global Const $KEYWORD_NULL = 2

; language identifiers
; in WinAPIlangConstants.au3

; sublanguage identifiers
; in WinAPIlangConstants.au3

; Sorting IDs. (from WINNT.H)
; in WinAPIlangConstants.au3
; ===============================================================================================================================
