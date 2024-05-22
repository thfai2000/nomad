
job "fo-component" {

  meta {
    A = "a"
  }

  group "example" {

    meta {
      B = "b"
    }

    task "service-task" {

      meta {
        C = "c ${env["NOMAD_META_A"]}"
      }

      artifact {
        source      = "https://github.com/thfai2000/jenkins-pipelines/releases/download/1.1/artifact-1.1.zip"
        destination = "local/app"
      }


      template {
        env = true
        data =<<EOH
        ENV_B = "b"
        ENV_E={{ env "NOMAD_META_A" }}-{{ env "NOMAD_META_B" }}-{{ env "NOMAD_META_C" }}
        EOH
        destination = "secrets/file2.env"
      }

      template {
        data        = <<EOH
<xml>
    <a>{{ env "ENV_A" }}</a>
    <a>{{ env "ENV_B" }}</a>
    <a>{{ env "ENV_C" }}</a>
    <a>{{ env "ENV_D" }}</a>
    <a>{{ env "ENV_E" }}</a>
    <a>{{ env "ENV_F" }}</a>
</xml>
        EOH
        destination   = "local/app/config.new.xml"
      }


      driver = "raw_exec"
      config {
        // command = "local/app/bin/Release/net8.0/.net.exe"
        command = "powershell.exe"
        args = ["-Command", "Write-Host 'AAAAA'; Write-Host ${ENV_E}; Start-Sleep -Seconds 30"]
      }
    }

  }

}