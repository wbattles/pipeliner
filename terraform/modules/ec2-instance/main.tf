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

resource "aws_vpc_security_group_ingress_rule" "this" {
  security_group_id = aws_security_group.public_traffic.id
  cidr_ipv4         = "0.0.0.0/0"

  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_eip" "instance_eip" {
  instance = aws_instance.this.id
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.public_traffic.id]

  tags = {
    Name = var.instance_name
  }
}