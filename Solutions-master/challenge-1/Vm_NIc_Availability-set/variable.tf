variable "resource_group_name" {
 description = "resource group name"
}
variable "vnet_name" {
 description = "name of the azure vnet"
}
variable "subnet_name" {
 description = "name of the azure subnet"
}
variable "ip_address" {
 description = "Private ip address allocation"
 default     = "Dynamic"
}
variable "vnet_resource_group_name" {
 description = "name of the network resource group"
}
variable "location" {
 description = "location of the virtual network"
}
variable "availability_set" {
  description = "Set this varible to 'true' to create Virtual Machine with availability set Or default will be false"
  type        = bool
  default     = false
}
variable "update_domain_count" {
  description = "Specifies the number of update domains that are used. And it is required when we set availability set true only"
  type        = number
  default     = 2
}
variable "fault_domain_count" {
  description = "Specifies the number of fault domains that are used. And it is required when we set availability set true only"
  type        = number
  default     = 2
}
variable "appname" {
 description = "Name of the application (the VM name will be captured based on the apllication)"
}
variable "rootadmin_login" {
 description = "Name of the vm administrator login"
 default     = "root1"
}
variable "rootadmin_password" {
 description = "Password for the vm administrator login"
 default     = "Password@1234"
}
variable "size" {
 description = "vm size specification"
 default     = "Standard_D2_v2"
}
variable "boot_diagnostics" {
 description = "boot diagnostics trorage for VMs"
 default     = ""
}   
variable "vm_count" {
 description = "Number of VMs deployment"
 default     = 1
}
variable "image_reference_id" {
 description = "storage_image_reference"
 default = ""
}
variable "storage_account_type" {
 description = "the disk geo replication Locations type"
 default     = "Premium_LRS"
}
variable "environment" {
 description = "Name of the environment"
 default     ="devtest"
}

