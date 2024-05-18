$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop



####################### Submit Nomad Job ########################


# $NOMAD_HOME/nomad.exe var put -force $NomadVarConfigValuePath content="$updatedContent"
D:\hashicorp\nomad\bin\nomad-pack.exe run D:\hashicorp\nomad\nomad_packs\packs\standard_win_pack -f ..\examples\win.csa\common.hcl -f ..\examples\win.csa\dit2.hcl 

Write-Host "Completed all."
