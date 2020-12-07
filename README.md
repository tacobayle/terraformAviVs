# terraform Avi VS

## Goals
Configure a Health Monitor, Pool and VS through Terraform (via Avi provider)

## Prerequisites:
- TF is installed
- Avi Controller is reachable from your terraform host
- IPAM and DNS profiles configured in the Avi Controller

## Environment:

Terraform script has/have been tested against:

### terraform

```
Terraform v0.13.5
+ provider registry.terraform.io/terraform-providers/avi v0.2.3

Your version of Terraform is out of date! The latest version
is 0.14.0. You can update by downloading from https://www.terraform.io/downloads.html
```

### Avi version

```
Avi 20.1.1
```

### Avi Environment

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
- poolServers
- dns
- ipam
- avi_cloud

The other variables don't need to be adjusted.

## Use the the terraform script to:
1. Create a Health Monitor
2. Create a Pool (based on the Health Monitor previously created)
3. Create a vsvip (based on Avi IPAM and DNS)
4. Create a VS based on the pool previously created

## Run the terraform:
- apply:
```
cd ~ ; git clone https://github.com/tacobayle/terraformAviVs ; cd terraformAviVs ; terraform init ; terraform apply -var-file=creds.json -auto-approve
```
- destroy:
```
terraform destroy -var-file=creds.json -auto-approve
```