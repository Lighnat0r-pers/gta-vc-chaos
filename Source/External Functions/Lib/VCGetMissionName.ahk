VCGetMissionName()
{
	; Get the name of the last specified GXT table
	VersionOffset := GameVersionCheck("GTAVC")
	GXTCurrentAddress := 0x0094B243+VersionOffset-1 ; -1 since the loop starts at index 1 and not index 0
 	loop 8
		{
			if A_Index = 1
				TestName =
			ReadAddress := GXTCurrentAddress+A_Index
			Test%A_Index% := Memory(3, ReadAddress, 1)
			if Test%A_Index% != 0
				{
					TestChar%A_Index% := chr(Test%A_Index%)
					TestCharTemp := % TestChar%A_Index%
					TestName = %TestName%%TestCharTemp%
				}
			else
				break		
		}
	MissionNameArray := {AMBULAE:"Paramedic", ASSIN1:"Road Kill", ASSIN2:"Waste The Wife", ASSIN3:"Autocide", ASSIN4:"Check Out At The Check In", ASSIN5:"Loose Ends", BANKJ1:"No Escape", BANKJ2:"The Shootist", BANKJ3:"The Driver", BANKJ4:"The Job", BARON1:"The Chase", BARON2:"Phnom Penh '86", BARON3:"The Fastest Boat", BARON4:"Supply And Demand", BARON5:"Rub Out", BIKE1:"Alloy Wheels Of Steel", BIKE2:"Messing With The Man", BIKE3:"Hog Tied", BMX_1:"Trial By Dirt", BOATBUY:"Buying Boatyard", CAP_1:"Cap The Collector", CARBUY:"Buying Sunshine Autos", CARPAR1:"Cone Crazy", COPCAR:"Vigilante", COUNT1:"Spilling The Beans", COUNT2:"Hit The Courier", CUBAN1:"Stunt Boat Challenge", CUBAN2:"Cannon Fodder", CUBAN3:"Naval Engagement", CUBAN4:"Trojan Voodoo", FINALE:"Keep Your Friends Close", FIRETRK:"Firefighter", GENERA1:"Treacherous Swine", GENERA2:"Mall Shootout", GENERA3:"Guardian Angels", GENERA4:"Sir Yes Sir", GENERA5:"All Hands On Deck", HAIT1:"Juju Scramble", HAIT2:"Bombs Away", HAIT3:"Dirty Lickin's", HOTEL:"An Old Friend", ICECRE1:"Distribution", ICECUT:"Buying Cherry Poppers", INTRO:"In The Beginning", KENT1:"Death Row", KICKSTT:"Dirtring", LAWYER1:"The Party", LAWYER2:"Back Alley Brawl", LAWYER3:"Jury Fury", LAWYER4:"Riot", MIAMI_1:"PCJ Playground", MM:"Bloodring", OVALRIG:"Hotring", PHIL1:"Gun Runner", PHIL2:"Boomshine Saigon", PIZZA:"Pizza Delivery", PORN1:"Recruitment Drive", PORN2:"Dildo Dodo", PORN3:"Martha's Mug Shot", PORN4:"G-Spotlight", PROT1:"Shakedown", PROT2:"Bar Brawl", PROT3:"Cop Land", RACES:"Races", RCHELI1:"RC Raider Pickup", RCPLNE1:"RC Baron Race", RCRACE:"RC Bandit Race", ROCK1:"Love Juice", ROCK2:"Psycho Killer", ROCK3:"Publicity Tour", SERG1:"Four Iron", SERG2:"Two Bit Hit", SERG3:"Demolition Man", TAXI1:"Taxi Driver", TAXICUT:"Buying Kaufman Cabs", TAXIWA1:"V.I.P.", TAXIWA2:"Friendly Rivalry", TAXIWA3:"Cabmaggedon"}
	; Note that Demolition Man is SERG3 and Two Bit Hit is SERG2, this is different from the in-game mission order but it is correct for the GXT table.
	MissionName := MissionNameArray[TestName]
	return MissionName
}
