using assembly "C:\ProgramData\flare-wsb\MicrosoftWindows.WindowsSandbox\SandboxCommon.dll"
$client = [SandboxCommon.Grpc.GrpcClient]::new()
$wsb_id = & wsb list
$config = $client.GetRdpClientConfigAsync($wsb_id).Result
return $config.Password