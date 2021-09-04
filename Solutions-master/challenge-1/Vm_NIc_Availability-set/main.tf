

# To prevent automatic upgrades to new major versions that may contain breaking changes, it is recommended to add version
terraform {
 required_version = ">= 0.12.0"
 required_providers {
 azurerm  = "1.44.0"
 }
}

# This data source to access information about an existing Resource Group.
data "azurerm_resource_group" "main_rg" {
  name = var.resource_group_name
}

# This data source to access information about an existing VNet Resource Group.
data "azurerm_resource_group" "vnetshared_rg" {
  name = var.vnet_resource_group_name
}

# This data source to access information about an existing VNet.
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = "${data.azurerm_resource_group.vnetshared_rg.name}"
}

# This data source to access information about an existing subnet.
data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.vnetshared_rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

# Create a availabilityset for the vm.
resource "azurerm_availability_set" "vm" {
  count                        = var.availability_set == true ? 1 : 0
  name                         = "ms${substr(var.appname,0,6)}${substr(var.environment,0,4)}a0${count.index + 1}"
  location                     = var.location
  resource_group_name          = data.azurerm_resource_group.main_rg.name
  platform_fault_domain_count  = var.fault_domain_count
  platform_update_domain_count = var.update_domain_count
  managed                      = true
}

# Create a network interface for the availability set VMs 
resource "azurerm_network_interface" "nic" {
  name                            = "ms${substr(var.appname,0,6)}${substr(var.environment,0,4)}a0${count.index + 1}-nic"
  count                           = var.vm_count
  location                        = var.location
  resource_group_name             = data.azurerm_resource_group.main_rg.name
   
  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = var.ip_address
  }
}

# Create a windows availability set virtual machine
resource "azurerm_virtual_machine" "vm" {
  count                 = var.vm_count
  name                  = "ms${substr(var.appname,0,6)}${substr(var.environment,0,4)}a0${count.index + 1}"
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.main_rg.name
  network_interface_ids = [element(azurerm_network_interface.nic.*.id,count.index)]
  availability_set_id   = var.availability_set == true ? azurerm_availability_set.vm[0].id : null
  vm_size               = var.size
  
  # This image from Shared Image Gallery will be used for availability set vm deployment  
  storage_image_reference {
    id = var.image_reference_id
  }

  storage_os_disk {
    name                = "ms${substr(var.appname,0,6)}${substr(var.environment,0,4)}a0${count.index + 1}-Osdisk"
    caching             = "ReadWrite"
    create_option       = "FromImage"
    managed_disk_type   = var.storage_account_type
    }

  os_profile {
    computer_name       = "ms${substr(var.appname,0,6)}${substr(var.environment,0,4)}a0${count.index + 1}"
    admin_username      = var.rootadmin_login
    admin_password      = var.rootadmin_password
    }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled             = true
    storage_uri         = var.boot_diagnostics
  }
}
