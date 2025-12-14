$run_cwd = Get-Location
$wsb_bin = "$run_cwd\bin"
$wsb_home_path = "C:\ProgramData\flare-wsb"
$log_path = "$wsb_home_path\install.log"
$wsb_path = "C:\ProgramData\flare-wsb\MicrosoftWindows.WindowsSandbox"

$guest_wdag_path = "C:\Users\WDAGUtilityAccount"

$host_flare_path = "$run_cwd\flare-vm"
$guest_flare_path = "$guest_wdag_path\Documents\flare-vm"

$host_bin_path = "$run_cwd\bin"
$guest_bin_path = "$guest_wdag_path\Documents\flare-wsb"

$host_scripts_path = "$wsb_bin\scripts"
$guest_scripts_path = "$guest_bin_path\scripts"

if (-Not (Test-Path $wsb_home_path)) {
    New-Item -ItemType Directory -Path $wsb_home_path | Out-Null
    Write-Log "[+] flare-wsb home folder not found on host. Created here: $wsb_home_path"
}

function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $log_message = "[$timestamp] $message"
    Write-Output $log_message
    Add-Content -Path $log_path -Value $log_message
}

Write-Log "[~] Using CWD: $run_cwd"
Write-Log "[~] Install logs will be stored in: $log_path"

# Check for administrator
if (-Not [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Log "[!] Installation requires elevated permissions. Please run PowerShell as an Administrator ..."
    exit 1
}

# Stop any running sandboxes + verify wsb is installed
try {
    $current_wsb = & wsb list
} catch {
    Write-Log "[!] Error checking for running sandboxes... is Windows Sandbox feature enabled and is 'wsb' in PATH?"
    Write-Log "[!] If you recently enabled Windows Sandbox, start it first."
    exit 1
}
if (-not ([string]::IsNullOrEmpty($current_wsb))) {
    Write-Log "[!] Found running sandbox. Stopping..."
    & wsb stop --id $current_wsb
}

# Check for powershell 7
$pwsh_cmd = Get-Command pwsh -ErrorAction SilentlyContinue
if (-not $pwsh_cmd) {
    Write-Log "[!] PowerShell 7 not found in PATH. Install PowerShell 7 and ensure pwsh is in PATH."
    Write-Log "https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.5"
    $winget = (Get-Command winget -ErrorAction SilentlyContinue).Source
    if (-not $winget) {
        exit 1
    }
    do {
        $ans = Read-Host "[~] Install PowerShell 7 with winget? (Y/N)"
        $ans = $ans.Trim().ToUpper()
    } while ($ans -notin @("Y","N"))
    if ($ans -eq "Y") {
        & winget install --id Microsoft.PowerShell --source winget
        & refreshenv
        $pwsh_cmd = Get-Command pwsh -ErrorAction SilentlyContinue
    } else {
        exit 1
    }
}
$pwsh_path = $pwsh_cmd.Source
Write-Log "[~] Found pwsh at: $pwsh_path"

# Find wsb base layer on host
$wsb_layers = Get-ChildItem -Path "C:\ProgramData\Microsoft\Windows\Containers\Layers" -Directory -Force -ErrorAction SilentlyContinue
$wsb_oldest_layer = ($wsb_layers | Sort-Object LastWriteTime | Select-Object -First 1).FullName
$host_wsb_base_layer_path = "$wsb_oldest_layer\Files"
$guest_wsb_base_layer_path = "C:\base_layer"

Write-Log "[~] Starting WSB..."
$wsb_id_json = ((& wsb start --raw) -join "`n")
$wsb_id = ($wsb_id_json | ConvertFrom-Json).Id

& wsb connect --id $wsb_id

Write-Log "[~] Sharing flare-vm..."
& wsb share --id $wsb_id -f $host_flare_path -s $guest_flare_path
Write-Log "[~] Sharing bin..."
& wsb share --id $wsb_id -f $host_bin_path -s $guest_bin_path
Write-Log "[~] Sharing base layer with guest..."
& wsb share --id $wsb_id -f $host_wsb_base_layer_path -s $guest_wsb_base_layer_path -w

Write-Log "[~] Getting WDAGUtility password for $wsb_id..."
if (-not (Test-Path $wsb_home_path)) {
    # SandboxCommon.dll needs to be in a predictable location
    Write-Log "[~] Creating a copy of Windows Sandbox directory..."
    $wsb_InstallLocation = (Get-AppxPackage *WindowsSandbox*).InstallLocation
    Copy-Item $wsb_InstallLocation -Destination $wsb_home_path -Recurse
}
$wsb_password = & $pwsh_path -NoProfile -NonInteractive -File "$host_scripts_path\get_wsb_pass.ps1"
Write-Log "[+] WDAGUtilityAccount:$wsb_password"

Write-Log "[~] Waiting a few seconds before starting Flare installer..."
Start-Sleep -Seconds 10

Write-Log "[~] Starting Flare installer..."
& wsb exec --id $wsb_id -c "$guest_scripts_path\start_flare_install.cmd $wsb_password" -r ExistingLogin -d $guest_flare_path

$ans = Read-Host "[!] Press any key when Flare is finished installing"

Write-Log "[~] Saving to base layer..."
$guest_public_doc_path = "$guest_wsb_base_layer_path\Users\Public\Documents"

Write-Log "[~] Running user script..."
& wsb exec --id $wsb_id -c "powershell.exe -ExecutionPolicy Unrestricted -File `"post_flare_user.ps1`"" -r ExistingLogin -d $guest_scripts_path
Write-Log "[~] Running system script..."
& wsb exec --id $wsb_id -c "powershell.exe -ExecutionPolicy Unrestricted -File `"post_flare_system.ps1`"" -r System -d $guest_scripts_path

Write-Log "[~] Stopping WSB..."
& wsb stop --id $wsb_id

Write-Log "[+] Flare installed to base layer! You are all set!"
Write-Log "[+] Start your new Flare WSB with: flare-wsb.bat"

exit 0