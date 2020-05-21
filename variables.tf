variable "region" {}
variable "profile" {}
data "aws_availability_zones" "available" {}
variable "vpc_cidr" {}
variable "cidrs" {
  type = map
}
variable "ec2_instance_type" {}
variable "ec2_ami" {}
variable "ec2_public_key_path" {}
variable "ec2_key_name" {}
