# Create a virtual network
resource "azurerm_virtual_network" "network" {
  name                = var.virtualNetworkName
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = var.virtualNetworkCIDR

  depends_on = [azurerm_resource_group.main]
}

#Create subnet
resource "azurerm_subnet" "sandbox" {
    name                      = var.subnetName
    resource_group_name       = azurerm_resource_group.main.name
    address_prefixes          = var.subnetCIDR
    virtual_network_name      = azurerm_virtual_network.network.name

    depends_on = [azurerm_virtual_network.network]
}

