namespace = "dit2"
enable_machine_constraint = true

env = {
}
env_text = ""

jobs = [{
    name = "job1"
    env = {
        aaaa = 1
    }
    groups = [
        {
        name = "group1"
        env = {
            bbbb = 1
            bbb2 = 2
        }
        tasks = [
            {
            name = "task1"
            task_type_name = "service1"
            env = {
                cccc = 333
                fff = "{{ add 4 5}}"
                wwww = "hello world"
            }
            env_text = <<-EOH
            combined_env="$${aaaa}hello"
            EOH
            machines = [
            {
                name = "DIT2_ST01"
                env = {
                    ddd = "st"
                }
            },
            {
                name = "DIT2_HV01"
                env = {
                    ddd = "hv"
                }
            }
            ]
            },
            {
            name = "task2"
            task_type_name = "service2"
            env = {
                cccc = 333
            }
            machines = [
            {
                name = "DIT2_ST01"
                env = {
                    ddd = "st"
                }
            },
            {
                name = "DIT2_HV01"
                env = {
                    ddd = "hv"
                }
            }
            ]
            }
        ]
        }
    ]
}]


