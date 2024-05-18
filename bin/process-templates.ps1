$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


$NomadVarConfigValuePath=$args[0]
$TemplateFolderPath=$args[1]
$TemplateListFilePath=$args[2]


Write-Host $NomadVarConfigValuePath
Write-Host $TemplateFolderPath
Write-Host $TemplateListFilePath


$tokenPattern = "@@@(.*?)@@@"
$replacementPattern = '{{ .$1 }}'

$encodedFiles = Get-ChildItem -Path $TemplateFolderPath -File -Recurse | Where-Object {
    !$_.PSIsContainer -and
    {
        try {
            [System.Text.Encoding]::UTF8.GetString((Get-Content -Path $_.FullName -Raw -Byte)) -or
            [System.Text.Encoding]::ASCII.GetString((Get-Content -Path $_.FullName -Raw -Byte))
            $true
        }
        catch {
            $false
        }
    }
}

$TextFiles = $encodedFiles | Where-Object {
    $fileContent = Get-Content -Path $_.FullName
    $fileContent -match $tokenPattern
}

$TextFiles | ForEach-Object {
    
    $fileContent = Get-Content -Path $_.FullName

    if ($fileContent -match $tokenPattern) {
        Write-Host $_.FullName
        $updatedContent = $fileContent -replace $tokenPattern, $replacementPattern

        $updatedContent = "{{- with nomadVar ""$NomadVarConfigValuePath"" -}}`n" +  $updatedContent + "`n{{- end -}}"
        $updatedContent | Out-File -Encoding utf8 -FilePath $_.FullName

        $FullPath = $_.FullName
        $RelativePath = $_.FullName.Substring($TemplateFolderPath.Length + 1)

        # Write-Host "Full Path: $FullPath"
        # Write-Host "Relative Path: $RelativePath"
        Write-Host "======= App Config File `"$RelativePath`"====="
        Write-Host $updatedContent
        Write-Host "============================="
    }
}

$RelativePathsString = ($TextFiles | ForEach-Object {
    $_.FullName.Substring($TemplateFolderPath.Length + 1)
}) -join ","

$RelativePathsString | Out-File -FilePath $TemplateListFilePath

Write-Host "Completed all."
