$guest_wdag_path = "C:\Users\WDAGUtilityAccount"
$guest_public_doc_path = "C:\Users\Public\Documents"

if (-Not (Test-Path $guest_wdag_path)) {
    Write-Output "[!] Not running in Sandbox! Aborting..."
    exit 1
}

# Move all . folders
Get-ChildItem -Path "$guest_public_doc_path\UserFiles" -Directory -Force | Where-Object { $_.Name -match '^\.' } | ForEach-Object { Move-Item -Path $_.FullName -Destination "C:\Users\WDAGUtilityAccount" -Force -ErrorAction SilentlyContinue }
Move-Item "$guest_public_doc_path\UserFiles\AppData" -Destination "C:\Users\WDAGUtilityAccount" -Force -ErrorAction SilentlyContinue
Remove-Item "$guest_public_doc_path\UserFiles" -Recurse -Force -ErrorAction SilentlyContinue

Move-Item "$guest_public_doc_path\CFiles\psnotify" -Destination "C:\" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\CFiles\Python310" -Destination "C:\" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\CFiles\symbols" -Destination "C:\" -Force -ErrorAction SilentlyContinue
Remove-Item "$guest_public_doc_path\CFiles" -Recurse -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\Common Files" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\Application Verifier" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\Graphviz" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\Microsoft SQL Server" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\Microsoft VS Code" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\Microsoft Visual Studio" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\Notepad++" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\WindowsApps" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\NASM" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\Dokan" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\Wireshark" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\OpenVPN" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\Npcap" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\AutoHotkey" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\nodejs" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\Git" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\HxD" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\010 Editor" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\BinDiff" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\dotnet" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\Microsoft Office 15" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\IDA Free 9.1" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\7-Zip" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\ProgFiles\OpenJDK" -Destination "C:\Program Files" -Force -ErrorAction SilentlyContinue
Remove-Item "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\Prog86Files\Common Files" -Destination "C:\Program Files (x86)" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\Prog86Files\Nmap" -Destination "C:\Program Files (x86)" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\Prog86Files\Application Verifier" -Destination "C:\Program Files (x86)" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\Prog86Files\Microsoft Office" -Destination "C:\Program Files (x86)" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\Prog86Files\NuGet" -Destination "C:\Program Files (x86)" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\Prog86Files\Microsft SDKs" -Destination "C:\Program Files (x86)" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\Prog86Files\dotnet" -Destination "C:\Program Files (x86)" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\Prog86Files\WinSCP" -Destination "C:\Program Files (x86)" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\Prog86Files\Windows Kits" -Destination "C:\Program Files (x86)" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\Prog86Files\Microsoft.NET" -Destination "C:\Program Files (x86)" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\Prog86Files\Reference Assemblies" -Destination "C:\Program Files (x86)" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\Prog86Files\MSBuild" -Destination "C:\Program Files (x86)" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\Prog86Files\Advanced Installer" -Destination "C:\Program Files (x86)" -Force -ErrorAction SilentlyContinue
Move-Item "$guest_public_doc_path\Prog86Files\Microsoft Visual Studio" -Destination "C:\Program Files (x86)" -Force -ErrorAction SilentlyContinue
Remove-Item "$guest_public_doc_path\Prog86Files" -Recurse -Force -ErrorAction SilentlyContinue