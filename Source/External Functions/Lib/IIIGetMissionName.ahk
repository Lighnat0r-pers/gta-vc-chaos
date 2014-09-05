IIIGetMissionName()
{
	; Get the name of the last specified mission thread
	VersionOffset := GameVersionCheck("GTA3")
	MissionThreadCurrentAddress := 0x0077B38A+VersionOffset-1 ; -1 since the loop starts at index 1 and not index 0
 	loop 8
		{
			if A_Index = 1
				TestName =
			ReadAddress := MissionThreadCurrentAddress+A_Index
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
	MissionNameArray := {INTRO:"Intro Movie", HEALTH:"Hospital Info Scene", WANTED:"Police Station Info Scene", RC1:"RC Diablo Destruction", RC2:"RC Mafia Massacre", RC3:"RC Rumpo Rampage", RC4:"RC Casino Calamity", T4X4_1:"Patriot Playground", T4X4_2:"A Ride In The Park", T4X4_3:"Gripped!", MAYHEM:"Multistorey Mayhem", AMBULAN:"Paramedic", FIRETRU:"Firefighter", COPCAR:"Vigilante", TAXI:"Taxi Driver", MEAT1:"The Crook", MEAT2:"The Thieves", MEAT3:"The Wife", MEAT4:"Her Lover", EIGHT:"Give Me Liberty and Luigi's Girls", LUIGI2:"Don't Spank Ma Bitch Up", LUIGI3:"Drive Misty For Me", LUIGI4:"Pump-Action Pimp", LUIGI5:"The Fuzz Ball", JOEY1:"Mike Lips Last Lunch", JOEY2:"Farewell 'Chunky' Lee Chong", JOEY3:"Van Heist", JOEY4:"Cipriani's Chauffeur", JOEY5:"Dead Skunk In The Trunk", JOEY6:"The Getaway", TONI1:"Taking Out The Laundry", TONI2:"The Pick-Up", TONI3:"Salvatore's Called A Meeting", TONI4:"Triads And Tribulations", TONI5:"Blow Fish", FRANK1:"Chaperone", FRANK2:"Cutting The Grass", FRANK21:"Bomb Da Base: Act I", FRANK3:"Bomb Da Base: Act II", FRANK4:"Last Requests", DIABLO1:"Turismo", DIABLO2:"I Scream, You Scream", DIABLO3:"Trial By Fire", DIABLO4:"Big'N'Veiny", ASUKA1:"Sayonara Salvatore", ASUKA2:"Under Surveillance", ASUKA3:"Paparazzi Purge", ASUKA4:"Payday For Ray", ASUKA5:"Two-Face Tanner", KENJI1:"Kanbu Bust-Out", KENJI2:"Grand Theft Auto", KENJI3:"Deal Steal", KENJI4:"Shima", KENJI5:"Smack Down", RAY1:"Silence The Sneak", RAY2:"Arms Shortage", RAY3:"Evidence Dash", RAY4:"Gone Fishing", RAY5:"Plaster Blaster", RAY6:"Marked Man", LOVE1:"Liberator", LOVE2:"Waka-Gashira Wipeout!", LOVE3:"A Drop In The Ocean", YARD1:"Bling-Bling Scramble", YARD2:"Uzi Rider", YARD3:"Gangcar Round-Up", YARD4:"Kingdom Come", LOVE4:"Grand Theft Aero", LOVE5:"Escort Service", LOVE6:"Decoy", LOVE7:"Love's Disappearance", ASUSB1:"Bait", ASUSB2:"Espresso-2-Go!", ASUSB3:"S.A.M.", HOOD1:"Uzi Money", HOOD2:"Toyminator", HOOD3:"Rigged To Blow", HOOD4:"Bullion Run", HOOD5:"Rumble", CAT1:"The Exchange"}
	MissionName := MissionNameArray[TestName]
	return MissionName
}
