data "avi_cloud" "default_cloud" {
  name = "cloudVmw"
}

data "avi_sslkeyandcertificate" "ssl_cert1" {
  name = var.vs["sslCert"]
}

data "avi_sslprofile" "ssl_profile1" {
  name = var.vs["sslProfile"]
}

data "avi_applicationprofile" "application_profile1" {
  name = var.vs["applicationProfile"]
}

data "avi_networkprofile" "network_profile1" {
  name = var.vs["networkProfile"]
}

data "avi_ipamdnsproviderprofile" "dns" {
    name = var.dns
}

data "avi_ipamdnsproviderprofile" "ipam" {
    name = var.ipam
}

data "avi_network" "network" {
    uuid = split("/network/", tolist(data.avi_ipamdnsproviderprofile.ipam.internal_profile)[0].usable_network_refs[0])[1]
}

resource "avi_healthmonitor" "hm" {
  name = var.healthmonitor["name"]
  tenant_ref = "/api/tenant/?name=${var.avi_tenant}"
  type = var.healthmonitor["type"]
  receive_timeout = var.healthmonitor["receive_timeout"]
  failed_checks = var.healthmonitor["failed_checks"]
  send_interval = var.healthmonitor["send_interval"]
  successful_checks = var.healthmonitor["successful_checks"]
  http_monitor {
    http_request = var.healthmonitor["http_request"]
    http_response_code = var.http_response_code
  }
}

resource "avi_pool" "lbpool" {
  depends_on = [avi_healthmonitor.hm]
  name = var.pool["name"]
  tenant_ref = "/api/tenant/?name=${var.avi_tenant}"
  lb_algorithm = var.pool["lb_algorithm"]
  cloud_ref = "/api/cloud/?name=${var.avi_cloud}"
  health_monitor_refs = ["/api/healthmonitor?name=${var.pool["poolHm"]}"]
  dynamic servers {
    for_each = [for server in var.poolServers:{
      addr = server.ip
      type = server.type
      port = server.port
    }]
    content {
      ip {
        type = servers.value.type
        addr = servers.value.addr
      }
      port = servers.value.port
    }
  }
}

resource "avi_vsvip" "vsvip" {
    name = "vsvip-${var.vs["name"]}"
    tenant_ref = "/api/tenant/?name=${var.avi_tenant}"
    cloud_ref = "/api/cloud/?name=${var.avi_cloud}"
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
      fqdn = "${var.vs["name"]}.${tolist(data.avi_ipamdnsproviderprofile.dns.internal_profile)[0].dns_service_domain[0].domain_name}"
    }
}

resource "avi_virtualservice" "https_vs" {
  name = var.vs["name"]
  pool_ref = avi_pool.lbpool.id
  cloud_ref = "/api/cloud/?name=${var.avi_cloud}"
  tenant_ref = "/api/tenant/?name=${var.avi_tenant}"
  ssl_key_and_certificate_refs = [data.avi_sslkeyandcertificate.ssl_cert1.id]
  ssl_profile_ref = data.avi_sslprofile.ssl_profile1.id
  application_profile_ref = data.avi_applicationprofile.application_profile1.id
  network_profile_ref = data.avi_networkprofile.network_profile1.id
  vsvip_ref= "/api/vsvip/?name=vsvip-${var.vs["name"]}"
  se_group_ref= "/api/serviceenginegroup/?name=${var.vs["se_group_ref"]}"
  services {
    port           = var.vs["port"]
    enable_ssl     = var.vs["ssl"]
  }
  analytics_policy {
    client_insights = "NO_INSIGHTS"
    all_headers = "true"
    udf_log_throttle = "10"
    significant_log_throttle = "0"
    metrics_realtime_update {
      enabled  = "true"
      duration = "0"
    }
    full_client_logs {
        enabled = "true"
        throttle = "10"
        duration = "0"
    }
  }
}
