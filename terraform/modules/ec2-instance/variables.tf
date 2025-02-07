variable "vpc_id" {
    type = string
    description = "VPC for the ec2 instance"
}

variable "subnet_id" {
    type = string
    description = "VPC public subnet for the ec2 instance"
}

variable "ami_id" {
  description = "The AMI to use for the EC2 instance"
  type        = string
}

variable "instance_name" {
    type        =  string
    description = "Name for the ec2 instance"
}

variable "instance_type" {
    type        = string
    description = "Type of ec2 instance"
}

variable "key_name" {
    type        = string
    description = "SSH key name for the ec2 instance"
}
