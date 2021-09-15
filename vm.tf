# Create Public IP Addresses
resource "azurerm_public_ip" "vm_pip" {
  name                    = "${var.dns_label_prefix}-${random_id.randomId.hex}"
  domain_name_label       = "${var.dns_label_prefix}-${random_id.randomId.hex}"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 4
  sku                     = "Standard"

  tags = local.common_tags
}

# Create Interface for VM
resource "azurerm_network_interface" "eth0" {
  name                = "${var.vmName}-eth0"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${var.vmName}-eth0-ip"
    subnet_id                     = azurerm_subnet.sandbox.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }

  tags = local.common_tags
}

# Creating Storage Account for Boot Diagnostics for Serial Console access to VMs
resource "azurerm_storage_account" "diag-storage-account" {
  name                     = "diag${random_id.randomId.hex}"
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = local.common_tags

  depends_on = [random_id.randomId]
}

# Create Sandbox VM
resource "azurerm_linux_virtual_machine" "sandbox" {
  name                = var.vmName
  computer_name       = var.vmName
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = var.vmSize

  admin_username = var.adminUsername
  admin_ssh_key {
    username   = var.adminUsername
    public_key = file(var.ssh_public_key_file)
  }

  network_interface_ids = [azurerm_network_interface.eth0.id]

  os_disk {
    name                   = "${var.vmName}-osdisk1"
    caching                = "ReadWrite"
    storage_account_type   = "Standard_LRS"
    disk_size_gb           = 40
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.diag-storage-account.primary_blob_endpoint
  }

  custom_data = base64encode(local.user_data)

  tags = local.common_tags

  depends_on = [
    azurerm_network_interface.eth0,
    azurerm_storage_account.diag-storage-account
  ]
}
