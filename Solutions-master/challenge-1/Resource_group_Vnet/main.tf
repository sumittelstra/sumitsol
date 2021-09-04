#Creating azure resource group

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

#Creating azure Network Security Group

resource "azurerm_network_security_group" "sg" {
  name                                = "SecurityGroup1"
  location                           = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

#Creating azure virtual network

resource "azurerm_virtual_network" vnet" {
  name                               = "virtualNetwork1"
  location                           = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space               = ["10.0.0.0/16"]
  dns_servers                    = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name                 = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name                 = "subnet3"
    address_prefix = "10.0.3.0/24"
    security_group = azurerm_network_security_group.example.id
 }
}
