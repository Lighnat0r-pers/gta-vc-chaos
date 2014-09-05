#SingleInstance Force
menu, tray, NoStandard
outputdebug Debug logger started
TargetProcessPID = %1%
LogFileName = %2%
; %3% contains a window handle of the script that started this one.
Gui, New
Gui, +HwndLoggerHandle
Gui, Show, Hide
DetectHiddenWindows On
PostMessage, 0x12345, %LoggerHandle%,,,ahk_id %3% 
;outputdebug Logger handle sent
DetectHiddenWindows Off
OnMessage(0x12345, "StopLoggingFunction")
SetFormat, Integer, H
DebugEventSubroutinesArray := {1:"EXCEPTION_DEBUG_EVENT", 2:"CREATE_THREAD_DEBUG_EVENT", 3:"CREATE_PROCESS_DEBUG_EVENT", 4:"EXIT_THREAD_DEBUG_EVENT", 5:"EXIT_PROCESS_DEBUG_EVENT", 6:"LOAD_DLL_DEBUG_EVENT", 7:"UNLOAD_DLL_DEBUG_EVENT", 8:"OUTPUT_DEBUG_STRING_EVENT", 9:"RIP_EVENT"}
ExceptionCodesArray := {0xC0000005:"EXCEPTION_ACCESS_VIOLATION", 0xC000008C:"EXCEPTION_ARRAY_BOUNDS_EXCEEDED", 0x80000003:"EXCEPTION_BREAKPOINT", 0x80000002:"EXCEPTION_DATATYPE_MISALIGNMENT", 0xC000008D:"EXCEPTION_FLT_DENORMAL_OPERAND", 0xC000008E:"EXCEPTION_FLT_DIVIDE_BY_ZERO", 0xC000008F:"EXCEPTION_FLT_INEXACT_RESULT", 0xC0000090:"EXCEPTION_FLT_INVALID_OPERATION", 0xC0000091:"EXCEPTION_FLT_OVERFLOW", 0xC0000092:"EXCEPTION_FLT_STACK_CHECK", 0xC0000093:"EXCEPTION_FLT_UNDERFLOW", 0xC000001D:"EXCEPTION_ILLEGAL_INSTRUCTION", 0xC0000006:"EXCEPTION_IN_PAGE_ERROR", 0xC0000094:"EXCEPTION_INT_DIVIDE_BY_ZERO", 0xC0000095:"EXCEPTION_INT_OVERFLOW", 0xC0000026:"EXCEPTION_INVALID_DISPOSITION", 0xC0000025:"EXCEPTION_NONCONTINUABLE_EXCEPTION", 0xC0000096:"EXCEPTION_PRIV_INSTRUCTION", 0x80000004:"EXCEPTION_SINGLE_STEP", 0xC00000FD:"EXCEPTION_STACK_OVERFLOW"}

; ######################################################################################################
; ############################################### MAIN SECTION #########################################
; ######################################################################################################

ReturnValue := DllCall("DebugActiveProcess", "UInt", TargetProcessPID)
If ReturnValue = 0
{
	Error := GetLastErrorMessage()
	outputdebug DebugActiveProcess Error`: %Error%
	outputdebug Shutting down debug logger due to error
	exitapp
}
Memory(1, TargetProcessPID)
While StopLoggingDebugMessages != 1
{
	Global DebugEventStructure
	VarSetCapacity(DebugEventStructure, 0x100, 0)
	ReturnValue := DllCall("WaitForDebugEvent", "Ptr", &DebugEventStructure, "UInt", 100)
	If ReturnValue = 0
	{
		; Error code 121 is sent if the function times out, which it will do every 100ms in order 
		; to be able to check if StopLoggingDebugMessages is set to 1. So to avoid spamming debug
		; messages, error code 121 will not generate a debug message. 
		; All other error codes indicate a problem so they should be reported.
		If (DllCall("GetLastError") = 121)
			continue
		Error := GetLastErrorMessage()
		outputdebug WaitForDebugEvent Error`: %Error%
		continue
	}
	DebugEventCode := NumGet(DebugEventStructure, 0x00, "UInt")
	ProcessID := NumGet(DebugEventStructure, 0x04, "UInt")
	ThreadID := NumGet(DebugEventStructure, 0x08, "UInt")
	ReturnValue := DllCall("ContinueDebugEvent", "UInt", ProcessID, "UInt", ThreadID, "UInt", 0x80010001)
	If ReturnValue = 0
	{
		Error := GetLastErrorMessage()
		outputdebug ContinueDebugEvent Error`: %Error%
	}
	FileAppend, `n`nDebug Event`:, %LogFileName%
	FileAppend, `nTime`: %A_Hour%`:%A_Min%`:%A_Sec%`.%A_MSec%, %LogFileName%
	FileAppend, `nDebug event code`: %DebugEventCode%, %LogFileName%
	FileAppend, `nProcess ID`: %ProcessID%, %LogFileName%
	FileAppend, `nThread ID`: %ThreadID%, %LogFileName%
	DebugEventSubroutine := DebugEventSubroutinesArray[DebugEventCode]
	If !IsLabel(DebugEventSubroutine)
	{
		FileAppend, `nUnknown debug event code`. Could not extract further data`., %LogFileName%
		continue
	}
	FileAppend, `nDebug event name`: %DebugEventSubroutine%, %LogFileName%	
	gosub %DebugEventSubroutine% ; Append event specific data in the subroutines.
}
DllCall("DebugSetKillOnExit", "Int", 0)
DllCall("DebugActiveProcessStop", "UInt", TargetProcessPID)
outputdebug Shutting down debug logger
exitapp
return

