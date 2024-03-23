variable "resource_group_name" {
  type        = string
  default     = "rg-default"
  description = "Defines the name of Resource Group"
}
variable "location" {
    default = "East US"
    description = "This points the location where we want to create our resources"
}
variable "virtual_network" {
    default ="myprojectvnet"
    description = "This indicates Virtual Network Name"
}
variable "subnet_name" {
    default = "myprojectsubnet"
    description ="The name given to subnet"
}
variable "newtork_security_group" {
    default = "myprojectnsg"
    description = "This is used to create network security group for the project"
}
variable "network_interface_name" {
    default ="myprojectnic"
    description ="This will create the Network interface"
}
variable "virtual_machine"{
    default ="SwiggyVM"
    description = "This will allocate the name to your VM"
}
variable "admin_username" {
  description = "The administrator username for the virtual machine"
  default     = "adminuser"
}

variable "admin_password" {
  description = "The administrator password for the virtual machine"
  default     = "Password1234!"  # Use a strong password or SSH key
}

variable "vm_size" {
  description = "The size of the Azure virtual machine"
  default     = "Standard_D2_v2"
}