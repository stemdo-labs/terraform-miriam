# variables.tf
variable "location" {
  type = string
}

variable "vm_map" {
  type = map(object({
    name           = string
    size           = string
    admin_user     = string
    admin_password = string
    port           = number
  }))
}