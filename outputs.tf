# Outputs en el módulo raíz
output "lb_public_ip" {
  value = module.load_balancer.lb_public_ip
}

output "vm_ids" {
  value = module.virtual_machines.vm_ids
}
