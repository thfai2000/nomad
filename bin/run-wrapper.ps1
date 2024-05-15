$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

$CommandLineString=$args[0]
$ConfigFilePath=$args[1]

Write-Host $args[0]
Write-Host $args[1]

$filePath = $ConfigFilePath
$fileContent = Get-Content -Path $filePath

$tokenPattern = "@@@(.*?)@@@"
$replacementPattern = '{{ .$1 }}'

$updatedContent = $fileContent -replace $tokenPattern, $replacementPattern

$updatedContent | Set-Content -Path $filePath

Invoke-Expression $CommandLineString