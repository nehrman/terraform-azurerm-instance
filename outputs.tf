output "virtual_machine_name" {
  description = "name of virtual machines"
  value       = "${azurerm_virtual_machine.vm.*.name}"
}

output "network_interface_name" {
  description = "name of network interface attached to vm"
  value       = "${azurerm_network_interface.vm.*.name}"
}

output "network_interface_private_ip" {
  description = "private ip addresses of the vm nics"
  value       = "${azurerm_network_interface.vm.*.private_ip_address}"
}

output "availability_set_name" {
  description = "name of availability set"
  value       = "${azurerm_availability_set.vm.*.name}"
}
