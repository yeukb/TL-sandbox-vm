variable "resource_group_name" {}

variable "location" {}

variable "adminUsername" {}

variable "adminPassword" {}

variable "allowed_src_ip" {}

variable "virtualNetworkName" {
    default = "sandbox-vnet"
}

variable "virtualNetworkCIDR" {
    default = ["172.31.0.0/23"]
}

variable "subnetName" {
    default = "sandbox-subnet"
}

variable "subnetCIDR" {
    default = ["172.31.0.0/29"]
}

variable "vmName" {
    default = "sandbox"
}

variable "vmSize" {
    default = "Standard_B1s"
}

variable "sandbox_nsg_name" {
    default = "Sandbox-NSG"
}

variable "dns_label_prefix" {
    default = "sandbox-pip"
}

variable "console_url" {}

variable "console_username" {}

variable "console_password" {}
