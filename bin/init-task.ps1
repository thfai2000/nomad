$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

$COMPONENT_BINARY_DIR =$args[0]
$SCRIPT_BEFORE_INSTALL= $args[1]
$SCRIPT_INSTALL= $args[2]

[System.Environment]::SetEnvironmentVariable("COMPONENT_BINARY_DIR", $COMPONENT_BINARY_DIR, [System.EnvironmentVariableTarget]::Process)


if (Test-Path -Path "$COMPONENT_BINARY_DIR\$SCRIPT_BEFORE_INSTALL") {
    & "$COMPONENT_BINARY_DIR\$SCRIPT_BEFORE_INSTALL"
    Write-Host "process-before-install completed."
} else {
    Write-Host "Skipping process-before-install script as it does not exist."
}

D:\hashicorp\nomad\bin\process-templates.ps1
Write-Host "process-templates completed."

if (Test-Path -Path "$COMPONENT_BINARY_DIR\$SCRIPT_INSTALL") {
    & "$COMPONENT_BINARY_DIR\$SCRIPT_INSTALL"
    Write-Host "process-install completed."
} else {
    Write-Host "Skipping process-install script as it does not exist."
}