; ######################################################################################################
; ############################################ HANDLE DEBUG EVENTS #####################################
; ######################################################################################################

EXCEPTION_DEBUG_EVENT:
ExceptionCode := NumGet(DebugEventStructure, 0x0C, "UInt")
ExceptionFlags := NumGet(DebugEventStructure, 0x10, "UInt")
NestedExceptionPointer := NumGet(DebugEventStructure, 0x14, "Ptr")
ExceptionAddress := NumGet(DebugEventStructure, 0x18, "Ptr")
NumberParameters := NumGet(DebugEventStructure, 0x1C, "UInt")
ExceptionInformation := NumGet(DebugEventStructure, 0x20, "UInt")
FirstChance := NumGet(DebugEventStructure, 0x24, "UInt")
ExceptionName := DebugEventSubroutinesArray[ExceptionCode]
FileAppend, `nException code`: %ExceptionCode%, %LogFileName%
FileAppend, `nException name`: %ExceptionName%, %LogFileName%
FileAppend, `nException flags`: %ExceptionFlags%, %LogFileName%
FileAppend, `nNested exception pointer`: %NestedExceptionPointer%, %LogFileName%
FileAppend, `nException address`: %ExceptionAddress%, %LogFileName%
FileAppend, `nNumber parameters`: %NumberParameters%, %LogFileName%
FileAppend, `nException Information`: %ExceptionInformation%, %LogFileName%
FileAppend, `nFirst chance`: %FirstChance%, %LogFileName%
return

CREATE_THREAD_DEBUG_EVENT:
ThreadHandle := NumGet(DebugEventStructure, 0x0C, "Ptr")
ThreadLocalBase := NumGet(DebugEventStructure, 0x10, "Ptr")
ThreadStartAddress := NumGet(DebugEventStructure, 0x14, "Ptr")
FileAppend, `nThread handle`: %ThreadHandle%, %LogFileName%
FileAppend, `nThread local base`: %ThreadLocalBase%, %LogFileName%
FileAppend, `nThread start address`: %ThreadStartAddress%, %LogFileName%
return

CREATE_PROCESS_DEBUG_EVENT:
FileHandle := NumGet(DebugEventStructure, 0x0C, "Ptr")
ProcessHandle := NumGet(DebugEventStructure, 0x10, "Ptr")
MainThreadHandle := NumGet(DebugEventStructure, 0x14, "Ptr")
BaseAddressOfExecutableImage := NumGet(DebugEventStructure, 0x18, "Ptr")
InfoFileOffset := NumGet(DebugEventStructure, 0x1C, "UInt")
InfoSize := NumGet(DebugEventStructure, 0x20, "UInt")
ThreadLocalBase := NumGet(DebugEventStructure, 0x24, "Ptr")
ProcessStartAddress := NumGet(DebugEventStructure, 0x28, "Ptr")
ImageNameAddress := NumGet(DebugEventStructure, 0x2C, "Ptr")
ImageNameType := NumGet(DebugEventStructure, 0x30, "UShort")
FileAppend, `nFile handle`: %FileHandle%, %LogFileName%
FileAppend, `nProcess handle`: %ProcessHandle%, %LogFileName%
FileAppend, `nMain thread handle`: %MainThreadHandle%, %LogFileName%
FileAppend, `nBase address of executable image`: %BaseAddressOfExecutableImage%, %LogFileName%
FileAppend, `nInfo file offset`: %InfoFileOffset%, %LogFileName%
FileAppend, `nInfo size`: %InfoSize%, %LogFileName%
FileAppend, `nThread local base`: %ThreadLocalBase%, %LogFileName%
FileAppend, `nProcess start address`: %ProcessStartAddress%, %LogFileName%
FileAppend, `nImage name address`: %ImageNameAddress%, %LogFileName%
FileAppend, `nImage name type`: %ImageNameType%, %LogFileName%
return

