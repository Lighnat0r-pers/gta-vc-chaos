/*
About difficulty tiers:
An effect will trigger 1 in %difficulty% cycles. The length of a cycle depends on the total number of effects.
*/


CreateArrays:
; Create the static effects arrays.
CurrentLoopCode := "CreateStaticEffectsArrayCode"
gosub StaticEffectsList ; Populate the static effects arrays.
; Create the permanent effects arrays.
CurrentLoopCode := "CreatePermanentEffectsArrayCode"
gosub PermanentEffectsList ; Populate the permanent effects arrays.
; Create the timed effects arrays.
CurrentLoopCode := "CreateTimedEffectsArrayCode" 
gosub TimedEffectsList ; Populate the timed effects arrays.
return


StaticEffectsList:
StaticEffectName := "CrazyCones"
gosub %CurrentLoopCode%
StaticEffectName := "NoReplay"
gosub %CurrentLoopCode%
return

CreateStaticEffectsArrayCode:
if StaticEffectsArraysCreated != 1
{
;	StaticArrayIndex = 1
	StaticEffectsArray := {} ; List of all the static effects which can be triggered.
	StaticEffectsArraysCreated = 1
}
;else
;	StaticArrayIndex += 1
;StaticEffectsArray.Insert(StaticArrayIndex, StaticEffectName)
StaticEffectsArray.Insert(StaticEffectName)
return


; List of which the permanent effects will be chosen. The program will make arrays
; based on this list because arrays are much easier to use in the code.
; However a list is much easier to update by hand which is why it's still stored like this.
PermanentEffectsList:
; Category Health
PermanentEffectName := "PackageHealth"
PermanentEffectCategory := "Health"
PermanentEffectDifficulty = 4
gosub %CurrentLoopCode%
PermanentEffectName := "Vampire"
PermanentEffectCategory := "Health"
PermanentEffectDifficulty = 4
gosub %CurrentLoopCode%
; Category MissionSuicide
PermanentEffectName := "MissionSuicide"
PermanentEffectCategory := "MissionSuicide"
PermanentEffectDifficulty = 3
gosub %CurrentLoopCode%
; Category CarAnimations
PermanentEffectName := "Flintstone"
PermanentEffectCategory := "CarAnimations"
PermanentEffectDifficulty = 2
gosub %CurrentLoopCode%
PermanentEffectName := "NoDriveBy"
PermanentEffectCategory := "CarAnimations"
PermanentEffectDifficulty = 2
gosub %CurrentLoopCode%
; Category Interface
PermanentEffectName := "Immersion"
PermanentEffectCategory := "Interface"
PermanentEffectDifficulty = 5
gosub %CurrentLoopCode%
;; Category OtherMoney
;PermanentEffectName := "OtherMoney"
;PermanentEffectCategory := "OtherMoney"
;PermanentEffectDifficulty = 1
;gosub %CurrentLoopCode%
; Category Traffic
PermanentEffectName := "AngryDrivers"
PermanentEffectCategory := "Traffic"
PermanentEffectDifficulty = 2
gosub %CurrentLoopCode%
; Category Handling
PermanentEffectName := "Bounce"
PermanentEffectCategory := "Handling"
PermanentEffectDifficulty = 2
gosub %CurrentLoopCode%
PermanentEffectName := "TaxiJump"
PermanentEffectCategory := "Handling"
PermanentEffectDifficulty = 2
gosub %CurrentLoopCode%
; Category CarGraphics
PermanentEffectName := "ImTheInvisibleDriver"
PermanentEffectCategory := "CarGraphics"
PermanentEffectDifficulty = 3
gosub %CurrentLoopCode%
; Category Weapons
PermanentEffectName := "Rayman"
PermanentEffectCategory := "Weapons"
PermanentEffectDifficulty = 2
gosub %CurrentLoopCode%
PermanentEffectName := "NoMagicalBackpack"
PermanentEffectCategory := "Weapons"
PermanentEffectDifficulty = 2
gosub %CurrentLoopCode%
; Category PlayerPhysics
PermanentEffectName := "Marathon"
PermanentEffectCategory := "PlayerPhysics"
PermanentEffectDifficulty = 2
gosub %CurrentLoopCode%
return

