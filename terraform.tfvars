# terraform.tfvars
location = "West Europe"

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