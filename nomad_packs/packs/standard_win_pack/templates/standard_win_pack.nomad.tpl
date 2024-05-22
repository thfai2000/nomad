[[- $task_types := (var "task_types" . )  -]]
[[- $enable_machine_constraint := (var "enable_machine_constraint" .) -]]
[[- $env := (var "env" .) -]]
[[- range $idx, $job := (var "jobs" .) -]]
job [[ $job.name | quote ]] {

  meta {
    [[- range $key, $value := $job.meta ]]
    [[ $key]]=[[ $value | quote ]]
    [[- end ]]
  }

  [[- range $idx, $group := $job.groups ]]

  group [[ $group.name | quote ]] {

    meta {
      [[- range $key, $value := $group.meta ]]
      [[ $key]]=[[ $value | quote ]]
      [[- end ]]
    }
        
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
                  "D:\\hashicorp\\nomad\\bin\\init-task.ps1",
                  "${NOMAD_ALLOC_DIR}\\artifacts\\[[ $task_name ]]",
                  [[ if $task_type.script_before_install ]][[ $task_type.script_before_install | quote ]][[ else ]]""[[ end ]],
                  [[ if $task_type.script_install ]][[ $task_type.script_install | quote ]][[ else ]]""[[ end ]]
                  ]
      }
    }

    task "[[ $task_name ]]" {

      meta {
        [[- range $key, $value := $task.meta ]]
        [[ $key]]=[[ $value | quote ]]
        [[- end ]]
      }

      [[ if $enable_machine_constraint ]]
      constraint {
        attribute = "${meta.machine_name}"
        value = [[ $machine.name | quote ]]
      }
      [[ end ]]

      env {
        # Common Environment variables
        [[- range $key, $value := $env ]]
        [[ $key]]=[[ $value | quote ]]
        [[ end ]]
        # Job Specific variables
        [[- range $key, $value := $job.env ]]
        [[ $key]]=[[ $value | quote ]]
        [[ end ]]
        # Group Specific variables
        [[- range $key, $value:= $group.env ]]
        [[ $key]]=[[ $value | quote ]]
        [[ end ]]
        # Task Specific variables
        [[- range $key, $value := $task.env ]]
        [[ $key]]=[[ $value | quote ]]
        [[ end ]]
        # Machine Specific variables
        [[- range $key, $value := $machine.env ]]
        [[ $key]]=[[ $value | quote ]]
        [[ end ]]
      }

      [[ range $idx_j, $tmpl := $task_type.templates ]]
      template {
        error_on_missing_key = true
        source = [[ (list "${NOMAD_ALLOC_DIR}\\artifacts" $task_name $tmpl) | join "\\" | quote ]]
        destination = [[ (list "${NOMAD_ALLOC_DIR}\\artifacts" $task_name $tmpl) | join "\\" | quote ]]
      }
      [[ end]]

      [[ if $task_type.env_template ]]
      template {
        env = true
        data = [[ $task_type.env_template | quote ]]
        destination = "secrets/1.env"
      }
      [[ end ]]
      
      driver = [[ $task_type.driver | quote ]]

      config {
        command = [[ (list "${NOMAD_ALLOC_DIR}\\artifacts" $task_name $task_type.config.command) | join "\\" | quote ]]
        args = [[ $task_type.config.args | toJson ]]
      }
      
    }
    [[- end ]]
    [[- end ]]
  }
  [[- end ]]
}

[[- end -]]