; Create the arrays based on the permanent effects list.
; The first time the code is called it will initialize the arrays,
; after that each effect is added to the arrays, with separate arrays
; for the effect name, category and difficulty. Each part of the effect
; can be found in the various arrays by the same index.
; In case no difficulty has been specified, set it to 1. Also blank the difficulty
; at the end of the subroutine to avoid carrying over to the next effect.
CreatePermanentEffectsArrayCode:
if PermanentEffectsArraysCreated != 1
{
;	PermanentArrayIndex = 1
	PermanentEffectsArray := {} ; List of all the permanent effects which can be triggered.
	PermanentCategoriesArray := {} ; Specifies the category for all permanent effects.
	PermanentDifficultiesArray := {} ; Specifies the difficulty for all permanent effects.
	PermanentEffectsActiveArray := {} ; Initialize the array which will contain the effects that are activated.
	PermanentEffectsArraysCreated = 1
}
;else
;	PermanentArrayIndex += 1
if PermanentEffectDifficulty = 
	PermanentEffectDifficulty = 1
;PermanentEffectsArray.Insert(PermanentArrayIndex, PermanentEffectName)
;PermanentCategoriesArray.Insert(PermanentArrayIndex, PermanentEffectCategory)
;PermanentDifficultiesArray.Insert(PermanentArrayIndex, PermanentEffectDifficulty)
PermanentEffectsArray.Insert(PermanentEffectName)
PermanentCategoriesArray.Insert(PermanentEffectCategory)
PermanentDifficultiesArray.Insert(PermanentEffectDifficulty)
PermanentEffectDifficulty = 
return


