
variable "resource_group_name" {
 description = "resource group name"
}

variable "vnet_resource_group_name" {
 description = "resource group name"
}

variable "vnet_name" {
 description = "name of the azure vnet"
}

variable "ip_address" {
 description = "Private ip address allocation"
 default     = "Dynamic"
}

variable "subnet_name" {
 description = "name of the azure subnet"
}

variable "location" {
 description = "location of the virtual network"
}

variable "appname" {
 description = "Name of the application (the VM name will be captured based on the apllication)"
}

variable "instance_count" {
 description = "Specifies the number of virtual machines in the scale set."
 default = "1"
}

variable "frontendadd" {
 description = "Describes a vmss ILB IP Configuration's (PrivateIPAddress or PublicIPAddress)"
 default = "PrivateIPAddress"
}

variable "vmss_size" {
 description = "vmss size specification"
 default = "Standard_DS1_v2"
}

variable "boot_diagnostics" {
 description = "boot diagnostics trorage for VMs"
 default     = ""
}

variable "rootadmin_login" {
 description = "vmss user name"
 default = "root1"
}

variable "rootadmin_password" {
 description = "vmss user password"
 default = "Password@1234"
}

variable "replication_type" {
 description = "managed disk type"
 default = "Standard_LRS"
}

variable "image_reference_id" {
 description = "storage_image_reference"
 default = ""
}

variable "storage_account_type" {
 description  = "additional data disk type"
 default      = "Standard_LRS"
}

variable "disk_size_gb" {
 description  = "additional data disk size"
 default      = "100"
}




