

# To prevent automatic upgrades to new major versions that may contain breaking changes, it is recommended to add version.
terraform {
 required_version = ">= 0.12.0"
 required_providers {
 azurerm  = "1.44.0"
 }
}

# this data source to access information about an existing Resource Group.
data "azurerm_resource_group" "main_rg" {
 name = var.resource_group_name
}

# this data source to access information about an existing VNet Resource Group.
data "azurerm_resource_group" "vnetshared_rg" {
 name = var.vnet_resource_group_name
}

# this data source to access information about an existing vnet.
data "azurerm_virtual_network" "vnet" {
 name                = var.vnet_name
 resource_group_name = data.azurerm_resource_group.vnetshared_rg.name
}

# this data source to access information about an existing subnet.
data "azurerm_subnet" "subnet" {
 name                 = var.subnet_name
 resource_group_name  = data.azurerm_resource_group.vnetshared_rg.name
 virtual_network_name = data.azurerm_virtual_network.vnet.name
}

# create a internal load balancer for the VMSS
resource "azurerm_lb" "vmsslb" {
 name                = "ms${substr(var.appname,0,6)}${substr(var.environment,0,4)}a01-lb"
 location            = var.location
 resource_group_name = data.azurerm_resource_group.main_rg.name

 frontend_ip_configuration {
  name                 = var.frontendadd
  private_ip_address_allocation = var.ip_address
  subnet_id = data.azurerm_subnet.subnet.id
 }
 
}

# create a internal load balancer backend address pool
resource "azurerm_lb_backend_address_pool" "bpepool" {
 resource_group_name = data.azurerm_resource_group.main_rg.name
 loadbalancer_id     = azurerm_lb.vmsslb.id
 name                = "BackEndAddressPool"
}


# create a internal load balancer NAT rule
resource "azurerm_lb_rule" "lbnatrule" {
 resource_group_name            = data.azurerm_resource_group.main_rg.name
 loadbalancer_id                = azurerm_lb.vmsslb.id
 name                           = "ssh"
 protocol                       = "Tcp"
 frontend_port                  = 3389
 backend_port                   = 3389
 backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
 frontend_ip_configuration_name = var.frontendadd
 probe_id                       = azurerm_lb_probe.lbprobe.id
}

# create a windows virtual machine scaleset 
resource "azurerm_virtual_machine_scale_set" "vmss" {
 name                = "ms${substr(var.appname,0,6)}${substr(var.environment,0,4)}a01"
 location            = var.location
 resource_group_name = data.azurerm_resource_group.main_rg.name
 upgrade_policy_mode = "Manual"

 sku {
  name     = var.vmss_size
  tier     = "Standard"
  capacity = var.instance_count
 }

# this image from shared repository will be used for vmss deployment
 storage_profile_image_reference {
  id = var.image_reference_id
  }

 storage_profile_os_disk {
  name              = ""
  caching           = "ReadWrite"
  create_option     = "FromImage"
  managed_disk_type = var.replication_type
 }

 storage_profile_data_disk {
  lun           = 0
  caching       = "ReadWrite"
  create_option = "Empty"
  disk_size_gb  = var.disk_size_gb
}

 os_profile {
  computer_name_prefix = "vmss"
  admin_username       = var.rootadmin_login
  admin_password       = var.rootadmin_password
  }

   os_profile_linux_config {
  disable_password_authentication = false
 }

  boot_diagnostics {
   enabled             = true
   storage_uri         = var.boot_diagnostics
  }

  network_profile {
   name    = "terraformnetworkprofile"
   primary = true

  ip_configuration {
   name                                   = "internal"
   subnet_id                              = data.azurerm_subnet.subnet.id
   load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
   primary                                = true
  }
 }
}