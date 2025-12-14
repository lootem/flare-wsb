$guest_wdag_path = "C:\Users\WDAGUtilityAccount"
if (-Not (Test-Path $guest_wdag_path)) {
    Write-Output "[!] Not running in Sandbox! Aborting..."
    exit 1
}
reg export "HKCU\Environment" "C:\base_layer\Users\Public\Documents\HKCU.reg" /y
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "C:\base_layer\Users\Public\Documents\HKLM.reg" /y

$Folder='C:\base_layer\Users\Public\Documents'
$Old='C:\\base_layer\\'
$New='C:\\'

Get-ChildItem -Path $Folder -Filter *.reg -File -Recurse | ForEach-Object {
    $file = $_.FullName
    $bytes = [System.IO.File]::ReadAllBytes($file)

    # Detect BOM/encoding name
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) { $encName = 'UTF8' }
    elseif ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) { $encName = 'Unicode' }       # UTF-16 LE
    elseif ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFE -and $bytes[1] -eq 0xFF) { $encName = 'BigEndianUnicode' } # UTF-16 BE
    else { $encName = 'Default' }

    $text = Get-Content -Raw -LiteralPath $file -Encoding $encName

    if ($text -notmatch '^Windows Registry Editor Version 5.00') {
        Write-Warning "$file missing header; skipping"
        return
    }

    $newText = $text.Replace($Old, $New)

    # Write back preserving encoding
    Set-Content -LiteralPath $file -Value $newText -Encoding $encName

    Write-Host "Processed: $file (encoding: $encName)"
}