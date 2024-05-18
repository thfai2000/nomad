
locals {

a = file("C:/a.txt")
}

job "fo-component" {


  group "example" {

    task "service-task" {
      artifact {
        source      = "https://github.com/thfai2000/jenkins-pipelines/releases/download/1.0/artifact-1.0.zip"
        destination = "local/app"
      }

      template {
        source        = "local/app/config.xml.tpl"
        destination   = "local/app/config.xml"
      }


      driver = "raw_exec"
      config {
        command = "local/app/bin/Release/net8.0/win-x64/.net.exe"
      }

    }

  }

}