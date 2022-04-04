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

locals  {
  Pod = "PodXX"
}

module "pod_vms" {
  source    = "./vm_module"
  folder = local.Pod
  hostname = "${local.Pod}-VM"
  vm_name = "${local.Pod}-VM"
  cpu       = 2
  ram       = 1024
  DHCP      = false
  ipv4_address = "10.156.32.87"
  ipv4_gateway = "10.156.32.254"
  ipv4_netmask = 24
}

output "vars" {
  value = regexall("(?:variable\\s\\W)(.*\\w)",file("vm_module/variables.tf"))
}

