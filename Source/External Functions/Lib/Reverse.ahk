Reverse(String)
{
	ReversedResult = 
	Length := StrLen(string)
	Loop, parse, String
		{
			Position := Length-A_Index+1
			Substring%Position% := A_LoopField
		}
	Loop %Length%
		{
		ReversedResult .= Substring%A_Index%
		}
	return ReversedResult
}

