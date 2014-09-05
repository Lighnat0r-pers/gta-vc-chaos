DoubleToHex(d) 
{
   form := A_FormatInteger
   SetFormat Integer, HEX
   v := DllCall("ntdll.dll\RtlLargeIntegerShiftLeft",Double,d, UChar,0, Int64)
   SetFormat Integer, %form%
   Return v
}

