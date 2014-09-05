
; ######################################################################################################
; ############################################## STATIC EFFECTS ########################################
; ######################################################################################################

/*
Subheadings:

	Crazy Cones

*/

; ######################################################################################################
; ############################################### CRAZY CONES ##########################################
; ######################################################################################################

StaticCrazyConesData:
ConeElasticityAddress := 0x007DE46C+VersionOffset
ConeElasticityOriginal := 0.03
ConeElasticityTarget := 1.0
return

StaticCrazyConesActivate:
if (Memory(3, ConeElasticityAddress, 4, "Float") != ConeElasticityTarget)
	Memory(4, ConeElasticityAddress, ConeElasticityTarget, 4, "Float")
return

StaticCrazyConesDeactivate:
if (Memory(3, ConeElasticityAddress, 4, "Float") != ConeElasticityOriginal)
	Memory(4, ConeElasticityAddress, ConeElasticityOriginal, 4, "Float")
return

StaticCrazyConesUpdate:
if (Memory(3, ConeElasticityAddress, 4, "Float") != ConeElasticityTarget)
	Memory(4, ConeElasticityAddress, ConeElasticityTarget, 4, "Float")
return

