avi@ansible:~/terraform/aviVs$ terraform apply -var-file=creds.tfvars.json -auto-approve
data.avi_ipamdnsproviderprofile.ipam: Refreshing state...
data.avi_cloud.default_cloud: Refreshing state...
data.avi_sslprofile.ssl_profile1: Refreshing state...
data.avi_applicationprofile.application_profile1: Refreshing state...
data.avi_sslkeyandcertificate.ssl_cert1: Refreshing state...
avi_healthmonitor.hm: Refreshing state... [id=https://192.168.142.135/api/healthmonitor/healthmonitor-155cec92-5501-4c47-93fe-1c59cc736a31]
data.avi_networkprofile.network_profile1: Refreshing state...
data.avi_network.network: Refreshing state...
data.avi_ipamdnsproviderprofile.dns: Refreshing state...
avi_pool.lbpool: Refreshing state... [id=https://192.168.142.135/api/pool/pool-4d0c74d2-24f4-4bf8-ad56-4d41eebac7fd]
avi_virtualservice.https_vs: Refreshing state... [id=https://192.168.142.135/api/virtualservice/virtualservice-49852fd6-687f-48f6-bedd-231aff54304b]
avi_healthmonitor.hm: Modifying... [id=https://192.168.142.135/api/healthmonitor/healthmonitor-155cec92-5501-4c47-93fe-1c59cc736a31]
avi_healthmonitor.hm: Modifications complete after 0s [id=https://192.168.142.135/api/healthmonitor/healthmonitor-155cec92-5501-4c47-93fe-1c59cc736a31]
avi_pool.lbpool: Creating...
avi_pool.lbpool: Creation complete after 1s [id=https://192.168.142.135/api/pool/pool-e1698313-1d95-4a95-9746-9ed63207ea12]
avi_virtualservice.https_vs: Creating...
avi_virtualservice.https_vs: Creation complete after 1s [id=https://192.168.142.135/api/virtualservice/virtualservice-dda7abc1-8311-41dd-99c7-8380b0347b96]

Apply complete! Resources: 2 added, 1 changed, 0 destroyed.

Outputs:

log1 = {
  "api_version" = "18.2.9"
  "controller" = "192.168.142.135"
  "password" = "Avi_2020"
  "username" = "admin"
}
log2 = admin
log3 = [
  {
    "dns_service_domain" = [
      {
        "domain_name" = "lsc.avidemo.fr"
        "num_dns_ip" = 0
        "pass_through" = false
        "record_ttl" = 100
      },
    ]
    "dns_virtualservice_ref" = ""
    "ttl" = 300
    "usable_network_refs" = []
  },
]
log4 = [
  {
    "dns_service_domain" = []
    "dns_virtualservice_ref" = ""
    "ttl" = 0
    "usable_network_refs" = [
      "https://192.168.142.135/api/network/network-782954c4-c866-42f9-bd16-0fd608172e15",
    ]
  },
]
log5 = [
  {
    "prefix" = [
      {
        "ip_addr" = [
          {
            "addr" = "10.1.2.0"
            "type" = "V4"
          },
        ]
        "mask" = 24
      },
    ]
    "static_ips" = []
    "static_ranges" = [
      {
        "begin" = [
          {
            "addr" = "10.1.2.51"
            "type" = "V4"
          },
        ]
        "end" = [
          {
            "addr" = "10.1.2.100"
            "type" = "V4"
          },
        ]
      },
    ]
  },
]
log6 = net-avi
avi@ansible:~/terraform/aviVs$
