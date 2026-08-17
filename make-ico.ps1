Add-Type -AssemblyName System.Drawing
$dir = $PSScriptRoot
$icoDir = Join-Path $dir "src-tauri\icons"
New-Item -ItemType Directory -Force -Path $icoDir | Out-Null

$bmp = New-Object System.Drawing.Bitmap(256, 256)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$rect = New-Object System.Drawing.Rectangle(0, 0, 256, 256)
$brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect,
    [System.Drawing.Color]::FromArgb(255, 232, 58, 0),
    [System.Drawing.Color]::FromArgb(255, 255, 149, 0), 45)
$g.FillRectangle($brush, $rect)
$white = [System.Drawing.Brushes]::White
function Ell([single]$x, [single]$y, [single]$w, [single]$h) {
    $g.FillEllipse($white, $x, $y, $w, $h)
}
Ell 62 122 132 58
Ell 78 84 74 74
Ell 106 62 88 88
Ell 148 94 62 62
$g.Dispose()

$ms = New-Object System.IO.MemoryStream
$bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
$png = $ms.ToArray()
$bmp.Dispose()

# ICO-контейнер с PNG внутри (Vista+)
$ico = New-Object System.IO.MemoryStream
$bw = New-Object System.IO.BinaryWriter($ico)
$bw.Write([uint16]0); $bw.Write([uint16]1); $bw.Write([uint16]1)
$bw.Write([byte]0); $bw.Write([byte]0)          # 256x256
$bw.Write([byte]0); $bw.Write([byte]0)          # палитры нет
$bw.Write([uint16]1); $bw.Write([uint16]32)     # planes, bpp
$bw.Write([uint32]$png.Length); $bw.Write([uint32]22)
$bw.Write($png)
$bw.Flush()
[System.IO.File]::WriteAllBytes((Join-Path $icoDir "icon.ico"), $ico.ToArray())
Write-Host ("icon.ico: " + (Get-Item (Join-Path $icoDir "icon.ico")).Length + " байт")
