IIIGetVehicleName(VehicleID)
{
	VehicleNameArray := {90:"Landstalker", 91:"Idaho", 92:"Stinger", 93:"Linerunner", 94:"Perennial", 95:"Sentinel", 96:"Patriot", 97:"Firetruck",98:"Trashmaster", 99:"Stretch", 100:"Manana", 101:"Infernus", 102:"Blista", 103:"Pony", 104:"Mule", 105:"Cheetah", 106:"Ambulance", 107:"FBI Car", 108:"Moonbeam", 109:"Esperanto", 110:"Taxi", 111:"Kuruma", 112:"Bobcat", 113:"Mr. Whoopy", 114:"BF Injection", 115:"Manana with corpse", 116:"Police", 117:"Enforcer", 118:"Securicar", 119:"Banshee", 120:"Predator", 121:"Bus", 122:"Rhino", 123:"Barracks OL", 124:"Train", 125:"Chopper", 126:"Dodo", 127:"Coach", 128:"Cabbie", 129:"Stallion", 130:"Rumpo", 131:"RC Bandit", 132:"Triad Fish Van", 133:"Mr Wong's", 134:"Mafia Sentinel", 135:"Yardio Lobo", 136:"Yakuza Stinger", 137:"Diablo Stallion", 138:"Cartel Cruiser", 139:"Hoods Rumpo XL", 140:"Airtrain", 141:"DeadDodo", 142:"Speeder", 143:"Reefer", 144:"Panlantic", 145:"Flatbed", 146:"Yankee", 147:"Helicopter", 148:"Borgnine", 149:"Toyz", 150:"Ghost"}
	VehicleName := VehicleNameArray[VehicleID]
	return VehicleName
}
