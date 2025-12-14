param (
  [string]$networking = "N"
)

####
# Flare installer normally does these things, but since we can't make registry changes persist we do this manually
# Admittedly, this file is mostly AI generated...
###

$guest_wdag_path = "C:\Users\WDAGUtilityAccount"
$guest_public_doc_path = "C:\Users\Public\Documents"

if (-Not (Test-Path $guest_wdag_path)) {
    Write-Output "[!] Not running in Sandbox! Aborting..."
    exit 1
}

& reg import "$guest_public_doc_path\HKLM.reg" | Out-Null
& reg import "$guest_public_doc_path\HKCU.reg" | Out-Null
Remove-Item "$guest_public_doc_path\HKLM.reg" -Force -ErrorAction SilentlyContinue
Remove-Item "$guest_public_doc_path\HKCU.reg" -Force -ErrorAction SilentlyContinue

$changes = @(
    @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState"; Value = "FullPath"; Type = "DWord"; Data = 1 },
    @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Value = "HideFileExt"; Type = "DWord"; Data = 0 },
    @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Value = "Hidden"; Type = "DWord"; Data = 1 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"; Value = "EnableSmartScreen"; Type = "DWord"; Data = 0 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter"; Value = "EnabledV9"; Type = "DWord"; Data = 0 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile"; Value = "EnableFirewall"; Type = "DWord"; Data = 0 },
    @{ Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; Value = "ZoomIt"; Type = "String"; Data = "C:\Tools\sysinternals\ZoomIt64.exe" },
    @{ Path = "HKCU:\Software\Sysinternals\ZoomIt"; Value = "OptionsShown"; Type = "DWord"; Data = 1 },
    @{ Path = "HKLM:\SOFTWARE\Classes\lnkfile"; Value = "NeverShowExt"; Type = "String"; Data = " " },
    @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"; Value = "SystemUsesLightTheme"; Type = "DWord"; Data = 0 },
    @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"; Value = "AppsUseLightTheme"; Type = "DWord"; Data = 0 }
)
function Ensure-KeyExists {
    param($path)
    if (-not (Test-Path -Path $path)) {
        try {
            New-Item -Path $path -Force | Out-Null
        } catch {
            Write-Error "Failed to create registry key: $path - $_"
            throw
        }
    }
}

foreach ($c in $changes) {
    $path = $c.Path
    $name = $c.Value
    $type = $c.Type
    $data = $c.Data
    try {
        Ensure-KeyExists -path $path
        switch ($type.ToLower()) {
            "dword" {
                $value = [int]$data
                New-ItemProperty -Path $path -Name $name -Value $value -PropertyType DWord -Force | Out-Null
            }
            "string" {
                $value = [string]$data
                New-ItemProperty -Path $path -Name $name -Value $value -PropertyType String -Force | Out-Null
            }
            default {
                Write-Warning "Unsupported type '$type' for $path\$name. Skipping."
            }
        }
        Write-Host "Set $path\$name = $data ($type)"
    } catch {
        Write-Error "Failed to set $path\$name : $_"
    }
}

# Notify Explorer and other apps to re-read settings where applicable
# Refresh Explorer to apply some changes (will restart explorer.exe)
try {
    Write-Host "Restarting Explorer to apply some changes..."
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    # Start-Sleep -Seconds 1
    # Start-Process explorer.exe
} catch {
    Write-Warning "Could not restart Explorer: $_"
}
& cmd.exe /c setx PATH "%PATH%"
Write-Host "Registry updates complete."

$TargetFolder = "C:\Users\Public\Documents\flare-vm\Tools"
$ShortcutName = "Tools.lnk"
$IconLocation = "shell32.dll,3"
$WallpaperStyle = "10"
$TileWallpaper = "0"

# Resolve current user's desktop path
$desktop = [Environment]::GetFolderPath('Desktop')

