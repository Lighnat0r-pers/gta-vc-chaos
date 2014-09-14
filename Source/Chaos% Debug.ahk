; ######################################################################################################
; ########################################### DEBUG STUFF ##############################################
; ######################################################################################################

/*
Subheadings:

	DebugFunctions
	DebugListvars
	DebugTemporaryTest
	DebugGotoNextEffect
	DebugTimeMultiplier
	DebugForceQuickload
	DebugOutputSeedList
	DebugMenu
	5ButtonConfirm
	5ButtonCancel/5GuiClose/5GuiEscape
*/

DebugFunctions:
Hotkey, F4, DebugForceQuickload, On
Hotkey, F7, DebugListvars, On
Hotkey, F6, DebugGotoNextEffect, On
Hotkey, F10, DebugMenu, On
Hotkey, F9, DebugOutputSeedList, On
Hotkey, F11, DebugTemporaryTest, On
menu, tray, Add, Debug Hotkeys, DebugListHotkeys
DisableDebugLogger = 0
DebugDifficultyLimitEnabled = 0
DebugDifficultyLimit = 5
gosub DebugTimeMultiplier
return

DebugListHotkeys:
msgbox F4 DebugForceQuickload `nF7 DebugListvars `nF6 DebugGotoNextEffect `nF10 DebugMenu `nF9 DebugOutputSeedList
return

DebugListvars:
Listvars
return

DebugTemporaryTest:
testvalue := IsInArray(PermanentEffectsActiveArray, "Bounce")
outputdebug %testvalue%
return

DebugGotoNextEffect:
DebugGotoNextEffect = 1
return

DebugTimeMultiplier:
DebugTimeMultiplier = 1
return

DebugForceQuickload:
SaveMenuAddress := 0x0086966B+VersionOffset
MenuCurrentPageAddress := 0x00869728+VersionOffset
SaveFileIndexAddress := 0x00869730+VersionOffset ; Starts at 0 instead of 1 like the actual index in the file name
SaveSlotIndex = 8 ; Slot 9
If ((Memory(3, GameRunningAddress, 1) = "Fail"))
	goto Mainscript
Memory(4, SaveMenuAddress, 1, 1)
sleep 100
Memory(4, SaveFileIndexAddress, SaveSlotIndex, 1)
Memory(4, MenuCurrentPageAddress, 10, 1)
sleep 1000
return

DebugOutputSeedList:
If PermanentEffectsEnabled !=
	return
;DifficultyLimit := 7
Loop %SeedValidLength%
	NumberOfSeeds .= 9
Loop %NumberOfSeeds%
{
	Output := ""
	Amount = 0
	PermanentEffectsActiveArray := {}
	Seed := A_Index
	; Set this back to undefined because that is what it'd normally be when picking the first effect, now it'd carry over from the previous seed.
	PermanentEffectsAvailable := 
	gosub DecodeSeed
	For Index, Value in PermanentEffectsActiveArray
	{
		Output := Output . A_Space . Index . "." . Value
		Amount += 1
	}
	outputdebug Seed`:%Seed%  NumberOfEffects`:%Amount%  Names`:%Output%
}
return


; Loop through all permanent effects and create a menu to activate and deactivate them.
DebugMenu:
If DebugMenuExists != 1
{
	gui 5:-MinimizeBox -MaximizeBox +LastFound
	Gui, 5:Font, Q3
	gui, 5:Add, Text,,
	loop % PermanentEffectsArray.MaxIndex()
	{
		PermanentEffectName := PermanentEffectsArray[A_Index]
		gui, 5:Add, Checkbox, v%PermanentEffectName%Required, %PermanentEffectName%
	}
	gui, 5:Add, Button, section default, Confirm
	gui, 5:Add, Button, ys, Close
	gui, 5:Show
	DebugMenuExists = 1
}
return

; If the user confirms, change the effects in the PermanentEffectsActiveArray.
5ButtonConfirm:
Thread, NoTimers
Gui, 5:Submit
gosub PermanentEffectsDeactivate
PermanentEffectsActiveArray := {}
For Index, Value in PermanentEffectsArray
{
	If %Value%Required = 1
		PermanentEffectsActiveArray.Insert(Value) ; Add effect name to array.
}
Gui, 5:Destroy
Gui, 2:Destroy
DebugMenuExists = 0
gosub OutputWindow
return

; If the user cancels, destroy the debug menu.
5ButtonClose:
5GuiClose:
5GuiEscape:
Gui, 5:Cancel
gui, 5:destroy
DebugMenuExists = 0
return


; ######################################################################################################
; ########################################## DEBUG LOGGER ##############################################
; ######################################################################################################

/*
Subheadings:

	InitiateLogger
	StoreLoggerHwnd(wParam)
	StopLogger
*/

InitiateLogger:
LogFileName := "ChaosDebugLog.log"
Gui, 6:New
Gui, 6:+HwndTempWindowHwnd
Gui, 6:Show, Hide
OnMessage(0x12345, "StoreLoggerHwnd")
FileInstall ChaosDebugLogger.exe, ChaosDebugLogger.exe, 1
if DisableDebugLogger != 1
	Run "ChaosDebugLogger.exe" %PID% %LogFileName% %TempWindowHwnd%,, Hide, DebugLoggerPID
return

StoreLoggerHwnd(wParam)
{
	global
;	outputdebug StoreLoggerHwnd wParam`:%wParam%
	DebugLoggerHwnd = %wParam%
	Gui, 6:Destroy
}


StopLogger:
if (DebugLoggerPID != "") ; Check if the debug logger has been started.
{
	DetectHiddenWindows On
	PostMessage, 0x12345,,,,ahk_id %DebugLoggerHwnd%
	DetectHiddenWindows Off
;	outputdebug StopLogger message sent
}
return
