Memory(Type=3,Param1=0,Param2=0,Param3=0,Param4=0)
{
	Static ProcessHandle
	If Type = 1 ; Open a new handle.     Syntax: Memory(1, PID)	
	{	
		ProcessHandle := DllCall("OpenProcess","Int",2035711,"Int", 0,"UInt",Param1)
		If ProcessHandle = 0
		{
			Error := GetLastErrorMessage()
			outputdebug Open process error`: %Error%
			Return % DllCall("GetLastError")
		}
		Else
			Return 0
	}
	Else If Type = 2 ; Close the handle. Syntax: Memory(2)
		DllCall("CloseHandle","UInt",ProcessHandle)
	Else If Type = 3 ; Reading a value.  Syntax: Memory(3, Address [, Length, Special Type])
	{
		Param2 := ((!Param2) ? 4 : Param2) ; If length is left out it defaults to 4
		VarSetCapacity(MVALUE,Param2,0)
		If (Param3 = "Unicode" OR Param3 = "Ascii")
		{
			CharLength := ((Param3 = "Unicode") ? 2 : 1) ; Unicode uses two bytes per character, Ascii uses one
			LoopAmount := Param2/CharLength
			Loop %LoopAmount%
			{
				ReadAddress := Param1+((A_Index-1)*CharLength)
				OutputChar%A_Index% := Memory(3, ReadAddress, CharLength)
				OutputChar%A_Index% := Chr(OutputChar%A_Index%)
				OutputString := OutputString . OutputChar%A_Index%
			}
			Return OutputString
		}
		If (ProcessHandle) && DllCall("ReadProcessMemory","UInt"
		,ProcessHandle,"UInt",Param1,"Str",MVALUE,"UInt",Param2,"UInt",0)
		{
			Result = 0 ; To prevent #Warn from complaining about an empty variable.
			Loop %Param2%
				Result += *(&MVALUE + A_Index-1) << 8*(A_Index-1)
			If (Param3 = "Float") ; Write a float value.
				Result := (1-2*(Result>>31)) * (2**((Result>>23 & 255)-150)) * (0x800000 | Result & 0x7FFFFF)
			Return Result
		}
		Return !ProcessHandle ? "Handle Closed: " Closed : "Fail"
	}
	Else If Type = 4 ; Writing a Value.  Syntax: Memory(4, Address, Value [, Length, Special Type])
	{
		If (Param4 = "Unicode" OR Param4 = "Ascii")
		{
			CharLength := ((Param4 = "Unicode") ? 2 : 1) ; Unicode uses two bytes per character, Ascii uses one
			StringSplit, InputStringArray, Param2
			Param3 := ((!Param3) ? InputStringArray0 : Param3) ; If length is left out it defaults to the length of the string
			Loop %Param3% ; Clear the current text
			{
				TextCharacter%A_Index%Address := Param1  + (A_Index-1) * CharLength
				Memory(4, TextCharacter%A_Index%Address, 0, 1)
			}
			If (InputStringArray0 > Param3) ; Limit the string length to write length
				InputStringArray0 := Param3
			Loop %InputStringArray0% ; Write the input string to memory
			{
				CurrentLetter := InputStringArray%A_Index%
				If CurrentLetter = `%
					CurrentLetter = 37
				Else
					CurrentLetter := Asc(CurrentLetter) ; Convert character to ASCII
				TextCharacter%A_Index%Address := Param1 + (A_Index-1) * CharLength
				Memory(4, TextCharacter%A_Index%Address, CurrentLetter, 1)
			}
		}
		Else
		{
			If (Param4 = "Float") ; Write a float value.
			{
				form := A_FormatInteger
				SetFormat Integer, HEX
				Param2 := DllCall("MulDiv", Float, Param2, Int,1, Int,1, UInt)
				SetFormat Integer, %form%
			}
			Param3 := ((!Param3) ? 4 : Param3) ; If length is left out it defaults to 4
			If (ProcessHandle) && DllCall("WriteProcessMemory","UInt"
			,ProcessHandle,"UInt",Param1,"Uint*",Param2,"Uint",Param3,"Uint",0)
				Return "Success"
			Return !ProcessHandle ? "Handle Closed: " closed : "Fail"
		}
	}
	Else If Type = 5 ; Pointing.         Syntax: Memory(5, Pointer, Offset)
	{
		Param1 := Memory(3, Param1)
		If Param1 is not xdigit
			Return Param1
		Return Param1 + Param2
	}
}

