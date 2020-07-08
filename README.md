# terraform Avi LSC VS

## Goals
Configure a Health Monitor, Pool and VS through Terraform (via Avi provider)

## Prerequisites:
1. Make sure terraform is installed
2. Make sure your Avi Controller is reachable from your terraform host

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
avi@ansible:~/terraform/aviLscVs$ more creds.tfvars.json
{"avi_credentials": {"username": "admin", "controller": "****", "password": "****", "api_version": "****"}}
avi@ansible:~/terraform/aviLscVs$
```

2. All the other paramaters/variables are stored in variables.tf. The following parameters need to be changed:

```
#### Pool variables

variable "poolServer1" {
  type    = string
  default = "a.b.c.d"
}

variable "poolServer2" {
  type    = string
  default = "a.b.c.d"
}

variable "poolPort" {
  type    = string
  default = "80"
}


#### VS variables

variable "vsNetwork" {
  default = "myNetworkName"
}

variable "vsMask" {
  default = "24"
}

variable "vsCidr" {
  default = "a.b.c.d"
}

variable "vsP" {
  default = "myVsPort"
}

variable "VsFqdn" {
  default = "myVsFqdn"
}
```

## Use the the terraform script to:
1. Create a Health Monitor
2. Create a Pool (with 2 backend servers)
3. Create a VS based on Avi IPAM and DNS

## Run the terraform:
- apply:
```
terraform apply -var-file=creds.tfvars.json -auto-approve
```
- destroy:
```
terraform destroy -var-file=creds.tfvars.json -auto-approve
```

## Improvment:
- handle list of object
- collect IPAM info from the API (via data resource)
