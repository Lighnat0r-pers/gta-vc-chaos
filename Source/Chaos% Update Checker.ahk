; ######################################################################################################
; ########################################### UPDATE CHECKER ###########################################
; ######################################################################################################

/*
Subheadings:

	UpdateCheck
	4ButtonYes
	4GuiClose/4GuiEscape/4ButtonNo
*/

UpdateCheck:
; Avast stops the program from functioning correctly, presumably because it tries to connect to the internet for the 
; update checker. So we will read the registry to see if Avast has been installed. The location of the registry key
; by which we determine if Avast is installed depends on whether the OS is 64 or 32 bit. If it is 64 bit, the key 
; can be in one of two locations (one for the 32 bit version of Avast and one for the 64 bit version). The 32 bit
; OS only has one possible location.
if (A_Is64bitOS)
{
	SetRegView 64
	RegRead, AvastInstalled, HKLM, Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Avast, DisplayName
	if ErrorLevel = 1
		RegRead, AvastInstalled, HKLM, Software\Microsoft\Windows\CurrentVersion\Uninstall\Avast, DisplayName
}
else
	RegRead, AvastInstalled, HKLM, Software\Microsoft\Windows\CurrentVersion\Uninstall\Avast, DisplayName
; If there was no problem reading the registry the registry key exists, so Avast is installed. In this case
; let the user know the update checker has been disabled and skip it.
if ErrorLevel = 0 
{
	outputdebug %AvastInstalled% detected
	MsgBox, Avast has been detected on your computer. `nThe auto-updater has been disabled.
	return
}
; Delete Updater.cmd to make sure the most recent version is always used.
FileDelete, Updater.cmd
; Download the version file.
UrlDownloadToFile, %VersionURL%, Version.ini
if ErrorLevel = 0 ; Check if the version file was downloaded successfully.
{
	; Check if a newer version is released. If this is the case, show the update screen with the current
	; version (stored internally), a description and the version it will update to (both read from the version file).
	IniRead, NewestVersion, Version.ini, Version, %ProgramName%
	if (NewestVersion != "Error" AND NewestVersion > CurrentVersion)
	{
		Gui 4:-MinimizeBox -MaximizeBox +LastFound
		Gui, 4:Font, Q3
		Gui, 4:Add, Text,, An update is available. Current version`: v%CurrentVersion%. `nNew version`: v%NewestVersion%. Would you like to update now`?
		IniRead, DescriptionText, Version.ini, %ProgramName% Files, Description
		if (DescriptionText != "Error" AND DescriptionText != "")
		{
			Gui, 4:Font, w700 Q3 ; Bold
			Gui, 4:Add, Text,, Update description`:
			Gui, 4:Font, w400 Q3 ; Normal
			Gui, 4:Add, Text,h0 w0 Y+4,
			StringSplit, DescriptionTextArray, DescriptionText, `|
			Loop %DescriptionTextArray0%
				Gui, 4:Add, Text,Y+1, % DescriptionTextArray%A_Index%
		}
		Gui, 4:Add, Text,h0 w0 Y+4,
		Gui, 4:Add, Button, section default, Yes
		Gui, 4:Add, Button, ys, No
		Gui, 4:Show
		return
	}
}
; If the version file failed to download or there is no new version, delete the version file and continue running the program.
FileDelete, Version.ini
return

; If the user accepts, show a splash text that the new version is being downloaded. 
4ButtonYes:
Gui, 4:Hide
SplashTextOn , 350, , Downloading the new version. This might take some time...
; Download all the files from the file list defined earlier, from the locations specified in the version file.
Loop
{
	If File%A_Index% =
		break
	File := File%A_Index%
	IniRead, FileLink, Version.ini, %ProgramName% Files, %File%
	UrlDownloadToFile, %FileLink%, %File%
}
; We don't need the version file anymore, so delete it.
FileDelete, Version.ini
; Once that's done, run the updater.cmd included in the executable of the running version. This is necessary because
; in order to update, the executable has to be replaced. Since that can't be done while the program is still running,
; it has to be done from a different process, in this case the updater.cmd, a Windows Command Script. From command-line,
; it will first close this program, then copy the new version of the executable over the old, then automatically start
; the new version. In all cases the version.ini file is deleted as to not clutter the computer. Since the updater.cmd
; is deleted every time the auto-updater checks for new updates, it will be deleted right after it has started the new version.
UpdateVar1 = `"%A_ScriptDir%\%ExecutableFile%`" ; Location of the newversion exe.
UpdateVar2 = `"%A_ScriptFullPath%`" ; Location of the old (currently running) exe which will be overwritten.
UpdateVar3 := DllCall("GetCurrentProcessId") ; Program PID so it can be closed.
FileInstall, Updater.cmd, Updater.cmd, 1
Run, Updater.cmd %UpdateVar1% %UpdateVar2% %UpdateVar3%, ,
sleep 5000 ; Give the updater some time to close this program.
ExitConfirmed = 1
exitapp

;If the user declines the update, delete the version file and continue running the program.
4GuiClose:
4GuiEscape:
4ButtonNo:
Gui, 4:Destroy
FileDelete, Version.ini
return
