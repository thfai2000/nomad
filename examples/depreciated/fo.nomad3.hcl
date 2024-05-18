locals {
  service_name = "service_1"
  artifact_path = "https://github.com/thfai2000/jenkins-pipelines/releases/download/1.0/artifact-1.0.zip"
  list_of_template_files = var.list_of_template_files
}

job "my-component" {

  group "my-app-service-1" {

    task "service-task-1" {

      artifact {
        source      =  local.artifact_path
        destination = "local/app"
      }

      dynamic template {
        for_each = split(",", local.list_of_template_files)
        
        iterator = relative_path

        content {
          error_on_missing_key = true
          source = "local/app/${relative_path.value}"
          destination = "local/app/${relative_path.value}"
        }

      }

      driver = "raw_exec"
      config {
        command = "app/bin/Release/net8.0/win-x64/.net.exe"
        args    = []
      }
      
    }


    task "service-task-2" {
      artifact {
        source      =  local.artifact_path
        destination = "local/app"
      }

      dynamic template {
        for_each = split(",", local.list_of_template_files)
        
        iterator = relative_path

        content {
          error_on_missing_key = true
          source = "local/app/${relative_path.value}"
          destination = "local/app/${relative_path.value}"
        }

      }

      driver = "raw_exec"
      config {
        command = "app/bin/Release/net8.0/win-x64/.net.exe"
        args    = []
      }
    }

  }

  group "my-app-service-1" {




  }

}