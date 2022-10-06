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