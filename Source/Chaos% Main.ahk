/*
List of GUI windows in use:
1: Welcome Screen
2: Output Window
3: Exit Confirmation Screen
4: Update Notifier
5: Debug menu
6: Empty menu to get a handle for the debug logger
*/


; ######################################################################################################
; ########################################### HEADER SECTION ###########################################
; ######################################################################################################

/*
Subheadings:

	#AUTO-EXECUTE
	CreateArrays
	FileList
	OpenReadme
	PermanentEffectsList
	CreatePermanentEffectsArrayCode
	TimedEffectsList
	CreateTimedEffectsArrayCode
	UpdateCurrentTime
*/


; Only one instance of the program can be running at a time.
#SingleInstance Force
; Get the stuff from other files as early as possible.
gosub Includes
; Tell the program what to do if it is closed.
OnExit, ExitSequence
; Change the name of the program in the tray menu, then remove the standard tray items
; and add new ones relevant to this program.
SplitPath, A_ScriptName,,,,ProgramNameNoExt
menu, tray, tip, %ProgramNameNoExt%
menu, tray, NoStandard
menu, tray, Add, Restart Program, RestartSequence
menu, tray, Add, Open Readme, OpenReadme
menu, tray, Add, Exit, ExitSequence
; Initialise the thread/timer which will keep the variable CurrentTime updated. 
; Setting a period of 0 will actually result in it executing every 10 or 15.6 milliseconds
; (depending on the type of hardware and drivers installed) but that is good enough for this purpose.
SetTimer, UpdateCurrentTime, 0
gosub UpdateCurrentTime ; Update immediately to be able to write the next entry in the log.
; Start the log.
outputdebug %CurrentTime% Start Chaos Program
FileAppend, `n%CurrentTime% Start Chaos Program, %ProgramNameNoExt% Log`.log
; Enable debug functions if they exist and if the program is not compiled.
; This way normal users can't (accidentally) activate them.
If (IsLabel("DebugFunctions") AND A_IsCompiled != 1)
	gosub DebugFunctions
; Configure the auto updater. The auto updater only triggers if the program is compiled, otherwise 
; the program will go to the create arrays subroutine immediately, skipping the auto updater.
CurrentVersion = 1.21
VersionURL := "http://pastebin.com/download.php?i=pc9QbQCK"
ProgramName = Chaos
gosub FileList
gosub DefineVars
If A_IsCompiled = 1
	gosub UpdateCheck
gosub CreateArrays
goto WelcomeScreen

Includes:
#Include Chaos% Debug.ahk
#Include Chaos% Effects Arrays.ahk
#Include Chaos% Exit Sequence.ahk
#Include Chaos% Output Window.ahk
#Include Chaos% Permanent Effects.ahk
#Include Chaos% Quicksave.ahk
#Include Chaos% Static Effects.ahk
#Include Chaos% Timed Effects.ahk
#Include Chaos% Timed Effects Limitations.ahk
#Include Chaos% Update Checker.ahk
#Include Chaos% Welcome Window.ahk
return

DefineVars:
; Some standard values are defined here.
; SeedValidLength: How many characters the seed has to have.
SeedValidLength := 4
; StandardTimeBetweenEffects: How long an effect lasts by default.
StandardTimeBetweenEffects = 30000 ; In ms
; RefreshRate: Used throughout the program, for example as the time between checking if the effect should be ended or not.
RefreshRate = 15 ; In ms
; SanicModeTimeMultiplier: When sanic mode is active, all effect lengths are multiplied by this.
SanicModeTimeMultiplier = 0.1 ; 10x speed
; Cycle: Needs to be initialized at 1 to ensure the timed effects working properly
Cycle = 1
; Create some arrays needed to find the game and to see if it's still running. Both the window class and name are used for improved accuracy.
GameWindowClassArray := {GTAVC:"Grand theft auto 3", GTA3:"Grand theft auto 3", GTASA:"Grand theft auto San Andreas", GTA4:"Grand theft auto IV"}
GameWindowNameArray := {GTAVC:"GTA: Vice City", GTA3:"GTA3", GTASA:"GTA: San Andreas", GTA4:"GTAIV"}
GameRunningAddressArray := {GTAVC:0x00400000, GTASA:0x00400000, GTA3:0x00400000}
; Game time is needed to determine when effects should end. It depends on game time to make sure you can't skip effects by waiting in the menu.
GameTimeAddressArray := {GTAVC:0x007E3F24}
;  Show a tray tip to the user explaining what the program will do.
TrayTip, Vice City Chaos`%, The program will automatically change the required settings to activate Chaos`%. `n`nMade by Lighnat0r,20,
; CurrentGame needs to be set for the version check later on.
CurrentGame = GTAVC
return

