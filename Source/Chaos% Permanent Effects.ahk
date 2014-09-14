; ######################################################################################################
; ########################################## PERMANENT EFFECTS #########################################
; ######################################################################################################

/*
Subheadings:

	Package Health
	Mission Suicide
	Flintstone
	No Drive-By
	Immersion
	Other Money
	Angry Drivers
	Bounce
	I'm The Invisible Driver
	Rayman
	No Magical Backpack
	Vampire
*/

; ###################################### PERMANENT PACKAGE HEALTH ######################################
; ######################################################################################################

; This effect will set the maximum health to double the amount the of hidden packages collected. In
; addition, the current health is checked to make sure it's not higher than the maximum.
; Naturally, a minimum of 2 health is enforced (because the game rounds 1 down to 0).
; When disabling this effect, the maximum health is set back to what it would've been without Chaos%.
; In order to do that, we need to check if pizza delivery has been completed (which makes the maximum 150)
; and if the game has been completed 100% (which makes the maximum 200). If neither is true, the maximum is 100.
PermanentPackageHealthData:
HealthOffset := 0x354
;ArmourOffset := 0x358
HiddenPackagesAddress := 0x0094ADD0+VersionOffset
MaxHealthAddress := 0x0094AE6B+VersionOffset
;MaxArmourAddress := 0x0094AE6C+VersionOffset
PercentageCompletedAddress := 0x00821418+VersionOffset
PizzaDeliveryCompletedAddress := 0x00821894+VersionOffset
MinMaxHealth := 2
return

PermanentPackageHealthActivate:
return

PermanentPackageHealthDeactivate:
if Memory(3, PercentageCompletedAddress, 4, "Float") = 100.0
	Memory(4, MaxHealthAddress, 200, 1)
else if Memory(3, PizzaDeliveryCompletedAddress, 4) = 1
	Memory(4, MaxHealthAddress, 150, 1)
else
	Memory(4, MaxHealthAddress, 100, 1)
return

PermanentPackageHealthUpdate:
NewMaxHealth := Memory(3, HiddenPackagesAddress, 4) * 2
if (NewMaxHealth < MinMaxHealth)
	NewMaxHealth := MinMaxHealth
Memory(4, MaxHealthAddress, NewMaxHealth, 1)
HealthAddress := Memory(5, PlayerPointer, HealthOffset)
if (Memory(3, HealthAddress, 4, "Float") > NewMaxHealth)
	Memory(4, HealthAddress, NewMaxHealth, 4, "Float")
return


; ########################################### HEADSHOT ARMOUR ##########################################
; ######################################################################################################

; Once done, this effect will ste the maximum armour to be related to the number of headshots you have made.
; In this case, it's fine if the maximum armour is 0.0 (I think).
; When disabling this effect, the maximum health is set back to what it would've been without Chaos%.
; In order to do that, we need to check if vigilante has been completed (which makes the maximum 150)
; and if the game has been completed 100% (which makes the maximum 200). If neither is true, the maximum is 100.
;ArmourOffset := 0x358
;MaxArmourAddress := 0x0094AE6C+VersionOffset
;PercentageCompletedAddress := 0x00821418+VersionOffset
;VigilanteCompletedAddress := 0x00822B38+VersionOffset

; ###################################### PERMANENT MISSION SUICIDE #####################################
; ######################################################################################################

; This effect kills the player every time the completion percentage is increased. This is usually at the
; end of a mission so it waits until the mission has been properly finished.
PermanentMissionSuicideData:
PercentageCompletedAddress := 0x00821418+VersionOffset
return

PermanentMissionSuicideActivate:
PercentageOld := Memory(3, PercentageCompletedAddress, 4) ; Store the completion percentage before the check.
return

PermanentMissionSuicideDeactivate:
return

PermanentMissionSuicideUpdate:
PercentageNew := Memory(3, PercentageCompletedAddress, 4)
if (PercentageOld < PercentageNew)
{
	sleep 500 ; To avoid killing the player before the game could properly finish the mission.
	if (Memory(3, OnMissionAddress, 4) = 0)
		Memory(4, PlayerStatusAddress, 55, 1) ; Player status 55 is wasted
	else
		return
}
PercentageOld := PercentageNew
return

; ######################################## PERMANENT FLINTSTONE ########################################
; ######################################################################################################

