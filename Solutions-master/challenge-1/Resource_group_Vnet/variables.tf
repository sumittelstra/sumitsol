variable "environment" {
  description = "The environment the storage account will be hosted in."
}

variable "resource_group_name" {
  description = "The name of the Azure resource group where all resources will be launched."
}

variable "location" {
  description = "The location in which all Azure resources will be launched."
  default     = "East US 2"
}





