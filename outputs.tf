output "lb_public_ip" {
  description = "Public IP of the Load Balancer"
  value       = azurerm_public_ip.main_lb_public_ip.ip_address
}

output "vm_ids" {
  description = "IDs of the virtual machines"
  value       = [for vm in azurerm_linux_virtual_machine.vm : vm.id]
}
