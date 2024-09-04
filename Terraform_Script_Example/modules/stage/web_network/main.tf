resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${lower(var.app_name)}-${lower(var.app_env)}-vpc"
    Env  = var.app_env
  }
}

resource "aws_internet_gateway" "gateway-1" {
   vpc_id = aws_vpc.vpc.id

   tags = {
      Name = "${lower(var.app_name)}-${var.app_env}-vpc-gw"
      Env  = var.app_env
   }
}

resource "aws_subnet" "subnet-1" {
  //count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id
  //cidr_block = element(var.private_subnet_cidrs, count.index)
  //availability_zone = element(var.awsvpclocation, count.index)
  cidr_block = var.vpc_subnet_cidrs
  availability_zone = var.vpc_location
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.gateway-1]

  tags = {
    //Name = "Project01_subnet${count.index + 1}"
    Name = "${lower(var.app_name)}-${var.app_env}-vpc-subnet"
    Env  = var.app_env

  }
}

resource "aws_route_table" "route-1" {
  vpc_id = aws_vpc.vpc.id

  route {
   cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway-1.id
   }
  tags = {
    Name = "${lower(var.app_name)}-${var.app_env}-vpc-route"
    Env  = var.app_env
  }   
}

resource "aws_route_table_association" "route-1-asso" {
  count          = length(var.vpc_subnet_cidrs)
  subnet_id      = element(aws_subnet.subnet-1[*].id, count.index)
  route_table_id = aws_route_table.route-1.id 
}

resource "aws_security_group" "security-1" {
  name        = "${lower(var.app_name)}-${var.app_env}-vpc-sg"
  description = "Allow incoming and outcoming details"
  vpc_id      = "${aws_vpc.vpc.id}"

ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks  = ["0.0.0.0/0"]
  description = "Allow incoming SSH connections"
}
ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks  = ["0.0.0.0/0"]
  description = "Allow incoming HTTP connections"
}
ingress {
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks  = ["0.0.0.0/0"]
  description = "Allow incoming HTTPS connections"
}
egress {
  from_port   = 0
  to_port     = 0 
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow outing all connections"
}

tags = {
  Name = "${lower(var.app_name)}-${var.app_env}-vpc-sg"
  Env  = var.app_env
  }   
}
