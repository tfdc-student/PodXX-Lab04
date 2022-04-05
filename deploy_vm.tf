terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
    //  version = "2.0.2"
    }
  }
}

provider "vsphere" {
  user           = "tfdc-student@vsphere.local"
  password       = var.vsphere_password
  vsphere_server = "vcenter.tfdc.lab"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

module "vm" {
  source    = "./VM_MODULE"
  folder = var.folder
  hostname = "${var.hostname}-MOD"
  vm_name = "${var.vm_name}-MOD"
  cpu       = 2
  ram       = 1024
  DHCP      = false
  ipv4_address = "172.16.1.1XX"
  ipv4_gateway = "172.16.1.254"
  ipv4_netmask = 24
}