# Create desktop shortcut
try {
    $wsh = New-Object -ComObject WScript.Shell
    $shortcutPath = Join-Path $desktop $ShortcutName
    $shortcut = $wsh.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $TargetFolder
    $shortcut.WorkingDirectory = $TargetFolder
    $shortcut.IconLocation = $IconLocation
    $shortcut.Save()
    Write-Host "Created shortcut: $shortcutPath -> $TargetFolder"
} catch {
    Write-Error "Failed to create shortcut: $_"
}

# Rewrite LNKs
Add-Type -AssemblyName WindowsBase

function Get-Shortcut($lnkPath) {
    $shell = New-Object -ComObject WScript.Shell
    try { $shortcut = $shell.CreateShortcut($lnkPath) } catch { return $null }
    return $shortcut
}

function Save-Shortcut($shortcut, $path) {
    $shortcut.Save()
}

$root = "C:\Users\Public\Documents\flare-vm"
$oldPrefix = "C:\base_layer"
$newPrefix = "C:\"

Get-ChildItem -Path $root -Recurse -Filter '*.lnk' -File | ForEach-Object {
    $lnk = $_.FullName
    $sc = Get-Shortcut $lnk
    if (-not $sc) { return }

    $changed = $false

    # Update TargetPath
    if ($sc.TargetPath -and $sc.TargetPath -like "$oldPrefix*") {
        $newTarget = $sc.TargetPath -replace [regex]::Escape($oldPrefix), $newPrefix
        $sc.TargetPath = $newTarget
        $changed = $true
    }

    # Update WorkingDirectory
    if ($sc.WorkingDirectory -and $sc.WorkingDirectory -like "$oldPrefix*") {
        $newWd = $sc.WorkingDirectory -replace [regex]::Escape($oldPrefix), $newPrefix
        $sc.WorkingDirectory = $newWd
        $changed = $true
    }

    # Update IconLocation (in case it embeds old path)
    if ($sc.IconLocation -and $sc.IconLocation -like "$oldPrefix*") {
        $newIcon = $sc.IconLocation -replace [regex]::Escape($oldPrefix), $newPrefix
        $sc.IconLocation = $newIcon
        $changed = $true
    }

    if ($changed) {
        try {
            $sc.Save()
            Write-Host "Updated: $lnk"
        } catch {
            Write-Warning "Failed to save: $lnk ($($_.Exception.Message))"
        }
    }
}

if ($networking -eq "Y") {
    $WallpaperPath = "C:\Users\Public\Documents\flare-vm\_VM\background-internet.png"
} else {
    $WallpaperPath = "C:\Users\Public\Documents\flare-vm\_VM\background.png"
}
# Function to set wallpaper via registry + SystemParametersInfo
function Set-Wallpaper {
    param([string]$imagePath)

    if (-not (Test-Path -Path $imagePath)) {
        Write-Error "Wallpaper image not found: $imagePath"
        return $false
    }

    $regPath = "HKCU:\Control Panel\Desktop"
    try {
        Set-ItemProperty -Path $regPath -Name Wallpaper -Value $imagePath -ErrorAction Stop
        Set-ItemProperty -Path $regPath -Name WallpaperStyle -Value $WallpaperStyle -ErrorAction Stop
        Set-ItemProperty -Path $regPath -Name TileWallpaper -Value $TileWallpaper -ErrorAction Stop
    } catch {
        Write-Error "Failed to set registry wallpaper values: $_"
        return $false
    }

    $signature = @'
[DllImport("user32.dll", SetLastError=true)]
public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
'@
    $type = Add-Type -MemberDefinition $signature -Name 'NativeMethods' -Namespace 'Win32' -PassThru

    $SPI_SETDESKWALLPAPER = 0x0014
    $SPIF_UPDATEINIFILE = 0x01
    $SPIF_SENDWININICHANGE = 0x02
    $flags = $SPIF_UPDATEINIFILE -bor $SPIF_SENDWININICHANGE

    $ok = $type::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $imagePath, $flags)
    if ($ok) {
        Write-Host "Wallpaper set to: $imagePath"
        return $true
    } else {
        Write-Error "SystemParametersInfo failed to set wallpaper."
        return $false
    }
}
Set-Wallpaper -imagePath $WallpaperPath