; This effect causes the infamous walking in car glitch. While controlling a vehicle, the game behaves as
; if the player is walking by showing the walking animations and by using a different control scheme.
; The control scheme is a clear example of the fact that the game is ported from console. The control scheme
; is such that you need to use the on foot controls of which the key number matches the vehicle control you
; want to use. For example, both sprint (on foot) and accelerate (vehicle) have key number 16 (they are on
; the same key when using a controller), so you need to use the sprint key to accelerate when this effect is active.
; Here is a table showing which keys correspond to which commands on foot and in a vehicle:
; Key	OnFoot				Vehicle
;  2	Turn left/right			Look+turret left/Look+turret right
;  3	Look left/right			Turret up/down
;  4	Action key			Radio
;  5	Previous weapon			Look left
;  6	Target				Handbrake
;  7	Next weapon			Look right
;  8	Forward				
;  9	Backwards			
; 10	Strafe left			Turn left
; 11	Strafe right			Turn right
; 12	Used to exit certain modes	Used to exit certain modes
; 13	Change camera mode		Change camera mode
; 14	Jump				Reverse
; 15	Enter vehicle			Exit vehicle
; 16	Sprint				Accelerate
; 17	Shoot/attack			Shoot
; 18	Crouch				Horn
; 19	Look behind			Sub-mission
PermanentFlintstoneData:
return

PermanentFlintstoneActivate:
return

PermanentFlintstoneDeactivate:
if (Memory(3, PlayerStatusAddress, 1) = 9 AND Memory(3, PlayerPointer, 4) != Memory(3, CarPointer, 4)) ; Checks to see if player is in a vehicle and Flintstone is triggered
	Memory(4, PlayerStatusAddress, 50, 1) ; Player status 50 is 'in vehicle', and should deactivate the glitch
return

PermanentFlintstoneUpdate:
if (Memory(3, PlayerStatusAddress, 1) = 50 AND Memory(3, PlayerPointer, 4) != Memory(3, CarPointer, 4)) ; Two checks to see if player is in a vehicle
	Memory(4, PlayerStatusAddress, 9, 1) ; Player status 9 is ped sprinting scared, which is one of many statuses that cause the walking while in car glitch. It seems to never be used on the player, so it's a perfect indication that Flintstone% is activated.
PermanentFlintstoneTimedOut = 1
SetTimer, PermanentFlintstoneUndoTimeOut, -5000 ; Negative time to make it activate only once.
return

PermanentFlintstoneUndoTimeOut:
PermanentFlintstoneTimedOut = 0
return

; ######################################## PERMANENT NO DRIVE-BY #######################################
; ######################################################################################################

; This effect disables the drive-by ability.
PermanentNoDriveByData:
DriveByEnabledAddress := 0x0094AE6F+VersionOffset
return

PermanentNoDriveByActivate:
return

PermanentNoDriveByDeactivate:
Memory(4, DriveByEnabledAddress, 1, 1)
return

PermanentNoDriveByUpdate:
if (Memory(3, DriveByEnabledAddress, 1) = 1)
	Memory(4, DriveByEnabledAddress, 0, 1)
return

; ######################################### PERMANENT IMMERSION ########################################
; ######################################################################################################

; This effect disables all 2D elements on the screen (the complete HUD). Because the radar is gone and 
; probably more importantly, all timers, this effect makes all ways of quickly earning money very difficult,
; which is why it is currently semi-disabled: the difficulty is so high it is never chosen. This effect
; is especially unforgiving because the rendering of the Chaos% text already removes most markers, leaving
; nearly no visual clues as to what the target is in some missions (such as Friendly Rivalry).
PermanentImmersionData:
if VersionOffset = -4088 ; Steam version
	HUDEnabledAddress := 0x00A0FB4E
else
	HUDEnabledAddress := 0x00A10B45+VersionOffset
return

PermanentImmersionActivate:
return

PermanentImmersionDeactivate:
Memory(4, HUDEnabledAddress, 1, 1)
return

PermanentImmersionUpdate:
if (Memory(3, HUDEnabledAddress, 1) = 1)
	Memory(4, HUDEnabledAddress, 0, 1)
return

; ######################################## PERMANENT OTHER MONEY #######################################
; ######################################################################################################

