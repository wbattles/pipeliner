terraform {
  backend "s3" {
    bucket         = "tf-state-pipeline-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}