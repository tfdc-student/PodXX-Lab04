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

/*
output "vars" {
  value = regexall("(?:variable\\s\\W)(.*\\w)",file("vm_module/variables.tf"))
}
*/





