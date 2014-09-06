VCGetCorrectAddressForVersion(Address)
{
	Value := Memory(3, 0x00608578, 1)
	if Value = 93 ; V1.0
		Return Address
	if Value = 129 ; V1.1
	{
		If Address <= 0x00489D0A
			return Address
		else if Address <= 0x00489D0C
			return Address + 4
		else if Address <= 0x00489D81
			return Address + 13
		else if Address <= 0x00489E0D
			return Address + 14
		else if Address <= 0x00498FEE
			return Address + 16
		else if Address <= 0x004A4251
			return Address + 33
		else if Address <= 0x00600FAF
			return Address + 32
		else if Address <= 0x00601F45
			return Address + 48
		else if Address <= 0x00601F49
			return Address + 46
		else if Address <= 0x00601F50
			return Address + 40
		else if Address <= 0x00601F89
			return Address + 38
		else if Address <= 0x00601F8D
			return Address + 36
		else if Address <= 0x00601FD0
			return Address - 30
		else if Address <= 0x00601FF4
			return Address - 37
		else if Address <= 0x00601FF8
			return Address - 39
		else if Address <= 0x006271EC
			return Address - 32
		else if Address <= 0x006272DA
			return Address + 15
		else if Address <= 0x006273CE
			return Address + 16
		else if Address <= 0x00627447
			return Address + 35
		else if Address <= 0x0062746C
			return Address + 40
		else if Address <= 0x006274B5
			return Address + 38
		else if Address <= 0x006274C1
			return Address + 42
		else if Address <= 0x00627569
			return Address + 32
		else if Address <= 0x0062758C
			return Address + 70
		else if Address <= 0x0067DD05
			return Address + 80
		else if Address <= 0x006D6658
			return Address
		else if Address <= 0x006D6B24
			return Address - 44
		else if Address <= 0x006DB8E4
			return Address - 40
		else if Address <= 0x006DB920
			return Address - 48
		else if Address <= 0x006DF9F4
			return Address - 16
		else if Address <= 0x00786BA4
			return Address
		else if Address <= 0x00786D3C
			return Address + 4
		else if Address <= 0x00A10B4C
			return Address + 8
		else if Address <= 0x00A10BA0
			return Address + 9
		else
			return "Error: Value not recognized"
	}
	if Value = 91 ; Steam
	{
		return "Version not yet supported"
	}
}
