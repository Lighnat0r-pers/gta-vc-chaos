; ######################################################################################################
; ############################################ OUTPUT WINDOW ###########################################
; ######################################################################################################

/*
Subheadings:

	OutputWindow
	2GuiContextMenu
	2GuiClose/2GuiEscape
*/

OutputWindow:
gui 2:-MinimizeBox -MaximizeBox +LastFound
gui, 2:Font, w700 Q3 ; Bold
gui, 2:Add, Text,, %DifficultySetting% difficulty
gui, 2:Font, w400 Q3 ; Normal
if StaticEffectsEnabled = 1
{
	gui, 2:Font, w700 Q3 ; Bold
	gui, 2:Add, Text,, Static Effects Enabled
	gui, 2:Font, w400 Q3 ; Normal
}
if PermanentEffectsEnabled = 1
{

	gui, 2:Font, w700 Q3 ; Bold
	gui, 2:Add, Text,, Permanent Effects Active`:
	gui, 2:Font, w400 Q3 ; Normal
	gui, 2:Add, Text, h0 w0 Y+5,
	For Index, PermanentEffectName in PermanentEffectsActiveArray
		gui, 2:Add, Text, Y+5, %PermanentEffectName%`%
	gui, 2:Add, Text, h0 w0 Y+5,
}
if TimedEffectsEnabled = 1 
{
	gui, 2:Font, w700 Q3 ; Bold
	If SanicModeEnabled = 1
	{
		gui, 2:Add, Text,, ---SÅNIC MODE ACTIVE---
		gui, 2:Add, Text,Y+5, Timed Effect Active`:
	}
	Else
		gui, 2:Add, Text,, Timed Effect Active`:
	gui, 2:Font, w400 Q3 ; Normal
	gui, 2:Add, Text, vTimedEffectText w150, -Game not running-
	gui, 2:Add, Text,h0 w0 Y+5,
}
Gui, 2:Show
return

; Create a context menu if the user right clicks on the window.
2GuiContextMenu:
Menu, OutputRightClick, Add, Restart Program, RestartSequence
Menu, OutputRightClick, Add, Open Readme, OpenReadme
Menu, OutputRightClick, Add, Exit, 2GuiClose
Menu, OutputRightClick, Show
return

; What happens if the user tries to close the window.
2GuiClose:
2GuiEscape:
CurrentGUI = 2
exitapp
return
