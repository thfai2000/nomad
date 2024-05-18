task_types ={
    service1 = {
      url = "https://github.com/thfai2000/jenkins-pipelines/releases/download/1.0/artifact-1.0.zip"
      templates = [
        "config.xml.tpl"
      ]
      driver = "raw_exec"
      config = {
        command = "bin/Release/net8.0/win-x64/.net.exe"
        args = []
      }
    }

    service2 = {
      url = "https://github.com/thfai2000/jenkins-pipelines/releases/download/1.0/artifact-1.0.zip"
      templates = [
        "config.xml.tpl"
      ]
      driver = "raw_exec"
      config = {
        command = "bin/Release/net8.0/win-x64/.net.exe"
        args = []
      }
    }
}