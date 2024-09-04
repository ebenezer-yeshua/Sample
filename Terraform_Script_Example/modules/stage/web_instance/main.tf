
resource "tls_private_key" "key_pair" {
  algorithm                    = "RSA"
  rsa_bits                     = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name                     = "${lower(var.app_name)}-${lower(var.app_env)}-${lower(var.aws_region)}-key"
  public_key                   = tls_private_key.key_pair.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename                     = "${aws_key_pair.key_pair.key_name}.pem"
  content                      = tls_private_key.key_pair.private_key_pem
}

resource "aws_instance" "web-server-1" {
  ami                         = var.aws_os_name
  instance_type               = var.aws_instance_type
  key_name                    = aws_key_pair.key_pair.key_name
  subnet_id                   = var.aws_subnet_subnet_id
  vpc_security_group_ids      = [var.aws_vpc_security_group_id]
  private_ip                  = var.aws_private_ip_address
  associate_public_ip_address = var.aws_associate_public_ip_address
  source_dest_check           = false
  user_data                   = file("../project01/scripts/cmd-execution-script.sh")

  tags = {
    Name                      = var.app_name
    Env                       = var.app_env
  }
}

resource "aws_eip" "elasticip-1" {
   domain                     = "vpc"
   instance                   = aws_instance.web-server-1.id
   associate_with_private_ip  = var.aws_private_ip_address
   depends_on                 = [var.aws_instance_internet_gateway]
}
