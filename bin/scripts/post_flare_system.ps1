$guest_wdag_path = "C:\Users\WDAGUtilityAccount"
$guest_wsb_base_layer_path = "C:\base_layer"
$guest_public_doc_path = "$guest_wsb_base_layer_path\Users\Public\Documents"

if (-Not (Test-Path $guest_wdag_path)) {
    Write-Output "[!] Not running in Sandbox! Aborting..."
    exit 1
}

Copy-Item "C:\ProgramData" -Destination "$guest_wsb_base_layer_path" -Recurse -Force -ErrorAction SilentlyContinue

New-Item -ItemType Directory -Path "$guest_public_doc_path\CFiles" | Out-Null
Copy-Item "C:\psnotify" -Destination "$guest_public_doc_path\CFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Python310" -Destination "$guest_public_doc_path\CFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\symbols" -Destination "$guest_public_doc_path\CFiles" -Recurse -Force -ErrorAction SilentlyContinue

New-Item -ItemType Directory -Path "$guest_public_doc_path\UserFiles" | Out-Null
# Copy all . folders
Get-ChildItem -Path "$guest_wdag_path" -Directory -Force | Where-Object { $_.Name -match '^\.' } | ForEach-Object { Copy-Item -Path $_.FullName -Destination "$guest_public_doc_path\UserFiles" -Recurse -Force -ErrorAction SilentlyContinue }
Copy-Item "C:\Users\WDAGUtilityAccount\AppData" -Destination "$guest_public_doc_path\UserFiles" -Recurse -Force -ErrorAction SilentlyContinue

New-Item -ItemType Directory -Path "$guest_public_doc_path\ProgFiles" | Out-Null
Copy-Item "C:\Program Files\Common Files" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\Application Verifier" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\Graphviz" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\Microsoft SQL Server" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\Microsoft VS Code" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\Microsoft Visual Studio" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\Notepad++" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\WindowsApps" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\NASM" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\Dokan" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\Wireshark" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\OpenVPN" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\Npcap" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\AutoHotkey" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\nodejs" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\Git" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\HxD" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\010 Editor" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\BinDiff" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\dotnet" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\Microsoft Office 15" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\IDA Free 9.1" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\7-Zip" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\OpenJDK" -Destination "$guest_public_doc_path\ProgFiles" -Recurse -Force -ErrorAction SilentlyContinue

New-Item -ItemType Directory -Path "$guest_public_doc_path\Prog86Files" | Out-Null
Copy-Item "C:\Program Files (x86)\Common Files" -Destination "$guest_public_doc_path\Prog86Files" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files (x86)\Nmap" -Destination "$guest_public_doc_path\Prog86Files" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files (x86)\Application Verifier" -Destination "$guest_public_doc_path\Prog86Files" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files (x86)\Microsoft Office" -Destination "$guest_public_doc_path\Prog86Files" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files (x86)\NuGet" -Destination "$guest_public_doc_path\Prog86Files" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files (x86)\Microsft SDKs" -Destination "$guest_public_doc_path\Prog86Files" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files (x86)\dotnet" -Destination "$guest_public_doc_path\Prog86Files" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files (x86)\WinSCP" -Destination "$guest_public_doc_path\Prog86Files" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files (x86)\Windows Kits" -Destination "$guest_public_doc_path\Prog86Files" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files (x86)\Microsoft.NET" -Destination "$guest_public_doc_path\Prog86Files" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files (x86)\Reference Assemblies" -Destination "$guest_public_doc_path\Prog86Files" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files (x86)\MSBuild" -Destination "$guest_public_doc_path\Prog86Files" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files (x86)\Advanced Installer" -Destination "$guest_public_doc_path\Prog86Files" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files (x86)\Microsoft Visual Studio" -Destination "$guest_public_doc_path\Prog86Files" -Recurse -Force -ErrorAction SilentlyContinue

exit 0