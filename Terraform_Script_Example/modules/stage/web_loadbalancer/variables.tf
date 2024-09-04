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

# Loadbalancer type
variable "aws_loadbalancer_type" {
  type        = string
  description = "Aws loadbalancer type"
}

# Loadbalancer security group
variable "aws_instance_security_group" {
  type        = string
  description = "Aws loadbalancer group"
}

# Loadbalancer subnet
variable "aws_instance_subnet" {
  type        = list(string)
  description = "Aws loadbalancer subnet"
}

# Loadbalancer target group
variable "aws_instance_vpc_id" {
  type        = string
  description = "Aws loadbalancer target group"
}

# Loadbalancer associated with instance id
variable "aws_intance_id" {
  type        = string
  description = "Aws loadbalancer associated with instance id"
}

# Loadbalancer assciated with instance name
variable "aws_intance_name" {
  type        = string
  description = "Aws loadbalancer assciated with instance name"
}