/*
; Once it's done, this effect will change the way money is earned. Essentially a way to get rid of Cone Crazy
; and replace it with something more interesting. One of the main issues with this effect (other than that the
; code here is not yet finished) is that it's difficult to communicate to the player, how money needs to be earned.
; It needs to be displayed ingame, for people with just one monitor, but people must also be able to refer to it at
; all times. Displaying it once and never again would unfairly punish the player for not paying attention to a 
; text message, or for not remembering. Obviously Chaos% shouldn't be a memory exercise.

PermanentOtherMoneyData:
return

PermanentOtherMoneyActivate:
SetTimer, DisableConeCrazy, %RefreshRate%
SetTimer, DisableDirtring, %RefreshRate%
gosub OtherMoneyPoliceHelicopterData
gosub OtherMoneyPoliceHelicopterActivate
return

PermanentOtherMoneyDeactivate:
SetTimer, PermanentDisableConeCrazy, Off
SetTimer, PermanentDisableDirtring, Off
gosub OtherMoneyPoliceHelicopterDeactivate
return


PermanentOtherMoneyPoliceHelicopterData:
PoliceHelicopterRewardAddress := 0x005AD23E ; Find the correct offsets for other versions.
PoliceHelicopterRewardOriginal := 250
PoliceHelicopterRewardTarget := 10000
return

PermanentOtherMoneyPoliceHelicopterActivate:
SetTimer, PermanentPoliceHelicopterRewardUpdate, %RefreshRate%
return

PermanentOtherMoneyPoliceHelicopterDeactivate:
SetTimer, PermanentPoliceHelicopterRewardUpdate, Off
Memory(4, PoliceHelicopterRewardAddress, PoliceHelicopterRewardOriginal, 4)
return

PermanentPoliceHelicopterRewardUpdate:
if (Memory(3, PoliceHelicopterRewardAddress, 4) != PoliceHelicopterRewardTarget)
	Memory(4, PoliceHelicopterRewardAddress, PoliceHelicopterRewardTarget, 4)
return


PermanentDisableConeCrazy:
ConeCrazyRewardAddress := 0x00828E58+VersionOffset
if (Memory(3, ConeCrazyRewardAddress, 4) != 0)
	Memory(4, ConeCrazyRewardAddress, 0, 4)
return

PermanentDisableDirtring:
DirtringCurrentTimeAddress := 0x00828394+VersionOffset
if (Memory(3, DirtringCurrentTimeAddress, 4) != 817000)
	Memory(4, DirtringCurrentTimeAddress, 817000, 4)
return
*/

; ####################################### PERMANENT ANGRY DRIVERS ######################################
; ######################################################################################################

; There are two parts to this effect. The first part changes the speed with which angry drivers go to
; make all vehicles drive at max speed and will make all drivers angry drivers. The second part affects
; collision (previously a separate effect: CrazyCollision%), making it much more extreme. Unfortunately 
; the second part has some downsides: Car explosions don't deal damage. Melee weapons don't hurt peds.
; Destroyed objects such as traffic lights don't move and stay solid.
; I still need to look into why this happens and how to fix it.
PermanentAngryDriversData:
if VersionOffset = -4088 ; Steam version
{
	AngryDriversEnabledAddress := 0x00A0FB50
	AddedSpeedAddress := 0x00428E97
	CollisionAddress := 0x0068E632
}
else
{
	AngryDriversEnabledAddress := 0x00A10B47+VersionOffset
	AddedSpeedAddress := 0x00428EC7
	CollisionAddress := 0x0068F62A
}
OriginalAddedSpeed := 10
PermanentTargetAddedSpeed := 100
OriginalCollision := 16307 ; Short
; No restrictions so return immediately
return

PermanentAngryDriversActivate:
return

PermanentAngryDriversDeactivate:
Memory(4, AddedSpeedAddress, OriginalAddedSpeed, 1)
Memory(4, AngryDriversEnabledAddress, 0, 1)
Memory(4, CollisionAddress, OriginalCollision, 2)
return

PermanentAngryDriversUpdate:
if (Memory(3, AddedSpeedAddress, 1) != PermanentTargetAddedSpeed)
	Memory(4, AddedSpeedAddress, PermanentTargetAddedSpeed, 1)
if (Memory(3, AngryDriversEnabledAddress, 1) != 1)
	Memory(4, AngryDriversEnabledAddress, 1, 1)
if (Memory(3, CollisionAddress, 1) != 0)
	Memory(4, CollisionAddress, 0, 2)
return

; ########################################## PERMANENT BOUNCE ##########################################
; ######################################################################################################

; These effects change the amount of damping done by the suspension of a vehicle.
PermanentBounceData:
if VersionOffset = -4088 
	BounceAddress := 0x0068E5F4
