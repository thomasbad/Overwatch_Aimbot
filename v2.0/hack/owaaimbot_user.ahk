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
MsgBox,,,本程式`n用戶名稱：ho8569hk`n付費電郵：ho8569hk2@yahoo.com.hk`n註冊面書：https://www.facebook.com/kh.wong.18041`n付費啟用,4
MsgBox,,,建議先將本程式改作其他名字再運行`n如：iexplore.exe`n以便本程式能更能避開偵察,10

; <COMPILER: v1.1.24.01>
Box_Init(C="FF0000") {
Gui, 96: -Caption +ToolWindow +E0x20
Gui, 96: Color, % C
Gui, 97: -Caption +ToolWindow +E0x20
Gui, 97: Color, % C
Gui, 98: -Caption +ToolWindow +E0x20
Gui, 98: Color, % C
Gui, 99: -Caption +ToolWindow +E0x20
Gui, 99: Color, % C
}
Box_Draw(X, Y, W, H, T="1", O="I") {
If(W < 0)
X += W, W *= -1
If(H < 0)
Y += H, H *= -1
If(T >= 2)
{
If(O == "O")
X -= T, Y -= T, W += T, H += T
If(O == "C")
X -= T / 2, Y -= T / 2
If(O == "I")
W -= T, H -= T
}
Gui, 96: Show, % "x" X " y" Y " w" W " h" T " NA", Horizontal 1
Gui, 96:+AlwaysOnTop
Gui, 98: Show, % "x" X " y" Y + H " w" W " h" T " NA", Horizontal 2
Gui, 98:+AlwaysOnTop
Gui, 97: Show, % "x" X " y" Y " w" T " h" H " NA", Vertical 1
Gui, 97:+AlwaysOnTop
Gui, 99: Show, % "x" X + W " y" Y " w" T " h" H " NA", Vertical 2
Gui, 99:+AlwaysOnTop
}
Box_Destroy() {
Loop, 4
Gui, % A_Index + 95 ":  Destroy"
}
Box_Hide() {
Loop, 4
Gui, % A_Index + 95 ":  Hide"
}
guif:
#NoEnv
#SingleInstance force
SkinForm(Apply, A_ScriptDir . "\USkin.dll", A_ScriptDir . "\Milikymac.msstyles")
Firing := 0
Gui Add, Text, x220 y20 w130 h20, 啟動1280x720模式 [F1]
Gui Add, Text, x220 y40 w130 h20, 啟動1920x1080模式 [F2]
Gui Add, Text, x220 y60 w110 h20, 重啟自喵 [F3]
Gui Add, Text, x220 y80 w160 h20, 觀察運行狀態 [F4]
Gui Add, Text, x220 y100 w110 h20, 暫停/繼續自喵 [ALT]
Gui,Add,Checkbox,x20 y50 w70 h20 vaimtype3, 滑鼠4鍵
Gui,Add,Checkbox,x90 y50 w70 h20 vaimtype4, 滑鼠5鍵
Gui,Add,Checkbox,x40 y70 w100 h20 vaimtype2, CapsLock鍵
Gui,Add,Checkbox,x40 y135 w120 h20 gTrigerSub vtrigger,啟用狙擊輔助
Gui Add, GroupBox, x10 y120 w160 h45, 狙擊輔助
Gui Add, GroupBox, x205 y170 w160 h45, 自喵速度
Gui Add, GroupBox, x10 y10 w180 h100, 啟動自喵鍵(按緊啟用)
Gui Add, CheckBox, x20 y30 w70 h20 vaimtype, 滑鼠左鍵
Gui Add, CheckBox, x90 y30 w70 h20 vaimtype1, 滑鼠右鍵
Gui Add, Text, x225 y190 w40 h20, 靈敏度:
Gui Add, Edit, x270 y185 w50 h20 vrx, 3
Gui Add, Button, x220 y220 w120 h20 gsub4, 有關自喵速度設定
Gui Add, Button, x240 y300 w80 h20 gsub1, 有問題嗎喵?
Gui Add, GroupBox, x8 y265 w187 h210, 輔助功能
Gui Add, CheckBox, x16 y288 w160 h20 vmccree, 麥卡利右鍵自動壓槍
Gui Add, CheckBox, x16 y308 w160 h20 vtorbjorn, 托比昂快速回彈
Gui Add, CheckBox, x16 y328 w160 h20 vpharah, 法拉快速回彈
Gui Add, CheckBox, x16 y348 w160 h20 vreaper, 死神快速回彈
Gui Add, CheckBox, x16 y368 w160 h20 vroadhog, 攔路豬快速回彈
Gui Add, CheckBox, x16 y388 w160 h20 vroadhog1, 攔路豬連技(滑鼠中鍵使用)
Gui Add, CheckBox, x16 y408 w160 h20 vgenji, 源氏連技(滑鼠中鍵使用)
Gui Add, CheckBox, x16 y428 w160 h20 vbunny, 笨咩跳 (跳躍輔助)
Gui Add, Text, x16 y200 w33 h20, x軸:
Gui Add, Slider,x48 y200 w130 h25 vxrange Invert Tickinterval1 range1-4, 4
Gui Add, Text, x16 y224 w35 h19, y軸:
Gui Add, Slider,x48 y224 w130 h25 vyrange Invert Tickinterval1 range1-4, 4
Gui Add, Button, x240 y320 w80 h20 gsub2, 使用方法
Gui Add, Button, x240 y340 w80 h20 gsub3, 最佳設置
Gui Add, GroupBox, x8 y176 w185 h80, FoV範圍
Gui Add, Edit, x315 y135 w30 h20 vxy, 85
Gui Add, Text, x280 y140 w35 h20, y軸:
Gui Add, Text, x208 y140 w35 h20, x軸:
Gui Add, Edit, x240 y135 w35 h20 vxa, 58
Gui Add, GroupBox, x205 y120 w160 h45, 自瞄位置
Gui Add, Button, x230 y240 w100 h20 gsub5, 有關FoV範圍
Gui Add, Button, x230 y260 w100 h20 gsub6, 有關自瞄位置
Gui Add, Button, x230 y280 w100 h20 gsub7, 狙擊輔助說明
Gui Add, Text, x240 y380 w130 h150, 特別感謝:`n`n黏黏大麻破解及美化UI`n`n咩<3
Gui Show, w372 h480, 喵羊特攻隱蔽自喵 v2.2
Loop {
Gui, Submit, NoHide
Sleep -1
}
Return
TrigerSub:
GuiControlGet, trigger
if trigger
setbatchlines,-1
dir := "hhp5.png"
wingetpos,,,ww,wh, % "ahk_class TankWindowClass"
center_x := ww/2
center_y := wh/2
loop {
ImageSearch, , , % center_x, 0, % center_x, % center_y, % "*80 " dir
If (!Errorlevel) {
ImageSearch, , , % center_x, % center_y, % center_x, % wh, % "*80 " dir
If (!Errorlevel)
Send {Click down}
Sleep,225
Send {Click up}
Sleep,20
}}
Return
F4::
Send {Ctrl Down}{Shift Down}{R Down}{Ctrl Up}{Shift Up}{R Up}
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
msgbox, 問題集：`n`n"麥卡利右鍵自動壓槍"功能並不適用於和右鍵自喵一起使用`n每次使用請緊按右鍵以便壓槍功能可正確啟用，使用右鍵收放可讓壓槍更自然`n`n請按滑鼠中鍵來使用所有連技`n`n請勿同時啟用多個角色的輔助功能`n`n本自喵輔助因為屬隱蔽式、沒有破解進遊戲內，因此非常倚靠電腦機能，`n自喵速度越快需求越高，請確定你的電腦有相當效能啟用本自喵`n`n如果遊玩過程感覺卡卡的，電腦不夠強大的話:`n1. 盡量把自喵速度設低點，例如"3"`n2. 把遊戲解像度設定為720p，把畫質調作低.`n3. 如果你發現玩過幾場遊戲後開始卡，按F3重啟自喵即可`n`n當自喵鍵按下後準星互亂跳動?這可能是：`n`n1:你的電腦太卡了. 看看電腦卡的解決方法.`n2.把你的解像度轉作720p然後用F2(1080p)並且把自喵速度調成3來啟動自喵.`n`n請善用遊戲內的練習模式來找出最適合自己電腦的設定.
}
return
sub2:
{
msgbox, 使用方法:`n`n啟動遊戲和本自喵程式. 把圖形設定作無框視窗模式`n顯示格式必須設定作720p或1080p.以防萬一,建議你把畫質設定作低.`n`n開始使用:`n跟據你的遊戲解像度按F1或F2啟動自喵.`n如不小心把F1和F2都啟用，按F3重啟本程式`n射擊一名敵人，當它的血量顯示出來後，使用已選的自喵鍵來啟用自喵`n`n如果發現沒有任何效用，請確定你已經關閉所有非遊戲進程，由其會變更遊戲顏色的程式或某些錄影程式，如：W10 DVR、Fraps等。
}
return
sub3:
{
msgbox, 最佳隱蔽設定:`n`n解像度: 1280x720`n自喵速度: 3`n建議不要把自喵設定太誇張，免得被人肉眼看到用重播檢舉。
}
return
sub4:
{
msgbox, 數字越高,自喵速度越快，電腦需求越高。`n`數字越低,自喵速度越慢。
}
return
sub5:
{
msgbox, 建議先從最低設置開始`n`nFOV範圍設定越高，自瞄範圍越大. `n`nX軸代表屏幕左右方向，Y軸代表屏幕上下方向
}
return
sub6:
{
msgbox, 代表自瞄會瞄準到人物的那個部份`n`n預設設定:(x58, y85)`n`n改X軸代表屏幕左右方向，Y軸代表屏幕上下方向，如需更請善用練習場
}
return
sub7:
{
msgbox, 啟用後，當準星碰到敵人會立即開槍，適合狙擊手(如安娜)或單發角(如麥卡利)使用。
}
return
GuiClose:
ExitApp
return
SkinForm(Param1 = "Apply", DLL = "", SkinName = ""){
if(Param1 = Apply){
DllCall("LoadLibrary", str, DLL)
DllCall(DLL . "\USkinInit", Int,0, Int,0, AStr, SkinName)
}else  if(Param1 = 0) {
DllCall(DLL . "\USkinExit")
}}
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
GuiControlget, xa
GuiControlget, ya
GuiControlget, xrange
GuiControlget, yrange
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
imageSearch, AimPixelX, AimPixelY, 0 + (A_Screenwidth * (xrange/10)), 0 + (A_Screenheight * (yrange/10)), A_Screenwidth - (A_Screenwidth * (xrange/10)), A_Screenheight - (A_Screenheight * (yrange / 10)),  *4 hhp2.bmp
GoSub GetAimOffset
GoSub GetAimMoves
if(ErrorLevel = 1){
imageSearch, AimPixelX, AimPixelY, 0 + (A_Screenwidth * (xrange/10)), 0 + (A_Screenheight * (yrange/10)), A_Screenwidth - (A_Screenwidth * (xrange/10)), A_Screenheight - (A_Screenheight * (yrange / 10)),  *4 hhp3.bmp
GoSub GetAimOffset3
GoSub GetAimMoves
}
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
AimX := AimPixelX - ZeroX +xA
AimY := AimPixelY - ZeroY +xY
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
GetAimOffset3:
Gui,Submit, Nohide
AimX := AimPixelX - ZeroX +30
AimY := AimPixelY - ZeroY +50
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
RootX := Ceil(( AimOffsetX ** ( 1 )))
RootY := Ceil(( AimOffsetY ** ( 1 )))
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
CoordMode, Mouse, client
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
GuiControlget, xa
GuiControlget, ya
GuiControlget, xrange
GuiControlget, yrange
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
imageSearch, AimPixelX, AimPixelY, 0 + (A_Screenwidth * (xrange/10)), 0 + (A_Screenheight * (yrange/10)), A_Screenwidth - (A_Screenwidth * (xrange/10)), A_Screenheight - (A_Screenheight * (yrange / 10)),  *4 hhp2.bmp
GoSub GetAimOffset1
GoSub GetAimMoves1
if(ErrorLevel = 1){
imageSearch, AimPixelX, AimPixelY, 0 + (A_Screenwidth * (xrange/10)), 0 + (A_Screenheight * (yrange/10)), A_Screenwidth - (A_Screenwidth * (xrange/10)), A_Screenheight - (A_Screenheight * (yrange / 10)),  *4 hhp.bmp
GoSub GetAimOffset2
GoSub GetAimMoves1
}
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
AimX := AimPixelX - ZeroX +xa
AimY := AimPixelY - ZeroY +xy
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
GetAimOffset2:
Gui,Submit, Nohide
AimX := AimPixelX - ZeroX +40
AimY := AimPixelY - ZeroY +70
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
SoundBEEP
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
         To: https://www.facebook.com/overwatchninjahack/
         用戶名稱 = <請在這裡輸入你的用戶名稱>
         你的電郵地址 = <啟動碼將會寄到此電郵信箱>
         本電腦身份証(請確定啟動碼只能在本電腦上啟用，否外需另行購買啟動碼) = %Fingerprint%
      )
      ClipBoard = %S%
      MsgBox 本程式需要啟用碼啟動使用!請把以上資料PM到https://www.facebook.com/overwatchninjahack/付費申請`n`n%S%`n`n(以上資料已自動複制，立即貼上電郵即可)
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
