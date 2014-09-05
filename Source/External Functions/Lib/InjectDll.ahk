InjectDll(exe="",dll="")
{
	if Not FileExist(dll)
		{
			msgbox, "The Dll you have specified is invalid."
			return
		}
	DllFullPath = %A_WorkingDir%\%dll%
	Process, Wait, %exe% ; Set ErrorLevel to PID
	PID := ErrorLevel
	if Not PID
		{
			msgbox, "The target process does not exist."
			return
		}
	StringLength := StrLen(DllFullPath)
	ProcessHandle := DllCall("OpenProcess","Int",2035711,"Int", 0,"UInt",PID) ; Retrieve the process handle
	DllAddress := DllCall("VirtualAllocEx", "Ptr", ProcessHandle, "Ptr", 0, "Ptr", StringLength, "UInt", MEM_COMMIT, "UInt", PAGE_EXECUTE_READWRITE, "Ptr") ; Allocate memory for the dll
	DllCall("WriteProcessMemory","UInt",ProcessHandle,"UInt",DllAddress,"Uint*",DllFullPath,"Uint",StringLength,"Uint",0) ; Write the dll name to the allocated memory
	Kernel32Handle:= DllCall("GetModuleHandle","Str","Kernel32") ; Get the handle of Kernel32.dll
	LoadLibrary := DllCall("GetProcAddress","PTR",Kernel32Handle,"AStr","LoadLibraryA","PTR") ; Get the address of LoadLibraryA
	ThreadHandle := DllCall("CreateRemoteThread", "PTR", ProcessHandle, "UInt", 0, "UInt", 0, "PTR", LoadLibrary, "PTR", DllAddress, "UInt", 0, "UInt", 0) ; Load the dll into the memory
	DllCall("WaitForSingleObject", "PTR", ThreadHandle, "UInt", INFINITE) ; Wait until the remote thread to finish
	DllCall("GetExitCodeThread", "PTR", ThreadHandle, "UIntP", ExitCode) ; 
 	If Not ExitCode
		{
			msgbox, "Could not execute script in remote process."
			return
		}
   	 DllCall("CloseHandle", "PTR", ThreadHandle) ; Close the handle to the thread
   	 DllCall("VirtualFreeEx","PTR",ProcessHandle,"PTR",DllAddress,"PTR",StringLength,MEM_RELEASE) ; Free the allocated memory
   	 DllCall("CloseHandle", "PTR", ProcessHandle) ; Close the handle to the process
}
