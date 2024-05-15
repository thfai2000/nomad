# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Full configuration options can be found at https://www.nomadproject.io/docs/configuration
datacenter = "dc0"
name = "nomad-on-win11"

data_dir  = "D:\\hashicorp\\nomad\\data"
log_file = "D:\\hashicorp\\nomad\\log\\nomad.log"
log_level = "DEBUG"
bind_addr = "0.0.0.0"

server {
  # license_path is required for Nomad Enterprise as of Nomad v1.1.1+
  #license_path = "/etc/nomad.d/license.hclic"
  enabled          = true
  bootstrap_expect = 1

  # This is the IP address of the first server provisioned
  server_join {
    # nslookup "$(hostname).local"
    retry_join = ["127.0.0.1:4648"]
    retry_max = 3
    retry_interval = "15s"
  }
}

client {
  enabled = true
  template {
    disable_file_sandbox = true
  }
  servers = ["127.0.0.1"]
  # use command to find the interface name "netsh int ipv4 show interfaces"
  network_interface = "Loopback Pseudo-Interface 1"
}

plugin "raw_exec" {
    config {
      enabled = true
    }
}