; List of names of the files the auto updater should download.
FileList:
File1 := "newversionGTA VC Chaos%.exe"
File2 := "GTA VC Chaos% Readme.txt"
ExecutableFile := File1

; Old versions included the source in one file. These days it's not included but on the GitHub,
; so when updating we check if the old file exists and if so delete it.
FileName := "GTA VC Chaos% Source.ahk"
If FileExist(FileName)
	FileDelete, %FileName%
return

; First define which file from the file list is the readme, then test if it exists
; and open it if it does. Otherwise, show an error message with the most likely issue.
OpenReadme:
ReadmeFile := File3
if FileExist(ReadmeFile)
	Run, edit %ReadmeFile%
else
	Msgbox,  The readme could not be found. `nPlease make sure it is located in the same folder as the executable.
return

; Convert the current time to a decently looking format. Adding the milliseconds is important
; because issues are likely to arise on that timescale. CurrentTime is used for the log.
UpdateCurrentTime:
CurrentTime = %A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec%.%A_MSec%
return

; ######################################################################################################
; ############################################ MAIN SECTION ############################################
; ######################################################################################################

/*
Subheadings:

	MainScript
	CheckGameRunning
	TimedEffectsMain
	TimedEffectActivate
	TimedEffectDeactivate
	TimedEffectsUpdate
	RemoveTimedEffectsInCategoryFromArrays
	TimedEffectCheckCycleProgress
	TimedEffectSetEffectTime
	GetTimedEffect
	SkipTimedEffect
	CheckGameStatus()
	PermanentEffectsMain
	PermanentEffectsActivate
	PermanentEffectsDeactivate
	PermanentEffectsUpdate
	StaticEffectsMain
	StaticEffectsActivate
	StaticEffectsDeactivate
	StaticEffectsUpdate
	ChaosTextMain
	ChaosTextAdd
	ChaosTextRemove
	UpdateVariableAddresses
*/

MainScript:

; Get the window class and name of the game from the array.
WindowClass := GameWindowClassArray[CurrentGame]
WindowName := GameWindowNameArray[CurrentGame]
; Wait until the game window is started. Check both the window class and window title to avoid false positives.
WinWait ahk_class %WindowClass%
WinGetTitle, CurrentWindowName
If (CurrentWindowName != WindowName)
	goto MainScript
; Get the Process Handle of the game for use in memory functions.
; If the process handle cannot be retrieved, try to restart the program
; with admin privileges to see if that fixes the problem.
; If it can still not be retrieved with admin privileges, the program
; cannot function properly so it will shut itself down.
WinGet, PID, PID
ErrorLevel := Memory(1, PID)
If ErrorLevel != 0
{
	If A_IsAdmin = 0
	{
		msgbox Error accessing the game. `nThe program will now try to restart with admin privileges.
		Run *RunAs "%A_ScriptFullPath%"

	}
	Else
	{
		msgbox Error accessing the game. `nThe program cannot continue operating.`n%Error%.
		Error := GetLastErrorMessage()
	}
	ExitConfirmed = 1
	ExitApp
}	
; Check if the game is started (which will set ErrorLevel != 0),
; then check which version of the current game is used and which offset to use for memory addresses.
Process, Exist, %PID%
if ErrorLevel != 0
	VersionOffset := GameVersionCheck(CurrentGame)
