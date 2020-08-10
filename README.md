# terraform Avi VS

## Goals
Configure a Health Monitor, Pool and VS through Terraform (via Avi provider)

## Prerequisites:
1. Make sure terraform is installed
2. Make sure your Avi Controller is reachable from your terraform host
3. Make sure you have an IPAM/DNS profile is configured

## Environment:

Terraform script has/have been tested against:

### terraform

```
avi@ansible:~$ terraform -v
Terraform v0.12.21

Your version of Terraform is out of date! The latest version
is 0.12.26. You can update by downloading from https://www.terraform.io/downloads.html
avi@ansible:~$
```

### Avi version

```
Avi 18.2.9
Avi 20.1.1 beta drop 3
```

### Avi Environment

- LSC Cloud
- VMware Cloud (Vsphere 6.7.0.42000) without NSX


## Input/Parameters:

1. Make sure you have a json file with the Avi credentials like the following:

```
avi@ansible:~/terraform/aviLscVs$ more creds.json
{"avi_credentials": {"username": "admin", "controller": "****", "password": "****", "api_version": "****"}}
avi@ansible:~/terraform/aviLscVs$
```

2. All the other paramaters/variables are stored in variables.tf.
The below variable(s) called need(s) to be adjusted:
- poolServer1
- poolServer2
- dns
- ipam

The other varaiables don't need to be adjusted.

```
#### Pool variables

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

variable "vsName" {
  default = "tfApp"
}

variable "vsP" {
  default = "443"
}

variable "vsSsl" {
  default = "true"
}
```

## Use the the terraform script to:
1. Create a Health Monitor
2. Create a Pool (based on the Health Monitor previously created)
3. Create a VS based on Avi IPAM and DNS and based on the pool previously created

## Run the terraform:
- apply:
```
terraform init
terraform apply -var-file=creds.json -auto-approve
```
- destroy:
```
terraform destroy -var-file=creds.json -auto-approve
```

## Improvment:
- handle list of object for the server pool
- add SE service group
- add log and analytics capabilities
```
resource "avi_virtualservice" "https_vs" {
  name                          = var.vs_name
  pool_group_ref                = avi_poolgroup.poolgroup1.id
  tenant_ref                    = data.avi_tenant.default_tenant.id
  vsvip_ref                     = avi_vsvip.test_vsvip.id
  cloud_ref                     = data.avi_cloud.default_cloud.id
  ssl_key_and_certificate_refs  = [data.avi_sslkeyandcertificate.ssl_cert1.id]
  ssl_profile_ref               = data.avi_sslprofile.ssl_profile1.id
  application_profile_ref       = data.avi_applicationprofile.application_profile1.id
  network_profile_ref           = data.avi_networkprofile.network_profile1.id
  services {
    port           = var.vs_port
    enable_ssl     = true
  }
  analytics_policy {
    client_insights = "NO_INSIGHTS"
    all_headers = "false"
    udf_log_throttle = "10"
    significant_log_throttle = "0"
    metrics_realtime_update {
      enabled  = "true"
      duration = "0"
    }
    full_client_logs {
        enabled = "true"
        throttle = "10"
        duration = "30"
    }
  }
}
```
- vsvip against 20.1.1
