scoop bucket add extras

$tools = Get-Content "$PSScriptRoot\scoop-tools.txt"
foreach ($tool in $tools) {
    if (-not (scoop list | Select-String "^$tool\s")) {
        scoop install $tool
    } else {
        Write-Host "$tool already installed, skipping."
    }
}

$shims = "$env:USERPROFILE\scoop\shims"
if (-not ($env:PATH -split ';' | Where-Object { $_ -eq $shims })) {
    [Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";" + $shims, "User")
    Write-Host "Added Scoop shims to user PATH. You may need to log out and back in or restart CMD for changes to take effect."
}