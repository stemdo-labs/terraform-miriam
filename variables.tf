variable "location" {
  type    = string
  default = "West Europe"
}

variable "client_id" {
  description = "The Client ID of the Azure Service Principal"
  type        = string
}

variable "client_secret" {
  description = "The Client Secret of the Azure Service Principal"
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "The Azure Subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "The Azure Tenant ID"
  type        = string
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
      admin_password = "Admin-user1"
      port           = 2221
    },
    "vm2" = {
      name           = "app-server-2"
      size           = "Standard_DS1_v2"
      admin_user     = "adminuser2"
      admin_password = "Admin-user2"
      port           = 2222
    }
  }
}
