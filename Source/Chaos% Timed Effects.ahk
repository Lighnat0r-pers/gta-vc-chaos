/*
Data for timed effects:
[%TimedEffectName%ContinuouslyActivate = 1] 		defaults to 0
[%TimedEffectName%Time := {Time in ms}] 		defaults to %StandardTimeBetweenEffects%
*/



; ######################################################################################################
; ############################################### TIMED EFFECTS ########################################
; ######################################################################################################

/*
Subheadings:

	Flat Tire
	To Flat Tire Or Not To Flat Tire
	Drunk Cam
	Wanted (1, 2, 3, 4, 5, 6)
	Gravity (Zero, Quarter, Half, Double, Quadruple, Beam me up Scotty)
	Game Speed (Quarter, Half, Double, Quadruple, Lag)	
	Angry Drivers
	No Right
	Rainbow Car
	Random Fall
	Lets Take A Break
	Phone Call
	Enter Car
	I'm The Invisible Driver
	Frame Limiter (15, 60)
	Sudden Car Death
	Pit Stop
	Interior
	Polaris
	Mirage
	Draw Distance (Zero, Eighth, Quarter, Half, Double)
	Bounce (NoBounce, Bounce, BouncyBounce)
	Random Weather
	Eclips
	Astral Projection
	Teleport (Home, Rave)
	Ghost Town
	Mouse Sensitivity (LowDPI, HighDPI)
	Pacifist
*/

; ######################################################################################################
; ################################################# FLAT TIRE ##########################################
; ######################################################################################################

; This effect flattens all tires of a bike, and three out of four tires on cars, because flattening all 
; four tires doesn't really affect how the car handles (other than slowing it down).
FlatTireData:
TireFrontLeftOffset := 0x2A5
TireRearLeftOffset := 0x2A6
TireFrontRightOffset := 0x2A7
TireRearRightOffset := 0x2A8
BikeTireFrontOffset := 0x32C
BikeTireRearOffset := 0x32D
%TimedEffectName%Time := 10000
if (Memory(3, PlayerPointer, 4) = Memory(3, CarPointer, 4)) ; Check if player is not in a vehicle
	SkipTimedEffect = 1
if Memory(3, VehicleTypeAddress, 1) = 1 ; Check if player is in a boat
	SkipTimedEffect = 1
return


FlatTireActivate:
if Memory(3, VehicleTypeAddress, 1) = 5 ; Check if player is on a bike
{
	BikeTireFrontAddress := Memory(5, CarPointer, BikeTireFrontOffset)
	BikeTireRearAddress := Memory(5, CarPointer, BikeTireRearOffset)
	if Memory(3, BikeTireFrontAddress, 1) != 1
		Memory(4, BikeTireFrontAddress, 1, 1)
	if Memory(3, BikeTireRearAddress, 1) != 1
		Memory(4, BikeTireRearAddress, 1, 1)
}
if Memory(3, VehicleTypeAddress, 1) = 0 ; Check if player is in a car
{
	TireFrontLeftAddress := Memory(5, CarPointer, TireFrontLeftOffset)
	TireRearLeftAddress := Memory(5, CarPointer, TireRearLeftOffset)
	TireFrontRightAddress := Memory(5, CarPointer, TireFrontRightOffset)
	TireRearRightAddress := Memory(5, CarPointer, TireRearRightOffset)
	if Memory(3, TireFrontLeftAddress, 1) != 1
		Memory(4, TireFrontLeftAddress, 1, 1)
	if Memory(3, TireRearLeftAddress, 1) != 1
		Memory(4, TireRearLeftAddress, 1, 1)
;	if Memory(3, TireFrontRightAddress, 1) != 1
;		Memory(4, TireFrontRightAddress, 1, 1)
	if Memory(3, TireRearRightAddress, 1) != 1
		Memory(4, TireRearRightAddress, 1, 1)
}
return


FlatTireDeactivate:
; We don't want to fix the tires, so return immediately
return

; ######################################################################################################
; #################################### TO FLAT TIRE OR NOT TO FLAT TIRE ################################
; ######################################################################################################

; This effect will quickly cycle through flattened and intact tires on the vehicle. It will always end
; with fixed tires.
ToFlatTireOrNotToFlatTireData:
TireFrontLeftOffset := 0x2A5
TireRearLeftOffset := 0x2A6
TireFrontRightOffset := 0x2A7
TireRearRightOffset := 0x2A8
BikeTireFrontOffset := 0x32C
BikeTireRearOffset := 0x32D
%TimedEffectName%ContinuouslyActivate = 1
if (Memory(3, PlayerPointer, 4) = Memory(3, CarPointer, 4) OR Memory(3, PlayerStatusAddress, 1) != 50) ; Check if player is not in a vehicle, double check for avoiding softlocks in cutscenes
	SkipTimedEffect = 1
if Memory(3, VehicleTypeAddress, 1) = 1 ; Check if player is in a boat
	SkipTimedEffect = 1
return


ToFlatTireOrNotToFlatTireActivate:
if Memory(3, VehicleTypeAddress, 1) = 5 ; Check if player is on a bike
{
	BikeTireFrontAddress := Memory(5, CarPointer, BikeTireFrontOffset)
	BikeTireRearAddress := Memory(5, CarPointer, BikeTireRearOffset)
	if Memory(3, BikeTireFrontAddress, 1) != 1
		Memory(4, BikeTireFrontAddress, 1, 1)
	else
		Memory(4, BikeTireFrontAddress, 0, 1)
	if Memory(3, BikeTireRearAddress, 1) != 1
		Memory(4, BikeTireRearAddress, 1, 1)
	else
		Memory(4, BikeTireRearAddress, 0, 1)
}
if Memory(3, VehicleTypeAddress, 1) = 0 ; Check if player is in a car
{
	TireFrontLeftAddress := Memory(5, CarPointer, TireFrontLeftOffset)
	TireRearLeftAddress := Memory(5, CarPointer, TireRearLeftOffset)
	TireFrontRightAddress := Memory(5, CarPointer, TireFrontRightOffset)
	TireRearRightAddress := Memory(5, CarPointer, TireRearRightOffset)
	if Memory(3, TireFrontLeftAddress, 1) != 1
		Memory(4, TireFrontLeftAddress, 1, 1)
	else
		Memory(4, TireFrontLeftAddress, 0, 1)
	if Memory(3, TireRearLeftAddress, 1) != 1
		Memory(4, TireRearLeftAddress, 1, 1)
	else
		Memory(4, TireRearLeftAddress, 0, 1)
;	if Memory(3, TireFrontRightAddress, 1) != 1
;		Memory(4, TireFrontRightAddress, 1, 1)
;	else
;		Memory(4, TireFrontRightAddress, 0, 1)
	if Memory(3, TireRearRightAddress, 1) != 1
		Memory(4, TireRearRightAddress, 1, 1)
	else
		Memory(4, TireRearRightAddress, 0, 1)
}
sleep 500
return


