provider "vsphere" {
  vsphere_server = var.vsphere_server
  user           = var.vsphere_user
  password       = var.vsphere_password

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

/*
data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}
*/

data "vsphere_resource_pool" "pool" {
  name          = var.pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "/${var.datacenter}/vm/${var.template_name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "tf_node_test" {
  name             = "tf-node-test-01"
#  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 1024

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  wait_for_guest_net_timeout = -1
  wait_for_guest_ip_timeout  = -1

  disk {
    label            = "disk0"
    #thin_provisioned = true
    size             = 35
    ##eagerly_scrub = false
    #size = data.vsphere_virtual_machine.template.disks.0.size
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  #guest_id = "sles15_64Guest"
    guest_id = data.vsphere_virtual_machine.template.guest_id
    firmware = data.vsphere_virtual_machine.template.firmware

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  
# may be conflict with cloud-init beacuse may use reboot for configure interface
    customize {
        linux_options {
            host_name = "terraform-test"
            domain = "rancher.suse.ru"
        }
        network_interface {
            ipv4_address = "192.168.13.201"
            ipv4_netmask = 24
        }
        ipv4_gateway = "192.168.13.1"
    }

  }


  extra_config = {
    "guestinfo.metadata"          = base64encode(file("${path.module}/cloudinit/metadata.yaml"))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(file("${path.module}/cloudinit/userdata.yaml"))
    "guestinfo.userdata.encoding" = "base64"
  }

}
