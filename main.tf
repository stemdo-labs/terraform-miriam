# Provider configuration
provider "azurerm" {
  features {}

  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-mblanco-dvfinlab"
  location = var.location
}

# Virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "main-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "main_subnet" {
  name                 = "main-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP for the load balancer
resource "azurerm_public_ip" "main_lb_public_ip" {
  name                = "main-lb-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Load balancer
resource "azurerm_lb" "main_lb" {
  name                = "main-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.main_lb_public_ip.id
  }
}

# Health probe for load balancer
resource "azurerm_lb_probe" "http_probe" {
  loadbalancer_id     = azurerm_lb.main_lb.id
  name                = "http-health-probe"
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

# Backend address pool for the load balancer
resource "azurerm_lb_backend_address_pool" "main_backend_pool" {
  loadbalancer_id = azurerm_lb.main_lb.id
  name            = "backend-pool"
}

resource "azurerm_lb_nat_rule" "ssh_nat_rule" {
  for_each                       = var.vm_map
  name                           = "ssh-nat-rule-${each.key}"
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.main_lb.id
  frontend_ip_configuration_name = "PublicIPAddress"
  protocol                       = "Tcp"
  frontend_port                  = format("22%02d", each.key)
  backend_port                   = 22
}

# Network security group
resource "azurerm_network_security_group" "nsg" {
  name                = "main-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network interface for each VM
resource "azurerm_network_interface" "nic" {
  for_each = var.vm_map

  name                = "nic-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Virtual machines
resource "azurerm_linux_virtual_machine" "vm" {
  for_each              = var.vm_map
  name                  = "vm-${each.key}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = each.value.size
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_username = each.value.admin_user
  admin_password = each.value.admin_password

  custom_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y nginx
  EOF
  )

  tags = {
    Environment = "Test"
  }
}

# Associate network interfaces with the backend pool of the load balancer
resource "azurerm_network_interface_backend_address_pool_association" "nic_backend_pool" {
  for_each                     = azurerm_network_interface.nic
  network_interface_id         = each.value.id
  backend_address_pool_id      = azurerm_lb_backend_address_pool.main_backend_pool.id
  ip_configuration_name        = "internal"
}
