# variables.tf

# Ubicación de los recursos en Azure
variable "location" {
  type        = string
  description = "La ubicación donde se desplegarán los recursos"
}

# Mapa de máquinas virtuales
variable "vm_map" {
  type = map(object({
    size           = string   # Tamaño de la VM
    admin_user     = string   # Usuario administrador de la VM
    admin_password = string   # Contraseña del usuario administrador
    port           = number   # Puerto para NAT rule y SSH
  }))
  description = "Mapa de configuración para cada máquina virtual"
}

# Nombre del grupo de recursos
variable "resource_group_name" {
  type        = string
  description = "El nombre del grupo de recursos existente donde se desplegarán los recursos"
}

# Dirección IP para el espacio de red virtual (VNet)
variable "vnet_address_space" {
  type        = list(string)
  description = "Espacio de direcciones IP para la red virtual (VNet)"
  default     = ["10.0.0.0/16"]
}

# Prefijos de dirección IP para la subred
variable "subnet_prefixes" {
  type        = list(string)
  description = "Prefijos de direcciones IP para la subred"
  default     = ["10.0.1.0/24"]
}

# Nombre de la red virtual (VNet)
variable "vnet_name" {
  type        = string
  description = "Nombre de la red virtual"
  default     = "main-vnet"
}

# Nombre de la subred
variable "subnet_name" {
  type        = string
  description = "Nombre de la subred"
  default     = "main-subnet"
}



# # variables.tf
# variable "location" {
#   type = string
# }

# variable "vm_map" {
#   type = map(object({
#     name           = string
#     size           = string
#     admin_user     = string
#     admin_password = string
#     port           = number
#   }))
# }