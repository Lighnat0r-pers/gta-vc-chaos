CheckOnFoot:
if (Memory(3, PlayerPointer, 4) = Memory(3, CarPointer, 4) OR Memory(3, PlayerStatusAddress, 1) != 50) ; Check if player is not in a vehicle, double check for avoiding softlocks in cutscenes
	SkipTimedEffect = 1
return

CheckInVehicle:
if (Memory(3, PlayerPointer, 4) != Memory(3, CarPointer, 4)) ; Check if player is in a vehicle
	SkipTimedEffect = 1
return

CheckInBoat:
if Memory(3, VehicleTypeAddress, 1) = 1 ; Check if player is in a boat
	SkipTimedEffect = 1
return

CheckDuringDistribution:
if (Memory(3, OnMissionAddress, 1) = 1) ; Don't trigger wanted% during cherry poppers
	if (VCGetMissionName() = "Distribution")
		SkipTimedEffect = 1
return

CheckOnFootNormalStatus:
if (Memory(3, PlayerStatusAddress, 1) != 1) ; Reduces softlock chance, this is probably too limited though
	SkipTimedEffect = 1
return

CheckNormalStatus:
if (Memory(3, PlayerStatusAddress, 1) != 1 AND Memory(3, PlayerStatusAddress, 1) != 50) ; This should prevent softlocks
	SkipTimedEffect = 1
return

CheckAngryDriversPermanent:
If (IsInArray(PermanentEffectsActiveArray, "AngryDrivers")) ; Check if the permanent effect "AngryDrivers" is active
	SkipTimedEffect = 1
return

CheckImTheInvisibleDriverPermanent:
If (IsInArray(PermanentEffectsActiveArray, "ImTheInvisibleDriver")) ; Check if the permanent effect "ImTheInvisibleDriver" is active
	SkipTimedEffect = 1
return

CheckBouncePermanent:
If (IsInArray(PermanentEffectsActiveArray, "Bounce")) ; Check if the permanent effect "Bounce" is active
	SkipTimedEffect = 1
return


CheckVehicleNotCar:
if Memory(3, VehicleTypeAddress, 1) != 0 ; Check if player is in anything other than a car (heli counts as car unfortunately)
	SkipTimedEffect = 1
return

CheckVehicleLowHealth:
CarHealthAddress := Memory(5, CarPointer, CarHealthOffset)
if (Memory(3, CarHealthAddress, 4, "Float") < 500.0) ; Only activate if the vehicle has more than 1/3 of its health left.
	SkipTimedEffect = 1
return

CheckSanicExtraDifficulty:
if SanicModeEnabled = 1
{
	SanicModeAdditionalDifficultyCheck := GetPseudoRandomValueUpTo(SanicModeAdditionalDifficulty)
	if SanicModeAdditionalDifficultyCheck != 1
		SkipTimedEffect = 1
}
return

CheckInInterior:
if (Memory(3, InteriorLoadedAddress, 1) != InteriorOutside) ; Check if player is not outside.
	SkipTimedEffect = 1
return

CheckOnMission:
If (Memory(3, OnMissionAddress, 4) = 1) ; Check if the player is on a mission (note: phone calls also count as missions here)
	SkipTimedEffect = 1
return

CheckOnNotRealMission:
OnNotRealMissionAddress := 0x008224F0+VersionOffset
MissionValue := Memory(3, OnMissionAddress, 4) + Memory(3, OnNotRealMissionAddress, 4)
If (MissionValue != 1) ; Phone calls etc set both the OnMission and OnNotRealMission flag and we don't want to activate the effect during a phone call.
	SkipTimedEffect = 1
return

CheckPlayerHasAnyWeapon:
SkipTimedEffect = 1
Loop %WeaponsStructureAmount%
	if Memory(3, WeaponStructureAddress+A_Index*WeaponStructureSize+WeaponAmmoOffset, 4) = 0
	{
		SkipTimedEffect = 0
		break
	}
return
