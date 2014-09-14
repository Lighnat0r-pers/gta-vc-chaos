; ######################################################################################################
; ########################################### WELCOME WINDOW ###########################################
; ######################################################################################################

/*
Subheadings:

	WelcomeScreen
	GuiContextMenu
	CheckboxTimedEffectsEnabled
	GuiClose/GuiEscape/ButtonClose
	ButtonConfirm
	SetDifficultyLimit
	DecodeSeed
	RemovePermanentEffectsInCategoryFromArrays
*/

; Create the welcome screen where the user has to specify the seed. It also shows some information
; about how to use the autosave feature, as well as options to disable timed effects or to enable sanic mode.
WelcomeScreen:
gui 1:-MinimizeBox -MaximizeBox +LastFound
Gui, 1:Font, Q3
gui, 1:Add, Text,, Welcome to Chaos`% v%CurrentVersion%!
If SeedValidLength in 8,11,18,80,81,82,83,84,85,86,87,88,89 ; All numbers which should be preceded by "an" instead of "a" up to 100
	gui, 1:Add, Text,, Please enter an %SeedValidLength% digit seed below`:
else
	gui, 1:Add, Text,, Please enter a %SeedValidLength% digit seed below`:
gui, 1:Add, Edit, vSeed +Number limit%SeedValidLength%, 
gui, 1:Add, Text,, Difficulty`:
gui, 1:Add, Radio, vDifficultySetting section, Easy
gui, 1:Add, Radio, ys Checked, Medium
gui, 1:Add, Radio, ys, Hard
gui, 1:Add, Text, xs, F5 will quicksave the game if not in a `nvehicle or on a mission. After a crash, `npress F5 in the main menu to restore `nthe save.
gui, 1:Add, Button, gToggleOptions, Show advanced options
gui, 1:Add, Checkbox, vStaticEffectsEnabled Checked1 Hidden, Static effects enabled
gui, 1:Add, Checkbox, gCheckboxTimedEffectsEnabled vTimedEffectsEnabled Checked1 Hidden, Timed effects enabled
gui, 1:Add, Checkbox, vSanicModeEnabled Hidden, Sånic mode enabled
gui, 1:Add, Button, section default, Confirm
gui, 1:Add, Button, ys, Close
gui, 1:Show
return

ToggleOptions:
GuiControlGet, OptionsVisible, Visible, StaticEffectsEnabled
if OptionsVisible = 0
{
	GuiControl, 1:Show, StaticEffectsEnabled
	GuiControl, 1:Show, TimedEffectsEnabled
	GuiControl, 1:Show, SanicModeEnabled
}
else
{
	GuiControl, 1:Hide, StaticEffectsEnabled
	GuiControl, 1: , StaticEffectsEnabled, 1
	GuiControl, 1:Hide, TimedEffectsEnabled
	GuiControl, 1: , TimedEffectsEnabled, 1
	GuiControl, 1:Hide, SanicModeEnabled
	GuiControl, 1: , SanicModeEnabled, 0
	GuiControl, 1:Enable, SanicModeEnabled
}
return

; Create a context menu if the user right clicks on the window.
GuiContextMenu:
Menu, OutputRightClick, Add, Restart Program, RestartSequence
Menu, OutputRightClick, Add, Open Readme, OpenReadme
Menu, OutputRightClick, Add, Exit, GuiClose
Menu, OutputRightClick, Show
return

; If timed effects are disabled, disable sanic mode and grey out the sanic mode checkbox.
; Sanic mode only affects the timed effects so it doesn't make sense to be able to enable it without timed effects.
CheckboxTimedEffectsEnabled:
GuiControlGet, TimedEffectsEnabled,1:, TimedEffectsEnabled
if TimedEffectsEnabled = 0
{
	GuiControl, 1:Disable, SanicModeEnabled
	GuiControl, 1:, SanicModeEnabled, 0
}
else
	GuiControl, 1:Enable, SanicModeEnabled
return

; What happens if the user tries to close the window.
GuiClose:
GuiEscape:
ButtonClose:
CurrentGUI = 1
exitapp
return

; If the user confirms, check if the seed has been entered correctly.
; Show an error message if it hasn't, otherwise process the seed to 
; determine which permanent effects have to be activated. 
; After that, go to the subroutine that creates the output window if 
; the timed or permanent effects are enabled (not that it's likely to
; not be the case since the program doesn't really affect anything if
; both are disabled). Once the window is done go to the MainScript.
ButtonConfirm:
Gui, 1:Submit
SeedLength := StrLen(Seed)
if (SeedLength != SeedValidLength)
{
	Msgbox,  Please enter a valid seed of length %SeedValidLength%.
	Gui, 1:Restore
	return
}
gosub DecodeSeed
if (PermanentEffectsEnabled = 1 OR TimedEffectsEnabled = 1 OR StaticEffectsEnabled = 1)
	gosub OutputWindow
goto MainScript



; Set the limit of the amount of permanent effects based on difficulty.
; The limit depends on the setting chosen in the welcome window.
; Optionally, a debug setting can override the difficulty limit.
SetDifficultyLimit:
if (DifficultySetting = 1) ; Easy
{
	DifficultyLimit = 4
	DifficultySetting := "Easy"
}
else if (DifficultySetting = 2) ; Medium
{
	DifficultyLimit = 7
	DifficultySetting := "Medium"
}
else if (DifficultySetting = 3) ; Hard
{
	DifficultyLimit = 10
	DifficultySetting := "Hard"
}
else ; just in case
{
	DifficultyLimit = 10
	DifficultySetting := "Error"
}
if DebugDifficultyLimitEnabled = 1
	DifficultyLimit := DebugDifficultyLimit
return

; Based on the seed, determine which permanent effects should be activated.
DecodeSeed:
; Check what the difficulty limit is.
gosub SetDifficultyLimit
; Make a special case of seed 0000, which doesn't activate any permanent effects.
if Seed = 0
	return
; Set some variables that are used later, initialize the temporary arrays that will be changed later. 
; The RequiredEffect variable determines which effect is chosen and is calculated by performing an
; arbitrary mathematical operation on the seed.
PermanentEffectsEnabled = 1
DifficultySum = 0
RequiredEffect := Abs(Floor(((((Tan(Sin(Abs((((CurrentVersion+2)*Seed+5426)/19-(114+Seed))*3)+34*PermanentEffectsAvailable+3)+37)+348)*DifficultyLimit*2)+(13*SeedValidLength))+160)/6-RefreshRate*43+StandardTimeBetweenEffects*StandardTimeBetweenEffects))
TempPermanentEffectsArray := PermanentEffectsArray.Clone()
TempPermanentCategoriesArray := PermanentCategoriesArray.Clone()
TempPermanentDifficultiesArray := PermanentDifficultiesArray.Clone()
Temp2PermanentDifficultiesArray := PermanentDifficultiesArray.Clone()
; Keep picking new effects until the difficulty limit has been exceeded. This allows
; for some variation (depending on the difficulty of the last effect that is added),
; but makes sure all seeds have a similar difficulty. If an effect has a difficulty
; higher than 1 a copy of the difficulty will be reduced by 3 every time. It only gets
; added if it picks the effect and that value is 1 or less. This makes sure effects
; with a high difficulty are not as common. At the end on the loop the RequiredEffect
; variable is changed by an arbitrary mathematical operation to determine the effect
; that will be picked in the next cycle.
loop
{

	PermanentEffectsAvailable := TempPermanentEffectsArray.MaxIndex()
	RequiredEffect := Abs(Mod(RequiredEffect, PermanentEffectsAvailable)+1)
	PermanentEffectName := TempPermanentEffectsArray[RequiredEffect]
	PermanentEffectCategory := TempPermanentCategoriesArray[RequiredEffect]
	PermanentEffectDifficulty := Temp2PermanentDifficultiesArray[RequiredEffect]
	if (PermanentEffectDifficulty <= 1)
	{
		PermanentEffectsActiveArray.Insert(PermanentEffectName) ; Add effect name to array.
		DifficultySum := DifficultySum + TempPermanentDifficultiesArray[RequiredEffect]
		if (DifficultySum >= DifficultyLimit)
			break
		gosub RemovePermanentEffectsInCategoryFromArrays
	}
	else
		Temp2PermanentDifficultiesArray[RequiredEffect] := PermanentEffectDifficulty - 3
	RequiredEffect := RequiredEffect + Round(Abs(Floor(((((Tan(Sin(Abs((((CurrentVersion+2)*Seed+5426)/19-(114+Seed))*3)+34*PermanentEffectsAvailable+3)+37)+348)*DifficultyLimit*2)+(13*SeedValidLength))+160)/6-RefreshRate*43+StandardTimeBetweenEffects*StandardTimeBetweenEffects)))
}
return

; Remove all the effects in the same category as the currently chosen one to avoid
; activating the same category more than once in a cycle. The effects can't be removed
; inside the For loop because that would screw up the index count.
RemovePermanentEffectsInCategoryFromArrays:
IndicesToBeRemoved = 
For Index, Category in TempPermanentCategoriesArray
{
	If (PermanentEffectCategory = Category)
		IndicesToBeRemoved := Index . "." . IndicesToBeRemoved
}
StringSplit, IndicesToBeRemovedArray, IndicesToBeRemoved, `.
IndicesToBeRemovedArray0 -= 1 ; To account for the empty part which is created the first time an index is added because IndicesToBeRemoved is empty at that point.
; We need to go from high to low in the indices we will remove, because
; otherwise we'd move items we want to remove and remove something else instead.
Loop %IndicesToBeRemovedArray0%
{
	Index := IndicesToBeRemovedArray%A_Index%
	TempPermanentEffectsArray.Remove(Index)
	TempPermanentCategoriesArray.Remove(Index)
	TempPermanentDifficultiesArray.Remove(Index)
	Temp2PermanentDifficultiesArray.Remove(Index)
}
; Also remove the effects in the same category from the timed effects since we
; don't want to have a permanent and timed effect of the same category active
; at the same time. The effects can't be removed inside the For loop because
; that would screw up the index count.
IndicesToBeRemoved = 
For Index, Category in TimedEffectsArray
{
	If (PermanentEffectCategory = Category)
		IndicesToBeRemoved := Index . "." . IndicesToBeRemoved
}
StringSplit, IndicesToBeRemovedArray, IndicesToBeRemoved, `.
IndicesToBeRemovedArray0 -= 1 ; To account for the empty part which is created the first time an index is added because IndicesToBeRemoved is empty at that point.
; We need to go from high to low in the indices we will remove, because
; otherwise we'd move items we want to remove and remove something else instead.
Loop %IndicesToBeRemovedArray0%
{
	Index := IndicesToBeRemovedArray%A_Index%
	TimedEffectsArray.Remove(Index)
	TimedCategoriesArray.Remove(Index)
	TimedDifficultiesArray.Remove(Index)
}
return
