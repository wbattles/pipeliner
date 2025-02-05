variable "instance_name" {
  type        =  string
  default     = "instance-name"
  description = "Name for the ec2 instance"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "The AMI to use for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "The subnet to launch the EC2 instance in"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}