; List of which the timed effects will be chosen. The program will make arrays
; based on this list because arrays are much easier to use in the code.
; However a list is much easier to update by hand which is why it's still stored like this.
TimedEffectsList:
; Category FlatTire
TimedEffectName := "FlatTire"
TimedEffectCategory := "FlatTire"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
TimedEffectName := "ToFlatTireOrNotToFlatTire"
TimedEffectCategory := "FlatTire"
TimedEffectDifficulty = 1
gosub %CurrentLoopCode%
; Category GUIVisuals
TimedEffectName := "DrunkCam"
TimedEffectCategory := "GUIVisuals"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
TimedEffectName := "ExtremeDrunkCam"
TimedEffectCategory := "GUIVisuals"
TimedEffectDifficulty = 4
gosub %CurrentLoopCode%
; Category EnvironmentVisuals
TimedEffectName := "Interior"
TimedEffectCategory := "EnvironmentVisuals"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
TimedEffectName := "Mirage"
TimedEffectCategory := "EnvironmentVisuals"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
TimedEffectName := "Eclipse"
TimedEffectCategory := "EnvironmentVisuals"
TimedEffectDifficulty = 1
gosub %CurrentLoopCode%
TimedEffectName := "TimeLapse"
TimedEffectCategory := "EnvironmentVisuals"
TimedEffectDifficulty = 1
gosub %CurrentLoopCode%
; Category Wanted
TimedEffectName := "Wanted1"
TimedEffectCategory := "Wanted"
TimedEffectDifficulty = 1
gosub %CurrentLoopCode%
TimedEffectName := "Wanted2"
TimedEffectCategory := "Wanted"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
TimedEffectName := "Wanted3"
TimedEffectCategory := "Wanted"
TimedEffectDifficulty = 3
gosub %CurrentLoopCode%
TimedEffectName := "Wanted4"
TimedEffectCategory := "Wanted"
TimedEffectDifficulty = 3
gosub %CurrentLoopCode%
TimedEffectName := "Wanted5"
TimedEffectCategory := "Wanted"
TimedEffectDifficulty = 4
gosub %CurrentLoopCode%
TimedEffectName := "Wanted6"
TimedEffectCategory := "Wanted"
TimedEffectDifficulty = 5
gosub %CurrentLoopCode%
; Category Gravity
TimedEffectName := "BeamMeUpScotty"
TimedEffectCategory := "Gravity"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
TimedEffectName := "ZeroGravity"
TimedEffectCategory := "Gravity"
TimedEffectDifficulty = 1
gosub %CurrentLoopCode%
TimedEffectName := "QuarterGravity"
TimedEffectCategory := "Gravity"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
TimedEffectName := "HalfGravity"
TimedEffectCategory := "Gravity"
TimedEffectDifficulty = 1
gosub %CurrentLoopCode%
TimedEffectName := "DoubleGravity"
TimedEffectCategory := "Gravity"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
TimedEffectName := "QuadrupleGravity"
TimedEffectCategory := "Gravity"
TimedEffectDifficulty = 3
gosub %CurrentLoopCode%
; Category GameSpeed
TimedEffectName := "QuarterGameSpeed"
TimedEffectCategory := "GameSpeed"
TimedEffectDifficulty = 3
gosub %CurrentLoopCode%
TimedEffectName := "HalfGameSpeed"
TimedEffectCategory := "GameSpeed"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
TimedEffectName := "DoubleGameSpeed"
TimedEffectCategory := "GameSpeed"
TimedEffectDifficulty = 2
TimedEffectWeight = 2
gosub %CurrentLoopCode%
;TimedEffectName := "QuadrupleGameSpeed"
;TimedEffectCategory := "GameSpeed"
;TimedEffectDifficulty = 3
;gosub %CurrentLoopCode%
TimedEffectName := "Lag"
TimedEffectCategory := "GameSpeed"
TimedEffectDifficulty = 1
gosub %CurrentLoopCode%
; Category Traffic
TimedEffectName := "AngryDrivers"
TimedEffectCategory := "Traffic"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
TimedEffectName := "Polaris"
TimedEffectCategory := "Traffic"
TimedEffectDifficulty = 4
gosub %CurrentLoopCode%
TimedEffectName := "GhostTown"
TimedEffectCategory := "Traffic"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
; Category Controls
TimedEffectName := "NoRight"
TimedEffectCategory := "Controls"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
TimedEffectName := "HighDPI"
TimedEffectCategory := "Controls"
TimedEffectDifficulty = 3
gosub %CurrentLoopCode%
TimedEffectName := "LowDPI"
TimedEffectCategory := "Controls"
TimedEffectDifficulty = 3
gosub %CurrentLoopCode%
; Category CarGraphics
TimedEffectName := "RainbowCar"
TimedEffectCategory := "CarGraphics"
TimedEffectDifficulty = 1
gosub %CurrentLoopCode%
TimedEffectName := "ImTheInvisibleDriver"
TimedEffectCategory := "CarGraphics"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
; Category PlayerGraphics
TimedEffectName := "AstralProjection"
TimedEffectCategory := "PlayerGraphics"
TimedEffectDifficulty = 3
gosub %CurrentLoopCode%
; Category PlayerPhysics
TimedEffectName := "Monstertruck"
TimedEffectCategory := "PlayerPhysics"
TimedEffectDifficulty = 3
gosub %CurrentLoopCode%
; Category PlayerAnimations
TimedEffectName := "RandomFall"
TimedEffectCategory := "PlayerAnimations"
TimedEffectDifficulty = 1
TimedEffectWeight = 2
gosub %CurrentLoopCode%
TimedEffectName := "LetsTakeABreak"
TimedEffectCategory := "PlayerAnimations"
TimedEffectDifficulty = 1
gosub %CurrentLoopCode%
TimedEffectName := "PhoneCall"
TimedEffectCategory := "PlayerAnimations"
TimedEffectDifficulty = 1
gosub %CurrentLoopCode%
;TimedEffectName := "EnterCar"
;TimedEffectCategory := "PlayerAnimations"
;TimedEffectDifficulty = 2
;gosub %CurrentLoopCode%
; Category FrameLimiter
TimedEffectName := "FrameLimiter15"
TimedEffectCategory := "FrameLimiter"
TimedEffectDifficulty = 4
gosub %CurrentLoopCode%
TimedEffectName := "FrameLimiter60"
TimedEffectCategory := "FrameLimiter"
TimedEffectDifficulty = 4
gosub %CurrentLoopCode%
; Category Collision
TimedEffectName := "SuddenCarDeath"
TimedEffectCategory := "Collision"
TimedEffectDifficulty = 1
gosub %CurrentLoopCode%
TimedEffectName := "PitStop"
TimedEffectCategory := "Collision"
TimedEffectDifficulty = 1
gosub %CurrentLoopCode%
; Category DrawDistance
TimedEffectName := "ZeroDrawDistance"
TimedEffectCategory := "DrawDistance"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
TimedEffectName := "EighthDrawDistance"
TimedEffectCategory := "DrawDistance"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
TimedEffectName := "QuarterDrawDistance"
TimedEffectCategory := "DrawDistance"
TimedEffectDifficulty = 1
gosub %CurrentLoopCode%
TimedEffectName := "HalfDrawDistance"
TimedEffectCategory := "DrawDistance"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
TimedEffectName := "DoubleDrawDistance"
TimedEffectCategory := "DrawDistance"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
; Category Handling
TimedEffectName := "NoBounce"
TimedEffectCategory := "Handling"
TimedEffectDifficulty = 3
gosub %CurrentLoopCode%
TimedEffectName := "Bounce"
TimedEffectCategory := "Handling"
TimedEffectDifficulty = 1
gosub %CurrentLoopCode%
TimedEffectName := "BouncyBounce"
TimedEffectCategory := "Handling"
TimedEffectDifficulty = 2
gosub %CurrentLoopCode%
TimedEffectName := "TaxiJump"
TimedEffectCategory := "Handling"
TimedEffectDifficulty = 3
gosub %CurrentLoopCode%
;; Category Weather
;TimedEffectName := "RandomWeather"
;TimedEffectCategory := "Weather"
;TimedEffectDifficulty = 2
;gosub %CurrentLoopCode%
; Category Teleport
TimedEffectName := "Home"
TimedEffectCategory := "Teleport"
TimedEffectDifficulty = 4
gosub %CurrentLoopCode%
TimedEffectName := "Rave"
TimedEffectCategory := "Teleport"
TimedEffectDifficulty = 3
gosub %CurrentLoopCode%
TimedEffectName := "Golf"
TimedEffectCategory := "Teleport"
TimedEffectDifficulty = 4
gosub %CurrentLoopCode%
TimedEffectName := "ImOuttaHere"
TimedEffectCategory := "Teleport"
TimedEffectDifficulty = 4
gosub %CurrentLoopCode%
TimedEffectName := "Cubicle"
TimedEffectCategory := "Teleport"
TimedEffectDifficulty = 4
gosub %CurrentLoopCode%
TimedEffectName := "InTheArmy"
TimedEffectCategory := "Teleport"
TimedEffectDifficulty = 4
gosub %CurrentLoopCode%
; Category Weapons
TimedEffectName := "Pacifist"
TimedEffectCategory := "Weapons"
TimedEffectDifficulty = 5
gosub %CurrentLoopCode%
; Category PlayerStats
TimedEffectName := "FullHeal"
TimedEffectCategory := "PlayerStats"
TimedEffectDifficulty = 4
gosub %CurrentLoopCode%
TimedEffectName := "FullArmour"
TimedEffectCategory := "PlayerStats"
TimedEffectDifficulty = 4
gosub %CurrentLoopCode%
return