else 
	BounceAddress := 0x0068F5EC
PermanentBounceTarget := 0.07
BounceOriginal := 0.53
return

PermanentBounceActivate:
return

PermanentBounceDeactivate:
if (Memory(3, BounceAddress, 4, "Float") != BounceOriginal)
	Memory(4, BounceAddress, BounceOriginal, 4, "Float")
return

PermanentBounceUpdate:
if (Memory(3, BounceAddress, 4, "Float") != PermanentBounceTarget)
	Memory(4, BounceAddress, PermanentBounceTarget, 4, "Float")
return

; ################################# PERMANENT I'M THE INVISIBLE DRIVER #################################
; ######################################################################################################

; Turns the vehicle Tommy is in invisible.
PermanentImTheInvisibleDriverData:
CarFlagsOffset := 0x52
return

PermanentImTheInvisibleDriverActivate:
return

PermanentImTheInvisibleDriverDeactivate:
if (Memory(3, CarFlagsAddress, 1) = 8)
	Memory(4, CarFlagsAddress, 12, 1)
return

PermanentImTheInvisibleDriverUpdate:
if (Memory(3, PlayerPointer, 4) != Memory(3, CarPointer, 4))
{
	CarFlagsAddress := Memory(5, CarPointer, CarFlagsOffset)
;	outputdebug % Memory(3, PlayerStatusAddress, 1)
	if (Memory(3, PlayerStatusAddress, 1) = 60 OR Memory(3, PlayerStatusAddress, 1) = 57) ; Exiting vehicle or getting carjacked.
	{
;		outputdebug % Memory(3, CarFlagsAddress, 1)
		if (Memory(3, CarFlagsAddress, 1) = 8) ; Make the vehicle visible when exiting it.
			Memory(4, CarFlagsAddress, 12, 1)
	}
	Else if (Memory(3, PlayerStatusAddress, 1) = 50 AND Memory(3, CarFlagsAddress, 1) = 12)
		Memory(4, CarFlagsAddress, 8, 1)
}
return

; ########################################## PERMANENT RAYMAN ##########################################
; ######################################################################################################

; Punching while running will deal massive damage to everything in a sizable radius.
PermanentRaymanData:
If VersionOffset = -4088
	WeaponDatStartAddress := 0x00781A14
Else
	WeaponDatStartAddress := 0x00782A14
WeaponDatStructureSize := 0x64
WeaponDatDamageOffset := 0x14
WeaponDatRadiusOffset := 0x1C
FistWeaponID := 0
FistDamageOriginal := 8
FistDamageTarget := 40000
FistRadiusOriginal := 0.6
FistRadiusTarget := 35.0
return

PermanentRaymanActivate:
return

PermanentRaymanDeactivate:
If Memory(3, WeaponDatStartAddress+WeaponDatStructureSize*FistWeaponID+WeaponDatDamageOffset, 4) != FistDamageOriginal
	Memory(4, WeaponDatStartAddress+WeaponDatStructureSize*FistWeaponID+WeaponDatDamageOffset, FistDamageOriginal, 4)
If Memory(3, WeaponDatStartAddress+WeaponDatStructureSize*FistWeaponID+WeaponDatRadiusOffset, 4, "Float") != FistRadiusOriginal
	Memory(4, WeaponDatStartAddress+WeaponDatStructureSize*FistWeaponID+WeaponDatRadiusOffset, FistRadiusOriginal, 4, "Float")
return

PermanentRaymanUpdate:
If Memory(3, WeaponDatStartAddress+WeaponDatStructureSize*FistWeaponID+WeaponDatDamageOffset, 4) != FistDamageTarget
	Memory(4, WeaponDatStartAddress+WeaponDatStructureSize*FistWeaponID+WeaponDatDamageOffset, FistDamageTarget, 4)
If Memory(3, WeaponDatStartAddress+WeaponDatStructureSize*FistWeaponID+WeaponDatRadiusOffset, 4, "Float") != FistRadiusTarget
	Memory(4, WeaponDatStartAddress+WeaponDatStructureSize*FistWeaponID+WeaponDatRadiusOffset, FistRadiusTarget, 4, "Float")
return

; #################################### PERMANENT NO MAGICAL BACKPACK ###################################
; ######################################################################################################

; This effect will drastically reduce the amount of weapon slots available. The player can only carry one weapon
; at a time. Only throwable weapons such as grenades are exempt from this limitation.
PermanentNoMagicalBackpackData:
If VersionOffset = -4088
	WeaponDatStartAddress := 0x00781A14