EXIT_THREAD_DEBUG_EVENT:
ThreadExitCode := NumGet(DebugEventStructure, 0x0C, "UInt")
FileAppend, `nExit code`: %DebugThreadExitCode%, %LogFileName%	
return

EXIT_PROCESS_DEBUG_EVENT:
ProcessExitCode := NumGet(DebugEventStructure, 0x0C, "UInt")
FileAppend, `nExit code`: %DebugProcessExitCode%, %LogFileName%	
return

LOAD_DLL_DEBUG_EVENT:
DllFileHandle := NumGet(DebugEventStructure, 0x0C, "Ptr")
BaseAddressOfDll := NumGet(DebugEventStructure, 0x10, "Ptr")
InfoFileOffset := NumGet(DebugEventStructure, 0x14, "UInt")
InfoSize := NumGet(DebugEventStructure, 0x18, "UInt")
ImageNameAddress := NumGet(DebugEventStructure, 0x1C, "Ptr")
ImageNameType := NumGet(DebugEventStructure, 0x20, "UShort")
FileAppend, `nDll file handle`: %DllFileHandle%, %LogFileName%
FileAppend, `nBase address of Dll`: %BaseAddressOfDll%, %LogFileName%
FileAppend, `nInfo file offset`: %InfoFileOffset%, %LogFileName%
FileAppend, `nInfo size`: %InfoSize%, %LogFileName%
FileAppend, `nImage name address`: %ImageNameAddress%, %LogFileName%
FileAppend, `nImage name type`: %ImageNameType%, %LogFileName%
return

UNLOAD_DLL_DEBUG_EVENT:
BaseAddressOfDll := NumGet(DebugEventStructure, 0x0C, "Ptr")
FileAppend, `nBase address of Dll`: %BaseAddressOfDll%, %LogFileName%
return

OUTPUT_DEBUG_STRING_EVENT:
; The debug event structure will contain 3 values: 
; 	A pointer to the memory address where the string is stored, in the memory of the debugged program (not the debugger).
;	A (short) variable indicating if the string is Unicode (non-zero), or ANSI (zero).
;	A (short) variable containing the length of the debug string. 
; If the string is in Unicode, we need to read (debug string length x 2) bytes at the pointer location.
; Otherwise reading (debug string length) bytes will suffice
DebugStringPointer := NumGet(DebugEventStructure, 0x0C, "Ptr")
DebugStringType := NumGet(DebugEventStructure, 0x10, "UShort")
DebugStringLength := NumGet(DebugEventStructure, 0x12, "UShort")
; Check if the string is in Unicode, and change the string length accordingly
If DebugStringType != 0
	DebugStringType := "Unicode"
Else
	DebugStringType := "Ascii"
VarSetCapacity(DebugStringOutput, DebugStringLength, 0)
DebugStringOutput := Memory(3, DebugStringPointer, DebugStringLength, DebugStringType)
FileAppend, `nDebug string`: %DebugStringOutput%, %LogFileName%	
return

RIP_EVENT:
Error := NumGet(DebugEventStructure, 0x0C, "UInt")
Type := NumGet(DebugEventStructure, 0x10, "UInt")
FileAppend, `nError`: %Error%, %LogFileName%
FileAppend, `nType`: %Type%, %LogFileName%
return

; ######################################################################################################
; ########################################### ON MESSAGE FUNCTIONS #####################################
; ######################################################################################################

StopLoggingFunction()
{
	global
;	outputdebug StopLoggingDebugMessages
	StopLoggingDebugMessages = 1
}

; ######################################################################################################
; ############################################## LISTVARS HOTKEY #######################################
; ######################################################################################################

F8::
Listvars
return

