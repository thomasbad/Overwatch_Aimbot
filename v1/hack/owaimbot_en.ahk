; AutoHotkey Version: 1.0.39+
; Language:  English
; Platform:  Win2000/XP
; Author:    Laszlo Hars <www.Hars.US>
; Function:  SW copy protection

k0 = 0x19901224
k1 = 0x19890111
k2 = 0x20160704
k3 = 0x12587653

l0 = 0x58413568
l1 = 0x87521634

m0 = 0x56874289
m1 = 0x56842387

IniFile = license.ini

GoSub    CheckAuth
SetTimer CheckAuth,1000
MsgBox,,,This hack is purchased by`n%User% at %Email%for activation,4
MsgBox,,,It is suggest you to rename the hack`nFor example：iexplore.exe`nTo make it much difficult to detect,10


; <COMPILER: v1.1.24.01>
; <COMPILER: v1.1.24.01>
guif:
#NoEnv
#SingleInstance force
SkinForm(Apply, A_ScriptDir . "\USkin.dll", A_ScriptDir . "\Milikymac.msstyles")
Gui,Add,Text,x220 y20 w130 h20,Run 1280 x 720 Mode [F1]
Gui,Add,Text,x220 y40 w140 h20,Run 1920 x 1080 Mode [F2]
Gui,Add,Text,x220 y60 w110 h20,Restart Program [F3]
Gui,Add,Text,x220 y80 w110 h20,Pause / Resume [ALT]
Gui,Add,GroupBox,x10 y120 w160 h45,Aim Speed Control
Gui,Add,GroupBox,x10 y10 w160 h100,Activation
Gui,Add,Checkbox,x20 y30 w70 h20 vaimtype,LButton
Gui,Add,Checkbox,x90 y30 w70 h20 vaimtype1,Rbutton
Gui,Add,Checkbox,x40 y70 w120 h20 vaimtype2,CapsLock Button
Gui,Add,Checkbox,x20 y50 w70 h20 vaimtype3,MButton4
Gui,Add,Checkbox,x90 y50 w70 h20 vaimtype4,MButton5
Gui,Add,Text,x40 y140 w35 h20,Sens:
Gui,Add,Edit,x80 y140 w50 h20 vrx,3
Gui,Add,Button,x220 y140 w100 h20 gsub4,About Aim Speed
Gui,Add,Button,x230 y160 w80 h20 gsub1,Issues?
Gui,Add,GroupBox,x10 y170 w185 h190,Misc
Gui,Add,Checkbox,x20 y190 w160 h20 vmccree,Mccree Right Click No Recoil
Gui,Add,Checkbox,x20 y210 w160 h20 vtorbjorn,Torbjorn Fast Reload
Gui,Add,Checkbox,x20 y230 w160 h20 vpharah,Pharah Fast Reload
Gui,Add,Checkbox,x20 y250 w160 h20 vreaper,Reaper Fast Reload
Gui,Add,Checkbox,x20 y270 w160 h20 vroadhog,RoadHog Fast Reload
Gui,Add,Checkbox,x20 y290 w160 h20 vroadhog1,RoadHog Combo
Gui,Add,Checkbox,x20 y310 w160 h20 vgenji,Genji combo
Gui,Add,Checkbox,x20 y330 w160 h20 vbunny,Bunnyhop
Gui,Add,Button,x230 y180 w80 h20 gsub2,How-to
Gui,Add,Button,x230 y200 w80 h20 gsub3,Best Settings

Gui,Show,w372 h391,MeowMewatch Undetectable Ninja aimbot v1.1
Loop {
Gui, Submit, NoHide
Sleep -1
}
Return
#If bunny=1
*~$Space::
sleep 20
loop
{
GetKeyState, SpaceState, Space, P
if SpaceState = U
break
Sleep 1
Send, {Blind}{Space}
}
Return
#If
Return
Return
#If roadhog1=1
mbutton::
MouseClick, right
sleep, 5
Send {LShift down}{LShift up}
sleep, 1040
MouseClick, left
sleep, 50
Send {v down}{v up}
Return
#If
Return
#If genji=1
mbutton::
MouseClick, right
sleep, 15
Send {v down}{v up}
sleep, 15
Send {Shift down}{Shift up}
Return
#If
Return
#If roadhog=1
$r::
Send {r}
Sleep 1880
Send {v}
Return
#If
Return
#If torbjorn=1
$r::
Send {r}
Sleep 1780
Send {v}
Return
#If
Return
#If pharah=1
$r::
Send {r}
Sleep 1200
Send {v}
Return
#If
return
#If reaper=1
$r::
Send {r}
Sleep 300
Send {v}
Return
#If
return
#If mccree=1
~RButton::
Loop
If GetKeyState("RButton") {
Sleep, 5
moveAmount := (moveAmount = 2) ? 3 : 0
mouseXY(moveAmount,3.4)
}
else
break
Return
mouseXY(x,y)
{
DllCall("mouse_event",int,1,int,x,int,y,uint,0,uint,0)
}
#If
return
#If aimtype2=1
~capslock::
GoSub MouseMoves2
Return
#If
Return
sub1:
{
msgbox, Having issues?`n`nMccree Right Click No Recoil Does NOT!!! work with right click aimlock`nHOLD DOWN RIGHT CLICK FOR IT TO WORK DONT JUST PRESS BUTTON`n`nAll Combos are middle mouse button`n`nCheat is CPU intensive and only uses math.`n`nLowFPS: Lower Aim speed to 3.`nLowFPS: Lower resolution to 720p and play on low.`nLowFPS: If you get low fps after a playthrough, press F3 to restart the cheat.`n`nCursor jumping left or right when using Aim key?`n`nJumpBug:Your PC is lagging out when using Aimkey. Check LowFPS solution.`nJumpBug: Switch your resolution to 720p but use F2(1080p) with Aim Speed 3.`n`nAlways try the cheat out in Practice Range to find your best settings.
}
return
sub2:
{
msgbox, How-to:`n`nLaunch Game. Switch to Borderless Windowed mode.`nResolution has to be 720p or 1080p. As precaution, set your quality settings to Low.`n`nTo-use:`nPress F1 or F2 depending on your resolution.`nShoot an Enemy. When the Health Bar is visible press the aimkey to snap onto the target.`n`nIf nothing is happening make sure you are not using any desktop applications that alter your color settings or are recording your gameplay such as W10 DVR or Fraps.
}
return
sub3:
{
msgbox, Best Settings for the cheat (Legit):`n`nResolution: 1280x720`nAim Speed: 3
}
return
sub4:
{
msgbox, Higher the number, Faster the it locks on. `n`Lower the number, The slower it locks on.
}
return
GuiClose:
ExitApp
return
SkinForm(Param1 = "Apply", DLL = "", SkinName = ""){
if(Param1 = Apply){
DllCall("LoadLibrary", str, DLL)
DllCall(DLL . "\USkinInit", Int,0, Int,0, AStr, SkinName)
}else if(Param1 = 0){
DllCall(DLL . "\USkinExit")
}
}
Change1:
MsgBox,  Applied
Gui,Submit, Nohide
return
F1::
#Persistent
#KeyHistory, 0
#NoEnv
#HotKeyInterval 1
#MaxHotkeysPerInterval 127
#InstallKeybdHook
#UseHook
#SingleInstance, Force
SetKeyDelay,-1, 8
SetControlDelay, -1
SetMouseDelay, 0
SetWinDelay,-1
SendMode, InputThenPlay
SetBatchLines,-1
ListLines, Off
CoordMode, Mouse, Screen
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, Normal
ZeroX := 640
ZeroY := 360
CFovX := 320
CFovY := 200
ScanL := 500
ScanR := 800
ScanT := 180
ScanB := 400
GuiControlget, rX
Loop, {
Gui,Submit, Nohide
if (aimtype=1)
{
GetKeyState, Mouse2, LButton, P
GoSub MouseMoves2
}
if (aimtype1=1)
{
GetKeyState, Mouse2, RButton, P
GoSub MouseMoves2
}
if (aimtype3=1)
{
GetKeyState, Mouse2, XButton1, P
GoSub MouseMoves2
}
if (aimtype4=1)
{
GetKeyState, Mouse2, XButton2, P
GoSub MouseMoves2
}
ImageSearch, AimPixelX, AimPixelY,ScanL, ScanT, ScanR, ScanB,  *4 hhp.bmp
GoSub GetAimOffset
GoSub GetAimMoves
}
MouseMoves:
If ( Mouse2 == "D" ) {
DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
}
Return
MouseMoves1:
If ( Mouse2 == "U" ) {
DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
}
Return
GetAimOffset:
Gui,Submit, Nohide
AimX := AimPixelX - ZeroX +41
AimY := AimPixelY - ZeroY +63
If ( AimX+5 > 0) {
DirX := rx / 10
}
If ( AimX+5 < 0) {
DirX := (-rx) / 10
}
If ( AimY+2 > 0 ) {
DirY := rX /10 *0.5
}
If ( AimY+2 < 0 ) {
DirY := (-rx) /10 *0.5
}
AimOffsetX := AimX * DirX
AimOffsetY := AimY * DirY
Return
GetAimMoves:
RootX := Ceil(( AimOffsetX ** ( 1/2 )))
RootY := Ceil(( AimOffsetY ** ( 1/2 )))
MoveX := RootX * DirX
MoveY := RootY * DirY
Return
SleepF:
SleepDuration = 1
TimePeriod = 1
DllCall("Winmm\timeBeginPeriod", uint, TimePeriod)
Iterations = 1
StartTime := A_TickCount
Loop, %Iterations% {
DllCall("Sleep", UInt, TimePeriod)
}
DllCall("Winmm\timeEndPeriod", UInt, TimePeriod)
Return
DebugTool:
MouseGetPos, MX, MY
ToolTip, %AimOffsetX% | %AimOffsetY%
ToolTip, %AimX% | %AimY%
ToolTip, %IntAimX% | %IntAimY%
ToolTip, %RootX% | %RootY%
ToolTip, %MoveX% | %MoveY% || %MX% %MY%
Return
F2::
#Persistent
#KeyHistory, 0
#NoEnv
#HotKeyInterval 1
#MaxHotkeysPerInterval 2000
#InstallKeybdHook
#UseHook
#SingleInstance, Force
SetKeyDelay,-1, 8
SetControlDelay, -1
SetMouseDelay, 0
SetWinDelay,-1
SendMode, InputThenPlay
SetBatchLines,-1
ListLines, Off
CoordMode, Mouse, Screen
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, Normal
ZeroX := 960
ZeroY := 540
CFovX := 80
CFovY := 200
ScanL := 660
ScanR := 1250
ScanT := 280
ScanB := 610
GuiControlget, rX
Loop, {
Gui,Submit, Nohide
if (aimtype=1)
{
GetKeyState, Mouse2, LButton, P
GoSub MouseMoves2
}
if (aimtype1=1)
{
GetKeyState, Mouse2, RButton, P
GoSub MouseMoves2
}
if (aimtype3=1)
{
GetKeyState, Mouse2, XButton1, P
GoSub MouseMoves2
}
if (aimtype4=1)
{
GetKeyState, Mouse2, XButton2, P
GoSub MouseMoves2
}
ImageSearch, AimPixelX, AimPixelY, ScanL, ScanT, ScanR, ScanB,  *4 hhp2.bmp
GoSub GetAimOffset1
GoSub GetAimMoves1
}
MouseMoves2:
If ( Mouse2 == "D" ) {
DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
}
Return
MouseMoves11:
If ( Mouse2 == "U" ) {
DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
}
GetAimOffset1:
Gui,Submit, Nohide
AimX := AimPixelX - ZeroX +58
AimY := AimPixelY - ZeroY +85
If ( AimX+10 > 0) {
DirX := rx / 10
}
If ( AimX+10 < 0) {
DirX := (-rx) / 10
}
If ( AimY+5 > 0 ) {
DirY := rX /10 *0.5
}
If ( AimY+5 < 0 ) {
DirY := (-rx) /10 *0.5
}
AimOffsetX := AimX * DirX
AimOffsetY := AimY * DirY
Return
GetAimMoves1:
RootX := Ceil(( AimOffsetX ** ( 1 )))
RootY := Ceil(( AimOffsetY ** ( 1 )))
MoveX := RootX * DirX
MoveY := RootY * DirY
Return
reload:
SleepF1:
SleepDuration = 1
TimePeriod = 1
DllCall("Winmm\timeBeginPeriod", uint, TimePeriod)
Iterations = 1
StartTime := A_TickCount
Loop, %Iterations% {
DllCall("Sleep", UInt, TimePeriod)
}
DllCall("Winmm\timeEndPeriod", UInt, TimePeriod)
Return
DebugTool1:
MouseGetPos, MX, MY
ToolTip, %AimOffsetX% | %AimOffsetY%
ToolTip, %AimX% | %AimY%
ToolTip, %IntAimX% | %IntAimY%
ToolTip, %RootX% | %RootY%
ToolTip, %MoveX% | %MoveY% || %MX% %MY%
Return
ALT::
pause
SoundPlay, C:\WINDOWS\Media\ding.wav
return
F3::
Reload
Return

ExitApp

;---- End autoexecute secsion ----;

CheckAuth:
   IniRead User, %IniFile%, Registration, User
   IniRead Email,%IniFile%, Registration, Email
   IniRead Code, %IniFile%, Registration, UnlockCode
   PCdata = %COMPUTERNAME%%HOMEPATH%%USERNAME%%PROCESSOR_ARCHITECTURE%%PROCESSOR_IDENTIFIER%
   PCdata = %PCdata%%PROCESSOR_LEVEL%%PROCESSOR_REVISION%%A_OSType%%A_OSVersion%%Language%
   Fingerprint := XCBC(Hex(PCdata,StrLen(PCdata)), 0,0, 0,0,0,0, 1,1, 2,2)
   Together = %User%%Email%%Fingerprint%
   AuthData := XCBC(Hex(Together,StrLen(Together)), 0,0, k0,k1,k2,k3, l0,l1, m0,m1)
   If (User="Error" || Email="Error" || Code <> AuthData)
   {
      S =
      (  LTrim
         To: thomasgoodboy@gmail.com
         User name = <Please enter your username here>
         Email address = <Your license key will be sent to here>

         PC fingerprint
	(Please make sure it can only activate on 1 PC only，
	or you need to purchase another one) = %Fingerprint%
      )
      ClipBoard = %S%
      MsgBox This hack needs license key to activate!Please send below info to: thomasgoodboy@gmail.com for pruchasement`n`n%S%`n`n(Info have auto-copied)
      ExitApp
   }
Return

;---- Crypto functions ----;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TEA cipher ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Block encryption with the TEA cipher
; [y,z] = 64-bit I/0 block
; [k0,k1,k2,k3] = 128-bit key
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TEA(ByRef y,ByRef z, k0,k1,k2,k3)
{                                   ; need  SetFormat Integer, D
   s = 0
   d = 0x9E3779B9
   Loop 32                          ; could be reduced to 8 for speed
   {
      k := "k" . s & 3              ; indexing the key
      y := 0xFFFFFFFF & (y + ((z << 4 ^ z >> 5) + z  ^  s + %k%))
      s := 0xFFFFFFFF & (s + d)  ; simulate 32 bit operations
      k := "k" . s >> 11 & 3
      z := 0xFFFFFFFF & (z + ((y << 4 ^ y >> 5) + y  ^  s + %k%))
   }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; XCBC-MAC ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; x  = long hex string input
; [u,v] = 64-bit initial value (0,0)
; [k0,k1,k2,k3] = 128-bit key
; [l0,l1] = 64-bit key for not padded last block
; [m0,m1] = 64-bit key for padded last block
; Return 16 hex digits (64 bits) digest
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XCBC(x, u,v, k0,k1,k2,k3, l0,l1, m0,m1)
{
   Loop % Ceil(StrLen(x)/16)-1   ; full length intermediate message blocks
      XCBCstep(u, v, x, k0,k1,k2,k3)

   If (StrLen(x) = 16)              ; full length last message block
   {
      u := u ^ l0                   ; l-key modifies last state
      v := v ^ l1
      XCBCstep(u, v, x, k0,k1,k2,k3)
   }
   Else {                           ; padded last message block
      u := u ^ m0                   ; m-key modifies last state
      v := v ^ m1
      x = %x%100000000000000
      XCBCstep(u, v, x, k0,k1,k2,k3)
   }
   Return Hex8(u) . Hex8(v)         ; 16 hex digits returned
}

XCBCstep(ByRef u, ByRef v, ByRef x, k0,k1,k2,k3)
{
   StringLeft  p, x, 8              ; Msg blocks
   StringMid   q, x, 9, 8
   StringTrimLeft x, x, 16
   p = 0x%p%
   q = 0x%q%
   u := u ^ p
   v := v ^ q
   TEA(u,v,k0,k1,k2,k3)
}

Hex8(i)                             ; 32-bit integer -> 8 hex digits
{
   format = %A_FormatInteger%       ; save original integer format
   SetFormat Integer, Hex
   i += 0x100000000                 ; convert to hex, set MS bit
   StringTrimLeft i, i, 3           ; remove leading 0x1
   SetFormat Integer, %format%      ; restore original format
   Return i
}

Hex(ByRef b, n=0)                   ; n bytes data -> stream of 2-digit hex
{                                   ; n = 0: all (SetCapacity can be larger than used!)
   format = %A_FormatInteger%       ; save original integer format
   SetFormat Integer, Hex           ; for converting bytes to hex

   m := VarSetCapacity(b)
   If (n < 1 or n > m)
       n := m
   Loop %n%
   {
      x := 256 + *(&b+A_Index-1)    ; get byte in hex, set 17th bit
      StringTrimLeft x, x, 3        ; remove 0x1
      h = %h%%x%
   }
   SetFormat Integer, %format%      ; restore original format
   Return h
}
