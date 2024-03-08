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
