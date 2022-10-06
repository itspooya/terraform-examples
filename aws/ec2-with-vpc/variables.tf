variable "access_key" {
  description = "AWS access key"
}
variable "secret_key" {
  description = "AWS secret key"
}
variable "instance_name" {
  description = "Name of the instance"
  default = "sample-aws-instance"
}
variable "instance_type" {
  description = "Type of the instance"
  default = "t2.micro"
}
variable "subnet_id" {
  description = "Subnet ID"
}
variable "ami_id" {
  description = "AMI ID"
}
variable "number_of_instances" {
  description = "Number of instances to create"
  default = 1
}
variable "key_name" {
  description = "Key name"
}
variable "aws_region" {
  description = "AWS region"
  default = "us-east-1"
}
variable "vpc_subnet_availability_zone" {
  description = "Availability zone"
  default = "us-east-1a"
}
variable "ec2_private_ip" {
  description = "Private IP"
  default = "
}