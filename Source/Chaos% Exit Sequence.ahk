; ######################################################################################################
; ########################################### RESTART/EXIT SEQUENCE ####################################
; ######################################################################################################

/*
Subheadings:

	RestartSequence
	ExitSequence
	3ButtonYes
	3ButtonNo/3GuiClose/3GuiEscape
*/

;Restart the program.
RestartSequence:
Thread, NoTimers
ReloadingProgram = 1
outputdebug %CurrentTime% Reload Chaos Program
FileAppend, `n%CurrentTime% Reload Chaos Program, %ProgramNameNoExt% Log`.log
reload
sleep 100
return


; If the exit is already confirmed or the script is being reloaded, do that immediately.
; If not, disable the currently active window (which prevents it from being activated)
; and instead create a window asking the user to confirm the exit. 
ExitSequence:
Thread, NoTimers
If (ExitConfirmed = 1 or ReloadingProgram = 1)
{
	if TimedEffectActive = 1
		gosub TimedEffectDeactivate
	if ChaosTextAdded = 1
		gosub ChaosTextRemove
	If PermanentEffectsActive = 1
		gosub PermanentEffectsDeactivate
	gosub StopLogger
	outputdebug %CurrentTime% Close Chaos Program
	FileAppend, `n%CurrentTime% Close Chaos Program, %ProgramNameNoExt% Log`.log
	sleep 200
	Exitapp
}
else
{
	if CurrentGUI != 
		gui %CurrentGUI%:+disabled
	gui 3:-MinimizeBox -MaximizeBox +owner%CurrentGUI% +LastFound
	Gui, 3:Font, Q3
	Gui, 3:Add, Text,, Are you sure you want to exit the program?
	Gui, 3:Add, Button, Default section, Yes
	Gui, 3:Add, Button, ys, No
	gui, 3:Show
	return
}

; If the user confirms the exit, exit.
3ButtonYes:
ExitConfirmed = 1
ExitApp

; If the user cancels the exit, restore the previous window and destroy the exit confirmation window.
3ButtonNo:
3GuiClose:
3GuiEscape:
if CurrentGUI != 
	gui %CurrentGUI%:-disabled
gui, 3:destroy
return

