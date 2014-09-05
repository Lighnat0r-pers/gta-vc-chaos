ChooseColourDialog(InputOutputColour, GuiHandle=0, CustomColoursStructure=0)
{
	; Since the way the colour dialog uses the colour data is not directly compatible
	; with the way it's used in the programs, it has to be converted.
	StringSplit, ColourSub, InputOutputColour
	InputOutputColour := "0x" ColourSub5 ColourSub6 ColourSub3 ColourSub4 ColourSub1 ColourSub2
	VarSetCapacity(ColourStructure, 0x24, 0)
		NumPut(0x24, ColourStructure, 0x0, "Uint")
		if GuiHandle != 0
			NumPut(GuiHandle, ColourStructure, 0x4) ; Will make the colour dialog owned by the gui window
		NumPut(InputOutputColour, ColourStructure, 0xC, "Uint") ; Input/Output
		ColourTest := NumGet(ColourStructure, 0xC, "Uint")
		if CustomColoursStructure != 0
			NumPut(&CustomColoursStructure, ColourStructure, 0x10) ; Pointer to the Custom Colours structure
		NumPut(0x00000103, ColourStructure, 0x14, "Uint") ; Sets the following flags: CC_ANYCOLOR, CC_RGBINIT, CC_FULLOPEN
	ChooseColourErrorLevel := DllCall("Comdlg32\ChooseColor", "Ptr", &ColourStructure)
	; Since the way the colour dialog saves the colour data is not directly compatible
	; with the way it's used in the programs, it has to be converted.
	if ChooseColourErrorLevel != 0
	{
		ColourHex := NumGet(ColourStructure, 0xC, "Uint")
		SetFormat, Integer, H
		ColourHex := ColourHex+0
		StringTrimLeft, Colour, ColourHex, 2
		Colour := SubStr("00000" . Colour,-5)
		StringSplit, ColourSub, Colour
		Colour = % ColourSub5 ColourSub6 ColourSub3 ColourSub4 ColourSub1 ColourSub2
		SetFormat, Integer, D
		return %Colour%
	}
	Else
		return "Error"
}
