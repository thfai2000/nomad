namespace = "dit1"
enable_machine_constraint = true

env = {
}
env_template = ""

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
        }
        tasks = [
            {
            name = "task1"
            task_type_name = "service1"
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