GetLastErrorMessage()
{
	ErrorCode := DllCall("GetLastError")
	VarSetCapacity(ReturnedMessage, 2000)
	ReturnValue := DllCall("FormatMessage", "UInt", 0x1000, "UInt", 0, "UInt", ErrorCode, "UInt", 0x800, "Str", ReturnedMessage, "UInt", 2000, "UInt", 0)
	If ReturnValue = 0
	{
		ErrorCode := DllCall("GetLastError")
		outputdebug Error getting error message`: %ErrorCode%
	}
	Else
	{
		Error = %ErrorCode%`: %ReturnedMessage%
		return Error
	}
}
