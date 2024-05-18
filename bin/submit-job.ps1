$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


$NOMAD_HOME = "D:/hashicorp/nomad"

$ServiceName=$args[0]
$ServiceVersion=$args[1]
$ServiceArtifactURL=$args[2]


#$TemplateListFilePath=$args[2]
# Write-Host $TemplateFolderPath
# #Write-Host $TemplateListFilePath


$NomadVarConfigValuePath="app-config/$ServiceName/$ServiceVersion/values"
$TemplateFolderPath="D:/temp"


####################### Download and Unzip ########################


# Set the URL of the ZIP file
$ZipFileUrl = $ServiceArtifactURL

# Set the destination folder for the extracted files
$DestinationFolder = $TemplateFolderPath

# Create the destination folder if it doesn't already exist
if (-not (Test-Path -Path $DestinationFolder)) {
    New-Item -ItemType Directory -Path $DestinationFolder | Out-Null
}

# Download the ZIP file to a temporary location
$TempZipFile = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "file.zip"
Invoke-WebRequest -Uri $ZipFileUrl -OutFile $TempZipFile

# Extract the ZIP file to the destination folder
Expand-Archive -Path $TempZipFile -DestinationPath $DestinationFolder -Force

# Clean up the temporary ZIP file
Remove-Item -Path $TempZipFile



####################### Check Template files ########################

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



####################### Submit Nomad Job ########################


$NOMAD_HOME/nomad.exe var put -force $NomadVarConfigValuePath content="$updatedContent"

$NOMAD_HOME/nomad-pack.exe run $NOMAD_HOME/my_nomad_packs/packs/hello_pack --registry=my_packs `
    var RelativePathsString=RelativePathsString `
    var ServiceName=ServiceName

Write-Host "Completed all."