ToFlatTireOrNotToFlatTireDeactivate:
if Memory(3, VehicleTypeAddress, 1) = 5 ; Check if player is on a bike
{
	BikeTireFrontAddress := Memory(5, CarPointer, BikeTireFrontOffset)
	BikeTireRearAddress := Memory(5, CarPointer, BikeTireRearOffset)
	if Memory(3, BikeTireFrontAddress, 1) != 0
		Memory(4, BikeTireFrontAddress, 0, 1)
	if Memory(3, BikeTireRearAddress, 1) != 0
		Memory(4, BikeTireRearAddress, 0, 1)
}
if Memory(3, VehicleTypeAddress, 1) = 0 ; Check if player is in a car
{
	TireFrontLeftAddress := Memory(5, CarPointer, TireFrontLeftOffset)
	TireRearLeftAddress := Memory(5, CarPointer, TireRearLeftOffset)
	TireFrontRightAddress := Memory(5, CarPointer, TireFrontRightOffset)
	TireRearRightAddress := Memory(5, CarPointer, TireRearRightOffset)
	if Memory(3, TireFrontLeftAddress, 1) != 0
		Memory(4, TireFrontLeftAddress, 0, 1)
	if Memory(3, TireRearLeftAddress, 1) != 0
		Memory(4, TireRearLeftAddress, 0, 1)
;	if Memory(3, TireFrontRightAddress, 1) != 0
;		Memory(4, TireFrontRightAddress, 0, 1)
	if Memory(3, TireRearRightAddress, 1) != 0
		Memory(4, TireRearRightAddress, 0, 1)
}
return

; ######################################################################################################
; ################################################# DRUNK CAM ##########################################
; ######################################################################################################

; Activates the drunk camera most famously featured in the mission Boomshine Saigon. The drunk camera 
; causes the aim to be off, the camera to swing from side to side and adds a white haze.
DrunkCamData:
DrunkCameraOffset = 0x638
DrunkCameraMaximum = 255
DrunkCameraMinimum = 0 ; 0 keeps the current value so does not turn it off per se, but since it fades in/out it's fine.
; DrunkCameraTarget = 0 ; Define the variable to make the math operations on it valid.
DrunkCameraDelta = 4
%TimedEffectName%Time := StandardTimeBetweenEffects-1000 ; To account for the time it takes to activate the effect
return

DrunkCamActivate:
DrunkCameraCurrentTarget := DrunkCameraMaximum
SetTimer, DrunkCamUpdate, %RefreshRate%
return

DrunkCamDeactivate:
DrunkCameraCurrentTarget := DrunkCameraMinimum
DrunkCameraDelta := -DrunkCameraDelta
return

; Enable/Disable the effect. Also keep it locked on while the effect is active.
; Doing this in a separate timer instead of the Activate and Deactivate subroutines
; makes the effect more compatible with shorter effect lengths (e.g. Sånic mode) since
; the effect can only be deactivated if the activate subroutine is done, which would 
; otherwise take a while.
DrunkCamUpdate:
DrunkCameraAddress := Memory(5, PlayerPointer, DrunkCameraOffset)
While (Memory(3, DrunkCameraAddress, 1) != DrunkCameraCurrentTarget) ; Fancy fade-in/out. 255 is on, 1 is off
{
	DrunkCameraAddress := Memory(5, PlayerPointer, DrunkCameraOffset)
	DrunkCameraTarget := Memory(3, DrunkCameraAddress, 1)
	DrunkCameraTarget := DrunkCameraTarget + DrunkCameraDelta
	if DrunkCameraTarget NOT BETWEEN %DrunkCameraMinimum% AND %DrunkCameraMaximum% ; Make sure the target value is valid.
		DrunkCameraTarget := DrunkCameraCurrentTarget
	Memory(4, DrunkCameraAddress, DrunkCameraTarget, 1)
	sleep %RefreshRate%
}
if (DrunkCameraCurrentTarget = DrunkCameraMinimum)
{
	SetTimer, DrunkCamUpdate, Off
	Memory(4, DrunkCameraAddress, 1, 1) ; Just to be sure it does deactivate.
}
return

; ######################################################################################################
; ################################################## WANTED ############################################
; ######################################################################################################

; These effects give the player a certain wanted level. Fairly straightforward.
Wanted1Data:
TargetWantedLevel = 1
gosub WantedGenericData
return

Wanted2Data:
TargetWantedLevel = 2
gosub WantedGenericData
return

Wanted3Data:
TargetWantedLevel = 3
gosub WantedGenericData
return

Wanted4Data:
TargetWantedLevel = 4
gosub WantedGenericData
return

Wanted5Data:
TargetWantedLevel = 5
gosub WantedGenericData
return

Wanted6Data:
TargetWantedLevel = 6
gosub WantedGenericData
return


WantedGenericData:
WantedLevelArray := {0:0, 1:120, 2:350, 3:900, 4:1800, 5:3600, 6:7200}
WantedPointerOffset := 0x5F4
; Crime rating address is +0x0 from the wanted level pointer so the offset doesn't need to be defined.
WantedLevelAddressOffset := 0x20
if VersionOffset = -4088 ; v1.0 and v1.1 have the same address
{
	MaxWantedLevelAddress := 0x006910D8+VersionOffset
	MaxCrimeRatingAddress := 0x006910DC+VersionOffset
}
else
{
	MaxWantedLevelAddress := 0x006910D8
	MaxCrimeRatingAddress := 0x006910DC
}
%TimedEffectName%Time := 5000 * TargetWantedLevel ; The length of the effect depends on the target wanted level.
if (Memory(3, OnMissionAddress, 1) = 1) ; Don't trigger wanted% during cherry poppers
{
	If (VCGetMissionName() = "Distribution")
		SkipTimedEffect = 1
}
if SanicModeEnabled = 1
{
	SanicModeAdditionalDifficulty := GetPseudoRandomValueUpTo(2)
	if SanicModeAdditionalDifficulty != 1
		SkipTimedEffect = 1
}
return

Wanted1Activate:
Wanted2Activate:
Wanted3Activate:
Wanted4Activate:
Wanted5Activate:
Wanted6Activate:
WantedPointer := Memory(5, PlayerPointer, WantedPointerOffset)
CrimeRatingAddress := Memory(5, WantedPointer, 0x0)
WantedLevelAddress := Memory(5, WantedPointer, WantedLevelAddressOffset)
CurrentWantedLevel := Memory(3, WantedLevelAddress, 1)	
CurrentMaxWantedLevel := Memory(3, MaxWantedLevelAddress, 1)
if (CurrentMaxWantedLevel < TargetWantedLevel)
{	
	NewMaxWantedLevel := TargetWantedLevel
	NewMaxCrimeRating := WantedLevelArray[NewMaxWantedLevel]
	Memory(4, MaxWantedLevelAddress, NewMaxWantedLevel, 1)
	Memory(4, MaxCrimeRatingAddress, NewMaxCrimeRating, 4)
} 
if (CurrentWantedLevel < TargetWantedLevel)
{	
	NewWantedLevel := TargetWantedLevel
	NewCrimeRating := WantedLevelArray[NewWantedLevel]
	Memory(4, WantedLevelAddress, NewWantedLevel, 1)
	Memory(4, CrimeRatingAddress, NewCrimeRating, 4)
}
return

