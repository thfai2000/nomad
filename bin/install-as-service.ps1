
sc.exe delete "Nomad"
[Environment]::SetEnvironmentVariable('NOMAD_HOME','D:\hashicorp\nomad','Machine')
sc.exe create "Nomad" binPath="$ENV:NOMAD_HOME\bin\nomad.exe agent -config=$ENV:NOMAD_HOME\config\nomad.hcl" start= auto