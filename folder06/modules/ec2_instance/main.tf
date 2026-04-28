provider "aws" {
  region = "ap-south-1"
}

variable "ami" {
  description = "contain ami value for instace"
}

variable "instance_type_vlue" {
  description = "contain instance type"
}
resource "aws_instance" "workspace" {
  ami           = var.ami
  instance_type = var.instance_type_vlue
  tags = {
    Name = "workspace"
  }
}