Wanted1Deactivate:
Wanted2Deactivate:
Wanted3Deactivate:
Wanted4Deactivate:
Wanted5Deactivate:
Wanted6Deactivate:
; We don't want to remove the wanted level, so return immediately
return

; ######################################################################################################
; ################################################# GRAVITY ############################################
; ######################################################################################################

; These effects change the gravitational acceleration.
BeamMeUpScottyData:
GravityTarget := -0.002
%TimedEffectName%Time := 5000
gosub GravityGenericData
return

ZeroGravityData:
GravityTarget := 0
%TimedEffectName%Time := 10000
gosub GravityGenericData
return

QuarterGravityData:
GravityTarget := 0.002
gosub GravityGenericData
return

HalfGravityData:
GravityTarget := 0.004
gosub GravityGenericData
return

DoubleGravityData:
GravityTarget := 0.016
gosub GravityGenericData
return

QuadrupleGravityData:
GravityTarget := 0.032
gosub GravityGenericData
return

GravityGenericData:
GravityOriginal := 0.008
if VersionOffset = -4088 
	GravityAddress := 0x0068E5F8
else 
	GravityAddress := 0x0068F5F0
; No restrictions so return immediately
return

BeamMeUpScottyActivate:
ZeroGravityActivate:
QuarterGravityActivate:
HalfGravityActivate:
DoubleGravityActivate:
QuadrupleGravityActivate:
Memory(4, GravityAddress, GravityTarget, 4, "Float")
return

BeamMeUpScottyDeactivate:
ZeroGravityDeactivate:
QuarterGravityDeactivate:
HalfGravityDeactivate:
DoubleGravityDeactivate:
QuadrupleGravityDeactivate:
Memory(4, GravityAddress, GravityOriginal, 4, "Float")
return

	
; ######################################################################################################
; ################################################# GAME SPEED #########################################
; ######################################################################################################

; These effects change the game speed.
QuarterGameSpeedData:
SpeedTarget := 0.25
%TimedEffectName%Time := StandardTimeBetweenEffects*0.125 ; To cancel the effect of the changed game speed and reduce it some more
gosub GameSpeedGenericData
return

HalfGameSpeedData:
SpeedTarget := 0.5
%TimedEffectName%Time := StandardTimeBetweenEffects*0.5 ; To cancel the effect of the changed game speed
gosub GameSpeedGenericData
return

DoubleGameSpeedData:
SpeedTarget := 2.0
%TimedEffectName%Time := StandardTimeBetweenEffects*2 ; To cancel the effect of the changed game speed
gosub GameSpeedGenericData
return

QuadrupleGameSpeedData:
SpeedTarget := 4.0
%TimedEffectName%Time := StandardTimeBetweenEffects*4 ; To cancel the effect of the changed game speed
gosub GameSpeedGenericData
return

LagData:
SpeedSlow := 0.25
SpeedFast := 2.0
%TimedEffectName%Time := StandardTimeBetweenEffects-1 ; To account for the time it takes to activate the effect
gosub GameSpeedGenericData
return

GameSpeedGenericData:
SpeedOriginal := 1.0
GameSpeedAddress := 0x0097F264+VersionOffset
%TimedEffectName%ContinuouslyActivate = 1
; No restrictions so return immediately
return

QuarterGameSpeedActivate:
HalfGameSpeedActivate:
DoubleGameSpeedActivate:
QuadrupleGameSpeedActivate:
if Memory(3, GameSpeedAddress, 4, "Float") != SpeedTarget
	Memory(4, GameSpeedAddress, SpeedTarget, 4, "Float")
return

LagActivate:
if (Memory(3, GameSpeedAddress, 4, "Float") != SpeedSlow)
{
	Memory(4, GameSpeedAddress, SpeedSlow, 4, "Float")
	SleepTime := GetPseudoRandomValueUpTo(100)+150 ; Value between 150 and 250
	sleep %SleepTime%
}
else
{
	Memory(4, GameSpeedAddress, SpeedFast, 4, "Float")
	SleepTime := GetPseudoRandomValueUpTo(100)+350 ; Value between 350 and 450
	sleep %SleepTime%
}
return

QuarterGameSpeedDeactivate:
HalfGameSpeedDeactivate:
DoubleGameSpeedDeactivate:
QuadrupleGameSpeedDeactivate:
LagDeactivate:
Memory(4, GameSpeedAddress, SpeedOriginal, 4, "Float")
return

; ######################################################################################################
; ############################################### ANGRY DRIVERS ########################################
; ######################################################################################################

; There are two parts to this effect. The first part changes the speed with which angry drivers go to
; make all vehicles drive at max speed and will make all drivers angry drivers. The second part affects
; collision, making it much more extreme. Unfortunately the second part has some downsides: Car explosions
; don't deal damage. Melee weapons don't hurt peds. Destroyed objects such as traffic lights don't move
; and stay solid. I still need to look into why this happens and how to fix it.
AngryDriversData:
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
TargetAddedSpeed := 100
OriginalCollision := 16307 ; Short
If (IsInArray(PermanentEffectsActiveArray, "AngryDrivers")) ; Check if the permanent effect "AngryDrivers" is active
	SkipTimedEffect = 1
return

AngryDriversActivate:
Memory(4, AddedSpeedAddress, TargetAddedSpeed, 1)
Memory(4, AngryDriversEnabledAddress, 1, 1)
Memory(4, CollisionAddress, 0, 2)
return

AngryDriversDeactivate:
Memory(4, AddedSpeedAddress, OriginalAddedSpeed, 1)
Memory(4, AngryDriversEnabledAddress, 0, 1)
Memory(4, CollisionAddress, OriginalCollision, 2)
return

; ######################################################################################################
; ################################################# NO RIGHT ###########################################
; ######################################################################################################

; This effect prevents the player from turning right in a car. I'm unsure why exactly, but it seems to 
; be related to the camber angle.
NoRightData:
if VersionOffset = -4088
	NoRightAddress := 0x006996A8
else
	NoRightAddress := 0x0069A6A8
OriginalValue := -1.0
if (Memory(3, PlayerPointer, 4) = Memory(3, CarPointer, 4)) ; Check if player is not in a vehicle
	SkipTimedEffect = 1
if Memory(3, VehicleTypeAddress, 1) != 0 ; Check if player is in anything other than a car (heli counts as car unfortunately)
	SkipTimedEffect = 1
