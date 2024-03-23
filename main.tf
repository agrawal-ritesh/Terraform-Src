terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.93.0"
    }
  }
}

provider "azurerm" {
    subscription_id = "b1b5d6d3-1867-435f-9d65-ae9f95120edc"
    features{}
}
resource "azurerm_resource_group" "rggroup" {
    name = var.resource_group_name
    location = var.location
}
resource "azurerm_virtual_network" "myvnet" {
    name = var.virtual_network
    resource_group_name = azurerm_resource_group.rggroup.name
    location = azurerm_resource_group.rggroup.location
    address_space = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "mysubnet"{
    name = var.subnet_name
    resource_group_name = azurerm_resource_group.rggroup.name
    virtual_network_name = azurerm_virtual_network.myvnet.name
    address_prefixes = ["10.0.0.0/24"]
}
resource "azurerm_network_security_group" "mynsg"{
    name = var.newtork_security_group
    resource_group_name = azurerm_resource_group.rggroup.name
    location = azurerm_resource_group.rggroup.location
    security_rule {
    name                       = "SSH"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}
}
resource "azurerm_public_ip" "mypublicip"{
    name = "mypublic_ip"
    resource_group_name = azurerm_resource_group.rggroup.name
    allocation_method = "Static"
    location = azurerm_resource_group.rggroup.location
}
resource "azurerm_network_interface" "mynic"{
    name = var.network_interface_name
    resource_group_name = azurerm_resource_group.rggroup.name
    location = azurerm_resource_group.rggroup.location

    ip_configuration{
        name ="internal"
        subnet_id = azurerm_subnet.mysubnet.id
        private_ip_address_allocation = "Static"
    }

}
resource "azurerm_linux_virtual_machine" "myvm"{
    name = var.virtual_machine
    resource_group_name = azurerm_resource_group.rggroup.name
    location = azurerm_resource_group.rggroup.location
    size = var.vm_size
    admin_username = var.admin_username
    admin_password = var.admin_password
    network_interface_ids = [azurerm_network_interface.mynic.id]
    disable_password_authentication = false  # Enable password authentication

    source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"

    }
    
    os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
    }
    depends_on = [
    azurerm_network_security_group.mynsg,
    azurerm_public_ip.mypublicip,
    azurerm_network_interface.mynic,
  ]
}
