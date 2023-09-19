; Get Name of Script  (remove "_compile" )
ifequal,A_IsCompiled,,Menu, Tray, Icon, %A_WinDir%\system32\shell32.dll,166
StringReplace, ScriptName, A_Scriptname, _compile
SplitPath, ScriptName,,,, ScriptName
; ---------------------------------------------------------------------
PassWd := crypt()
SplashTextOn,,,Compiling script: "%ScriptName%.ahk"
RunWait, %A_ProgramFiles%\AutoHotkey\Compiler\Ahk2Exe.exe  /in "%ScriptName%.ahk" /out "%ScriptName%.exe" /icon "%ScriptName%.ico" /pass %passwd%
SplashTextOff
MsgBox,64,Autocompile, "%ScriptName%.ahk" compiled and crypted to "%ScriptName%.exe"`n`nCrypt-Key:`n`n%PassWd%,3
; ---------------------------------------------------------------------
crypt(l=65)
{
	pass =
	chPool = abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!"£$`%^&*()_-=+{}[]`;:``@'#~<>,./?\|¬¦
	StringSplit, list, chPool
	Loop, % l
	{
		Random, rnd, 1, % list0
		i := list%rnd%
		pass = %pass%%i%
	}
	Return, pass
}