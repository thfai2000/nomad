$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

$NomadVarConfigTemplatePath=$args[0]
$NomadVarConfigValuePath=$args[1]
$ConfigFilePath=$args[2]
$NewConfigFilePath=$args[3]

Write-Host $args[0]
Write-Host $args[1]
Write-Host $args[2]
Write-Host $args[3]

$fileContent = Get-Content -Path $ConfigFilePath


$Directory = Split-Path -Path $NewConfigFilePath -Parent
if (-not (Test-Path -Path $Directory)) {
    New-Item -ItemType Directory -Path $Directory | Out-Null
}

$tokenPattern = "@@@(.*?)@@@"
$replacementPattern = '{{ .$1 }}'

$updatedContent = $fileContent -replace $tokenPattern, $replacementPattern

$updatedContent = "{{ with nomadVar ""$NomadVarConfigValuePath"" }}`n" +  $updatedContent + "`n{{ end }}"
$updatedContent | Out-File -Encoding utf8 -FilePath $NewConfigFilePath


Write-Host "======= App Config File ====="
Write-Host $updatedContent
Write-Host "============================="

D:/hashicorp/nomad/bin/nomad.exe var put -force $NomadVarConfigTemplatePath content="$updatedContent"