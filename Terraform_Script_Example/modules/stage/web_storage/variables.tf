# Storage Name
variable "app_name" {
  type        = string
  description = "VPC name"
}

# Storage Env
variable "app_env" {
  type        = string
  description = "VPC envinroment"
}

# Storage Type
variable "project_storage_type" {
  type        = string
  description = "Aws virtual machine for OS"
  default     = "Standard"
}

# Storage Size
variable "project_storage_size" {
  type     = string
  description = "Aws storage volume size"
  default = "10"
}

# Storage iops
variable "project_storage_iops" {
  type     = string
  description = "Aws storage volume iops"
  default = "30"
}

# Storage attachment
variable "project_storage_multi_attach" {
  type     = string
  description = "Aws storage volume multi attached"
  default = "true"
}

# Storage location
variable "project_storage_location" {
  type        = string
  description = "Storage location"
  default = "eu-north-1"
}

# Storage attachment to EC2
variable "aws_ebs_volume_attach" {
   type = string
   description = "Aws volume instance"
}
