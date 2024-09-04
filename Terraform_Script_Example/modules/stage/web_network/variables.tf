# VPC Name
variable "app_name" {
  type        = string
  description = "VPC name"
}

# VPC Env
variable "app_env" {
  type        = string
  description = "VPC envinroment"
}

# VPC variables
variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
  default     = "172.31.0.0/16"
}

# VPC subnet variables
variable "vpc_subnet_cidrs" {
  //type        = list(string)
  type        = string
  description = "Public subnet CIDR values"
  //default     = ["10.0.1.0/24", "10.0.2.0/24"]
  default     = "172.31.44.0/24"
}

# VPC location variables
variable "vpc_location" {
  //type        = list(string)
  type        = string
  description = "Availability VPC Zones"
  //default     = ["eu-north-1a", "eu-north-1b"]
  default     = "eu-north-1a"
}




