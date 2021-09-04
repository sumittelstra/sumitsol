output "vm_name" {
  value = azurerm_virtual_machine.vm.*.name
}
output "network_interface_private_ip" {
  description = "private ip addresses of the vm nics"
  value       = azurerm_network_interface.nic.*.private_ip_address
}
output "availability_set" {
  value = azurerm_availability_set.vm.*.name 
}
