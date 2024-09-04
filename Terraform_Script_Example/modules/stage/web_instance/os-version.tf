data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
    owners = ["099720109477"]
}

data "aws_ami" "debian" {
    most_recent = true
    filter {
      name = "name"
      values = ["debian-12-amd64-*"]
    }
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
    owners = ["136693071363"]
}