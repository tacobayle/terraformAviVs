// Configure the AVI provider
provider "avi" {
  avi_username   = var.avi_credentials.username
  avi_password   = var.avi_credentials.password
  avi_controller = var.avi_credentials.controller
  avi_tenant     = var.avi_tenant
}
