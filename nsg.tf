# Create NSG for Sandbox VM
resource "azurerm_network_security_group" "sandbox" {
  name                = var.sandbox_nsg_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allowed_src_ip
    destination_address_prefix = azurerm_network_interface.eth0.private_ip_address
  }

  security_rule {
    name                       = "Myself"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = azurerm_linux_virtual_machine.sandbox.public_ip_address
    destination_address_prefix = azurerm_network_interface.eth0.private_ip_address
  }

  security_rule {
    name                       = "Deny-VNET-In"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Deny-VNET-Out"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = local.common_tags
}

resource "azurerm_network_interface_security_group_association" "sandbox" {
  network_interface_id      = azurerm_network_interface.eth0.id
  network_security_group_id = azurerm_network_security_group.sandbox.id
}
