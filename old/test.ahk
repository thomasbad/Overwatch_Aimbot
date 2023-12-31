﻿; <COMPILER: v1.1.22.04>
#NoTrayIcon
#SingleInstance, Force
#NoEnv
UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
{
if ((x != "") && (y != ""))
VarSetCapacity(pt, 8), NumPut(x, pt, 0), NumPut(y, pt, 4)
if (w = "") ||(h = "")
WinGetPos,,, w, h, ahk_id %hwnd%
return DllCall("UpdateLayeredWindow", "uint", hwnd, "uint", 0, "uint", ((x = "") && (y = "")) ? 0 : &pt
, "int64*", w|h<<32, "uint", hdc, "int64*", 0, "uint", 0, "uint*", Alpha<<16|1<<24, "uint", 2)
}
BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster="")
{
return DllCall("gdi32\BitBlt", "uint", dDC, "int", dx, "int", dy, "int", dw, "int", dh
, "uint", sDC, "int", sx, "int", sy, "uint", Raster ? Raster : 0x00CC0020)
}
StretchBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, sw, sh, Raster="")
{
return DllCall("gdi32\StretchBlt", "uint", ddc, "int", dx, "int", dy, "int", dw, "int", dh
, "uint", sdc, "int", sx, "int", sy, "int", sw, "int", sh, "uint", Raster ? Raster : 0x00CC0020)
}
SetStretchBltMode(hdc, iStretchMode=4)
{
return DllCall("gdi32\SetStretchBltMode", "uint", hdc, "int", iStretchMode)
}
SetImage(hwnd, hBitmap)
{
SendMessage, 0x172, 0x0, hBitmap,, ahk_id %hwnd%
E := ErrorLevel
DeleteObject(E)
return E
}
SetSysColorToControl(hwnd, SysColor=15)
{
WinGetPos,,, w, h, ahk_id %hwnd%
bc := DllCall("GetSysColor", "Int", SysColor)
pBrushClear := Gdip_BrushCreateSolid(0xff000000 | (bc >> 16 | bc & 0xff00 | (bc & 0xff) << 16))
pBitmap := Gdip_CreateBitmap(w, h), G := Gdip_GraphicsFromImage(pBitmap)
Gdip_FillRectangle(G, pBrushClear, 0, 0, w, h)
hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
SetImage(hwnd, hBitmap)
Gdip_DeleteBrush(pBrushClear)
Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
return 0
}
Gdip_BitmapFromScreen(Screen=0, Raster="")
{
if (Screen = 0)
{
Sysget, x, 76
Sysget, y, 77
Sysget, w, 78
Sysget, h, 79
}
else if (SubStr(Screen, 1, 5) = "hwnd:")
{
Screen := SubStr(Screen, 6)
if !WinExist( "ahk_id " Screen)
return -2
WinGetPos,,, w, h, ahk_id %Screen%
x := y := 0
hhdc := GetDCEx(Screen, 3)
}
else if (Screen&1 != "")
{
Sysget, M, Monitor, %Screen%
x := MLeft, y := MTop, w := MRight-MLeft, h := MBottom-MTop
}
else
{
StringSplit, S, Screen, |
x := S1, y := S2, w := S3, h := S4
}
if (x = "") || (y = "") || (w = "") || (h = "")
return -1
chdc := CreateCompatibleDC(), hbm := CreateDIBSection(w, h, chdc), obm := SelectObject(chdc, hbm), hhdc := hhdc ? hhdc : GetDC()
BitBlt(chdc, 0, 0, w, h, hhdc, x, y, Raster)
ReleaseDC(hhdc)
pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
SelectObject(chdc, obm), DeleteObject(hbm), DeleteDC(hhdc), DeleteDC(chdc)
return pBitmap
}
Gdip_BitmapFromHWND(hwnd)
{
WinGetPos,,, Width, Height, ahk_id %hwnd%
hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
PrintWindow(hwnd, hdc)
pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
return pBitmap
}
CreateRectF(ByRef RectF, x, y, w, h)
{
VarSetCapacity(RectF, 16)
NumPut(x, RectF, 0, "float"), NumPut(y, RectF, 4, "float"), NumPut(w, RectF, 8, "float"), NumPut(h, RectF, 12, "float")
}
CreateRect(ByRef Rect, x, y, w, h)
{
VarSetCapacity(Rect, 16)
NumPut(x, Rect, 0, "uint"), NumPut(y, Rect, 4, "uint"), NumPut(w, Rect, 8, "uint"), NumPut(h, Rect, 12, "uint")
}
CreateSizeF(ByRef SizeF, w, h)
{
VarSetCapacity(SizeF, 8)
NumPut(w, SizeF, 0, "float"), NumPut(h, SizeF, 4, "float")
}
CreatePointF(ByRef PointF, x, y)
{
VarSetCapacity(PointF, 8)
NumPut(x, PointF, 0, "float"), NumPut(y, PointF, 4, "float")
}
CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0)
{
hdc2 := hdc ? hdc : GetDC()
VarSetCapacity(bi, 40, 0)
NumPut(w, bi, 4), NumPut(h, bi, 8), NumPut(40, bi, 0), NumPut(1, bi, 12, "ushort"), NumPut(0, bi, 16), NumPut(bpp, bi, 14, "ushort")
hbm := DllCall("CreateDIBSection", "uint" , hdc2, "uint" , &bi, "uint" , 0, "uint*", ppvBits, "uint" , 0, "uint" , 0)
if !hdc
ReleaseDC(hdc2)
return hbm
}
PrintWindow(hwnd, hdc, Flags=0)
{
return DllCall("PrintWindow", "uint", hwnd, "uint", hdc, "uint", Flags)
}
DestroyIcon(hIcon)
{
return DllCall("DestroyIcon", "uint", hIcon)
}
PaintDesktop(hdc)
{
return DllCall("PaintDesktop", "uint", hdc)
}
CreateCompatibleBitmap(hdc, w, h)
{
return DllCall("gdi32\CreateCompatibleBitmap", "uint", hdc, "int", w, "int", h)
}
CreateCompatibleDC(hdc=0)
{
return DllCall("CreateCompatibleDC", "uint", hdc)
}
SelectObject(hdc, hgdiobj)
{
return DllCall("SelectObject", "uint", hdc, "uint", hgdiobj)
}
DeleteObject(hObject)
{
return DllCall("DeleteObject", "uint", hObject)
}
GetDC(hwnd=0)
{
return DllCall("GetDC", "uint", hwnd)
}
GetDCEx(hwnd, flags=0, hrgnClip=0)
{
return DllCall("GetDCEx", "uint", hwnd, "uint", hrgnClip, "int", flags)
}
ReleaseDC(hdc, hwnd=0)
{
return DllCall("ReleaseDC", "uint", hwnd, "uint", hdc)
}
DeleteDC(hdc)
{
return DllCall("DeleteDC", "uint", hdc)
}
Gdip_LibraryVersion()
{
return 1.45
}
Gdip_BitmapFromBRA(ByRef BRAFromMemIn, File, Alternate=0)
{
if !BRAFromMemIn
return -1
Loop, Parse, BRAFromMemIn, `n
{
if (A_Index = 1)
{
StringSplit, Header, A_LoopField, |
if (Header0 != 4 || Header2 != "BRA!")
return -2
}
else if (A_Index = 2)
{
StringSplit, Info, A_LoopField, |
if (Info0 != 3)
return -3
}
else
break
}
if !Alternate
StringReplace, File, File, \, \\, All
RegExMatch(BRAFromMemIn, "mi`n)^" (Alternate ? File "\|.+?\|(\d+)\|(\d+)" : "\d+\|" File "\|(\d+)\|(\d+)") "$", FileInfo)
if !FileInfo
return -4
hData := DllCall("GlobalAlloc", "uint", 2, "uint", FileInfo2)
pData := DllCall("GlobalLock", "uint", hData)
DllCall("RtlMoveMemory", "uint", pData, "uint", &BRAFromMemIn+Info2+FileInfo1, "uint", FileInfo2)
DllCall("GlobalUnlock", "uint", hData)
DllCall("ole32\CreateStreamOnHGlobal", "uint", hData, "int", 1, "uint*", pStream)
DllCall("gdiplus\GdipCreateBitmapFromStream", "uint", pStream, "uint*", pBitmap)
DllCall(NumGet(NumGet(1*pStream)+8), "uint", pStream)
return pBitmap
}
Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
{
return DllCall("gdiplus\GdipDrawRectangle", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h)
}
Gdip_DrawRoundedRectangle(pGraphics, pPen, x, y, w, h, r)
{
Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
E := Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
Gdip_ResetClip(pGraphics)
Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
Gdip_DrawEllipse(pGraphics, pPen, x, y, 2*r, 2*r)
Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y, 2*r, 2*r)
Gdip_DrawEllipse(pGraphics, pPen, x, y+h-(2*r), 2*r, 2*r)
Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
Gdip_ResetClip(pGraphics)
return E
}
Gdip_DrawEllipse(pGraphics, pPen, x, y, w, h)
{
return DllCall("gdiplus\GdipDrawEllipse", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h)
}
Gdip_DrawBezier(pGraphics, pPen, x1, y1, x2, y2, x3, y3, x4, y4)
{
return DllCall("gdiplus\GdipDrawBezier", "uint", pgraphics, "uint", pPen
, "float", x1, "float", y1, "float", x2, "float", y2
, "float", x3, "float", y3, "float", x4, "float", y4)
}
Gdip_DrawArc(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
return DllCall("gdiplus\GdipDrawArc", "uint", pGraphics, "uint", pPen, "float", x
, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}
Gdip_DrawPie(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
return DllCall("gdiplus\GdipDrawPie", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}
Gdip_DrawLine(pGraphics, pPen, x1, y1, x2, y2)
{
return DllCall("gdiplus\GdipDrawLine", "uint", pGraphics, "uint", pPen
, "float", x1, "float", y1, "float", x2, "float", y2)
}
Gdip_DrawLines(pGraphics, pPen, Points)
{
StringSplit, Points, Points, |
VarSetCapacity(PointF, 8*Points0)
Loop, %Points0%
{
StringSplit, Coord, Points%A_Index%, `,
NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
}
return DllCall("gdiplus\GdipDrawLines", "uint", pGraphics, "uint", pPen, "uint", &PointF, "int", Points0)
}
Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
{
return DllCall("gdiplus\GdipFillRectangle", "uint", pGraphics, "int", pBrush
, "float", x, "float", y, "float", w, "float", h)
}
Gdip_FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r)
{
Region := Gdip_GetClipRegion(pGraphics)
Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
E := Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
Gdip_SetClipRegion(pGraphics, Region, 0)
Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
Gdip_FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
Gdip_FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
Gdip_SetClipRegion(pGraphics, Region, 0)
Gdip_DeleteRegion(Region)
return E
}
Gdip_FillPolygon(pGraphics, pBrush, Points, FillMode=0)
{
StringSplit, Points, Points, |
VarSetCapacity(PointF, 8*Points0)
Loop, %Points0%
{
StringSplit, Coord, Points%A_Index%, `,
NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
}
return DllCall("gdiplus\GdipFillPolygon", "uint", pGraphics, "uint", pBrush, "uint", &PointF, "int", Points0, "int", FillMode)
}
Gdip_FillPie(pGraphics, pBrush, x, y, w, h, StartAngle, SweepAngle)
{
return DllCall("gdiplus\GdipFillPie", "uint", pGraphics, "uint", pBrush
, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}
Gdip_FillEllipse(pGraphics, pBrush, x, y, w, h)
{
return DllCall("gdiplus\GdipFillEllipse", "uint", pGraphics, "uint", pBrush, "float", x, "float", y, "float", w, "float", h)
}
Gdip_FillRegion(pGraphics, pBrush, Region)
{
return DllCall("gdiplus\GdipFillRegion", "uint", pGraphics, "uint", pBrush, "uint", Region)
}
Gdip_FillPath(pGraphics, pBrush, Path)
{
return DllCall("gdiplus\GdipFillPath", "uint", pGraphics, "uint", pBrush, "uint", Path)
}
Gdip_DrawImagePointsRect(pGraphics, pBitmap, Points, sx="", sy="", sw="", sh="", Matrix=1)
{
StringSplit, Points, Points, |
VarSetCapacity(PointF, 8*Points0)
Loop, %Points0%
{
StringSplit, Coord, Points%A_Index%, `,
NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
}
if (Matrix&1 = "")
ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
else if (Matrix != 1)
ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
if (sx = "" && sy = "" && sw = "" && sh = "")
{
sx := 0, sy := 0
sw := Gdip_GetImageWidth(pBitmap)
sh := Gdip_GetImageHeight(pBitmap)
}
E := DllCall("gdiplus\GdipDrawImagePointsRect", "uint", pGraphics, "uint", pBitmap
, "uint", &PointF, "int", Points0, "float", sx, "float", sy, "float", sw, "float", sh
, "int", 2, "uint", ImageAttr, "uint", 0, "uint", 0)
if ImageAttr
Gdip_DisposeImageAttributes(ImageAttr)
return E
}
Gdip_DrawImage(pGraphics, pBitmap, dx="", dy="", dw="", dh="", sx="", sy="", sw="", sh="", Matrix=1)
{
if (Matrix&1 = "")
ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
else if (Matrix != 1)
ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
if (sx = "" && sy = "" && sw = "" && sh = "")
{
if (dx = "" && dy = "" && dw = "" && dh = "")
{
sx := dx := 0, sy := dy := 0
sw := dw := Gdip_GetImageWidth(pBitmap)
sh := dh := Gdip_GetImageHeight(pBitmap)
}
else
{
sx := sy := 0
sw := Gdip_GetImageWidth(pBitmap)
sh := Gdip_GetImageHeight(pBitmap)
}
}
E := DllCall("gdiplus\GdipDrawImageRectRect", "uint", pGraphics, "uint", pBitmap
, "float", dx, "float", dy, "float", dw, "float", dh
, "float", sx, "float", sy, "float", sw, "float", sh
, "int", 2, "uint", ImageAttr, "uint", 0, "uint", 0)
if ImageAttr
Gdip_DisposeImageAttributes(ImageAttr)
return E
}
Gdip_SetImageAttributesColorMatrix(Matrix)
{
VarSetCapacity(ColourMatrix, 100, 0)
Matrix := RegExReplace(RegExReplace(Matrix, "^[^\d-\.]+([\d\.])", "$1", "", 1), "[^\d-\.]+", "|")
StringSplit, Matrix, Matrix, |
Loop, 25
{
Matrix := (Matrix%A_Index% != "") ? Matrix%A_Index% : Mod(A_Index-1, 6) ? 0 : 1
NumPut(Matrix, ColourMatrix, (A_Index-1)*4, "float")
}
DllCall("gdiplus\GdipCreateImageAttributes", "uint*", ImageAttr)
DllCall("gdiplus\GdipSetImageAttributesColorMatrix", "uint", ImageAttr, "int", 1, "int", 1, "uint", &ColourMatrix, "int", 0, "int", 0)
return ImageAttr
}
Gdip_GraphicsFromImage(pBitmap)
{
DllCall("gdiplus\GdipGetImageGraphicsContext", "uint", pBitmap, "uint*", pGraphics)
return pGraphics
}
Gdip_GraphicsFromHDC(hdc)
{
DllCall("gdiplus\GdipCreateFromHDC", "uint", hdc, "uint*", pGraphics)
return pGraphics
}
Gdip_GetDC(pGraphics)
{
DllCall("gdiplus\GdipGetDC", "uint", pGraphics, "uint*", hdc)
return hdc
}
Gdip_ReleaseDC(pGraphics, hdc)
{
return DllCall("gdiplus\GdipReleaseDC", "uint", pGraphics, "uint", hdc)
}
Gdip_GraphicsClear(pGraphics, ARGB=0x00ffffff)
{
return DllCall("gdiplus\GdipGraphicsClear", "uint", pGraphics, "int", ARGB)
}
Gdip_BlurBitmap(pBitmap, Blur)
{
if (Blur > 100) || (Blur < 1)
return -1
sWidth := Gdip_GetImageWidth(pBitmap), sHeight := Gdip_GetImageHeight(pBitmap)
dWidth := sWidth//Blur, dHeight := sHeight//Blur
pBitmap1 := Gdip_CreateBitmap(dWidth, dHeight)
G1 := Gdip_GraphicsFromImage(pBitmap1)
Gdip_SetInterpolationMode(G1, 7)
Gdip_DrawImage(G1, pBitmap, 0, 0, dWidth, dHeight, 0, 0, sWidth, sHeight)
Gdip_DeleteGraphics(G1)
pBitmap2 := Gdip_CreateBitmap(sWidth, sHeight)
G2 := Gdip_GraphicsFromImage(pBitmap2)
Gdip_SetInterpolationMode(G2, 7)
Gdip_DrawImage(G2, pBitmap1, 0, 0, sWidth, sHeight, 0, 0, dWidth, dHeight)
Gdip_DeleteGraphics(G2)
Gdip_DisposeImage(pBitmap1)
return pBitmap2
}
Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality=75)
{
SplitPath, sOutput,,, Extension
if Extension not in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
return -1
Extension := "." Extension
DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
VarSetCapacity(ci, nSize)
DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, "uint", &ci)
if !(nCount && nSize)
return -2
Loop, %nCount%
{
Location := NumGet(ci, 76*(A_Index-1)+44)
if !A_IsUnicode
{
nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
VarSetCapacity(sString, nSize)
DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "str", sString, "int", nSize, "uint", 0, "uint", 0)
if !InStr(sString, "*" Extension)
continue
}
else
{
nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
sString := ""
Loop, %nSize%
sString .= Chr(NumGet(Location+0, 2*(A_Index-1), "char"))
if !InStr(sString, "*" Extension)
continue
}
pCodec := &ci+76*(A_Index-1)
break
}
if !pCodec
return -3
if (Quality != 75)
{
Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
if Extension in .JPG,.JPEG,.JPE,.JFIF
{
DllCall("gdiplus\GdipGetEncoderParameterListSize", "uint", pBitmap, "uint", pCodec, "uint*", nSize)
VarSetCapacity(EncoderParameters, nSize, 0)
DllCall("gdiplus\GdipGetEncoderParameterList", "uint", pBitmap, "uint", pCodec, "uint", nSize, "uint", &EncoderParameters)
Loop, % NumGet(EncoderParameters)
{
if (NumGet(EncoderParameters, (28*(A_Index-1))+20) = 1) && (NumGet(EncoderParameters, (28*(A_Index-1))+24) = 6)
{
p := (28*(A_Index-1))+&EncoderParameters
NumPut(Quality, NumGet(NumPut(4, NumPut(1, p+0)+20)))
break
}
}
}
}
if !A_IsUnicode
{
nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sOutput, "int", -1, "uint", 0, "int", 0)
VarSetCapacity(wOutput, nSize*2)
DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sOutput, "int", -1, "uint", &wOutput, "int", nSize)
VarSetCapacity(wOutput, -1)
if !VarSetCapacity(wOutput)
return -4
E := DllCall("gdiplus\GdipSaveImageToFile", "uint", pBitmap, "uint", &wOutput, "uint", pCodec, "uint", p ? p : 0)
}
else
E := DllCall("gdiplus\GdipSaveImageToFile", "uint", pBitmap, "uint", &sOutput, "uint", pCodec, "uint", p ? p : 0)
return E ? -5 : 0
}
Gdip_GetPixel(pBitmap, x, y)
{
DllCall("gdiplus\GdipBitmapGetPixel", "uint", pBitmap, "int", x, "int", y, "uint*", ARGB)
return ARGB
}
Gdip_SetPixel(pBitmap, x, y, ARGB)
{
return DllCall("gdiplus\GdipBitmapSetPixel", "uint", pBitmap, "int", x, "int", y, "int", ARGB)
}
Gdip_GetImageWidth(pBitmap)
{
DllCall("gdiplus\GdipGetImageWidth", "uint", pBitmap, "uint*", Width)
return Width
}
Gdip_GetImageHeight(pBitmap)
{
DllCall("gdiplus\GdipGetImageHeight", "uint", pBitmap, "uint*", Height)
return Height
}
Gdip_GetImageDimensions(pBitmap, ByRef Width, ByRef Height)
{
DllCall("gdiplus\GdipGetImageWidth", "uint", pBitmap, "uint*", Width)
DllCall("gdiplus\GdipGetImageHeight", "uint", pBitmap, "uint*", Height)
}
Gdip_GetDimensions(pBitmap, ByRef Width, ByRef Height)
{
Gdip_GetImageDimensions(pBitmap, Width, Height)
}
Gdip_GetImagePixelFormat(pBitmap)
{
DllCall("gdiplus\GdipGetImagePixelFormat", "uint", pBitmap, "uint*", Format)
return Format
}
Gdip_GetDpiX(pGraphics)
{
DllCall("gdiplus\GdipGetDpiX", "uint", pGraphics, "float*", dpix)
return Round(dpix)
}
Gdip_GetDpiY(pGraphics)
{
DllCall("gdiplus\GdipGetDpiY", "uint", pGraphics, "float*", dpiy)
return Round(dpiy)
}
Gdip_GetImageHorizontalResolution(pBitmap)
{
DllCall("gdiplus\GdipGetImageHorizontalResolution", "uint", pBitmap, "float*", dpix)
return Round(dpix)
}
Gdip_GetImageVerticalResolution(pBitmap)
{
DllCall("gdiplus\GdipGetImageVerticalResolution", "uint", pBitmap, "float*", dpiy)
return Round(dpiy)
}
Gdip_BitmapSetResolution(pBitmap, dpix, dpiy)
{
return DllCall("gdiplus\GdipBitmapSetResolution", "uint", pBitmap, "float", dpix, "float", dpiy)
}
Gdip_CreateBitmapFromFile(sFile, IconNumber=1, IconSize="")
{
SplitPath, sFile,,, ext
if ext in exe,dll
{
Sizes := IconSize ? IconSize : 256 "|" 128 "|" 64 "|" 48 "|" 32 "|" 16
VarSetCapacity(buf, 40)
Loop, Parse, Sizes, |
{
DllCall("PrivateExtractIcons", "str", sFile, "int", IconNumber-1, "int", A_LoopField, "int", A_LoopField, "uint*", hIcon, "uint*", 0, "uint", 1, "uint", 0)
if !hIcon
continue
if !DllCall("GetIconInfo", "uint", hIcon, "uint", &buf)
{
DestroyIcon(hIcon)
continue
}
hbmColor := NumGet(buf, 16)
hbmMask  := NumGet(buf, 12)
if !(hbmColor && DllCall("GetObject", "uint", hbmColor, "int", 24, "uint", &buf))
{
DestroyIcon(hIcon)
continue
}
break
}
if !hIcon
return -1
Width := NumGet(buf, 4, "int"),  Height := NumGet(buf, 8, "int")
hbm := CreateDIBSection(Width, -Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
if !DllCall("DrawIconEx", "uint", hdc, "int", 0, "int", 0, "uint", hIcon, "uint", Width, "uint", Height, "uint", 0, "uint", 0, "uint", 3)
{
DestroyIcon(hIcon)
return -2
}
VarSetCapacity(dib, 84)
DllCall("GetObject", "uint", hbm, "int", 84, "uint", &dib)
Stride := NumGet(dib, 12), Bits := NumGet(dib, 20)
DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", Stride, "int", 0x26200A, "uint", Bits, "uint*", pBitmapOld)
pBitmap := Gdip_CreateBitmap(Width, Height), G := Gdip_GraphicsFromImage(pBitmap)
Gdip_DrawImage(G, pBitmapOld, 0, 0, Width, Height, 0, 0, Width, Height)
SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmapOld)
DestroyIcon(hIcon)
}
else
{
if !A_IsUnicode
{
VarSetCapacity(wFile, 1023)
DllCall("kernel32\MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sFile, "int", -1, "uint", &wFile, "int", 512)
DllCall("gdiplus\GdipCreateBitmapFromFile", "uint", &wFile, "uint*", pBitmap)
}
else
DllCall("gdiplus\GdipCreateBitmapFromFile", "uint", &sFile, "uint*", pBitmap)
}
return pBitmap
}
Gdip_CreateBitmapFromHBITMAP(hBitmap, Palette=0)
{
DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "uint", hBitmap, "uint", Palette, "uint*", pBitmap)
return pBitmap
}
Gdip_CreateHBITMAPFromBitmap(pBitmap, Background=0xffffffff)
{
DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "uint", pBitmap, "uint*", hbm, "int", Background)
return hbm
}
Gdip_CreateBitmapFromHICON(hIcon)
{
DllCall("gdiplus\GdipCreateBitmapFromHICON", "uint", hIcon, "uint*", pBitmap)
return pBitmap
}
Gdip_CreateHICONFromBitmap(pBitmap)
{
DllCall("gdiplus\GdipCreateHICONFromBitmap", "uint", pBitmap, "uint*", hIcon)
return hIcon
}
Gdip_CreateBitmap(Width, Height, Format=0x26200A)
{
DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", 0, "int", Format, "uint", 0, "uint*", pBitmap)
Return pBitmap
}
Gdip_CreateBitmapFromClipboard()
{
if !DllCall("OpenClipboard", "uint", 0)
return -1
if !DllCall("IsClipboardFormatAvailable", "uint", 8)
return -2
if !hBitmap := DllCall("GetClipboardData", "uint", 2)
return -3
if !pBitmap := Gdip_CreateBitmapFromHBITMAP(hBitmap)
return -4
if !DllCall("CloseClipboard")
return -5
DeleteObject(hBitmap)
return pBitmap
}
Gdip_SetBitmapToClipboard(pBitmap)
{
hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
DllCall("GetObject", "uint", hBitmap, "int", VarSetCapacity(oi, 84, 0), "uint", &oi)
hdib := DllCall("GlobalAlloc", "uint", 2, "uint", 40+NumGet(oi, 44))
pdib := DllCall("GlobalLock", "uint", hdib)
DllCall("RtlMoveMemory", "uint", pdib, "uint", &oi+24, "uint", 40)
DllCall("RtlMoveMemory", "Uint", pdib+40, "Uint", NumGet(oi, 20), "uint", NumGet(oi, 44))
DllCall("GlobalUnlock", "uint", hdib)
DllCall("DeleteObject", "uint", hBitmap)
DllCall("OpenClipboard", "uint", 0)
DllCall("EmptyClipboard")
DllCall("SetClipboardData", "uint", 8, "uint", hdib)
DllCall("CloseClipboard")
}
Gdip_CloneBitmapArea(pBitmap, x, y, w, h, Format=0x26200A)
{
DllCall("gdiplus\GdipCloneBitmapArea", "float", x, "float", y, "float", w, "float", h
, "int", Format, "uint", pBitmap, "uint*", pBitmapDest)
return pBitmapDest
}
Gdip_CreatePen(ARGB, w)
{
DllCall("gdiplus\GdipCreatePen1", "int", ARGB, "float", w, "int", 2, "uint*", pPen)
return pPen
}
Gdip_CreatePenFromBrush(pBrush, w)
{
DllCall("gdiplus\GdipCreatePen2", "uint", pBrush, "float", w, "int", 2, "uint*", pPen)
return pPen
}
Gdip_BrushCreateSolid(ARGB=0xff000000)
{
DllCall("gdiplus\GdipCreateSolidFill", "int", ARGB, "uint*", pBrush)
return pBrush
}
Gdip_BrushCreateHatch(ARGBfront, ARGBback, HatchStyle=0)
{
DllCall("gdiplus\GdipCreateHatchBrush", "int", HatchStyle, "int", ARGBfront, "int", ARGBback, "uint*", pBrush)
return pBrush
}
Gdip_CreateTextureBrush(pBitmap, WrapMode=1, x=0, y=0, w="", h="")
{
if !(w && h)
DllCall("gdiplus\GdipCreateTexture", "uint", pBitmap, "int", WrapMode, "uint*", pBrush)
else
DllCall("gdiplus\GdipCreateTexture2", "uint", pBitmap, "int", WrapMode, "float", x, "float", y, "float", w, "float", h, "uint*", pBrush)
return pBrush
}
Gdip_CreateLineBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode=1)
{
CreatePointF(PointF1, x1, y1), CreatePointF(PointF2, x2, y2)
DllCall("gdiplus\GdipCreateLineBrush", "uint", &PointF1, "uint", &PointF2, "int", ARGB1, "int", ARGB2, "int", WrapMode, "uint*", LGpBrush)
return LGpBrush
}
Gdip_CreateLineBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode=1, WrapMode=1)
{
CreateRectF(RectF, x, y, w, h)
DllCall("gdiplus\GdipCreateLineBrushFromRect", "uint", &RectF, "int", ARGB1, "int", ARGB2, "int", LinearGradientMode, "int", WrapMode, "uint*", LGpBrush)
return LGpBrush
}
Gdip_CloneBrush(pBrush)
{
DllCall("gdiplus\GdipCloneBrush", "uint", pBrush, "uint*", pBrushClone)
return pBrushClone
}
Gdip_DeletePen(pPen)
{
return DllCall("gdiplus\GdipDeletePen", "uint", pPen)
}
Gdip_DeleteBrush(pBrush)
{
return DllCall("gdiplus\GdipDeleteBrush", "uint", pBrush)
}
Gdip_DisposeImage(pBitmap)
{
return DllCall("gdiplus\GdipDisposeImage", "uint", pBitmap)
}
Gdip_DeleteGraphics(pGraphics)
{
return DllCall("gdiplus\GdipDeleteGraphics", "uint", pGraphics)
}
Gdip_DisposeImageAttributes(ImageAttr)
{
return DllCall("gdiplus\GdipDisposeImageAttributes", "uint", ImageAttr)
}
Gdip_DeleteFont(hFont)
{
return DllCall("gdiplus\GdipDeleteFont", "uint", hFont)
}
Gdip_DeleteStringFormat(hFormat)
{
return DllCall("gdiplus\GdipDeleteStringFormat", "uint", hFormat)
}
Gdip_DeleteFontFamily(hFamily)
{
return DllCall("gdiplus\GdipDeleteFontFamily", "uint", hFamily)
}
Gdip_DeleteMatrix(Matrix)
{
return DllCall("gdiplus\GdipDeleteMatrix", "uint", Matrix)
}
Gdip_TextToGraphics(pGraphics, Text, Options, Font="Arial", Width="", Height="", Measure=0)
{
IWidth := Width, IHeight:= Height
RegExMatch(Options, "i)X([\-\d\.]+)(p*)", xpos)
RegExMatch(Options, "i)Y([\-\d\.]+)(p*)", ypos)
RegExMatch(Options, "i)W([\-\d\.]+)(p*)", Width)
RegExMatch(Options, "i)H([\-\d\.]+)(p*)", Height)
RegExMatch(Options, "i)C(?!(entre|enter))([a-f\d]+)", Colour)
RegExMatch(Options, "i)Top|Up|Bottom|Down|vCentre|vCenter", vPos)
RegExMatch(Options, "i)NoWrap", NoWrap)
RegExMatch(Options, "i)R(\d)", Rendering)
RegExMatch(Options, "i)S(\d+)(p*)", Size)
if !Gdip_DeleteBrush(Gdip_CloneBrush(Colour2))
PassBrush := 1, pBrush := Colour2
if !(IWidth && IHeight) && (xpos2 || ypos2 || Width2 || Height2 || Size2)
return -1
Style := 0, Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
Loop, Parse, Styles, |
{
if RegExMatch(Options, "\b" A_loopField)
Style |= (A_LoopField != "StrikeOut") ? (A_Index-1) : 8
}
Align := 0, Alignments := "Near|Left|Centre|Center|Far|Right"
Loop, Parse, Alignments, |
{
if RegExMatch(Options, "\b" A_loopField)
Align |= A_Index//2.1
}
xpos := (xpos1 != "") ? xpos2 ? IWidth*(xpos1/100) : xpos1 : 0
ypos := (ypos1 != "") ? ypos2 ? IHeight*(ypos1/100) : ypos1 : 0
Width := Width1 ? Width2 ? IWidth*(Width1/100) : Width1 : IWidth
Height := Height1 ? Height2 ? IHeight*(Height1/100) : Height1 : IHeight
if !PassBrush
Colour := "0x" (Colour2 ? Colour2 : "ff000000")
Rendering := ((Rendering1 >= 0) && (Rendering1 <= 5)) ? Rendering1 : 4
Size := (Size1 > 0) ? Size2 ? IHeight*(Size1/100) : Size1 : 12
hFamily := Gdip_FontFamilyCreate(Font)
hFont := Gdip_FontCreate(hFamily, Size, Style)
FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
hFormat := Gdip_StringFormatCreate(FormatStyle)
pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour)
if !(hFamily && hFont && hFormat && pBrush && pGraphics)
return !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0
CreateRectF(RC, xpos, ypos, Width, Height)
Gdip_SetStringFormatAlign(hFormat, Align)
Gdip_SetTextRenderingHint(pGraphics, Rendering)
ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
if vPos
{
StringSplit, ReturnRC, ReturnRC, |
if (vPos = "vCentre") || (vPos = "vCenter")
ypos += (Height-ReturnRC4)//2
else if (vPos = "Top") || (vPos = "Up")
ypos := 0
else if (vPos = "Bottom") || (vPos = "Down")
ypos := Height-ReturnRC4
CreateRectF(RC, xpos, ypos, Width, ReturnRC4)
ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
}
if !Measure
E := Gdip_DrawString(pGraphics, Text, hFont, hFormat, pBrush, RC)
if !PassBrush
Gdip_DeleteBrush(pBrush)
Gdip_DeleteStringFormat(hFormat)
Gdip_DeleteFont(hFont)
Gdip_DeleteFontFamily(hFamily)
return E ? E : ReturnRC
}
Gdip_DrawString(pGraphics, sString, hFont, hFormat, pBrush, ByRef RectF)
{
if !A_IsUnicode
{
nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", 0, "int", 0)
VarSetCapacity(wString, nSize*2)
DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", &wString, "int", nSize)
return DllCall("gdiplus\GdipDrawString", "uint", pGraphics
, "uint", &wString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", pBrush)
}
else
{
return DllCall("gdiplus\GdipDrawString", "uint", pGraphics
, "uint", &sString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", pBrush)
}
}
Gdip_MeasureString(pGraphics, sString, hFont, hFormat, ByRef RectF)
{
VarSetCapacity(RC, 16)
if !A_IsUnicode
{
nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", 0, "int", 0)
VarSetCapacity(wString, nSize*2)
DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", &wString, "int", nSize)
DllCall("gdiplus\GdipMeasureString", "uint", pGraphics
, "uint", &wString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", &RC, "uint*", Chars, "uint*", Lines)
}
else
{
DllCall("gdiplus\GdipMeasureString", "uint", pGraphics
, "uint", &sString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", &RC, "uint*", Chars, "uint*", Lines)
}
return &RC ? NumGet(RC, 0, "float") "|" NumGet(RC, 4, "float") "|" NumGet(RC, 8, "float") "|" NumGet(RC, 12, "float") "|" Chars "|" Lines : 0
}
Gdip_SetStringFormatAlign(hFormat, Align)
{
return DllCall("gdiplus\GdipSetStringFormatAlign", "uint", hFormat, "int", Align)
}
Gdip_StringFormatCreate(Format=0, Lang=0)
{
DllCall("gdiplus\GdipCreateStringFormat", "int", Format, "int", Lang, "uint*", hFormat)
return hFormat
}
Gdip_FontCreate(hFamily, Size, Style=0)
{
DllCall("gdiplus\GdipCreateFont", "uint", hFamily, "float", Size, "int", Style, "int", 0, "uint*", hFont)
return hFont
}
Gdip_FontFamilyCreate(Font)
{
if !A_IsUnicode
{
nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &Font, "int", -1, "uint", 0, "int", 0)
VarSetCapacity(wFont, nSize*2)
DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &Font, "int", -1, "uint", &wFont, "int", nSize)
DllCall("gdiplus\GdipCreateFontFamilyFromName", "uint", &wFont, "uint", 0, "uint*", hFamily)
}
else
DllCall("gdiplus\GdipCreateFontFamilyFromName", "uint", &Font, "uint", 0, "uint*", hFamily)
return hFamily
}
Gdip_CreateAffineMatrix(m11, m12, m21, m22, x, y)
{
DllCall("gdiplus\GdipCreateMatrix2", "float", m11, "float", m12, "float", m21, "float", m22, "float", x, "float", y, "uint*", Matrix)
return Matrix
}
Gdip_CreateMatrix()
{
DllCall("gdiplus\GdipCreateMatrix", "uint*", Matrix)
return Matrix
}
Gdip_CreatePath(BrushMode=0)
{
DllCall("gdiplus\GdipCreatePath", "int", BrushMode, "uint*", Path)
return Path
}
Gdip_AddPathEllipse(Path, x, y, w, h)
{
return DllCall("gdiplus\GdipAddPathEllipse", "uint", Path, "float", x, "float", y, "float", w, "float", h)
}
Gdip_AddPathPolygon(Path, Points)
{
StringSplit, Points, Points, |
VarSetCapacity(PointF, 8*Points0)
Loop, %Points0%
{
StringSplit, Coord, Points%A_Index%, `,
NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
}
return DllCall("gdiplus\GdipAddPathPolygon", "uint", Path, "uint", &PointF, "int", Points0)
}
Gdip_DeletePath(Path)
{
return DllCall("gdiplus\GdipDeletePath", "uint", Path)
}
Gdip_SetTextRenderingHint(pGraphics, RenderingHint)
{
return DllCall("gdiplus\GdipSetTextRenderingHint", "uint", pGraphics, "int", RenderingHint)
}
Gdip_SetInterpolationMode(pGraphics, InterpolationMode)
{
return DllCall("gdiplus\GdipSetInterpolationMode", "uint", pGraphics, "int", InterpolationMode)
}
Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
{
return DllCall("gdiplus\GdipSetSmoothingMode", "uint", pGraphics, "int", SmoothingMode)
}
Gdip_SetCompositingMode(pGraphics, CompositingMode=0)
{
return DllCall("gdiplus\GdipSetCompositingMode", "uint", pGraphics, "int", CompositingMode)
}
Gdip_Startup()
{
if !DllCall("GetModuleHandle", "str", "gdiplus")
DllCall("LoadLibrary", "str", "gdiplus")
VarSetCapacity(si, 16, 0), si := Chr(1)
DllCall("gdiplus\GdiplusStartup", "uint*", pToken, "uint", &si, "uint", 0)
return pToken
}
Gdip_Shutdown(pToken)
{
DllCall("gdiplus\GdiplusShutdown", "uint", pToken)
if hModule := DllCall("GetModuleHandle", "str", "gdiplus")
DllCall("FreeLibrary", "uint", hModule)
return 0
}
Gdip_RotateWorldTransform(pGraphics, Angle, MatrixOrder=0)
{
return DllCall("gdiplus\GdipRotateWorldTransform", "uint", pGraphics, "float", Angle, "int", MatrixOrder)
}
Gdip_ScaleWorldTransform(pGraphics, x, y, MatrixOrder=0)
{
return DllCall("gdiplus\GdipScaleWorldTransform", "uint", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}
Gdip_TranslateWorldTransform(pGraphics, x, y, MatrixOrder=0)
{
return DllCall("gdiplus\GdipTranslateWorldTransform", "uint", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}
Gdip_ResetWorldTransform(pGraphics)
{
return DllCall("gdiplus\GdipResetWorldTransform", "uint", pGraphics)
}
Gdip_GetRotatedTranslation(Width, Height, Angle, ByRef xTranslation, ByRef yTranslation)
{
pi := 3.14159, TAngle := Angle*(pi/180)
Bound := (Angle >= 0) ? Mod(Angle, 360) : 360-Mod(-Angle, -360)
if ((Bound >= 0) && (Bound <= 90))
xTranslation := Height*Sin(TAngle), yTranslation := 0
else if ((Bound > 90) && (Bound <= 180))
xTranslation := (Height*Sin(TAngle))-(Width*Cos(TAngle)), yTranslation := -Height*Cos(TAngle)
else if ((Bound > 180) && (Bound <= 270))
xTranslation := -(Width*Cos(TAngle)), yTranslation := -(Height*Cos(TAngle))-(Width*Sin(TAngle))
else if ((Bound > 270) && (Bound <= 360))
xTranslation := 0, yTranslation := -Width*Sin(TAngle)
}
Gdip_GetRotatedDimensions(Width, Height, Angle, ByRef RWidth, ByRef RHeight)
{
pi := 3.14159, TAngle := Angle*(pi/180)
if !(Width && Height)
return -1
RWidth := Ceil(Abs(Width*Cos(TAngle))+Abs(Height*Sin(TAngle)))
RHeight := Ceil(Abs(Width*Sin(TAngle))+Abs(Height*Cos(Tangle)))
}
Gdip_ImageRotateFlip(pBitmap, RotateFlipType=1)
{
return DllCall("gdiplus\GdipImageRotateFlip", "uint", pBitmap, "int", RotateFlipType)
}
Gdip_SetClipRect(pGraphics, x, y, w, h, CombineMode=0)
{
return DllCall("gdiplus\GdipSetClipRect", "uint", pGraphics, "float", x, "float", y, "float", w, "float", h, "int", CombineMode)
}
Gdip_SetClipPath(pGraphics, Path, CombineMode=0)
{
return DllCall("gdiplus\GdipSetClipPath", "uint", pGraphics, "uint", Path, "int", CombineMode)
}
Gdip_ResetClip(pGraphics)
{
return DllCall("gdiplus\GdipResetClip", "uint", pGraphics)
}
Gdip_GetClipRegion(pGraphics)
{
Region := Gdip_CreateRegion()
DllCall("gdiplus\GdipGetClip", "uint" pGraphics, "uint*", Region)
return Region
}
Gdip_SetClipRegion(pGraphics, Region, CombineMode=0)
{
return DllCall("gdiplus\GdipSetClipRegion", "uint", pGraphics, "uint", Region, "int", CombineMode)
}
Gdip_CreateRegion()
{
DllCall("gdiplus\GdipCreateRegion", "uint*", Region)
return Region
}
Gdip_DeleteRegion(Region)
{
return DllCall("gdiplus\GdipDeleteRegion", "uint", Region)
}
Gdip_LockBits(pBitmap, x, y, w, h, ByRef Stride, ByRef Scan0, ByRef BitmapData, LockMode = 3, PixelFormat = 0x26200a)
{
CreateRect(Rect, x, y, w, h)
VarSetCapacity(BitmapData, 21, 0)
E := DllCall("Gdiplus\GdipBitmapLockBits", "uint", pBitmap, "uint", &Rect, "uint", LockMode, "int", PixelFormat, "uint", &BitmapData)
Stride := NumGet(BitmapData, 8)
Scan0 := NumGet(BitmapData, 16)
return E
}
Gdip_UnlockBits(pBitmap, ByRef BitmapData)
{
return DllCall("Gdiplus\GdipBitmapUnlockBits", "uint", pBitmap, "uint", &BitmapData)
}
Gdip_SetLockBitPixel(ARGB, Scan0, x, y, Stride)
{
Numput(ARGB, Scan0+0, (x*4)+(y*Stride))
}
Gdip_GetLockBitPixel(Scan0, x, y, Stride)
{
return NumGet(Scan0+0, (x*4)+(y*Stride))
}
Gdip_PixelateBitmap(pBitmap, ByRef pBitmapOut, BlockSize)
{
static PixelateBitmap
if !PixelateBitmap
{
MCode_PixelateBitmap := "83EC388B4424485355568B74245C99F7FE8B5C244C8B6C2448578BF88BCA894C241C897C243485FF0F8E2E0300008B44245"
. "499F7FE897C24448944242833C089542418894424308944242CEB038D490033FF397C2428897C24380F8E750100008BCE0FAFCE894C24408DA4240000"
. "000033C03BF08944241089442460894424580F8E8A0000008B5C242C8D4D028BD52BD183C203895424208D3CBB0FAFFE8BD52BD142895424248BD52BD"
. "103F9897C24148974243C8BCF8BFE8DA424000000008B5C24200FB61C0B03C30FB619015C24588B5C24240FB61C0B015C24600FB61C11015C241083C1"
. "0483EF0175D38B7C2414037C245C836C243C01897C241475B58B7C24388B6C244C8B5C24508B4C244099F7F9894424148B44245899F7F9894424588B4"
. "4246099F7F9894424608B44241099F7F98944241085F60F8E820000008D4B028BC32BC18D68038B44242C8D04B80FAFC68BD32BD142895424248BD32B"
. "D103C18944243C89742420EB038D49008BC88BFE0FB64424148B5C24248804290FB644245888010FB644246088040B0FB644241088040A83C10483EF0"
. "175D58B44243C0344245C836C2420018944243C75BE8B4C24408B5C24508B6C244C8B7C2438473B7C2428897C24380F8C9FFEFFFF8B4C241C33D23954"
. "24180F846401000033C03BF2895424108954246089542458895424148944243C0F8E82000000EB0233D2395424187E6F8B4C243003C80FAF4C245C8B4"
. "424280FAFC68D550203CA8D0C818BC52BC283C003894424208BC52BC2408BFD2BFA8B54241889442424895424408B4424200FB614080FB60101542414"
. "8B542424014424580FB6040A0FB61439014424600154241083C104836C24400175CF8B44243C403BC68944243C7C808B4C24188B4424140FAFCE99F7F"
. "9894424148B44245899F7F9894424588B44246099F7F9894424608B44241099F7F98944241033C08944243C85F60F8E7F000000837C2418007E6F8B4C"
. "243003C80FAF4C245C8B4424280FAFC68D530203CA8D0C818BC32BC283C003894424208BC32BC2408BFB2BFA8B54241889442424895424400FB644241"
. "48B5424208804110FB64424580FB654246088018B4424248814010FB654241088143983C104836C24400175CF8B44243C403BC68944243C7C818B4C24"
. "1C8B44245C0144242C01742430836C2444010F85F4FCFFFF8B44245499F7FE895424188944242885C00F8E890100008BF90FAFFE33D2897C243C89542"
. "45489442438EB0233D233C03BCA89542410895424608954245889542414894424400F8E840000003BF27E738B4C24340FAFCE03C80FAF4C245C034C24"
. "548D55028BC52BC283C003894424208BC52BC2408BFD03CA894424242BFA89742444908B5424200FB6040A0FB611014424148B442424015424580FB61"
. "4080FB6040F015424600144241083C104836C24440175CF8B4424408B7C243C8B4C241C33D2403BC1894424400F8C7CFFFFFF8B44241499F7FF894424"
. "148B44245899F7FF894424588B44246099F7FF894424608B44241099F7FF8944241033C08944244085C90F8E8000000085F67E738B4C24340FAFCE03C"
. "80FAF4C245C034C24548D53028BC32BC283C003894424208BC32BC2408BFB03CA894424242BFA897424448D49000FB65424148B4424208814010FB654"
. "24580FB644246088118B5424248804110FB644241088043983C104836C24440175CF8B4424408B7C243C8B4C241C403BC1894424407C808D04B500000"
. "00001442454836C2438010F858CFEFFFF33D233C03BCA89542410895424608954245889542414894424440F8E9A000000EB048BFF33D2395424180F8E"
. "7D0000008B4C24340FAFCE03C80FAF4C245C8B4424280FAFC68D550203CA8D0C818BC52BC283C003894424208BC52BC240894424248BC52BC28B54241"
. "8895424548DA424000000008B5424200FB6140A015424140FB611015424588B5424240FB6140A015424600FB614010154241083C104836C24540175CF"
. "8B4424448B4C241C403BC1894424440F8C6AFFFFFF0FAF4C24188B44241499F7F9894424148B44245899F7F9894424588B44246099F7F9894424608B4"
. "4241099F7F98944241033C03944241C894424540F8E7B0000008B7C241885FF7E688B4C24340FAFCE03C80FAF4C245C8B4424280FAFC68D530203CA8D"
. "0C818BC32BC283C003894424208BC32BC2408BEB894424242BEA0FB65424148B4424208814010FB65424580FB644246088118B5424248804110FB6442"
. "41088042983C10483EF0175D18B442454403B44241C894424547C855F5E5D33C05B83C438C3"
VarSetCapacity(PixelateBitmap, StrLen(MCode_PixelateBitmap)//2)
Loop % StrLen(MCode_PixelateBitmap)//2
NumPut("0x" SubStr(MCode_PixelateBitmap, (2*A_Index)-1, 2), PixelateBitmap, A_Index-1, "char")
}
Gdip_GetImageDimensions(pBitmap, Width, Height)
if (Width != Gdip_GetImageWidth(pBitmapOut) || Height != Gdip_GetImageHeight(pBitmapOut))
return -1
if (BlockSize > Width || BlockSize > Height)
return -2
E1 := Gdip_LockBits(pBitmap, 0, 0, Width, Height, Stride1, Scan01, BitmapData1)
E2 := Gdip_LockBits(pBitmapOut, 0, 0, Width, Height, Stride2, Scan02, BitmapData2)
if (E1 || E2)
return -3
E := DllCall(&PixelateBitmap, "uint", Scan01, "uint", Scan02, "int", Width, "int", Height, "int", Stride1, "int", BlockSize)
Gdip_UnlockBits(pBitmap, BitmapData1), Gdip_UnlockBits(pBitmapOut, BitmapData2)
return 0
}
Gdip_ToARGB(A, R, G, B)
{
return (A << 24) | (R << 16) | (G << 8) | B
}
Gdip_FromARGB(ARGB, ByRef A, ByRef R, ByRef G, ByRef B)
{
A := (0xff000000 & ARGB) >> 24
R := (0x00ff0000 & ARGB) >> 16
G := (0x0000ff00 & ARGB) >> 8
B := 0x000000ff & ARGB
}
Gdip_AFromARGB(ARGB)
{
return (0xff000000 & ARGB) >> 24
}
Gdip_RFromARGB(ARGB)
{
return (0x00ff0000 & ARGB) >> 16
}
Gdip_GFromARGB(ARGB)
{
return (0x0000ff00 & ARGB) >> 8
}
Gdip_BFromARGB(ARGB)
{
return 0x000000ff & ARGB
}
global layout, tooltipArray, pToken, Scan0, Stride, ts
SetBatchLines,-1
SetMouseDelay,-1
coordmode,mouse,screen
coordmode,tooltip,screen
LoadLayout()
Tooltip()
ts := new TempSettings()
ts.Refresh()
altMouse := 1
return
~F12::
~home::
~delete::
Tooltip()
return
~up::Tooltip(,-1)
~down::Tooltip(,1)
~right::Tooltip(1)
~left::Tooltip(-1)
aim:
if (!active) {
active := true
while (GetKeyState(strreplace(a_thishotkey,"~"),"P")) {
match := false
QPX(True)
movepoint := new point(0,0)
movepoint2 := new point(0,-1)
if (ts.alternative == 1) {
pbmp := Gdip_BitmapFromScreen(ts.search_offset.x "|" ts.search_offset.y "|" ts.dimensions.x "|" ts.dimensions.y)
E1 := Gdip_LockBits(pbmp, 0, 0, ts.dimensions.x, ts.dimensions.y, Stride, Scan0, BitmapData,1)
}
else if (ts.alternative == 2) {
}
else {
pbmp := BitmapFromScreen2(ts.search_offset.x, ts.search_offset.y, ts.dimensions.x, ts.dimensions.y,ts.dc)
E1 := Gdip_LockBits(pbmp, 0, 0, ts.dimensions.x, ts.dimensions.y, Stride, Scan0, BitmapData,1,0x21808)
}
loop % (ts.dimensions.max()/ts.spread)**2 {
if ((-ts.dimensions.x/2 < movepoint.x) <= ts.dimensions.x/2) && ((-ts.dimensions.y/2 < movepoint.y) <= ts.dimensions.y/2) {
search_point := new point((movepoint.x*ts.spread) + (ts.dimensions.x/2), (movepoint.y*ts.spread) + (ts.dimensions.y/2))
if (search_point.x >= 0 && search_point.x < ts.dimensions.x) && (search_point.y >= 0 && search_point.y < ts.dimensions.y) {
GetRGB(search_point,"",r,g,b)
if (r > 240 && g < 20 && b < 20) && (b > 0) && (g == 0) {
match := true
found_point := new point(search_point.x-3,search_point.y)
FindLeftEdge(found_point)
mouse_point := new point((ts.search_offset.x+found_point.x)-ts.window_center.x, (ts.search_offset.y+found_point.y-ts.offset_y)-ts.window_center.y)
DllCall("mouse_event", "UInt", 0x01, "UInt", (mouse_point.x+ts.mouse_offset.x)/ts.ingame_sens, "UInt", (mouse_point.y+ts.mouse_offset.y)/(ts.ingame_sens*2.41))
match_search_offset := new point(ts.window_center.x+(mouse_point.x)-ts.match_dimensions.x+ts.mouse_offset.x, ts.window_center.y+(mouse_point.y)-ts.match_dimensions.y+ts.mouse_offset.y+ts.offset_y)
}
}
}
if (!match) {
if (movepoint.x == movepoint.y || (movepoint.x < 0 && movepoint.x == -movepoint.y) || (movepoint.x > 0 && movepoint.x == 1-movepoint.y)) {
movepoint2.swap()
}
movepoint.add(movepoint2.x,movepoint2.y)
}
} until (match)
if (match) {
ts.dimensions := new point(ts.match_dimensions.x,ts.match_dimensions.y)
ts.search_offset := match_search_offset
if (ts.overlayShow)
overlay(ts.search_offset.x, ts.search_offset.y, ts.dimensions.x, ts.dimensions.y,,1)
dur := QPX(false)
if (dur < 0.008) {
delay(0.008-dur)
}
}
else {
if (ts.dimensions.max() < ts.start_dimensions.min()) {
ts.dimensions.x += 200
ts.dimensions.y += 100
ts.search_offset.sub(100,50)
if (ts.overlayShow)
overlay(ts.search_offset.x, ts.search_offset.y, ts.dimensions.x, ts.dimensions.y,,1)
}
else {
ts.dimensions := ts.start_dimensions
ts.search_offset := ts.start_search_offset
if (ts.overlayShow)
overlay(ts.search_offset.x, ts.search_offset.y, ts.dimensions.x, ts.dimensions.y)
}
dur := QPX(false)
if (dur < 0.008) {
delay(0.008-dur)
}
}
Gdip_UnlockBits(pbmp, BitmapData)
Gdip_DisposeImage(pbmp)
}
active := false
}
ts.dimensions := ts.start_dimensions
ts.search_offset := ts.start_search_offset
overlay(ts.search_offset.x, ts.search_offset.y, ts.dimensions.x, ts.dimensions.y)
return
FindHPBar() {
}
GetRGB(point,mode,byref r, byref g, byref b) {
mode := strsplit(mode,"|")
if (mode[1] == "dwm") {
Gdip_FromRGB(DllCall("gdi32.dll\GetPixel", "UInt", ts.dc, "Int", point.x, "Int", point.y, "UInt"),b,g,r)
}
else
Gdip_FromRGB(NumGet(Scan0+0, (point.x*3)+(point.y*Stride)),r,g,b)
}
FindLeftEdge(byref found_point) {
mismatch := 0
loop 100{
if (found_point.x < 0 || found_point.x > dimensions.x)
mismatch := 9
GetRGB(search_point,"",r,g,b)
if !((r > 200 && g < 100 && b < 100))
mismatch++
else
mismatch := 0
found_point.x-=2
} until % mismatch > 8
}
BitmapFromScreen2(s_x,s_y,s_w,s_h,dc) {
chdc := CreateCompatibleDC(dc), hbm := CreateDIBSection(s_w, s_h, chdc), obm := SelectObject(chdc, hbm)
BitBlt(chdc, 0, 0, s_w, s_h, dc, s_x, s_y)
pbmp := Gdip_CreateBitmapFromHBITMAP(hbm)
SelectObject(chdc, obm), DeleteObject(hbm), DeleteDC(chdc)
return pbmp
}
Gdip_FromRGB(RGB, ByRef R, ByRef G, ByRef B)
{
R := (0x00ff0000 & RGB) >> 16
G := (0x0000ff00 & RGB) >> 8
B := 0x000000ff & RGB
}
Delay( D=0.001 ) {
Static F
Critical
F ? F : DllCall( "QueryPerformanceFrequency", Int64P,F )
DllCall( "QueryPerformanceCounter", Int64P,pTick ), cTick := pTick
While( ( (Tick:=(pTick-cTick)/F)) <D ) {
DllCall( "QueryPerformanceCounter", Int64P,pTick )
Sleep -1
}
Return Round( Tick,3 )
}
QPX( N=0 ) {
Static F,A,Q,P,X
If	( N && !P )
Return	DllCall("QueryPerformanceFrequency",Int64P,F) + (X:=A:=0) + DllCall("QueryPerformanceCounter",Int64P,P)
DllCall("QueryPerformanceCounter",Int64P,Q), A:=A+Q-P, P:=Q, X:=X+1
Return	( N && X=N ) ? (X:=X-1)<<64 : ( N=0 && (R:=A/X/F) ) ? ( R + (A:=P:=X:=0) ) : 1
}
overlay(x ,y ,w ,h, create=0,c=0) {
static overlay_ID
if (!overlay_ID) {
Gui, 2: +E0x20 -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs
Gui, 2: Show,,Window
overlay_ID := WinExist()
}
overlay_dib := CreateDIBSection(w, h)
overlay_dc := CreateCompatibleDC()
overlay_obm := SelectObject(overlay_dc, overlay_dib)
G := Gdip_GraphicsFromHDC(overlay_dc)
if (!c)
overlay_pen := Gdip_CreatePen(Gdip_ToARGB(255,255,0,0), 2)
else
overlay_pen := Gdip_CreatePen(Gdip_ToARGB(255,0,255,0), 2)
Gdip_DrawRectangle(G, overlay_pen, 0, 0, w, h)
Gdip_DeletePen(overlay_pen)
UpdateLayeredWindow(overlay_ID, overlay_dc, x, y, w, h)
SelectObject(overlay_dc, overlay_obm)
DeleteObject(overlay_dib)
DeleteDC(overlay_dc)
Gdip_DeleteGraphics(G)
}
class point {
__new(x,y) {
this.x := x
this.y := y
}
swap() {
ty := -this.y
this.y := this.x
this.x := ty
}
max() {
if (this.x > this.y)
return  % this.x
else
return % this.y
}
min() {
if (this.x < this.y)
return  % this.x
else
return % this.y
}
add(x,y) {
this.x += x
this.y += y
}
sub(x,y) {
this.x -= x
this.y -= y
}
}
pickItem(subs,val=0) {
temp := strsplit(layout[subs],"|")
if (instr(temp[1],"num")) {
temp2 := strsplit(temp[1],":")
newVal := temp[2]+(temp2[2]*val)
if (newVal >= 0) {
if (temp2[2] < 1)
temp[2] := round(newVal,2)
else
temp[2] := round(newVal,0)
}
layout[subs] := temp[1] "|" temp[2]
return % temp[2]
}
else if (instr(temp[1],"bool")) {
temp2 := strsplit(temp[1],":")
temp[1] := temp2[1] ":" !temp2[2]
temp[2] := (temp2[2]) ? "Enabled" : "Disabled"
layout[subs] := temp[1] "|" temp[2]
return % temp[2]
}
else {
temp[1] += val
retStr := strsplit(temp[2],";")[temp[1]]
if (!retStr)
temp[1] -= val
else if (subs == "1a. 自瞄模式" && val) {
LoadLayout(temp[1],temp[1]-val)
}
layout[subs] := temp[1] "|" temp[2]
return % strsplit(temp[2],";")[temp[1]]
}
}
Tooltip(newTab=0,newItem=0) {
static activeTab, activeItem, toggle, x, y
if (toggle == "")
toggle := 1
if (!newTab && !newItem) {
toggle := ! toggle
mousegetpos,x,y
}
if (toggle) {
activeItem := (!newItem && !activeItem) ? 1 : activeItem+newItem
if (activeItem == 1)
activeTab := (!newTab && !activeTab) ? 1 : (activeTab+newTab > 0 && activeTab+newTab <= tooltipArray["tabCount"]) ? activeTab+newTab : activeTab
else
addItem := newTab
for tabName in tooltipArray {
if (a_index == activeTab) {
for t in tooltipArray[tabName]
itemCount := a_index
if (activeItem < 1 || activeItem > itemCount+1)
activeItem := activeItem-newItem
if (activeItem == 1)
nText .= "|[" strsplit(tabName,".")[2] "]|`n"
else
nText .= strsplit(tabName,".")[2] "`n"
for subs in tooltipArray[tabName] {
if (a_index+1 == activeItem) {
if (addItem) {
tooltipArray[tabName,subs] := pickItem(subs,addItem)
}
if (!tooltipArray[tabName,subs])
nText .= "|[" strsplit(subs,".")[2] "]|"
else
nText .= strsplit(subs,".")[2] ": " "|[" tooltipArray[tabName,subs] "]|`n"
}
else {
if (!tooltipArray[tabName,subs])
nText .= strsplit(subs,".")[2]
else
nText .= strsplit(subs,".")[2] ": " tooltipArray[tabName,subs] "`n"
}
}
}
}
tooltip, % rTrim(nText,"`n"), % x, % y
}
else
tooltip,
if (ts.overwatch) {
ts.Refresh()
}
}
LoadLayout(num=1,pnum=0) {
if (pnum) {
SaveLayout(pnum)
}
layout := array(), tooltipArray := array()
if (!fileexist("layout.dat")) {
loop 23 {
fileappend, % a_index ";1;15.00;70;30;8;400;300;200;100;1;0`r`n",layout.dat
}
}
fileread,strIn,layout.dat
loop,parse,strIn,`r`n
{
if (a_loopfield) {
temp := strsplit(a_loopfield,";")
if (temp[1] == num) {
layout["1a. 自瞄模式"] := num "|通用預設;安娜;璧疊機兵;D.V.A;源氏;半藏;炸彈鼠;路西歐;麥卡利;小美;慈悲;法拉;死神;萊因哈特;攔路豬;士兵76;辛梅塔;閃光;托比昂;奪命女;溫斯頓;札莉雅;札莉雅"
layout["1b. 應用自鍵鍵"] := temp[2] "|LButton;RButton;LAlt;LButton, RButton;LButton, RButton, LAlt"
layout["2a. 自瞄靈敏度"] := "num:0.05|" temp[3]
layout["2b. 自瞄位置X軸"] := "num:1|" temp[4]
layout["2c. 自瞄位置Y軸"] := "num:1|" temp[5]
layout["3a. 檢察模糊度"] := "num:1|" temp[6]
layout["3b. 檢察寬度"] := "num:20|" temp[7]
layout["3c. 檢察高度"] := "num:20|" temp[8]
layout["3d. 確定寬度"] := "num:20|" temp[9]
layout["3f. 確定高度"] := "num:20|" temp[10]
layout["4a. 檢察顯示"] := "bool:" temp[11] "|Disabled"
layout["4b. 自主檢索"] := "bool:" temp[12] "|Disabled"
}
}
}
menuLayout := "1.第一頁：外掛設定|1a. 自瞄模式,1b. 應用自鍵鍵;"
. "2.第二頁：射擊設定|2a. 自瞄靈敏度,2b. 自瞄位置X軸,2c. 自瞄位置Y軸;"
. "3.第三頁：自瞄檢察範圍|3a. 檢察模糊度,3b. 檢察寬度,3c. 檢察高度,3d. 確定寬度,3f. 確定高度;"
. "4.第四頁：其他設定|4a. 檢察顯示,4b. 自主檢索"
loop,parse,menuLayout,`;
{
tabName := strsplit(a_loopfield,"|")
subs := strsplit(tabName[2],",")
loop % subs.length(){
tooltipArray[tabName[1],subs[a_index]] := pickItem(subs[a_index])
}
len := a_index
}
tooltipArray["tabCount"] := len
}
class TempSettings {
Refresh() {
static hotkeys
if (winexist("ahk_class TankWindowClass") && !ts.overwatch) {
this.overwatch := true
}
else {
while !(winexist("ahk_class TankWindowClass")) {
tooltip, 請啟動遊戲
sleep, 50
}
}
if (!ptoken)
pToken := Gdip_Startup()
this.handle := winexist("ahk_class TankWindowClass")
this.dc := GetDC(this.handle)
pbmp := Gdip_BitmapFromHWND(this.handle)
Gdip_GetDimensions(pbmp, w, h)
Gdip_DisposeImage(pbmp)
ts.window_center := new point(w/2,h/2)
this.active := strsplit(layout["1a. 自瞄模式"],"|")[1]
ingame_sens := strsplit(layout["2a. 自瞄靈敏度"],"|")[2]
this.mouse_offset := new point(strsplit(layout["2b. 自瞄位置X軸"],"|")[2], strsplit(layout["2c. 自瞄位置Y軸"],"|")[2])
this.spread := strsplit(layout["3a. 檢察模糊度"],"|")[2]
this.start_dimensions := new point(strsplit(layout["3b. 檢察寬度"],"|")[2], strsplit(layout["3c. 檢察高度"],"|")[2])
this.dimensions := this.start_dimensions
this.match_dimensions := new point(strsplit(layout["3d. 確定寬度"],"|")[2], strsplit(layout["3f. 確定高度"],"|")[2])
this.overlayShow := !(strsplit(strsplit(layout["4a. 檢察顯示"],":")[2],"|")[1])
this.alternative := !(strsplit(strsplit(layout["4b. 自主檢索"],":")[2],"|")[1])
this.offset_y := -this.dimensions.max()*0.125
this.start_search_offset := new point(this.window_center.x-(this.dimensions.x/2),(this.window_center.y-(this.dimensions.y/2))+this.offset_y)
this.search_offset := this.start_search_offset
cappedFPS := 5
this.ingame_sens := 0.116*(ingame_sens*(16/cappedFPS))
if (hotkeys)
loop,parse,hotkeys,`,
hotkey, % strreplace("~" a_loopfield,a_space,""), aim, off
temp := strsplit(layout["1b. 應用自鍵鍵"],"|")
hotkeys := strsplit(temp[2],";")[temp[1]]
loop,parse,hotkeys,`,
hotkey, % strreplace("~" a_loopfield,a_space,""), aim, on
if (this.overlayShow)
overlay(this.search_offset.x, this.search_offset.y, this.start_dimensions.x, this.start_dimensions.y,1)
}
}
SaveLayout(num) {
for k, v in layout {
if (a_index <= 2)
out .= strsplit(v,"|")[1] ";"
else if (a_index <= 10)
out .= strsplit(v,"|")[2] ";"
else
out .= !strsplit(strsplit(v,":")[2],"|")[1] ";"
}
out := rTrim(out,";")
fileread,strIn,layout.dat
filedelete,layout.dat
loop, parse, strIn, `r`n
{
if (a_loopfield) {
temp := strsplit(a_loopfield,";")
if (temp[1] == num)
strOut .= out "`r`n"
else
strOut .= a_loopfield "`r`n"
}
}
fileappend, % strOut, layout.dat
}
F10::
pause
F11::
GuiClose:
SaveLayout(ts.active)
Gdip_DisposeImage(pbmp)
Gdip_Shutdown(pToken)
ExitApp