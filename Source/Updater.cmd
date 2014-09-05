@echo off
echo Closing the old version...
echo(
FOR /F "tokens=2*" %%A IN ('REG.EXE QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /V "EditionID" 2^>NUL ^| Find "REG_SZ"') DO Set Edition=%%B
IF "%Edition%" EQU "Home" (
	TSKILL %3	
 ) ELSE (
	taskkill /F /PID %3
 )
echo(
echo Updating the program...
echo(
xcopy %1 %2 /Y
echo(
del %1
echo(
echo Preparing to launch the new version...
echo(
start "" %2
exit
