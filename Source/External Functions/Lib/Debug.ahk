Debug(Type,Param1=0,Param2=0)
{
	If Type = 1 ; Start debugging the specified process		Syntax: Debug(1, PID, LogFileName)
	{

		ReturnValue := DllCall("DebugActiveProcess", "UInt", Param1)
		If ReturnValue = 0
		{
			Error := GetLastErrorMessage()
			outputdebug DebugActiveProcess Error`: %Error%
		}
		LogFileName := Param2
		SetTimer, WaitForDebugEvent, -1
		While StopLoggingDebugMessages != 1
		{
			Global DebugEventStructure
			VarSetCapacity(DebugEventStructure, 0x100, 0)
			ReturnValue := DllCall("WaitForDebugEvent", "Ptr", &DebugEventStructure, "UInt", -1)
			If ReturnValue = 0
			{
				Error := GetLastErrorMessage()
				outputdebug WaitForDebugEvent Error`: %Error%
			}
			DebugEventCode := NumGet(DebugEventStructure, 0x00, "UInt")
			ProcessID := NumGet(DebugEventStructure, 0x04, "UInt")
			ThreadID := NumGet(DebugEventStructure, 0x08, "UInt")
			Union := NumGet(DebugEventStructure, 0x0C, "UInt")
			ReturnValue := DllCall("ContinueDebugEvent", "UInt", ProcessID, "UInt", ThreadID, "UInt", 0x80010001)
			If ReturnValue = 0
			{
				Error := GetLastErrorMessage()
				outputdebug ContinueDebugEvent Error`: %Error% 
			}
			FileAppend, `n`nDebug Event`:, %LogFileName%
			FileAppend, `nDebug event code`: %DebugEventCode%, %LogFileName%
			FileAppend, `nProcess ID`: %ProcessID%, %LogFileName%
			FileAppend, `nThread ID`: %ThreadID%, %LogFileName%
			FileAppend, `nUnion`: %Union%, %LogFileName%
		}
	}
	Else If Type = 2 ; Stop debugging the specified process		Syntax: Debug(2, PID[, KillDebugProcess])
	{
		Param2 := ((!Param2) ? 0 : 1)
		DllCall("DebugSetKillOnExit", "Int", Param2)
		DllCall("DebugActiveProcessStop", "UInt", Param1)
	}
	Else If Type = 3 ; Log debug messages				Syntax: Debug(3, LogFileName)
	{
		LogFileName := Param1

	}
	Else If Type = 4 ; Stop logging debug messages soon		Syntax: Debug(4)
		StopLoggingDebugMessages = 1
}
