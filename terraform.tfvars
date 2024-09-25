# terraform.tfvars

# Ubicación (location)
location = "West Europe"

# Nombre del grupo de recursos existente
resource_group_name = "rg-mblanco-dvfinlab"

# Nombre de la red virtual
vnet_name = "main-vnet"

# Address space para la red virtual
vnet_address_space = ["10.0.0.0/16"]

# Nombre de la subred
subnet_name = "main-subnet"

# Prefijos de la subred
subnet_prefixes = ["10.0.1.0/24"]

# Mapa de las máquinas virtuales (vm_map)
vm_map = {
  vm1 = {
    name           = "app-server-1"
    size           = "Standard_DS1_v2"
    admin_user     = "adminuser1"
    admin_password = "Admin-user1"
    port           = 2221
  },
  vm2 = {
    name           = "app-server-2"
    size           = "Standard_DS1_v2"
    admin_user     = "adminuser2"
    admin_password = "Admin-user2"
    port           = 2222
  }
}


# # terraform.tfvars
# location = "West Europe"

# vm_map = {
#   vm1 = {
#     name           = "app-server-1"
#     size           = "Standard_DS1_v2"
#     admin_user     = "adminuser1"
#     admin_password = "Admin-user1"
#     port           = 2221
#   },
#   vm2 = {
#     name           = "app-server-2"
#     size           = "Standard_DS1_v2"
#     admin_user     = "adminuser2"
#     admin_password = "Admin-user2"
#     port           = 2222
#   }
# }