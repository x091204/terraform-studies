provider "aws" {
  region = "ap-south-1"
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami_value = "ami-08e7318c2e031024c"
  instance_type_value = "t3.micro"
}