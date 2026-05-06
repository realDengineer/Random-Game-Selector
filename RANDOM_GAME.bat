@echo off
set "STEAM_PATH=C:\Program Files (x86)\Steam\steam\games"
set "TEMP_BG=%TEMP%\steam_scaled_bg.png"

dir /b "%STEAM_PATH%" | findstr /r "[0-9a-f]*\.ico$" | findstr /V "Steam" | powershell -Command ^
    "$file = $input | Get-Random;" ^
    "$path = '%STEAM_PATH%\' + $file;" ^
    "Add-Type -AssemblyName System.Drawing, System.Windows.Forms;" ^
    "$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds;" ^
    "$bmp = New-Object System.Drawing.Bitmap($screen.Width, $screen.Height);" ^
    "$g = [System.Drawing.Graphics]::FromImage($bmp);" ^
    "$g.Clear([System.Drawing.Color]::Green);" ^
    "$icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path);" ^
    "$iconBmp = $icon.ToBitmap();" ^
    "$scale = 5;" ^
    "$newW = [int]($iconBmp.Width * $scale);" ^
    "$newH = [int]($iconBmp.Height * $scale);" ^
    "$x = ($screen.Width - $newW) / 2;" ^
    "$y = ($screen.Height - $newH) / 2;" ^
    "$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor;" ^
    "$g.DrawImage($iconBmp, $x, $y, $newW, $newH);" ^
    "$bmp.Save('%TEMP_BG%', [System.Drawing.Imaging.ImageFormat]::Png);" ^
    "$g.Dispose(); $bmp.Dispose(); $icon.Dispose(); $iconBmp.Dispose();" ^
    "$code = '[DllImport(\"user32.dll\")] public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);';" ^
    "$type = Add-Type -MemberDefinition $code -Name 'Win32' -Namespace 'Wallpaper' -PassThru;" ^
    "$type::SystemParametersInfo(20, 0, '%TEMP_BG%', 3)"

exit
