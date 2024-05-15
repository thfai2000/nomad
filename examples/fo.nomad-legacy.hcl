job "fo-component" {


  group "example" {

    task "service-task" {
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
                  "D:\\hashicorp\\nomad\\bin\\run-wrapper.ps1",
                  "${NOMAD_TASK_DIR}\\app\\bin\\Release\\net8.0\\win-x64\\.net.exe",
                  "${NOMAD_TASK_DIR}\\app\\config.xml"
                  ]
      }
    }

    




  }
}