else 
	goto MainScript
; A list of addresses which are either required in the loop, or are used in so many
; effects it's more efficient to put them here.
GameRunningAddress := GameRunningAddressArray[CurrentGame]
GameTimeAddress := GameTimeAddressArray[CurrentGame]+VersionOffset
InTheBeginningDoneAddress := 0x008215F0+VersionOffset
PlayerPointer := 0x007E4B8C+VersionOffset
PlayerStatusOffset := 0x244
PlayerControllableOffset := 0x63D
VehicleTypeOffset := 0x29C
CarPointer := 0x007E49C0+VersionOffset
OnMissionAddress := 0x00821764+VersionOffset
If VersionOffset = -4088 ; Steam
	TimeHoursAddress := 0x00A0FB75
Else if VersionOffset = 8 ; V1.1
	TimeHoursAddress := 0x00A10B74
else
	TimeHoursAddress := 0x00A10B6B
If VersionOffset = -4088 ; Steam
	TimeMinutesAddress := 0x00A0FB9C
Else if VersionOffset = 8 ; V1.1
	TimeMinutesAddress := 0x00A10B92
else
	TimeMinutesAddress := 0x00A10B9B

Guicontrol,2:,TimedEffectText,
SetTimer, UpdateVariableAddresses, %RefreshRate%
SetTimer, CheckGameRunning, %RefreshRate%
If StaticEffectsEnabled = 1
	SetTimer, StaticEffectsMain, %RefreshRate%
If PermanentEffectsEnabled = 1
	SetTimer, PermanentEffectsMain, %RefreshRate%
If TimedEffectsEnabled = 1
	SetTimer, TimedEffectsMain, %RefreshRate%
SetTimer, ChaosTextMain, %RefreshRate%
Hotkey, F5, Quicksave, On
gosub InitiateLogger
Outputdebug %CurrentTime% Log Start`. Version`: %CurrentVersion% `, Seed`: %Seed%
FileAppend, `n`n%CurrentTime% Log Start`. Version`: %CurrentVersion% `, Seed`: %Seed% Difficulty`:%DifficultySetting%, %ProgramNameNoExt% Log`.log
return

