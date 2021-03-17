output "vm_ip" {
  value = vsphere_virtual_machine.tf_node_test.guest_ip_addresses
}