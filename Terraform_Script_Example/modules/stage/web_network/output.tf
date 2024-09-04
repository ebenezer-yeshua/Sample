  output "output_security_group" {
    value = "${aws_security_group.security-1.id}"
  }
  output "output_subnet" {
    value = "${aws_subnet.subnet-1.id}"
  }
  output "output_gateway" {
    value = "${aws_internet_gateway.gateway-1.id}"  
  }
  output "output_vpc_id" {
    value = "${aws_vpc.vpc.id}"
  }