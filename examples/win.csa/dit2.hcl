namespace = "dit2"
enable_machine_constraint = false

env = {
}
env_text = ""

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
            }
            env_text = <<-EOH
            ENV_D="$${ENV_C}hello$${ENV_B}"
            EOH
            machines = [
            {
                name = "DIT2_ST01"
                env = {
                    ENV_E = "$${ENV_A}_$${ENV_B}_$${ENV_C}_$${ENV_D}_DIT2_ST01"
                }
            },
            {
                name = "DIT2_HV01"
                env = {
                    ENV_F = "$${ENV_A}_$${ENV_B}_$${ENV_C}_$${ENV_D}_DIT2_HV01"
                }
            }
            ]
            },
            {
            name = "task2"
            task_type_name = "service2"
            env = {
                ENV_C = "task2"
            }
            machines = [
            {
                name = "DIT2_ST01"
                env = {
                    ENV_E = "$${ENV_A}_$${ENV_B}_$${ENV_C}_$${ENV_D}_DIT2_ST01"
                }
            },
            {
                name = "DIT2_HV01"
                env = {
                    ENV_F = "$${ENV_A}_$${ENV_B}_$${ENV_C}_$${ENV_D}_DIT2_HV01"
                }
            }
            ]
            }
        ]
        }
    ]
}]