return

NoRightActivate:
Memory(4, NoRightAddress, 0, 4)
return

NoRightDeactivate:
Memory(4, NoRightAddress, OriginalValue, 4, "Float")
return

; ######################################################################################################
; ################################################ RAINBOW CAR #########################################
; ######################################################################################################

; Cycles through all possible colours for vehicles. The primary and secondary colour are cycle separately.
RainbowCarData:
VehiclePrimaryColourOffset := 0x1A0
VehicleSecondaryColourOffset := 0x1A1
%TimedEffectName%ContinuouslyActivate = 1
if (Memory(3, PlayerPointer, 4) = Memory(3, CarPointer, 4)) ; Check if player is not in a vehicle
	SkipTimedEffect = 1
If (IsInArray(PermanentEffectsActiveArray, "ImTheInvisibleDriver")) ; Check if the permanent effect "ImTheInvisibleDriver" is active
	SkipTimedEffect = 1
return


RainbowCarActivate:
VehiclePrimaryColourAddress := Memory(5, CarPointer, VehiclePrimaryColourOffset)
VehicleSecondaryColourAddress := Memory(5, CarPointer, VehicleSecondaryColourOffset)
NewPrimaryColour := Memory(3, VehiclePrimaryColourAddress, 1) + 1
NewSecondaryColour := Memory(3, VehicleSecondaryColourAddress, 1) - 1
if NewPrimaryColour > 94 ; Total number of car colours
	NewPrimaryColour = 0
if NewSecondaryColour < 0
	NewSecondaryColour = 94
Memory(4, VehiclePrimaryColourAddress, NewPrimaryColour, 1)
Memory(4, VehicleSecondaryColourAddress, NewSecondaryColour, 1)
sleep 50
return


RainbowCarDeactivate:
; Just not triggering the effect anymore is enough
return

; ######################################################################################################
; ################################################ RANDOM FALL #########################################
; ######################################################################################################

; This effect triggers the falling animation for the player, as if Tommy tripped.
RandomFallData:
%TimedEffectName%Time := 5000
if (Memory(3, PlayerPointer, 4) != Memory(3, CarPointer, 4)) ; Check if player is in a vehicle
	SkipTimedEffect = 1
if (Memory(3, PlayerStatusAddress, 1) != 1) ; Reduces softlock chance, this is probably too limited though
	SkipTimedEffect = 1
return


RandomFallActivate:
Memory(4, PlayerStatusAddress, 43, 1) ; Player status 43 is fallen
return


RandomFallDeactivate:
if (Memory(3, PlayerStatusAddress, 1) = 43) ; Hopefully this is enough to avoid a softlock which I think occurs when this effect is triggered while you are dead.
	Memory(4, PlayerStatusAddress, 1, 1) ; Player status 1 is on foot
return

; ######################################################################################################
; ############################################# LETS TAKE A BREAK ######################################
; ######################################################################################################

; Prevents the player from controlling Tommy for a short period of time.
LetsTakeABreakData:
%TimedEffectName%Time := 2500
if (Memory(3, PlayerStatusAddress, 1) != 1 AND Memory(3, PlayerStatusAddress, 1) != 50) ; This should prevent softlocks
	SkipTimedEffect = 1
return


