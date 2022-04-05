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
  password       = var.password
  vsphere_server = "vcenter.tfdc.lab"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

module "pod_vms" {
  source    = "./vm_module"
  folder = var.Pod
  hostname = "${var.Pod}-VM"
  vm_name = "${var.Pod}-VM"
  cpu       = 2
  ram       = 1024
  DHCP      = true
  ipv4_address = "10.156.32.87"
  ipv4_gateway = "10.156.32.254"
  ipv4_netmask = 24
}

/*
output "vars" {
  value = regexall("(?:variable\\s\\W)(.*\\w)",file("vm_module/variables.tf"))
}
*/
