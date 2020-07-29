variable "avi_credentials" {}

variable "avi_tenant" {
  default = "admin"
}

#### Health Monitor variables

variable "hmHttpName" {
  default = "tfHm1"
}

variable "hmHttpType" {
  default = "HEALTH_MONITOR_HTTP"
}

variable "hmHttpRt" {
  default = "1"
}

variable "hmHttpFc" {
  default = "2"
}

variable "hmHttpSi" {
  default = "1"
}

variable "hmHttpSc" {
  default = "2"
}

variable "hmHttpR" {
  default = "HEAD / HTTP/1.0"
}

variable "hmHttpRc" {
  type = list
  default = ["HTTP_2XX", "HTTP_3XX", "HTTP_5XX"]
}

variable "hmHttpM" {
  type = object({
    http_request = string
    http_response_code = list(string)
  })
  default = {
    http_request = "HEAD / HTTP/1.0"
    http_response_code = ["HTTP_2XX", "HTTP_3XX", "HTTP_5XX"]
  }
}

#### Pool variables

variable "pool" {
  type = string
  default = "tfPool1"
}

variable "poolA" {
  type = string
  default = "LB_ALGORITHM_ROUND_ROBIN"
}

variable "poolHm" {
  type    = string
  default = "tfHm1"
}

variable "poolServer1" {
  type    = string
  default = "172.16.3.252"
}

variable "poolServer2" {
  type    = string
  default = "172.16.3.253"
}

variable "poolPort" {
  type    = string
  default = "80"
}


#### VS variables

variable "network_profile" {
  type    = string
  default = "System-TCP-Proxy"
}

variable "ssl_key_cert1" {
  type    = string
  default = "System-Default-Cert"
}
variable "ssl_profile1" {
  type    = string
  default = "System-Standard"
}
variable "application_profile1" {
  type    = string
  default = "System-Secure-HTTP"
}

variable "vsName" {
  default = "tfApp"
}

variable "vsP" {
  default = "443"
}

variable "vsSsl" {
  default = "true"
}
