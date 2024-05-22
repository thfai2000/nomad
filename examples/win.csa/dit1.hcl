namespace = "DIT1"
enable_machine_constraint = false

env = {
}

jobs = [{
    name = "job1"
    env = {
        ENV_A = "job1"
    }
    groups = [
        {
        name = "group1"
        env = {
            ENV_B = "group1"
        }
        tasks = [
            {
            name = "task1"
            task_type_name = "service1"
            env = {
                ENV_C = "task1"
                ENV_APPD_ENABLED = true
            }
            machines = [
            {
                name = "DIT1_ST01"
                env = {
                    ENV_D = "DIT1_ST01"
                }
            },
            {
                name = "DIT1_HV01"
                env = {
                    ENV_D = "DIT1_HV01"
                }
            }
            ]
            },
            {
            name = "task2"
            task_type_name = "service2"
            env = {
                ENV_C = "task2"
                ENV_APPD_ENABLED = false
            }
            machines = [
            {
                name = "DIT1_ST01"
                env = {
                    ENV_D = "DIT1_ST01"
                }
            },
            {
                name = "DIT1_HV01"
                env = {
                    ENV_D = "DIT1_HV01"
                }
            }
            ]
            }
        ]
        }
    ]
}]


