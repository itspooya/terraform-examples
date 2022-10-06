resource "aws_vpc" "sample_vpc" {
  cidr_block = "10.9.0.0/16"
  tags = {
    Name = "sample_vpc"
  }
}
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits = 4096
}
resource "local_sensitive_file" "pem_file" {
  filename = pathexpand("./sshkeys/key")
  file_permission = "600"
  directory_permission = "700"
  content = tls_private_key.pk.private_key_pem
}
resource "local_file" "pem_file_pub" {
  filename = pathexpand("./sshkeys/key.pub")
  file_permission = "644"
  directory_permission = "700"
  content = tls_private_key.pk.public_key_pem

}
# Question is whether to use hvm or pv
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/virtualization_types.html
# Also what to filter for name?
# ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-* ?
# ubuntu/images/ubuntu-*-*-amd64-server-* ?
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_subnet" "sample_subnet" {
  vpc_id = aws_vpc.sample_vpc.id
  cidr_block = "10.9.0.1/24"
  availability_zone = var.vpc_subnet_availability_zone
}

resource "aws_instance" "sample_instance" {
  ami = data.aws_ami.ubuntu.id
  count = var.number_of_instances
  subnet_id = var.subnet_id
  instance_type = var.instance_type
  key_name = tls_private_key.pk.public_key_openssh
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

resource "null_resource" "install-nginx" {
    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("./sshkeys/key")
        host        = aws_instance.sample_instance.public_ip
    }
    provisioner "remote-exec" {
        inline = [
        "sudo apt update",
        "sudo apt install nginx -y",
        "sudo systemctl start nginx",
        "sudo systemctl enable nginx",
        ]
    }
}




