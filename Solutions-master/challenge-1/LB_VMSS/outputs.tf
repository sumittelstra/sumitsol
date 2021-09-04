output "VMSS_name" {
  description = "Name of the virtual machine scale set"     
  value       = azurerm_virtual_machine_scale_set.vmss.name 
}
output "VMSS_ID" {
  description = "Name of the virtual machine scale set"     
  value       = azurerm_virtual_machine_scale_set.vmss.id 
} 
output "VMSS_lb_name" {
  description = "Name of the vmss lb"
  value       = azurerm_lb.vmsslb.name 
}