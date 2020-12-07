variable "avi_credentials" {}

variable "avi_tenant" {
  default = "admin"
}

variable "avi_cloud" {
  default = "cloudVmw"
}
# Default-Cloud

#### IPAM/DNS variables

variable "dns" {
  default = "dns-avi"
}

variable "ipam" {
  default = "ipam-avi"
}

#### Health Monitor variables

variable "healthmonitor" {
  type = map
  default = {
    name = "tfHm1"
    type = "HEALTH_MONITOR_HTTP"
    receive_timeout = "1"
    failed_checks = "2"
    send_interval= "1"
    successful_checks = "2"
    http_request= "HEAD / HTTP/1.0"
  }
}

variable "http_response_code" {
  type = list
  default = ["HTTP_2XX", "HTTP_3XX", "HTTP_5XX"]
}

#### Pool variables

variable "pool" {
  type = map
  default = {
    name = "tfPool1"
    lb_algorithm = "LB_ALGORITHM_ROUND_ROBIN"
    poolHm = "tfHm1"
    port = "80"
  }
}

variable "poolServers" {
  default = [
    {
      ip = "100.64.130.203"
      type = "V4"
      port = "80"
    },
    {
      ip = "100.64.130.204"
      type = "V4"
      port = "80"
    }
  ]
}


# "172.16.3.252"
# "172.16.3.253"

#### VS variables

variable "vs" {
  type = map
  default = {
    name = "tfApp"
    port = "443"
    ssl = "true"
    applicationProfile = "System-Secure-HTTP"
    networkProfile = "System-TCP-Proxy"
    sslProfile = "System-Standard"
    sslCert = "System-Default-Cert"
    se_group_ref = "Default-Group"
  }
}
