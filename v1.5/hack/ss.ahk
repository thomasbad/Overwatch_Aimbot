setbatchlines,-1
dir := "hhp5.png"
wingetpos,,,ww,wh, % "ahk_class TankWindowClass"
center_x := ww/2
center_y := wh/2
loop {
	ImageSearch, , , % center_x, 0, % center_x, % center_y, % "*100 " dir
	If (!Errorlevel) {
		ImageSearch, , , % center_x, % center_y, % center_x, % wh, % "*100 " dir
		If (!Errorlevel)
			mouseclick, left
	}
}
rshift::exitapp