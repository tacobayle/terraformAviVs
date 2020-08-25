output "aviCreds" {
  value = var.avi_credentials
}

output "aviTenant" {
  value = var.avi_tenant
}
output "domaineName" {
  value = tolist(data.avi_ipamdnsproviderprofile.dns.internal_profile)[0].dns_service_domain[0].domain_name
}
output "networkUuid" {
  value = split("/network/", tolist(data.avi_ipamdnsproviderprofile.ipam.internal_profile)[0].usable_network_refs[0])[1]
  #value = split("/network/", tolist(data.avi_ipamdnsproviderprofile.ipam.internal_profile)[0].usable_network_refs[0])[1]
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