; This subroutine checks if the game is still running. If it isn't, it will deactivate the other timers
; depending on the game, running them once first to make sure they are disabled properly. To avoid issues
; with running a subroutine twice, this subroutine can't be interrupted by timers. If the game is stopped
; this subroutine will make the program return to the code which waits for the game to start.
CheckGameRunning:
Thread, NoTimers
GameStatus := CheckGameStatus() ; 0 for ready, other values for not ready.
If GameStatus = 1 ; Game not running.
{
	SetTimer, UpdateVariableAddresses, Off
	SetTimer, CheckGameRunning, Off
	If StaticEffectsEnabled = 1
	{
		SetTimer, StaticEffectsMain, Off
		gosub StaticEffectsMain
	}
	If PermanentEffectsEnabled = 1
	{
		SetTimer, PermanentEffectsMain, Off
		gosub PermanentEffectsMain
	}
	If TimedEffectsEnabled = 1
	{
		SetTimer, TimedEffectsMain, Off
		gosub TimedEffectsMain
	}
	SetTimer, ChaosTextMain, Off
	gosub ChaosTextMain
	Hotkey, F5, Quicksave, Off
	gosub StopLogger
	If QuicksaveUsed = 1
	{
		Traytip, Vice City Chaos`%, Press F5 to load the quicksave once you have restarted the game.,20,
		QuicksaveUsed = 0	
	}
	outputdebug %CurrentTime% Game Stopped
	FileAppend, `n`n%CurrentTime% Game Stopped`n, %ProgramNameNoExt% Log`.log
	Guicontrol,2:,TimedEffectText, -Game not running-
	goto MainScript
}
return


TimedEffectsMain:
GameStatus := CheckGameStatus() ; 0 for ready, other values for not ready.
; If the game is not ready, deactivate the timed effect if one is active.
; The game status for 'In Menu' is not included here because the timed
; effect should not deactivate every time the menu is opened, that would
; be much too abusable.
if (GameStatus != 0 AND GameStatus != 2)
{
	If TimedEffectActive = 1
		gosub TimedEffectDeactivate
	return
}
; If the game is ready, check if a timed effect is active. If not,
; pick one and activate it.
Else If TimedEffectActive != 1
{
	gosub TimedEffectCheckCycleProgress
	gosub GetTimedEffect
	gosub RemoveTimedEffectsInCategoryFromArrays
	gosub %TimedEffectName%Data
	if (PreviousTimedEffectCategory = TimedEffectCategory)
		SkipTimedEffect = 1
	TimedEffectDifficultyLimiter := GetPseudoRandomValueUpTo(Difficulty)
	if TimedEffectDifficultyLimiter != 1
		SkipTimedEffect = 1
	if SkipTimedEffect = 1
		gosub SkipTimedEffect
	Else
		gosub TimedEffectActivate
	return
}
Else
; If a timed effect is active, check what should happen.
{
	; If the debug function to go to the next effect is activated, deactivate the current effect.
	If DebugGotoNextEffect = 1 ; Debug function
	{
		gosub TimedEffectDeactivate
		return
	}
	; Check if the duration of the timed effect has passed. Deactivate it if it has.
	If (Memory(3, GameTimeAddress, 4) > EndTime)
	{
		gosub TimedEffectDeactivate
		return
	}
	; Check if the begin time is less than the current time. This usually indicates a save has been loaded.
	; With the subroutine already testing for loads in the game status at the beginning, this should never
	; be activated. Just in case the game status check misses something, this will keep the effect from
	; lasting a very long time.
	If (Memory(3, GameTimeAddress, 4) < BeginTime)
	{
		gosub TimedEffectDeactivate
		return
	}
	; If the 'Continuously Activate' flag has been set, check if the effect is not limited by any factors.
	; If it isn't, activate it again. If an effect has an extra difficulty during Sanic mode, this will
	; cause the effect to wrongly not activate here. Luckily Sanic mode switches effects so fast that
	; shouldn't be a problem, but it is something to keep in mind.
	If %TimedEffectName%ContinuouslyActivate = 1
	{
		SkipTimedEffect = 0
		gosub %TimedEffectName%Data
		if SkipTimedEffect != 1
			gosub %TimedEffectName%Activate
		return
	}
}
return

; Everything related to activating a timed effect.
TimedEffectActivate:
Guicontrol,2:,TimedEffectText,%TimedEffectName%`%
gosub %TimedEffectName%Activate
PreviousTimedEffectCategory := TimedEffectCategory
TimedEffectsTotalActivated += 1
%TimedEffectName%NameEnableCount += 1
outputdebug % CurrentTime A_Space Cycle A_Space TimedEffectName A_Space %TimedEffectName%NameEnableCount
FileAppend, `n%CurrentTime% %Cycle% %TimedEffectName%, %ProgramNameNoExt% Log`.log
gosub TimedEffectSetEffectTime
TimedEffectActive = 1
return

; Everything related to deactivating a timed effect.
TimedEffectDeactivate:
gosub %TimedEffectName%Deactivate
Guicontrol,2:,TimedEffectText,
DebugGotoNextEffect = 0
TimedEffectActive = 0
; outputdebug %CurrentTime% %TimedEffectName% Deactivated
return

; Remove all the effects in the same category as the currently chosen one 
; to avoid activating the same category more than once in a cycle.
; The effects can't be removed inside the For loop because that would
; screw up the index count.
RemoveTimedEffectsInCategoryFromArrays:
IndicesToBeRemoved = 
For Index, Category in TempTimedCategoriesArray
{
	If (TimedEffectCategory = Category)
		IndicesToBeRemoved := Index . "." . IndicesToBeRemoved
}
StringSplit, IndicesToBeRemovedArray, IndicesToBeRemoved, `.
IndicesToBeRemovedArray0 -= 1 ; To account for the empty part which is created the first time an index is added because IndicesToBeRemoved is empty at that point.
; We need to go from high to low in the indices we will remove, because
; otherwise we'd move items we want to remove and remove something else instead.
Loop %IndicesToBeRemovedArray0%
{
	Index := IndicesToBeRemovedArray%A_Index%
	TempTimedEffectsArray.Remove(Index)
	TempTimedCategoriesArray.Remove(Index)
	TempTimedDifficultiesArray.Remove(Index)
}
return

; Check if the temporary arrays are empty. If they are, restore them from the originals and start the next cycle.
TimedEffectCheckCycleProgress:
if (TempTimedEffectsArray.MaxIndex() = "")
{
	Cycle += 1
	TempTimedEffectsArray := TimedEffectsArray.Clone()
	TempTimedCategoriesArray := TimedCategoriesArray.Clone()
	TempTimedDifficultiesArray := TimedDifficultiesArray.Clone()
}
return

; Determine the begin and end time of the effect.
; If a duration was not specified, use the standard length.
; The time is also affected by Sanic mode and by a debug function with pretty much the same effect.
TimedEffectSetEffectTime:
If %TimedEffectName%Time =
	%TimedEffectName%Time := StandardTimeBetweenEffects
%TimedEffectName%TimeActual := %TimedEffectName%Time
If SanicModeEnabled = 1
	%TimedEffectName%TimeActual := %TimedEffectName%TimeActual * SanicModeTimeMultiplier
If DebugTimeMultiplier != ; Debug function
	%TimedEffectName%TimeActual := %TimedEffectName%TimeActual * DebugTimeMultiplier
BeginTime := Memory(3, GameTimeAddress, 4)
EndTime := Memory(3, GameTimeAddress, 4) + %TimedEffectName%TimeActual
; outputdebug SetEffectTime %BeginTime% %EndTime%
return

; Generate a random number in the range of the amount of items still in the temporary
; timed effects array. Get the information of the effect belonging to that index.
GetTimedEffect:
TimedEffectsTotalSelected += 1
TimedEffectsAvailable := TempTimedEffectsArray.MaxIndex()
ChosenEffect := GetPseudoRandomValueUpTo(TimedEffectsAvailable)
TimedEffectName := TempTimedEffectsArray[ChosenEffect]
TimedEffectCategory := TempTimedCategoriesArray[ChosenEffect]
Difficulty := TempTimedDifficultiesArray[ChosenEffect]
; outputdebug GetTimedEffect %RandomOutput% %TimedEffectName% total`:%TimedEffectsAvailable%
return

; Function to skip effects when they shouldn't be activated because of difficulty limitations
; or because the circumstances are not correct (e.g. RainbowCar% while on foot).
SkipTimedEffect:
TimedEffectsTotalSkipped += 1
%TimedEffectName%SkipCount += 1
SkipTimedEffect = 0
outputdebug %CurrentTime% %TimedEffectName% Skipped
return


PermanentEffectsMain:
GameStatus := CheckGameStatus() ; 0 for ready, other values for not ready.
; If the game is not ready, check if the permanent effects are active.
; If they are active deactivate them, otherwise do nothing.
if (GameStatus != 0)
{
	If PermanentEffectsActive = 1
		Gosub PermanentEffectsDeactivate
	return
}
; Since we've established that the game is ready, check if the permanent
; effects are active. If they aren't, activate them.
If PermanentEffectsActive != 1
{
	Gosub PermanentEffectsActivate
	return
}
; We've established that the game is ready and the permanent effects are
; active. Update the permanent effects.
Else
{
	Gosub PermanentEffectsUpdate
	return
}
return

; Loop through all permanent effects and activate them if they should be and haven't already.
PermanentEffectsActivate:
For Index, PermanentEffectName in PermanentEffectsActiveArray
{
	gosub Permanent%PermanentEffectName%Data
	gosub Permanent%PermanentEffectName%Activate
	outputdebug %CurrentTime% Permanent Effect`: %PermanentEffectName% Activated
	FileAppend, `n%CurrentTime% Permanent Effect`: %PermanentEffectName% Activated, %ProgramNameNoExt% Log`.log
}
PermanentEffectsActive = 1
return

; Loop through all permanent effects and deactivate them if they are active.
PermanentEffectsDeactivate:
For Index, PermanentEffectName in PermanentEffectsActiveArray
{
	gosub Permanent%PermanentEffectName%Data
	gosub Permanent%PermanentEffectName%Deactivate
	outputdebug %CurrentTime% Permanent Effect`: %PermanentEffectName% Deactivated
	FileAppend, `n%CurrentTime% Permanent Effect`: %PermanentEffectName% Deactivated, %ProgramNameNoExt% Log`.log
}
PermanentEffectsActive = 0
return

; Loop through all permanent effects and update them. If an effect needs to
; be updated at a slower rate, it can be timed out it the update loop and it
; will skip the update until the timeout is finished.
PermanentEffectsUpdate:
For Index, PermanentEffectName in PermanentEffectsActiveArray
{
	If (Permanent%PermanentEffectName%TimedOut != 1)
	{
		gosub Permanent%PermanentEffectName%Data
		gosub Permanent%PermanentEffectName%Update
	}
}
return


StaticEffectsMain:
GameStatus := CheckGameStatus() ; 0 for ready, other values for not ready.
; If the game is not ready, check if the static effects are active.
; If they are active deactivate them, otherwise do nothing.
if (GameStatus != 0 AND GameStatus != 7)
{
	If StaticEffectsActive = 1
		Gosub StaticEffectsDeactivate
	return
}
; Since we've established that the game is ready, check if the static
; effects are active. If they aren't, activate them.
If StaticEffectsActive != 1
{
	Gosub StaticEffectsActivate
	return
}
; If the static effects are already active, update them.
Else
{
	Gosub StaticEffectsUpdate
	return
}
return

; Loop through all static effects and activate them if they should be and haven't already.
StaticEffectsActivate:
For Index, StaticEffectName in StaticEffectsArray
{
	gosub Static%StaticEffectName%Data
	gosub Static%StaticEffectName%Activate
	outputdebug %CurrentTime% Static Effect`: %StaticEffectName% Activated
	FileAppend, `n%CurrentTime% Static Effect`: %StaticEffectName% Activated, %ProgramNameNoExt% Log`.log
}
StaticEffectsActive = 1
return

; Loop through all static effects and deactivate them if they are active.
StaticEffectsDeactivate:
For Index, StaticEffectName in StaticEffectsArray
{
	gosub Static%StaticEffectName%Data
	gosub Static%StaticEffectName%Deactivate
	outputdebug %CurrentTime% Static Effect`: %StaticEffectName% Deactivated
	FileAppend, `n%CurrentTime% Static Effect`: %StaticEffectName% Deactivated, %ProgramNameNoExt% Log`.log
}
StaticEffectsActive = 0
return

; Loop through all static effects and update them. If an effect needs to
; be updated at a slower rate, it can be timed out it the update loop and it
; will skip the update until the timeout is finished.
StaticEffectsUpdate:
For Index, StaticEffectName in StaticEffectsArray
{
	gosub Static%StaticEffectName%Data
	gosub Static%StaticEffectName%Update
}
return


; Check if the Chaos% text is being displayed. If it isn't, add it.
ChaosTextMain:
TextCharacter1Address := 0x0078D100+VersionOffset
InputString := "Chaos%"
GameStatus := CheckGameStatus() ; 0 for ready, other values for not ready.
; If the game is not ready, check if the Chaos% text is added.
; If it is added remove it, otherwise do nothing.
if (GameStatus != 0 AND GameStatus != 7)
{
	If ChaosTextAdded = 1
		gosub ChaosTextRemove
	return
}
; Since we've established that the game is ready, check if the
; Chaos% text is added. If it isn't, add it.
If ChaosTextAdded != 1
{
	gosub ChaosTextAdd
	return
}
; We've established that the game is ready and the Chaos% text is added.
; Now we need to check the game memory to see if it actually is being displayed,
; since the game likes to remove it on its own. It would be possible to not check
; if the text is added before this, but checking a variable is quicker than reading
; memory so we want to try and avoid having to read the memory here.
if (Memory(3, TextCharacter1Address, 20, "Unicode") != InputString)
	gosub ChaosTextAdd
return

; Add the Chaos% text to the text field ingame where "Busted" and "Wasted" are normally displayed.
; Works reasonably well, other than the fact that the text tends to disappear automatically, making
; it flicker. The fade in/out is far shorter than on the other tested text fields, but is still 
; visible. Also annoying is that all markers and (in some cases?) subtitles are not shown if this
; text field is active. Using other text fields hasn't been an improvement so far, but needs to be
; looked into further.
ChaosTextAdd:
Memory(4, TextCharacter1Address, InputString, 20, "Unicode")
ChaosTextAdded = 1
outputdebug %CurrentTime% Chaos Text Added
return

; Remove the Chaos% text.
ChaosTextRemove:
Memory(4, TextCharacter1Address, 0, 1) ; Making the first character 0 causes the whole text to disappear.
ChaosTextAdded = 0
outputdebug %CurrentTime% Chaos Text Removed
return


; Some often-used addresses depending on pointers are updated here to avoid having to do that
; every time they are needed in the code. Only update the variables if the game is ready.
UpdateVariableAddresses:
GameStatus := CheckGameStatus() ; 0 for ready, other values for not ready.
If (GameStatus = 0 OR GameStatus = 7)
{
	PlayerStatusAddress := Memory(5, PlayerPointer, PlayerStatusOffset)
	VehicleTypeAddress := Memory(5, CarPointer, VehicleTypeOffset)
}
return

CheckGameStatus()
; Do various checks to see if the game is ready for the effects to be active.
; Various states are reported with separate values to differentiate between them.
; Note that if multiple checks are true, only the first is reported.
{
	global
	InMenuAddress := 0x00A10B36+VersionOffset ; 1 Byte
	if VersionOffset = -4088 ; Steam version
		StillToFadeOutAddress := 0x00A0FB5F ; 1 Byte
	else if VersionOffset = 8
		StillToFadeOutAddress := 0x00A10B5F ; 1 Byte
	else
		StillToFadeOutAddress := 0x00A10B56 ; 1 Byte
	LoadingGameCheckAddress := 0x00974B74+VersionOffset ; 0 if loading a game or changing resolution, 1 otherwise. (DWord)
;	ShuttingDownCheckAddress := 0x006DB8E8 ; 0 if shutting down stuff for restart or quit. Also 0 during initialise. (1 Byte)
	If (Memory(3, GameRunningAddress, 1) = "Fail")
		return 1
	If Memory(3, InTheBeginningDoneAddress, 4) != 1 ; Check if the player isn't loading a game.
		return 5
	If Memory(3, LoadingGameCheckAddress, 4) = 0
		return 3
	If Memory(3, StillToFadeOutAddress, 1) = 1
		return 4
;	If Memory(3, ShuttingDownCheckAddress, 1) = 0
;		return 6
	If Memory(3, InMenuAddress, 1) = 1
		return 2
	PlayerControllableAddress := Memory(5, PlayerPointer, PlayerControllableOffset)
	If Memory(3, PlayerControllableAddress, 1) = 0
		return 7
	return 0
}

GetPseudoRandomValueUpTo(int)
{
	global
	RandomValue := Abs(Floor(((((Tan(Sin(Abs((((ChosenEffect+2)*Seed+5426)/19-(114+Seed))*3)+34*TimedEffectsAvailable+3)+TimedEffectsTotalSelected)+348)**2)+(13*Cycle))+160)/6-4*43))
	RandomValue := Abs(Mod(RandomValue, int))+1
	return RandomValue
}
