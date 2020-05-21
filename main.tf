provider "aws" {
  region  = var.region
  profile = var.profile
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "The VPC"
  }
}

# Internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "The Internet Gateway"
  }
}

# Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "The Public Route Table"
  }
}

resource "aws_default_route_table" "private_rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  tags = {
    Name = "The Default Route Table"
  }
}

#Subnets
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidrs["public"]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "The Public Subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidrs["private"]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "The Private Subnet"
  }
}


# Route Table Associations
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_default_route_table.private_rt.id
}


#Public Security Group
resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  vpc_id      = aws_vpc.vpc.id

  #HTTP

  ingress {
    from_port   = 0 //80 or 8080 or 22......
    to_port     = 0 //80 or 8080 or 22.....
    protocol    = "-1" ///tcp, udp....
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


# Key pair
resource "aws_key_pair" "pc_auth" {
  key_name   = var.ec2_key_name
  public_key = file(var.ec2_public_key_path)
}

#EC2 Instance
resource "aws_instance" "pc_instance" {
  instance_type = var.ec2_instance_type
  ami = var.ec2_ami

  tags = {
    Name = "The EC2 Instance"
  }

  key_name = aws_key_pair.pc_auth.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id = aws_subnet.public_subnet.id
}
