job "fo-component" {

  group "example" {

    task "pre-task" {
      lifecycle {
        hook = "prestart"
        sidecar = false
      }
      
      artifact {
        source      = "https://github.com/thfai2000/jenkins-pipelines/releases/download/1.0/artifact-1.0.zip"
        destination = "local/app"
      }

      driver = "raw_exec"
      config {
        command = "powershell.exe"
        args    = [
                  "-ExecutionPolicy",
                  "Bypass",
                  "-File",
                  "D:\\hashicorp\\nomad\\bin\\process-app-config.ps1",
                  "app-config/service-1/templates",
                  "app-config/service-1/values",
                  "${NOMAD_TASK_DIR}\\app\\config.xml.tpl",
                  "${NOMAD_ALLOC_DIR}\\app-config\\config.xml.tpl"
                  ]
      }
    }


    task "service-task" {
      artifact {
        source      = "https://github.com/thfai2000/jenkins-pipelines/releases/download/1.0/artifact-1.0.zip"
        destination = "local/app"
      }

      template {
        error_on_missing_key = true
        source = "${NOMAD_ALLOC_DIR}\\app-config\\config.xml.tpl"
        destination = "local/app/config.xml"

        // <<EOF
        // {{- with nomadVar "app-config/service-1/templates" }}{{ .content }}{{ end -}}
        // EOF
      }

      driver = "raw_exec"
      config {
        command = "app/bin/Release/net8.0/win-x64/.net.exe"
        args    = []
      }
    }
  }
}