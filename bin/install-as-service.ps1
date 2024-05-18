sc.exe delete "Nomad"
sc.exe create "Nomad" binPath="D:\hashicorp\nomad\bin\nomad.exe agent -config=D:\hashicorp\nomad\config\nomad.hcl" start= auto