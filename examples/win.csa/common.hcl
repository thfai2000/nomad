task_types ={
    service1 = {
      url = "https://github.com/thfai2000/jenkins-pipelines/releases/download/1.1/artifact-1.1.zip"
      templates = [
        "config.xml"
      ]
      driver = "raw_exec"
      config = {
        command = "bin/Release/net8.0/.net.exe"
        args = []
      }
    }

    service2 = {
      url = "https://github.com/thfai2000/jenkins-pipelines/releases/download/1.1/artifact-1.1.zip"
      templates = [
        "config.xml"
      ]
      driver = "raw_exec"
      config = {
        command = "bin/Release/net8.0/.net.exe"
        args = []
      }
    }
}