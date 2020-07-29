output "aviCreds" {
  value = var.avi_credentials
}

output "aviTenant" {
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

data "avi_ipamdnsproviderprofile" "dns" {
    name = "dns-avi"
}

output "domaineName" {
  value = tolist(data.avi_ipamdnsproviderprofile.dns.internal_profile)[0].dns_service_domain[0].domain_name
}

data "avi_ipamdnsproviderprofile" "ipam" {
    name = "ipam-avi"
}

output "networkUuid" {
  value = split("/network/", tolist(data.avi_ipamdnsproviderprofile.ipam.internal_profile)[0].usable_network_refs[0])[1]
}

data "avi_network" "network" {
    uuid = split("/network/", tolist(data.avi_ipamdnsproviderprofile.ipam.internal_profile)[0].usable_network_refs[0])[1]
}

output "networkaddr" {
  value = tolist(tolist(tolist(data.avi_network.network.configured_subnets)[0].prefix)[0].ip_addr)[0].addr
}

output "networktype" {
  value = tolist(tolist(tolist(data.avi_network.network.configured_subnets)[0].prefix)[0].ip_addr)[0].type
}

output "networkmask" {
  value = tolist(tolist(data.avi_network.network.configured_subnets)[0].prefix)[0].mask
}

output "networkName" {
  value = data.avi_network.network.name
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
    auto_allocate_ip = true
    ipam_network_subnet {
      network_ref = "/api/network/?name=${data.avi_network.network.name}"
      subnet {
        mask = tolist(tolist(data.avi_network.network.configured_subnets)[0].prefix)[0].mask
        ip_addr {
          type = tolist(tolist(tolist(data.avi_network.network.configured_subnets)[0].prefix)[0].ip_addr)[0].type
          addr = tolist(tolist(tolist(data.avi_network.network.configured_subnets)[0].prefix)[0].ip_addr)[0].addr
        }
      }
    }
  }
  dns_info {
    fqdn = "${var.vsName}.${tolist(data.avi_ipamdnsproviderprofile.dns.internal_profile)[0].dns_service_domain[0].domain_name}"
  }
  ssl_key_and_certificate_refs = [data.avi_sslkeyandcertificate.ssl_cert1.id]
  ssl_profile_ref = data.avi_sslprofile.ssl_profile1.id
  application_profile_ref = data.avi_applicationprofile.application_profile1.id
  network_profile_ref = data.avi_networkprofile.network_profile1.id
  services {
    port           = var.vsP
    enable_ssl     = var.vsSsl
  }
}