Else
	WeaponDatStartAddress := 0x00782A14
WeaponDatStructureSize := 0x64
WeaponDatSlotOffset := 0x60
WeaponsArray := {2:1, 3:1, 4:1, 5:1, 6:1, 7:1, 8:1, 9:1, 10:1, 11:1, 17:3, 18:3, 19:4, 20:4, 21:4, 22:5, 23:5, 24:5, 25:5, 26:6, 27:6, 28:8, 29:8, 30:7, 31:7, 32:7, 33:7} ; WeaponID:OriginalWeaponSlot
WeaponSlotTarget := 3
return

PermanentNoMagicalBackpackActivate:
return

PermanentNoMagicalBackpackDeactivate:
For WeaponID, OriginalWeaponSlot in WeaponsArray
{
	If Memory(3, WeaponDatStartAddress+WeaponID*WeaponDatStructureSize+WeaponDatSlotOffset, 4) != OriginalWeaponSlot
		Memory(4, WeaponDatStartAddress+WeaponID*WeaponDatStructureSize+WeaponDatSlotOffset, OriginalWeaponSlot, 4)
}
return

PermanentNoMagicalBackpackUpdate:
For WeaponID in WeaponsArray
{
	If Memory(3, WeaponDatStartAddress+WeaponID*WeaponDatStructureSize+WeaponDatSlotOffset, 4) != WeaponSlotTarget
		Memory(4, WeaponDatStartAddress+WeaponID*WeaponDatStructureSize+WeaponDatSlotOffset, WeaponSlotTarget, 4)
}
return

; ########################################## PERMANENT VAMPIRE #########################################
; ######################################################################################################

; This effect will give the player health for killing people, but lose health during daytime (while not in an interior).
; To make it more realistic, force the weather to extra sunny during the day.
PermanentVampireData:
Weather1Address := 0x00A10A2E+VersionOffset
Weather2Address := 0x00A10AAA+VersionOffset
HealthOffset := 0x354
InteriorLoadedAddress := 0x00978810+VersionOffset
PeopleKilledAddress := 0x00978794+VersionOffset
HealthPenalty := 1
HealthPerKill := 4
TimeBetweenDamage := 1000 ; In ms
DaytimeStart := 6
DaytimeEnd := 19
WeatherTarget :=  4 ; Extra sunny
return

PermanentVampireActivate:
GameTimeOld := Memory(3, GameTimeAddress, 4)
PeopleKilledOld := Memory(3, PeopleKilledAddress, 4)
return

PermanentVampireDeactivate:
return

PermanentVampireUpdate:
PeopleKilledNew := Memory(3, PeopleKilledAddress, 4)
If (PeopleKilledNew > PeopleKilledOld)
{
	PeopleKilledDifference := PeopleKilledNew-PeopleKilledOld
	HealthGained := PeopleKilledDifference*HealthPerKill
	HealthAddress := Memory(5, PlayerPointer, HealthOffset)
	PlayerHealth := Memory(3, HealthAddress, 4, "Float")
	PlayerHealth := PlayerHealth+HealthGained
	Memory(4, HealthAddress, PlayerHealth, 4, "Float")
	PeopleKilledOld := PeopleKilledNew
}
If (Memory(3, TimeHoursAddress, 1) >= DaytimeStart AND Memory(3, TimeHoursAddress, 1) <= DaytimeEnd AND Memory(3, InteriorLoadedAddress, 1) = 0) ; Check if it is daytime and the player is outside.
{
	If (Memory(3, Weather1Address, 1) != WeatherTarget)
		Memory(4, Weather1Address, WeatherTarget, 1)
	If (Memory(3, Weather2Address, 1) != WeatherTarget)
		Memory(4, Weather2Address, WeatherTarget, 1)
	If (Memory(3, GameTimeAddress, 4) > GameTimeOld+TimeBetweenDamage)
	{
		HealthAddress := Memory(5, PlayerPointer, HealthOffset)
		PlayerHealth := Memory(3, HealthAddress, 4, "Float")
		PlayerHealth := PlayerHealth-HealthPenalty
		if PlayerHealth <= 1 ; 1 instead of 0 because this is how the game does it as well.
			PlayerShouldDie = 1	
		Memory(4, HealthAddress, PlayerHealth, 4, "Float")
		GameTimeOld := Memory(3, GameTimeAddress, 4)
		If PlayerShouldDie = 1
		{
			Memory(4, PlayerStatusAddress, 55, 1) ; Player status 55 is wasted
			PlayerShouldDie = 0
		}
	}
}
return

