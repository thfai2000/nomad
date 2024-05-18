[[ $task_types := (var "task_types" . )  ]]
[[ $env := (var "env" .) ]]
[[ range $idx, $job := (var "jobs" .) ]]


job [[ $job.name | quote ]] {

  [[ range $idx, $group := $job.groups ]]

  group [[ $group.name | quote ]] {
    
    [[ range $idx_x, $task := $group.tasks ]]
    [[ range $idx_y, $machine := $task.machines ]]

    task "[[ $task.name  ]]-[[ $machine.name ]]" {

      constraint {
        attribute = "${meta.machine_name}"
        value = [[ $machine.name | quote ]]
      }

      [[ $task_type := (index $task_types $task.task_type_name) ]]
      driver = [[ $task_type.driver | quote ]]

      config {
        command = [[ $task_type.config.command | quote ]]
        args = [[ $task_type.config.args ]]
      }
      
      artifact {
        source      =  [[ $task_type.url | quote ]]
        destination = "local/app"
      }

      env {
        
        [[ range $key, $value := $env ]]
        [[ $key]] = [[ $value | quote ]]
        [[ end ]]

        [[ range $key, $value := $job.env ]]
        [[ $key]] = [[ $value | quote ]]
        [[ end ]]


        [[ range $key, $value:= $group.env ]]
        [[ $key]] = [[ $value | quote ]]
        [[ end ]]


        [[ range $key, $value := $task.env ]]
        [[ $key]] = [[ $value | quote ]]
        [[ end ]]

        [[ range $key, $value := $machine.env ]]
        [[ $key]] = [[ $value | quote ]]
        [[ end ]]

      }

      
      
    }
    [[ end ]]
    [[ end ]]
  }
  [[ end ]]
}

[[ end ]]