resource "aws_vpc" "sample_vpc" {
  cidr_block = "10.9.0.0/16"
  tags = {
    Name = "sample_vpc"
  }
}
resource "aws_subnet" "sample_subnet" {
  vpc_id = aws_vpc.sample_vpc.id
  cidr_block = "10.9.0.1/24"
  availability_zone = var.vpc_subnet_availability_zone
}

resource "aws_instance" "sample_instance" {
  ami           = var.ami_id
  count = var.number_of_instances
  subnet_id = var.subnet_id
  instance_type = var.instance_type
  key_name = var.key_name
  tags = {
    Name = "sample_instance"
  }
}
resource "aws_network_interface" "sample_network_interface" {
  subnet_id = aws_subnet.sample_subnet.id
  private_ips = ["10.9.0.10"]
}
resource "aws_security_group" "sample_security_group" {
  name        = "sample_security_group"
  description = "sample_security_group"
  vpc_id      = aws_vpc.sample_vpc.id
}
resource "aws_security_group_rule" "sample_security_group_rule_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sample_security_group.id
}




