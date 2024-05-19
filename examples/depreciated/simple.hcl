
job "fo-component" {


  group "example" {

    task "service-task" {
      artifact {
        source      = "https://github.com/thfai2000/jenkins-pipelines/releases/download/1.1/artifact-1.1.zip"
        destination = "local/app"
      }

      template {
        env = true
        data =<<EOH
        ENV_C="c"
        ENV_D="d"
        EOH
        destination = "secrets/file.env"
      }

      template {
        source        = "D:/a.txt"
        destination   = "local/app/config.xml"
      }

      env {
        ENV_A = "a"
        ENV_B = "b"
      }


      driver = "raw_exec"
      config {
        command = "local/app/bin/Release/net8.0/.net.exe"
      }

    }

  }

}