provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 1
  memory   = 4096
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = 17
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = var.vm_name
        domain    = var.domain
        time_zone = var.timezone
      }

      network_interface {
        ipv4_address = var.vm_ip
        ipv4_netmask = var.netmask

      }

      ipv4_gateway = var.gateway
      dns_server_list = var.dns_server_list
      dns_suffix_list = var.dns_suffix_list
    }
  }
  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = var.vm_ip
  }

  provisioner "remote-exec" {
    inline = [
      "apt update && apt upgrade -y",
    ]
  }
}
