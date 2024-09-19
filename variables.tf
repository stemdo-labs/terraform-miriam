variable "location" {
  type    = string
  default = "West Europe"
}

variable "vm_map" {
  type = map(object({
    name           = string
    size           = string
    admin_user     = string
    admin_password = string
  }))
  
  default = {
    "vm1" = {
      name           = "app-server-1"
      size           = "Standard_DS1_v2"
      admin_user     = "adminuser1"
      admin_password = "adminuser1"
    },
    "vm2" = {
      name           = "app-server-2"
      size           = "Standard_DS1_v2"
      admin_user     = "adminuser2"
      admin_password = "adminuser2"
    }
  }
}
