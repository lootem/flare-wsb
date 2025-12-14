Write-Output "[!] This script is for starting WSB after installing Flare to the base image. Use 'install.ps1' to setup."

# Stop any running sandboxes + verify wsb is installed
try {
    $current_wsb = & wsb list
} catch {
    Write-Output "[!] Error checking for running sandboxes... is Windows Sandbox feature enabled and is 'wsb' in PATH?"
    Write-Output "[!] If you recently enabled Windows Sandbox, start it first."
    exit 1
}
if (-not ([string]::IsNullOrEmpty($current_wsb))) {
    Write-Output "[!] Found running sandbox. Stopping..."
    & wsb stop --id $current_wsb
}

$run_cwd = Get-Location
$guest_wdag_path = "C:\Users\WDAGUtilityAccount"

$wsb_bin = "$run_cwd\bin" # Intented to be run from flare-wsb with flare-wsb.bat

$host_scripts_path = "$wsb_bin\scripts"
$guest_scripts_path = "$guest_wdag_path\scripts"

$host_shared_path = "$run_cwd\shared"
$guest_shared_path = "$guest_wdag_path\Desktop\shared"

$networking = Read-Host "[~] Attach networking? (Y/N) (Default: No)"
$networking = $networking.Trim().ToUpper()

$shared_write = Read-Host "[~] Make shared folder writeable by sandbox? (Y/N) (Default: No)"
$shared_write = $shared_write.Trim().ToUpper()

if ($networking -eq "Y") {
    Write-Output "[~] Starting WSB (Networking: Yes)..."
    $wsb_id_json = ((& wsb start --raw) -join "`n")
} else {
    Write-Output "[~] Starting WSB (Networking: No)..."
    $wsb_id_json = ((& wsb start --config "<Configuration><Networking>Disabled</Networking></Configuration>" --raw) -join "`n")
}

$wsb_id = ($wsb_id_json | ConvertFrom-Json).Id
& wsb connect --id $wsb_id

Write-Output "[~] Adding script directory..."
& wsb share --id $wsb_id -f $host_scripts_path -s $guest_scripts_path

if (-Not (Test-Path $host_shared_path)) {
    New-Item -ItemType Directory -Path $host_shared_path | Out-Null
}
if ($shared_write -eq "Y") {
    Write-Output "[~] Adding shared folder (writeable) to desktop..."
    & wsb share --id $wsb_id -f $host_shared_path -s $guest_shared_path -w
} else {
    Write-Output "[~] Adding shared folder to desktop..."
    & wsb share --id $wsb_id -f $host_shared_path -s $guest_shared_path
}
Write-Output "[+] Shared folder: $host_scripts_path"

Write-Output "[~] Starting system script..."
& wsb exec --id $wsb_id -c "start_post_install_system.cmd" -r System -d $guest_scripts_path

Write-Output "[~] Waiting a few seconds for login..."
Start-Sleep -Seconds 10

Write-Output "[~] Starting post installation script..."
& wsb exec --id $wsb_id -c "powershell.exe -ExecutionPolicy Unrestricted -File `"C:\Users\WDAGUtilityAccount\scripts\post_install_user.ps1`" -networking `"$networking`"" -r ExistingLogin -d $guest_scripts_path

Write-Output "[+] Done!"

$ans = Read-Host "[!] Press any key to stop WSB or exit this script to stop it on your own time"

Write-Output "[~] Stopping WSB..."
& wsb stop --id $wsb_id

exit 0