; Create the arrays based on the timed effects list.
; The first time the code is called it will initialze the arrays,
; after that each effect is added to the arrays, with separate arrays
; for the effect name, category and difficulty. Each part of the effect
; can be found in the various arrays by the same index.
; Each effect is added [weight] times to the arrays.
; In case no weight has been specified, set it to 1. Also blank the weight
; at the end of the subroutine to avoid carrying over to the next effect.
; In case no difficulty has been specified, set it to 1. Also blank the difficulty
; at the end of the subroutine to avoid carrying over to the next effect.
CreateTimedEffectsArrayCode:
if TimedEffectsArraysCreated != 1
{
;	TimedArrayIndex = 1
	TimedEffectsArray := {} ; List of all the timed effects which can be triggered
	TimedCategoriesArray := {} ; Specifies the category for all timed effects
	TimedDifficultiesArray := {} ; Specifies the difficulty for all timed effects
	TimedEffectsArraysCreated = 1
}
;else
;	TimedArrayIndex += 1
if TimedEffectDifficulty = 
	TimedEffectDifficulty = 1
if TimedEffectWeight = 
	TimedEffectWeight = 1
Loop %TimedEffectWeight%
{
;	TimedEffectsArray.Insert(TimedArrayIndex, TimedEffectName)
;	TimedCategoriesArray.Insert(TimedArrayIndex, TimedEffectCategory)
;	TimedDifficultiesArray.Insert(TimedArrayIndex, TimedEffectDifficulty)
	TimedEffectsArray.Insert(TimedEffectName)
	TimedCategoriesArray.Insert(TimedEffectCategory)
	TimedDifficultiesArray.Insert(TimedEffectDifficulty)
}
TimedEffectDifficulty = 
TimedEffectWeight = 
return
