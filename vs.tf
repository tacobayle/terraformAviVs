output "log1" {
  value = var.avi_credentials
}

output "log2" {
  value = var.avi_tenant
}

data "avi_cloud" "default_cloud" {
  name = "Default-Cloud"
}

data "avi_sslkeyandcertificate" "ssl_cert1" {
  name = var.ssl_key_cert1
}

data "avi_sslprofile" "ssl_profile1" {
  name = var.ssl_profile1
}

data "avi_applicationprofile" "application_profile1" {
  name = var.application_profile1
}

data "avi_networkprofile" "network_profile1" {
  name = var.network_profile
}


resource "avi_healthmonitor" "hm" {
  name = var.hmHttpName
  tenant_ref = "/api/tenant/?name=${var.avi_tenant}"
  type = var.hmHttpType
  receive_timeout = var.hmHttpRt
  failed_checks = var.hmHttpFc
  send_interval = var.hmHttpSi
  successful_checks = var.hmHttpSc
  http_monitor {
    http_request = var.hmHttpR
    http_response_code = var.hmHttpRc
  }
}

resource "avi_pool" "lbpool" {
  depends_on = [avi_healthmonitor.hm]
  name = var.pool
  tenant_ref = "/api/tenant/?name=${var.avi_tenant}"
  lb_algorithm = var.poolA
  health_monitor_refs = ["/api/healthmonitor?name=${var.poolHm}"]
  servers {
    ip {
      type = "V4"
      addr = var.poolServer1
    }
    port = var.poolPort
  }
  servers {
    ip {
      type = "V4"
      addr = var.poolServer2
    }
    port = var.poolPort
  }
}

resource "avi_virtualservice" "https_vs" {
  name = var.vsName
  pool_ref = avi_pool.lbpool.id
  tenant_ref = "/api/tenant/?name=${var.avi_tenant}"
  vip {
    auto_allocate_ip= true
    ipam_network_subnet {
      network_ref = "/api/network/?name=${var.vsNetwork}"
      subnet {
        mask = var.vsMask
        ip_addr {
          type = "V4"
          addr = var.vsCidr
        }
      }
    }
  }
  dns_info {
    fqdn = var.VsFqdn
  }
  ssl_key_and_certificate_refs = [data.avi_sslkeyandcertificate.ssl_cert1.id]
  ssl_profile_ref = data.avi_sslprofile.ssl_profile1.id
  application_profile_ref = data.avi_applicationprofile.application_profile1.id
  network_profile_ref = data.avi_networkprofile.network_profile1.id
  services {
    port           = var.vsP
    enable_ssl     = true
  }
}