; ######################################### PERMANENT TAXI JUMP ########################################
; ######################################################################################################

; This effect will turn on the taxi jump ability, and set the vehicle the player is currently in
; as one of the vehicle that can jump. The effect doesn't work on bikes or boats or heli's, but it
; doesn't cause any problems either so we don't have to protect against that.
PermanentTaxiJumpData:
VehicleIDOffset := 0x5C
TaxiJumpModel1Original := 150
If VersionOffset = -4088 ; Steam
{
	TaxiJumpModel1Address := 0x00592ED0
	TaxiJumpEnabledAddress := 0x00A0FB43
}
else
{
	if VersionOffset = 8 ; V1.1
		TaxiJumpModel1Address := 0x0059310C
	else
		TaxiJumpModel1Address := 0x005930EC

	TaxiJumpEnabledAddress := 0x00A10B3A+VersionOffset
}

TaxiFaresCompletedAddress := 0x00821844+VersionOffset
return


PermanentTaxiJumpActivate:
if (Memory(3, TaxiJumpEnabledAddress, 1) != 1)
	Memory(4, TaxiJumpEnabledAddress, 1, 1)
return

PermanentTaxiJumpDeactivate:
if (Memory(3, TaxiJumpModel1Address, 1) != 150)
	Memory(4, TaxiJumpModel1Address, 150, 1)
if (Memory(3, TaxiFaresCompletedAddress, 4) < 100)
{
	if (Memory(3, TaxiJumpEnabledAddress, 1) != 0)
		Memory(4, TaxiJumpEnabledAddress, 0, 1)
}
else
{
	if (Memory(3, TaxiJumpEnabledAddress, 1) != 1)
		Memory(4, TaxiJumpEnabledAddress, 1, 1)
}
return

PermanentTaxiJumpUpdate:
if (Memory(3, PlayerPointer, 4) != Memory(3, CarPointer, 4)) ; player in vehicle
{
	VehicleIDAddress := Memory(5, CarPointer, VehicleIDOffset)
	VehicleID := Memory(3, VehicleIDAddress, 1)
	if (Memory(3, TaxiJumpModel1Address, 1) != VehicleID)
		Memory(4, TaxiJumpModel1Address, VehicleID, 1)
}
return

; ######################################### PERMANENT MARATHON #########################################
; ######################################################################################################

; Messes with the running animation stuff of the player. This has the effect that the player can't stand still anymore
; (the stop sprinting animation will keep looping instead). When running forward, you will get the sprint animation
; but only move VERY slowly. Holding sprint will fold Tommy sideways i.e. you don't move at all. By tapping sprint
; at the right pace (figure it out) you can reach insane speeds though. Once you've reached a high speed you can
; stop tapping sprint and keep the speed as long as you hold any of the movement (WSAD) keys.
PermanentMarathonData:
RunAnimationTarget := 2
RunAnimationOriginal := 1
SomeFloatTarget := -.001
SomeFloatOriginal := 0.0
If VersionOffset = -4088 ; Steam
{
	
	RunAnimationAddress := 0x00536C25-272
	SomeFloatAddress := 0x00694A7C-0xFF8

}
else if VersionOffset = 8 ; V1.1
{
	RunAnimationAddress := 0x00536C25+32
	SomeFloatAddress := 0x00694A7C+0
}
else
{
	RunAnimationAddress := 0x00536C25
	SomeFloatAddress := 0x00694A7C
}
return


PermanentMarathonActivate:
PermanentMarathonUpdate:
if (Memory(3, RunAnimationAddress, 1) != RunAnimationTarget)
	Memory(4, RunAnimationAddress, RunAnimationTarget, 1)
if (Memory(3, SomeFloatAddress, 4, "Float") != SomeFloatTarget)
	Memory(4, SomeFloatAddress, SomeFloatTarget, 4, "Float")
return

PermanentMarathonDeactivate:
if (Memory(3, RunAnimationAddress, 1) != RunAnimationOriginal)
	Memory(4, RunAnimationAddress, RunAnimationOriginal, 1)
if (Memory(3, SomeFloatAddress, 4, "Float") != SomeFloatOriginal)
	Memory(4, SomeFloatAddress, SomeFloatOriginal, 4, "Float")
return
