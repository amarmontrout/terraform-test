resource "azurerm_resource_group" "this" {
  for_each = var.resource_groups
  name     = each.value.name
  location = each.value.location
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-test-001"
  location            = azurerm_resource_group.this["rg1"].location
  resource_group_name = azurerm_resource_group.this["rg1"].name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "this" {
  for_each             = var.subnets
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.this["rg1"].name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_storage_account" "this" {
  name                     = "sttest00198756487"
  resource_group_name      = azurerm_resource_group.this["rg1"].name
  location                 = azurerm_resource_group.this["rg1"].location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Cool"
}

resource "azurerm_network_interface" "this" {
  name                = "nic-test-001"
  location            = azurerm_resource_group.this["rg1"].location
  resource_group_name = azurerm_resource_group.this["rg1"].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "/subscriptions/33764b3d-f586-4756-ad2d-ba2ee7043bd7/resourceGroups/rg-test-001/providers/Microsoft.Network/virtualNetworks/vnet-test-001/subnets/snet-test-001"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "this" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.this["rg1"].name
  location            = azurerm_resource_group.this["rg1"].location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
