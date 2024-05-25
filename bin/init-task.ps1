$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

Write-Host "NOMAD_HOME=$ENV:NOMAD_HOME"

$COMPONENT_BINARY_DIR =$args[0]
$SCRIPT_BEFORE_INSTALL= $args[1]
$SCRIPT_INSTALL= $args[2]

[System.Environment]::SetEnvironmentVariable("COMPONENT_BINARY_DIR", $COMPONENT_BINARY_DIR, [System.EnvironmentVariableTarget]::Process)


if (-not [string]::IsNullOrEmpty($SCRIPT_BEFORE_INSTALL)) {
$beforeInstallScriptPath = Join-Path -Path $COMPONENT_BINARY_DIR -ChildPath "process-before-install.ps1"
$SCRIPT_BEFORE_INSTALL | Out-File -FilePath $beforeInstallScriptPath -Encoding utf8
& $beforeInstallScriptPath
Write-Host "process-before-install completed."
} else {
Write-Host "Skipping process-before-install script as it does not exist."
}

& $ENV:NOMAD_HOME\bin\process-templates.ps1
Write-Host "process-templates completed."

if (-not [string]::IsNullOrEmpty($SCRIPT_INSTALL)) {
$installScriptPath = Join-Path -Path $COMPONENT_BINARY_DIR -ChildPath "process-install.ps1"
$SCRIPT_INSTALL | Out-File -FilePath $installScriptPath -Encoding utf8
& $installScriptPath
Write-Host "process-install completed."
} else {
Write-Host "Skipping process-install script as it does not exist."
}