LetsTakeABreakActivate:
PlayerHandleOld := Memory(3, PlayerPointer, 4)
if (Memory(3, PlayerPointer, 4) != Memory(3, CarPointer, 4) AND Memory(3, PlayerStatusAddress, 1) = 50) ; Check if player is in a vehicle (double check because sometimes (e.g. in cutscenes) the game misuses the car pointer causing a crash
{
	Memory(4, PlayerStatusAddress, 60, 1) ; Player status 60 is exiting vehicle, which will make Tommy uncontrollable and stuck in his car.
	LockedInCar = 1
}
else
{
	Memory(4, PlayerStatusAddress, 45, 1) ; Player status 45 is jumping sideways, which will make Tommy uncontrollable on foot.
	LockedInCar = 0
}
return


LetsTakeABreakDeactivate:
Memory(4, PlayerStatusAddress, 1, 1) ; Player status 1 is on foot, which will make Tommy controllable (without leaving the car if in one).
if (LockedInCar = 1 AND Memory(3, PlayerPointer, 4) = PlayerHandleOld) ; Check if player was in a vehicle and didn't die.
{
	sleep %RefreshRate%
	Memory(4, PlayerStatusAddress, 50, 1) ; Player status 50 is in car, which will restore the normal car controls.	
}
return

; ######################################################################################################
; ################################################ PHONE CALL ##########################################
; ######################################################################################################

; Triggers the phone call animation. After the effect ends, Tommy remains in the phone holding stance,
; even though his actions are no longer limited. Actions such as entering a car disable the stance.
PhoneCallData:
%TimedEffectName%Time := 5000
if (Memory(3, PlayerPointer, 4) != Memory(3, CarPointer, 4)) ; Check if player is in a vehicle
	SkipTimedEffect = 1
if (Memory(3, PlayerStatusAddress, 1) != 1) ; Reduces softlock chance, this is probably too limited though
	SkipTimedEffect = 1
return


PhoneCallActivate:
Memory(4, PlayerStatusAddress, 36, 1) ; Player status 36 is answering phone
return


PhoneCallDeactivate:
Memory(4, PlayerStatusAddress, 1, 1) ; Player status 1 is on foot
return

; ######################################################################################################
; ################################################# ENTER CAR ##########################################
; ######################################################################################################

/*
EnterCarData:
%TimedEffectName%Time := 5000
%TimedEffectName%ContinuouslyActivate = 1
if (Memory(3, PlayerPointer, 4) != Memory(3, CarPointer, 4)) ; Check if player is in a vehicle
	SkipTimedEffect = 1
if (Memory(3, PlayerStatusAddress, 1) != 1) ; Reduces softlock chance, this is probably too limited though
	SkipTimedEffect = 1
return


EnterCarActivate:
if (Memory(3, PlayerPointer, 4) = Memory(3, CarPointer, 4) AND Memory(3, PlayerStatusAddress, 1) = 1)
	Memory(4, PlayerStatusAddress, 24, 1) ; Player status 24 is walking to enter car
return


EnterCarDeactivate:
; Memory(4, PlayerStatusAddress, 1, 1) ; Player status 1 is on foot
; Just not triggering the effect is enough
return
*/

; ######################################################################################################
; ########################################## I'M THE INVISIBLE DRIVER ##################################
; ######################################################################################################

; Turns the vehicle Tommy is in invisible. It will remain invisible forever.
ImTheInvisibleDriverData:
CarFlagsOffset := 0x52
If (IsInArray(PermanentEffectsActiveArray, "Flintstone")) ; Check if the permanent effect "Flintstone" is active
	%TimedEffectName%Time := StandardTimeBetweenEffects*2
%TimedEffectName%ContinuouslyActivate = 1
if (Memory(3, PlayerPointer, 4) = Memory(3, CarPointer, 4)) ; Check if player is not in a vehicle
	SkipTimedEffect = 1
If (IsInArray(PermanentEffectsActiveArray, "ImTheInvisibleDriver")) ; Check if the permanent effect "ImTheInvisibleDriver" is active
	SkipTimedEffect = 1
return


ImTheInvisibleDriverActivate:
CarFlagsAddress := Memory(5, CarPointer, CarFlagsOffset)
if (Memory(3, CarFlagsAddress, 1) = 12)
	Memory(4, CarFlagsAddress, 8, 1)
return


ImTheInvisibleDriverDeactivate:
if (Memory(3, CarFlagsAddress, 1) = 8)
	Memory(4, CarFlagsAddress, 12, 1)
return


; ######################################################################################################
; ############################################### FRAME LIMITER ########################################
; ######################################################################################################

; Changes the FPS forced by the frame limiter.
FrameLimiter15Data:
FrameLimiterTarget := 15
gosub FrameLimiterGenericData
return

FrameLimiter60Data:
FrameLimiterTarget := 60
gosub FrameLimiterGenericData
return

FrameLimiterGenericData:
FrameLimiterOriginal := 30
FrameLimiterFPSAddress := 0x009B48EC+VersionOffset
FrameLimiterEnabledAddress := 0x00869655+VersionOffset
%TimedEffectName%ContinuouslyActivate = 1
return


FrameLimiter15Activate:
FrameLimiter60Activate:
if (Memory(3, FrameLimiterEnabledAddress, 1) != 1) ; Turn frame limiter on if it isn't already.
	Memory(4, FrameLimiterEnabledAddress, 1, 1)
if (Memory(3, FrameLimiterFPSAddress, 1) != FrameLimiterTarget)
	Memory(4, FrameLimiterFPSAddress, FrameLimiterTarget, 1)
return

FrameLimiter15Deactivate:
FrameLimiter60Deactivate:
if (Memory(3, FrameLimiterFPSAddress, 1) != FrameLimiterOriginal)
	Memory(4, FrameLimiterFPSAddress, FrameLimiterOriginal, 1)
return


; ######################################################################################################
; ############################################## SUDDEN CAR DEATH ######################################
; ######################################################################################################

; Sets the health of your car to 250, meaning even the tiniest amount of damage will set it on fire.
SuddenCarDeathData:
CarHealthOffset := 0x204
CarHealthTarget := 250.0
%TimedEffectName%Time := 10000
if (Memory(3, PlayerPointer, 4) = Memory(3, CarPointer, 4)) ; Check if player is not in a vehicle
	SkipTimedEffect = 1
CarHealthAddress := Memory(5, CarPointer, CarHealthOffset)
if (Memory(3, CarHealthAddress, 4, "Float") < 500.0) ; Only activate if the vehicle has more than 1/3 of its health left.
	SkipTimedEffect = 1
if SanicModeEnabled = 1
{
	SanicModeAdditionalDifficulty := GetPseudoRandomValueUpTo(4)
	if SanicModeAdditionalDifficulty != 1
		SkipTimedEffect = 1
}
if (Memory(3, OnMissionAddress, 1) = 1) ; Don't trigger during cherry poppers
{
	If (VCGetMissionName() = "Distribution")
		SkipTimedEffect = 1
}
return


SuddenCarDeathActivate:
CarHealthAddress := Memory(5, CarPointer, CarHealthOffset)
if (Memory(3, CarHealthAddress, 4, "Float") > CarHealthTarget)
	Memory(4, CarHealthAddress, CarHealthTarget, 4, "Float")
return


SuddenCarDeathDeactivate:
; Just not triggering the effect is enough
return


; ######################################################################################################
; ################################################## PIT STOP ##########################################
; ######################################################################################################

; Sets the health of your car to 10000, 10x the normal maximum health. In addition, the effect will do
; one of two things depending on which vehicle you are in. For cars (helicopters are considered cars by the game)
; and bikes it will remove all the wheels of the vehicle for the duration of the effect. For other vehicles (boats)
; it will set your speed to 0 instead, since there are no wheels to remove.
PitStopData:
XVelocityOffset := 0x70
YVelocityOffset := 0x74
ZVelocityOffset := 0x78
TireFrontLeftOffset := 0x2A5
TireRearLeftOffset := 0x2A6
TireFrontRightOffset := 0x2A7
TireRearRightOffset := 0x2A8
BikeTireFrontOffset := 0x32C
BikeTireRearOffset := 0x32D
CarHealthOffset := 0x204
CarHealthTarget := 10000.0 ; 10x the normal maximum health.
%TimedEffectName%Time := 5000
%TimedEffectName%ContinuouslyActivate = 1
if (Memory(3, PlayerPointer, 4) = Memory(3, CarPointer, 4) OR Memory(3, PlayerStatusAddress, 1) != 50) ; Check if player is not in a vehicle
	SkipTimedEffect = 1
return


PitStopActivate:
CarHealthAddress := Memory(5, CarPointer, CarHealthOffset)
XVelocityAddress := Memory(5, CarPointer, XVelocityOffset)
YVelocityAddress := Memory(5, CarPointer, YVelocityOffset)
ZVelocityAddress := Memory(5, CarPointer, ZVelocityOffset)
if (Memory(3, CarHealthAddress, 4, "Float") < CarHealthTarget)
	Memory(4, CarHealthAddress, CarHealthTarget, 4, "Float")
if Memory(3, VehicleTypeAddress, 1) = 5 ; Check if player is on a bike, if so remove the wheels.
{
	BikeTireFrontAddress := Memory(5, CarPointer, BikeTireFrontOffset)
	BikeTireRearAddress := Memory(5, CarPointer, BikeTireRearOffset)
	if Memory(3, BikeTireFrontAddress, 1) != 2
		Memory(4, BikeTireFrontAddress, 2, 1)
	if Memory(3, BikeTireRearAddress, 1) != 2
		Memory(4, BikeTireRearAddress, 2, 1)
}
Else if Memory(3, VehicleTypeAddress, 1) = 0 ; Check if player is in a car, if so remove the wheels.
{
	TireFrontLeftAddress := Memory(5, CarPointer, TireFrontLeftOffset)
	TireRearLeftAddress := Memory(5, CarPointer, TireRearLeftOffset)
	TireFrontRightAddress := Memory(5, CarPointer, TireFrontRightOffset)
	TireRearRightAddress := Memory(5, CarPointer, TireRearRightOffset)
	if Memory(3, TireFrontLeftAddress, 1) != 2
		Memory(4, TireFrontLeftAddress, 2, 1)
	if Memory(3, TireRearLeftAddress, 1) != 2
			Memory(4, TireRearLeftAddress, 2, 1)
	if Memory(3, TireFrontRightAddress, 1) != 2
		Memory(4, TireFrontRightAddress, 2, 1)
	if Memory(3, TireRearRightAddress, 1) != 2
	Memory(4, TireRearRightAddress, 2, 1)
}
Else ; If player is in something other than a bike or car (i.e. a boat) nullify the velocity in all directions.
{
	if (Memory(3, XVelocityAddress, 4) > 0)
		Memory(4, XVelocityAddress, 0, 4)
	if (Memory(3, YVelocityAddress, 4) > 0)
		Memory(4, YVelocityAddress, 0, 4)
	if (Memory(3, ZVelocityAddress, 4) > 0)
		Memory(4, ZVelocityAddress, 0, 4)
}
return


PitStopDeactivate:
if Memory(3, VehicleTypeAddress, 1) = 5 ; Check if player is on a bike, if so restore the wheels.
{
	BikeTireFrontAddress := Memory(5, CarPointer, BikeTireFrontOffset)
	BikeTireRearAddress := Memory(5, CarPointer, BikeTireRearOffset)
	if Memory(3, BikeTireFrontAddress, 1) != 0
		Memory(4, BikeTireFrontAddress, 0, 1)
	if Memory(3, BikeTireRearAddress, 1) != 0
		Memory(4, BikeTireRearAddress, 0, 1)
}
Else if Memory(3, VehicleTypeAddress, 1) = 0 ; Check if player is in a car, if so restore the wheels.
{
	TireFrontLeftAddress := Memory(5, CarPointer, TireFrontLeftOffset)
	TireRearLeftAddress := Memory(5, CarPointer, TireRearLeftOffset)
	TireFrontRightAddress := Memory(5, CarPointer, TireFrontRightOffset)
	TireRearRightAddress := Memory(5, CarPointer, TireRearRightOffset)
	if Memory(3, TireFrontLeftAddress, 1) != 0
		Memory(4, TireFrontLeftAddress, 0, 1)
	if Memory(3, TireRearLeftAddress, 1) != 0
		Memory(4, TireRearLeftAddress, 0, 1)
	if Memory(3, TireFrontRightAddress, 1) != 0
		Memory(4, TireFrontRightAddress, 0, 1)
	if Memory(3, TireRearRightAddress, 1) != 0
		Memory(4, TireRearRightAddress, 0, 1)
}
return

; ######################################################################################################
; ################################################## INTERIOR ##########################################
; ######################################################################################################

; This effect loads a random interior for the duration of the effect. Will only activate if the player is outside.
InteriorData:
InteriorLoadedAddress := 0x00978810+VersionOffset
InteriorOutside := 0
If InteriorTargetChosen = 0
{
	InteriorTarget := GetPseudoRandomValueUpTo(17)
	if InteriorTarget = 13 ; This interior doesn't exist(?)
		InteriorTarget = 18
	InteriorTargetChosen = 1
}
if (Memory(3, InteriorLoadedAddress, 1) != InteriorOutside) ; Check if player is not outside.
	SkipTimedEffect = 1
%TimedEffectName%ContinuouslyActivate = 1
return


InteriorActivate:
if (Memory(3, InteriorLoadedAddress, 1) != InteriorTarget)
	Memory(4, InteriorLoadedAddress, InteriorTarget, 1)
return


InteriorDeactivate:
if (Memory(3, InteriorLoadedAddress, 1) = InteriorTarget)
	Memory(4, InteriorLoadedAddress, InteriorOutside, 1)
InteriorTargetChosen = 0
return

; ######################################################################################################
; ################################################## POLARIS ###########################################
; ######################################################################################################

; An odd effect which disables pathfinding for pedestrians. All random pedestrians will spawn walking to the north,
; and (more noticably) mission peds won't be able to go where they are supposed to go. Tommy also won't
; be able to find and enter the nearest car unless he is standing right next to it. Since the effect is
; so much more noticable in missions, it will only trigger in missions.
PolarisData:
if VersionOffset = -4088
	PolarisAddress := 0x00691E96+VersionOffset
else
	PolarisAddress := 0x00691E96 
OnNotRealMissionAddress := 0x008224F0+VersionOffset
PolarisOriginal := 15286 ; Short
PolarisTarget := 0
MissionValue := Memory(3, OnMissionAddress, 4) + Memory(3, OnNotRealMissionAddress, 4)
If (MissionValue != 1) ; Phone calls etc set both the OnMission and OnNotRealMission flag and we don't want to activate the effect during a phone call.
	SkipTimedEffect = 1
return


PolarisActivate:
if (Memory(3, PolarisAddress, 2) != PolarisTarget)
	Memory(4, PolarisAddress, PolarisTarget, 2)
return


PolarisDeactivate:
if (Memory(3, PolarisAddress, 1) != PolarisOriginal)
	Memory(4, PolarisAddress, PolarisOriginal, 2)
return

; ######################################################################################################
; ################################################## MIRAGE ############################################
; ######################################################################################################

; Glitchy visual effect which causes objects and buildings to appear and disappear depending on the viewing angle.
; Collision is not affected, so it is possible to crash into stuff without seeing it.
MirageData:
if VersionOffset = -4088
	MirageAddress := 0x00689E9A
else
	MirageAddress := 0x0068AE9A 
MirageOriginal := 15502 ; Short
MirageTarget := 0
return


MirageActivate:
if (Memory(3, MirageAddress, 2) != MirageTarget)
	Memory(4, MirageAddress, MirageTarget, 2)
return


MirageDeactivate:
if (Memory(3, MirageAddress, 2) != MirageOriginal)
	Memory(4, MirageAddress, MirageOriginal, 2)
return

; ######################################################################################################
; ############################################### DRAW DISTANCE ########################################
; ######################################################################################################

; A couple of effects which change the draw distance.
ZeroDrawDistanceData:
DrawDistanceTarget := 0
%TimedEffectName%Time := 10000
gosub DrawDistanceGenericData
return

EighthDrawDistanceData:
DrawDistanceTarget := 8.75
gosub DrawDistanceGenericData
return

QuarterDrawDistanceData:
DrawDistanceTarget := 17.5
gosub DrawDistanceGenericData
return

HalfDrawDistanceData:
DrawDistanceTarget := 35.0
gosub DrawDistanceGenericData
return

DoubleDrawDistanceData:
DrawDistanceTarget := 140.0
gosub DrawDistanceGenericData
return


DrawDistanceGenericData:
if VersionOffset = -4088
	DrawDistanceAddress := 0x00689EC0
else
	DrawDistanceAddress := 0x0068AEC0 
DrawDistanceOriginal := 70.0
return

ZeroDrawDistanceActivate:
EighthDrawDistanceActivate:
QuarterDrawDistanceActivate:
HalfDrawDistanceActivate:
DoubleDrawDistanceActivate:
if (Memory(3, DrawDistanceAddress, 4, "Float") != DrawDistanceTarget)
	Memory(4, DrawDistanceAddress, DrawDistanceTarget, 4, "Float")
return

ZeroDrawDistanceDeactivate:
EighthDrawDistanceDeactivate:
QuarterDrawDistanceDeactivate:
HalfDrawDistanceDeactivate:
DoubleDrawDistanceDeactivate:
if (Memory(3, DrawDistanceAddress, 4, "Float") != DrawDistanceOriginal)
	Memory(4, DrawDistanceAddress, DrawDistanceOriginal, 4, "Float")
return


; ######################################################################################################
; ################################################## BOUNCE ############################################
; ######################################################################################################

; These effects change the amount of damping done by the suspension of a vehicle.
NoBounceData:
BounceTarget := 4.0
gosub BounceGenericData
return

BounceData:
BounceTarget := 0.01
gosub BounceGenericData
return

BouncyBounceData:
BounceTarget := -0.1
gosub BounceGenericData
return

BounceGenericData:
if VersionOffset = -4088 
	BounceAddress := 0x0068E5F4
else 
	BounceAddress := 0x0068F5EC
BounceOriginal := 0.53
if (Memory(3, PlayerPointer, 4) = Memory(3, CarPointer, 4)) ; Check if player is not in a vehicle
	SkipTimedEffect = 1
If (IsInArray(PermanentEffectsActiveArray, "Bounce")) ; Check if the permanent effect "Bounce" is active
	SkipTimedEffect = 1
return

NoBounceActivate:
BounceActivate:
BouncyBounceActivate:
if (Memory(3, BounceAddress, 4, "Float") != BounceTarget)
	Memory(4, BounceAddress, BounceTarget, 4, "Float")
return

NoBounceDeactivate:
BounceDeactivate:
BouncyBounceDeactivate:
if (Memory(3, BounceAddress, 4, "Float") != BounceOriginal)
	Memory(4, BounceAddress, BounceOriginal, 4, "Float")
return


; ######################################################################################################
; ############################################### RANDOM WEATHER #######################################
; ######################################################################################################

/*
RandomWeatherData:
Weather1Address := 0x00A10A2E+VersionOffset
Weather2Address := 0x00A10AAA+VersionOffset
%TimedEffectName%Time = 5000
return

RandomWeatherActivate:
;Random, WeatherTotalTarget, 0, 255 Unfortunately while producing really cool effects setting the weather to something higher than the official numbers will make the game unstable
;Random, Weather1Target, 0, %WeatherTotalTarget% Using official weather numbers just makes the game look like gta 3 colour wise
;Weather2Target := WeatherTotalTarget-Weather1Target
Memory(4, Weather1Address, Weather1Target, 1)
Memory(4, Weather2Address, Weather2Target, 1)
return

RandomWeatherDeactivate:
; The weather will cycle further on its own after a while
return
*/


; ######################################################################################################
; ################################################ ECLIPSE #############################################
; ######################################################################################################

; This effect makes the game world much darker, most noticably by disabling the numerous skylights that don't have a source.
EclipseData:
BrightnessAddress := 0x00869648+VersionOffset ; Needs to be changed (slightly) from default otherwise the effect doesn't do anything
If VersionOffset = -4088 ; Steam
{
	TimeHoursAddress := 0x00A0FB75
	TimeMinutesAddress := 0x00A0FB9C
	EclipseAddress := 0x00699197
}
Else
{
	TimeHoursAddress := 0x00A10B6B+VersionOffset
	TimeMinutesAddress := 0x00A10B92+VersionOffset
	EclipseAddress := 0x0069A197
}
TimeHoursTarget := 23
TimeMinutesTarget := 58
EclipseOriginal := 59 ; Byte
EclipseTarget := 0
BrightnessTarget := 260
BrightnessOriginal := Memory(3, BrightnessAddress, 4) ; Default is 256, but this keeps personal settings intact
return

EclipseActivate:
if (Memory(3, EclipseAddress, 1) != EclipseTarget)
	Memory(4, EclipseAddress, EclipseTarget, 1)
if (Memory(3, TimeHoursAddress, 1) != TimeHoursTarget)
	Memory(4, TimeHoursAddress, TimeHoursTarget, 1)
if (Memory(3, TimeMinutesAddress, 1) != TimeMinutesTarget)
	Memory(4, TimeMinutesAddress, TimeMinutesTarget, 1)
SetTimer, BrightnessCheck, %RefreshRate% ; To prevent the player from cheating out of the effect by changing the display options ingame
return

EclipseDeactivate:
SetTimer, BrightnessCheck, Off
if (Memory(3, EclipseAddress, 1) != EclipseOriginal)
	Memory(4, EclipseAddress, EclipseOriginal, 1)
if (Memory(3, BrightnessAddress, 4) != BrightnessOriginal)
	Memory(4, BrightnessAddress, BrightnessOriginal, 4)
return

BrightnessCheck:
if (Memory(3, BrightnessAddress, 4) != BrightnessTarget)
	Memory(4, BrightnessAddress, BrightnessTarget, 4)
return


; ######################################################################################################
; ############################################# ASTRAL PROJECTION ######################################
; ######################################################################################################

; This effect temporarily stops the player texture from moving with the player. The player weapons will
; still be fired from the location of the texture, meaning it's quickly very difficult to aim properly.
AstralProjectionData:
TextureAttachedOffset := 0x44
TextureAttachedTarget := 0
return

AstralProjectionActivate:
SetTimer, AstralProjectionCheck, %RefreshRate% ; Activates the effect again if the player dies/got busted/loaded a save
return

AstralProjectionCheck:
TextureAttachedAddress := Memory(5, PlayerPointer, TextureAttachedOffset)
if (Memory(3, TextureAttachedAddress, 4) != TextureAttachedTarget)
{
	TextureAttachedOriginal := Memory(3, TextureAttachedAddress, 4)
	Memory(4, TextureAttachedAddress, TextureAttachedTarget, 4)
}
return

AstralProjectionDeactivate:
SetTimer, AstralProjectionCheck, Off
TextureAttachedAddress := Memory(5, PlayerPointer, TextureAttachedOffset)
Memory(4, TextureAttachedAddress, TextureAttachedOriginal, 4)
return


; ######################################################################################################
; ################################################ TELEPORT ############################################
; ######################################################################################################

; Teleports the player to another location. Home% teleports the player to the Ocean View Hotel. Rave% 
; teleports the player to the Malibu Club.
HomeData:
XCoordinateTarget := 228.163406
YCoordinateTarget := -1262.800903
ZCoordinateTarget := 20.574146
InteriorTarget := 1
gosub TeleportGenericData
return

RaveData:
XCoordinateTarget := 470.703583
YCoordinateTarget := -71.482162
ZCoordinateTarget := 10.483632
InteriorTarget := 17
If (Memory(3, OnMissionAddress, 4) = 1)
	SkipTimedEffect = 1
gosub TeleportGenericData
return

TeleportGenericData:
PlayerXCoordinateOffset := 0x34
PlayerYCoordinateOffset := 0x38
PlayerZCoordinateOffset := 0x3C
InteriorLoadedAddress := 0x00978810+VersionOffset
; InteriorOutside := 0
%TimedEffectName%Time = 5000
if (Memory(3, PlayerPointer, 4) != Memory(3, CarPointer, 4) OR Memory(3, PlayerStatusAddress, 1) != 1) ; Check if player is in a vehicle or doing something which might interfere with teleporting.
	SkipTimedEffect = 1
if SanicModeEnabled = 1
{
	SanicModeAdditionalDifficulty := GetPseudoRandomValueUpTo(10)
	if SanicModeAdditionalDifficulty != 1
		SkipTimedEffect = 1
}
return

HomeActivate:
RaveActivate:
PlayerXAddress := Memory(5, PlayerPointer, PlayerXCoordinateOffset)
PlayerYAddress := Memory(5, PlayerPointer, PlayerYCoordinateOffset)
PlayerZAddress := Memory(5, PlayerPointer, PlayerZCoordinateOffset)
Memory(4, PlayerXAddress, XCoordinateTarget, 4, "Float")
Memory(4, PlayerYAddress, YCoordinateTarget, 4, "Float")
Memory(4, PlayerZAddress, ZCoordinateTarget, 4, "Float")
if (Memory(3, InteriorLoadedAddress, 1) != InteriorTarget)
	Memory(4, InteriorLoadedAddress, InteriorTarget, 1)
return

HomeDeactivate:
RaveDeactivate:
; Nothing needs to be deactivated
return


; ######################################################################################################
; ############################################### GHOST TOWN ###########################################
; ######################################################################################################

; This effect disables all random spawns, both for pedestrians and vehicles.
GhostTownData:
if VersionOffset = -4088
{
	PedDensityMultiplierAddress := 0x00694DC0+VersionOffset
	CarDensityMultiplierAddress := 0x00685FC8
}
Else
{
	PedDensityMultiplierAddress := 0x00694DC0
	CarDensityMultiplierAddress := 0x00686FC8
}

DensityOriginal := 1.0
DensityTarget := 0.0
%TimedEffectName%ContinuouslyActivate = 1
return

GhostTownActivate:
if Memory(3, PedDensityMultiplierAddress, 4, "Float") != DensityTarget
	Memory(4, PedDensityMultiplierAddress, DensityTarget, 4, "Float")
if Memory(3, CarDensityMultiplierAddress, 4, "Float") != DensityTarget
	Memory(4, CarDensityMultiplierAddress, DensityTarget, 4, "Float")
return

GhostTownDeactivate:
if Memory(3, PedDensityMultiplierAddress, 4, "Float") != DensityOriginal
	Memory(4, PedDensityMultiplierAddress, DensityOriginal, 4, "Float")
if Memory(3, CarDensityMultiplierAddress, 4, "Float") != DensityOriginal
	Memory(4, CarDensityMultiplierAddress, DensityOriginal, 4, "Float")
return


; ######################################################################################################
; ############################################ MOUSE SENSITIVITY #######################################
; ######################################################################################################

; These effects set a high or low mouse sensitivity respectively.
HighDPIData:
MouseSensivityTargetMultiplier := 10
gosub MouseSensitivityGenericData
return

LowDPIData:
MouseSensivityTargetMultiplier := 0.1
gosub MouseSensitivityGenericData
return

MouseSensitivityGenericData:
MouseSensivityAddress := 0x0094DBD0+VersionOffset ; Check if this is correct for all versions. (it should be)
; Because the ContinuouslyActivate flag is on, we need to make sure the mouse sensitivity is only stored
; the first time, before the sensitivity is changed. Otherwise we'd store the changed sensitivity after that.
If MouseSensitivityStored != 1
{
	MouseSensivityOriginal := Memory(3, MouseSensivityAddress, 4, "Float")
	MouseSensitivityStored = 1
}
MouseSensivityTarget := MouseSensivityOriginal*MouseSensivityTargetMultiplier ; To make sure everyone is affected in more or less the same way, the target value is dependent on the original value.
if (Memory(3, PlayerPointer, 4) != Memory(3, CarPointer, 4)) ; Check if player is in a vehicle because mouse sensitivity doesn't affect anything then anyway.
	SkipTimedEffect = 1
%TimedEffectName%ContinuouslyActivate = 1
return

HighDPIActivate:
LowDPIActivate:
if Memory(3, MouseSensivityAddress, 4) != MouseSensivityTarget
	Memory(4, MouseSensivityAddress, MouseSensivityTarget, 4, "Float")
return

HighDPIDeactivate:
LowDPIDeactivate:
if Memory(3, MouseSensivityAddress, 4) != MouseSensivityOriginal
	Memory(4, MouseSensivityAddress, MouseSensivityOriginal, 4, "Float")
MouseSensitivityStored = 0
return


; ######################################################################################################
; ################################################## PACIFIST ##########################################
; ######################################################################################################

; This effect set the out of ammo state for each of the player weapons. This means that although the player
; keeps the weapons, firing them will do nothing. The normal weapon state will be restored at the end.
PacifistData:
PlayerWeaponStructuresOffset := 0x408
WeaponStateOffset := 0x4
WeaponStructureSize := 0x18
WeaponStructuresAmount := 10 ; Amount of weapons the player can have.
WeaponStateTarget := 3 ; "out of ammo" state
WeaponStateOriginal := 0 ; "normal" state
%TimedEffectName%ContinuouslyActivate = 1
return

PacifistActivate:
PlayerWeaponStateFirstAddress := Memory(5, PlayerPointer, PlayerWeaponStructuresOffset+WeaponStateOffset)
loop %WeaponStructuresAmount%
{
	WeaponSlot := A_Index-1 ; Weapon slot starts at 0 instead of at 1.
	If (Memory(3, PlayerWeaponStateFirstAddress+WeaponSlot*WeaponStructureSize, 4) != WeaponStateTarget)
		Memory(4, PlayerWeaponStateFirstAddress+WeaponSlot*WeaponStructureSize, WeaponStateTarget, 4)
}
return

PacifistDeactivate:
PlayerWeaponStateFirstAddress := Memory(5, PlayerPointer, PlayerWeaponStructuresOffset+WeaponStateOffset)
loop %WeaponStructuresAmount%
{
	WeaponSlot := A_Index-1 ; Weapon slot starts at 0 instead of at 1.
	If (Memory(3, PlayerWeaponStateFirstAddress+WeaponSlot*WeaponStructureSize, 4) != WeaponStateOriginal)
		Memory(4, PlayerWeaponStateFirstAddress+WeaponSlot*WeaponStructureSize, WeaponStateOriginal, 4)
}
return

