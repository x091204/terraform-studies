provider "aws" {
  region = "ap-south-1"
}

variable "ami" {
  description = "contain value for instance ami"
}

variable "instance_type_value" {
  description = "contain value for instance type"
  type = map(string)
  default = {
    "dev" = "t3.micro"
    "prod" = "t3.medium"
    "stage" = "t3.small"
  }
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami           = var.ami
  instance_type_vlue = lookup(instance_type_value, terraform.workspace, "t3.micro")
}