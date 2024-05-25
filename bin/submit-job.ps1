$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop



####################### Submit Nomad Job ########################


# $NOMAD_HOME/nomad.exe var put -force $NomadVarConfigValuePath content="$updatedContent"
& $ENV:NOMAD_HOME\\bin\\nomad-pack.exe run $ENV:NOMAD_HOME\\nomad_packs\\packs\\standard_win_pack `
-f $ENV:NOMAD_HOME\\examples\\win.csa\\common.hcl `
-f $ENV:NOMAD_HOME\\examples\\win.csa\\dit2.hcl 

Write-Host "Completed all."


