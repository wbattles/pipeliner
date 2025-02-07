terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

resource "aws_security_group" "public_traffic" {
  name        = "EC2-Public-SecGrp"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    Name = "EC2-Public-SecGrp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "web" {
  security_group_id = aws_security_group.public_traffic.id
  cidr_ipv4         = "0.0.0.0/0"

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.public_traffic.id
  cidr_ipv4         = "0.0.0.0/0"

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "web" {
  security_group_id = aws_security_group.public_traffic.id
  cidr_ipv4         = "0.0.0.0/0"

  ip_protocol = -1
  from_port   = -1
  to_port     = -1
}

resource "aws_eip" "instance_eip" {
  instance = aws_instance.this.id
}

resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.public_traffic.id]
  key_name = var.key_name

  tags = {
    Name = var.instance_name
  }
}