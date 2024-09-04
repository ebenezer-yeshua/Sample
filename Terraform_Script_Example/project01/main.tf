variable "app_name" {
  type = string
  description = "Application Name"
  default = "projectx01"
}
variable "app_env" {
  type = string
  description = "Application Envinorment"
  default = "stage"
}

module "web_storage" {
  source                                = "../modules/stage/web_storage/"
  app_name                              = var.app_name
  app_env                               = var.app_env
  project_storage_type                  = "Standard"
  project_storage_size                  = "10"
  project_storage_location              = "eu-north-1a"
  aws_ebs_volume_attach                 = module.web_instance.output_aws_instance_volume_attach
}

module "web_network" {
  source                                = "../modules/stage/web_network/"
  app_name                              = "projectx01"
  app_env                               = "stage"
}
module "web_instance" {
  source                                = "../modules/stage/web_instance/"
  app_name                              = var.app_name
  app_env                               = var.app_env
  aws_os_name                           = "ami-01427dce5d2537266"
  aws_region                            = "eu-north-1a"
  aws_instance_type                     = "t3.micro"
  aws_private_ip_address                = "172.31.44.145"
  aws_vpc_security_group_id             = module.web_network.output_security_group
  aws_subnet_subnet_id                  = module.web_network.output_subnet
  aws_associate_public_ip_address       = "true"
  aws_instance_internet_gateway         = module.web_network.output_gateway
}
module "web_loadbalancer" {
  source                                = "../modules/stage/web_loadbalancer/"
  app_name                              = var.app_name
  app_env                               = var.app_env
  aws_instance_security_group           = module.web_network.output_security_group
  aws_instance_vpc_id                   = module.web_network.output_vpc_id
  aws_intance_id                        = module.web_instance.output_aws_instance_volume_attach
  aws_loadbalancer_type                 = "application"
  aws_instance_subnet                   = [module.web_network.output_subnet]
  aws_intance_name                      = var.app_name
}
