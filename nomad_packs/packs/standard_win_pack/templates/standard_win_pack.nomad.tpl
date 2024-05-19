[[- $task_types := (var "task_types" . )  -]]
[[- $enable_machine_constraint := (var "enable_machine_constraint" .) -]]
[[- $env := (var "env" .) -]]
[[- $env_text := (var "env_text" .) -]]
[[- range $idx, $job := (var "jobs" .) -]]
job [[ $job.name | quote ]] {

  [[- range $idx, $group := $job.groups ]]

  group [[ $group.name | quote ]] {
    
    [[- range $idx_x, $task := $group.tasks -]]
    [[- range $idx_y, $machine := $task.machines -]]

    [[- $pre_task_name := ( (list "init" $task.name $machine.name) | join "-" ) -]]
    [[- $task_name := ( (list "main" $task.name $machine.name) | join "-" )  -]]
    [[- $task_type := (index $task_types $task.task_type_name) ]]

    task "[[ $pre_task_name ]]" {
      lifecycle {
        hook = "prestart"
        sidecar = false
      }
      
      artifact {
        source      = [[ $task_type.url | quote ]]
        destination = "${NOMAD_ALLOC_DIR}\\artifacts\\[[ $task_name ]]"
      }

      driver = "raw_exec"
      config {
        command = "powershell.exe"
        args    = [
                  "-ExecutionPolicy",
                  "Bypass",
                  "-File",
                  "D:\\hashicorp\\nomad\\bin\\process-templates.ps1",
                  "${NOMAD_ALLOC_DIR}\\artifacts\\[[ $task_name ]]"
                  ]
      }
    }


    task "[[ $task_name ]]" {

      [[ if $enable_machine_constraint ]]
      constraint {
        attribute = "${meta.machine_name}"
        value = [[ $machine.name | quote ]]
      }
      [[ end ]]

      [[ range $idx_j, $tmpl := $task_type.templates ]]
      template {
        source = [[ (list "${NOMAD_ALLOC_DIR}\\artifacts" $task_name $tmpl) | join "\\" | quote ]]
        destination = [[ (list "${NOMAD_ALLOC_DIR}\\artifacts" $task_name $tmpl) | join "\\" | quote ]]
      }
      [[ end]]
      
      driver = [[ $task_type.driver | quote ]]

      config {
        command = [[ (list "${NOMAD_ALLOC_DIR}\\artifacts" $task_name $task_type.config.command) | join "\\" | quote ]]
        args = [[ $task_type.config.args ]]
      }
      
      template {
        env = true
        data = <<EOH
        # Common Environment variables
        [[- range $key, $value := $env ]]
        [[ $key]]=[[ $value | quote ]]
        [[ end -]]
        [[ $env_text ]]
        # Job Specific variables
        [[- range $key, $value := $job.env ]]
        [[ $key]]=[[ $value | quote ]]
        [[ end -]]
        [[ $job.env_text ]]
        # Group Specific variables
        [[- range $key, $value:= $group.env ]]
        [[ $key]]=[[ $value | quote ]]
        [[ end -]]
        [[ $group.env_text ]]
        # Task Specific variables
        [[- range $key, $value := $task.env ]]
        [[ $key]]=[[ $value | quote ]]
        [[ end -]]
        [[ $task.env_text ]]
        # Machine Specific variables
        [[- range $key, $value := $machine.env ]]
        [[ $key]]=[[ $value | quote ]]
        [[ end -]]
        [[ $machine.env_text ]]
        EOH

        destination = "secrets/file.env"

      }
    }
    [[- end ]]
    [[- end ]]
  }
  [[- end ]]
}

[[- end -]]