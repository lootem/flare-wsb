mkdir "C:\base_layer\Users\Public\Documents\flare-vm"
mkdir "C:\base_layer\Users\Public\Documents\flare-vm\_VM"
mkdir "C:\base_layer\Users\Public\Documents\flare-vm\Tools"
mkdir "C:\base_layer\Users\Public\Documents\flare-vm\Tools_Raw"
copy "C:\Users\WDAGUtilityAccount\Documents\flare-wsb\LayoutModification.xml" "C:\Users\WDAGUtilityAccount\Documents\LayoutModification.xml"
copy "C:\Users\WDAGUtilityAccount\Documents\flare-wsb\config.xml" "C:\Users\WDAGUtilityAccount\Documents\config.xml"
cmd.exe /c start "" powershell.exe -NoExit -ExecutionPolicy Unrestricted -File "C:\Users\WDAGUtilityAccount\Documents\flare-vm\install.ps1" -customLayout "C:\Users\WDAGUtilityAccount\Documents\LayoutModification.xml" -customConfig "C:\Users\WDAGUtilityAccount\Documents\config.xml" -password %1 -noWait -noReboots