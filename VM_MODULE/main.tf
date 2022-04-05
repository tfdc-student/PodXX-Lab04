terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
    //  version = "2.0.2"
    }
  }
}

/*
DATA blocks below are used to query vCenter for data used in the resource block
*/

# Get Data Center Infor (MOID etc.)
data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

# Get information of the datastore to be used for the VM
data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

/*
Eventhough we did not specify a resource pool,
vCenter puts resources in the default resource pool.
This Data block is used to get its ID
*/
data "vsphere_resource_pool" "pool" {
  name          = var.resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Get information about the portgroup used for the VM
data "vsphere_network" "network" {
  name          = var.portgroup
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Get the information about the template to be used for the VM
data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder = var.folder
  num_cpus = var.cpu
  memory   = var.ram
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
  
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"
  
  wait_for_guest_ip_timeout = 0
  wait_for_guest_net_timeout = 0
  
  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
      network_interface {
        ipv4_address = var.DHCP ? null : var.ipv4_address
        ipv4_netmask = var.DHCP ? null : var.ipv4_netmask
      }
      ipv4_gateway = var.DHCP ? null : var.ipv4_gateway
      linux_options {
        host_name = var.hostname
        domain = "tfdc.lab"
      }
    }
  }
}