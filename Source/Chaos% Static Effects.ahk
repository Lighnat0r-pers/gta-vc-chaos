
; ######################################################################################################
; ########################################### STATIC EFFECTS ###########################################
; ######################################################################################################

/*
Subheadings:

	Crazy Cones
	No Replay
*/

; ######################################################################################################
; ############################################# CRAZY CONES ############################################
; ######################################################################################################

StaticCrazyConesData:
ConeElasticityAddress := 0x007DE46C+VersionOffset
ConeElasticityOriginal := 0.03
ConeElasticityTarget := 1.0
return

StaticCrazyConesActivate:
StaticCrazyConesUpdate:
if (Memory(3, ConeElasticityAddress, 4, "Float") != ConeElasticityTarget)
	Memory(4, ConeElasticityAddress, ConeElasticityTarget, 4, "Float")
return

StaticCrazyConesDeactivate:
if (Memory(3, ConeElasticityAddress, 4, "Float") != ConeElasticityOriginal)
	Memory(4, ConeElasticityAddress, ConeElasticityOriginal, 4, "Float")
return

; ######################################################################################################
; ############################################## NO REPLAY #############################################
; ######################################################################################################

StaticNoReplayData:
if VersionOffset = -0xFF8
	NoReplayAddress := 0x004A45C3-390
else if VersionOffset = 8
	NoReplayAddress := 0x004A45C3+32
else
	NoReplayAddress := 0x004A45C3
NoReplayTarget := 0x90
NumChangedAddresses := 5
return

StaticNoReplayActivate:
Loop %NumChangedAddresses%
{
	if (Memory(3, NoReplayAddress+A_Index-1, 1) != NoReplayTarget)
	{
		NoReplayOriginal%A_Index% := Memory(3, NoReplayAddress+A_Index-1, 1)
		Memory(4, NoReplayAddress+A_Index-1, NoReplayTarget, 1)
	}
}
return

StaticNoReplayDeactivate:
Loop %NumChangedAddresses%
	if (Memory(3, NoReplayAddress+A_Index-1, 1) != NoReplayOriginal%A_Index%)
		Memory(4, NoReplayAddress+A_Index-1, NoReplayOriginal%A_Index%, 1)
return

StaticNoReplayUpdate:
Loop %NumChangedAddresses%
{
	if (Memory(3, NoReplayAddress+A_Index-1, 1) != NoReplayTarget)
	{
		NoReplayOriginal%A_Index% := Memory(3, NoReplayAddress+A_Index-1, 1)
		Memory(4, NoReplayAddress+A_Index-1, NoReplayTarget, 1)
	}
}
return


