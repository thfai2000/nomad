task_types ={
    service1 = {
      url = "https://github.com/thfai2000/jenkins-pipelines/releases/download/1.1/artifact-1.1.zip"
      
      templates = [
        "config.xml"
      ]

      script_before_install = <<EOH
        Write-Host "XXXXXXXXXXXXXXXXXXX"
        Write-Host $COMPONENT_BINARY_DIR
        Write-Host "AAAAAAAAAAAAAAAAAA"
      EOH

      env_template = <<EOH
        {{ if and (env "ENV_APPD_ENABLED") true }}
        ENV_F=yes
        {{ else }}
        ENV_F=no
        {{ end }}
      EOH


      driver = "raw_exec"
      config = {
        command = "bin/Release/net8.0/.net.exe"
        args = ["-Command", "Write-Host 'AAAAA'; Write-Host $${ENV_F}; Start-Sleep -Seconds 30"]
      }
    }

    service2 = {
      url = "https://github.com/thfai2000/jenkins-pipelines/releases/download/1.1/artifact-1.1.zip"
      templates = [
        "config.xml" 
      ]
      env_template = ""
      driver = "raw_exec"
      config = {
        command = "bin/Release/net8.0/.net.exe"
        args = []
      }
    }
}