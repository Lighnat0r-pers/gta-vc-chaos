; ######################################################################################################
; ######################################### QUICK SAVE/LOAD ############################################
; ######################################################################################################

/*
Subheadings:

	Quicksave
*/

Quicksave:
SaveMenuAddress := 0x0086966B+VersionOffset
MenuCurrentPageAddress := 0x00869728+VersionOffset
SaveFileIndexAddress := 0x00869730+VersionOffset ; Starts at 0 instead of 1 like the actual index in the file name
SaveSlotIndex = 8 ; Slot 9
outputdebug %CurrentTime% Quicksave`/Load Attempted
FileAppend, `n%CurrentTime% Quicksave`/load Attempted, %ProgramNameNoExt% Log`.log
If ((Memory(3, GameRunningAddress, 1) = "Fail"))
	goto Mainscript
If Memory(3, MenuCurrentPageAddress, 1) = 29 ; Main menu, then do quick load
{
	Memory(4, SaveFileIndexAddress, SaveSlotIndex, 1)
	Memory(4, MenuCurrentPageAddress, 10, 1)
	sleep 1000
	outputdebug %CurrentTime% Quickload Used
	FileAppend, `n%CurrentTime% Quickload Used, %ProgramNameNoExt% Log`.log
}
If (Memory(3, PlayerPointer, 4) = Memory(3, CarPointer, 4) AND Memory(3, OnMissionAddress, 4) != 1 AND QuicksaveDisabled != 1 AND Memory(3, PlayerStatusAddress, 1) = 1 AND (Memory(3, InTheBeginningDoneAddress, 4) = 1))
{
	QuicksaveStartTime := A_TickCount
	StoredTime := Memory(3, TimeHoursAddress, 1)
	Memory(4, SaveFileIndexAddress, SaveSlotIndex, 1)
	Memory(4, SaveMenuAddress, 1, 1)
	sleep 50
	Loop 10
	{
		Memory(4, MenuCurrentPageAddress, 17, 1)
		sleep 10
	}		
	While (Memory(3, MenuCurrentPageAddress, 1) != 17)
	{
		Memory(4, MenuCurrentPageAddress, 17, 1)
		if (A_TickCount > (QuicksaveStartTime + 5000))
			break ; if this takes more than 5 seconds, something has gone wrong.
	}
	sleep 500
	QuicksaveUsed = 1
	Memory(4, TimeHoursAddress, StoredTime, 1)
	outputdebug %CurrentTime% Quicksave Used
	FileAppend, `n%CurrentTime% Quicksave Used, %ProgramNameNoExt% Log`.log
}
return

