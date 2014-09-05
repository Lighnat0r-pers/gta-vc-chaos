GameVersionCheck(GameName)
{
	if GameName = GTAVC
	{
		; Check which version of Vice City is used (this offsets the memory addresses)
		Value := Memory(3, 0x00608578, 1)
		if Value = 93
			Return 0 ; Version 1.0
		if Value = 129
			Return 8 ; Version 1.1
		if Value = 91
			Return -0xFF8 ; Version Steam
		Msgbox Error`: The script could not determine the version of GTA Vice City %Value%
	}
	Else if GameName = GTASA
	{
		; Check which version of San Andreas is used (this offsets the memory addresses)
		if Memory(3, 0x0082457C, 4) = 0x94BF
			return 0 ; Version 1.0 US
		if Memory(3, 0x008245BC, 4) = 0x94BF
			return 0 ; Version 1.0 EU/AUS or 1.0 US Hoodlum or 1.0 Downgraded
		if Memory(3, 0x008252FC, 4) = 0x94BF
			return 0x2680 ; Version 1.01 US
		if Memory(3, 0x0082533C, 4) = 0x94BF
			return 0x2680 ; Version 1.01 EU/AUS or 1.01 Deviance or 1.01 Downgraded
		if Memory(3, 0x0085EC4A, 4) = 0x94BF
			return 0x75130 ; Version 3.0 Steam
		if Memory(3, 0x0085DEDA, 4) = 0x94BF
			return 0x75770 ; Version 1.01 Steam ?
		Msgbox Error`: The script could not determine the version of GTA San Andreas
	}
	Else if GameName = GTA3
	{
		; Check which version of III is used (this offsets the memory addresses)
		if Memory(3, 0x005C1E70, 4) = 0x53E58955
			return -0x10140 ; Version 1.0 NoCD		
		if Memory(3, 0x005C2130, 4) = 0x53E58955
			return -0x10140 ; Version 1.1 NoCD
		if Memory(3, 0x005C6FD0, 4) = 0x53E58955
			return  0 ; Version 1.1 Steam
		Msgbox Error`: The script could not determine the version of GTA 3
	}
	Else if GameName = Bully
	{
		; Check which version of III is used (this offsets the memory addresses)
		if Memory(3, 0x0091BF70, 5, "Ascii") = "Coll\"
			return 0 ; Version Steam 1.2 and retail 1.153
		Msgbox Error`: The script could not determine the version of Bully
	}
	Else 
		msgbox Error`: Invalid game`: %GameName%.
} 
