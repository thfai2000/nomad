locals {
  service_name = "service_1"
  artifact_path = "https://github.com/thfai2000/jenkins-pipelines/releases/download/1.1/artifact-1.1.zip"

  nomadvar_path = "app-config/${local.service_name}/values"
  temp_folder_of_template = "${NOMAD_ALLOC_DIR}\\templates\\${local.service_name}\\files"
  temp_list_of_template = "${NOMAD_ALLOC_DIR}\\templates\\${local.service_name}\\list_of_template_files.txt"

}

job "fo-component" {

  group "example" {

    task "pre-task" {
      lifecycle {
        hook = "prestart"
        sidecar = false
      }
      
      artifact {
        source      = local.artifact_path
        destination = "${NOMAD_ALLOC_DIR}\\artifacts\\${local.service_name}"
      }

      driver = "raw_exec"
      config {
        command = "powershell.exe"
        args    = [
                  "-ExecutionPolicy",
                  "Bypass",
                  "-File",
                  "${NOMAD_HOME}\\bin\\process-templates.ps1",
                  local.temp_folder_of_template,
                  ]
      }
    }


    task "service-task" {
      artifact {
        source      = "https://github.com/thfai2000/jenkins-pipelines/releases/download/1.1/artifact-1.1.zip"
        destination = "local/app"
      }

      dynamic template {
        for_each = split(",", "{{ env }}")
        
        iterator = relative_path

        content {
          error_on_missing_key = true
          source = "${local.temp_folder_of_template}\\${relative_path.value}"
          destination = "local/app/${relative_path.value}"
        }

      }

      driver = "raw_exec"
      config {
        command = "app/bin/Release/net8.0/.net.exe"
        args    = []
      }
    }
  }
}