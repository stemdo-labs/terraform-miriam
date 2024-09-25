# IP pública del balanceador de carga
output "lb_public_ip" {
  description = "La dirección IP pública del balanceador de carga"
  value       = module.load_balancer.lb_public_ip
}

# IDs de las máquinas virtuales
output "vm_ids" {
  description = "IDs de las máquinas virtuales creadas"
  value       = module.virtual_machines.vm_ids
}