// One of the input variable is a nested object with multiple levels like below. 
// The tasks are multiplied by the number of "machines"
// "env" is a list of "OS environment" with name and value attributes.
// Each level of elements has "env" but I want the environment are stacked and included into the task level.

// jobs:
// - name:
// - env:
// - groups:
//   - env:
//   - tasks:
//     - name:
//     - env:
//     - machines:
//       - env:

variable "namespace" {
  type = map(string)
}

variable "enable_machine_constraint" {
  type = bool
  default = true
}

variable "env" {
  type = map(string)
  default = {}
}

variable "task_types" { 
  type = map(object({
    url = string
    driver = string
    templates = list(string)
    config = object({
      command = string
      args = list(string)
    })
  }))

  default = {
    service1 = {
      url = "https://github.com/thfai2000/jenkins-pipelines/releases/download/1.1/artifact-1.1.zip"
      templates = [
        "config.xml.tpl"
      ]
      driver = "raw_exec"
      config = {
        command = "bin/Release/net8.0/.net.exe"
        args = []
      }
    }
  }
}

variable "jobs" {
  type = list(object({
    name = string
    meta = map(string)
    env = map(string)

    groups = list(object({
      name = string
      meta = map(string)
      env = map(string)

      tasks = list(object({
        name     = string
        meta = map(string)
        task_type_name = string
        env = map(string)

        machines = list(object({
          name = string
          env = map(string)

        }))

      }))
    }))
  }))

  default     = [{
    name = "job1"
    meta = {
      // a = 1
    }
    env = {
      // aaaa = 1
    }
    groups = [
      {
        name = "group1"
        meta = {
          // a = 1
        }
        env = {
          // bbbb = 1
        }
        tasks = [
          {
            name = "task1"
            task_type_name = "service1"
            meta = {

            }
            env = {
              // cccc = 333
            }
            machines = [
              {
                name = "DIT2_ST01"
                env = {
                  // ddd = "st"
                }
              },
              {
                name = "DIT2_HV01"
                env = {
                  // ddd = "hv"
                }
              }
            ]
          }
        ]
      }

    ]
  }]
}