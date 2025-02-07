module "my_ec2" {
  source = "../modules/ec2-instance"

  instance_name   = var.instance_name
  instance_type   = var.instance_type
  ami_id          = var.ami_id
  # ami_id          = data.aws_ami.amazon_linux_2.id
  vpc_id          = var.vpc_id
  subnet_id       = var.subnet_id
  key_name        = var.key_name
}
