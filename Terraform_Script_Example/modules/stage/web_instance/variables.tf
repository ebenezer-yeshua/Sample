# Instance Name
variable "app_name" {
  type        = string
  description = "VPC name"
}

# Instance Env
variable "app_env" {
  type        = string
  description = "VPC envinroment"
}

# Instance Env
variable "aws_region" {
  type        = string
  description = "Aws instance region"
}

# Instance OS
variable "aws_os_name" {
   type = string
   description = "Name of OS"
   default = "debian-12"
}

# Instance Type
variable "aws_instance_type" {
   type = string
   description = "Aws intance type"
   default = "t3.micro"
}

# Instance Subnet 
variable "aws_subnet_subnet_id" {
   type = list(string)
   description = "Aws subnet id"
}

# Instance security group
variable "aws_vpc_security_group_id" {
   type = string
   description = "Aws vpc security group id"
}

# Instance private ip
variable "aws_private_ip_address" {
   type = string
   description = "Aws instance private ip"
}

# Instance associate with public ip
variable "aws_associate_public_ip_address" {
   type = string
   description = "Aws associated with public ip"
}

# Elastic IP associate with gateway
variable "aws_instance_internet_gateway" {
   type = string
   description = "Aws associated with public ip"
}


