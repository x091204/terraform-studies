variable "instance_type" {
  description = "EC2 instance type"
  type = string
  default = "t3.micro"
}
variable "ami_id" {
  description = "ami id for the instance"
  type = string
  default = "ami-0e12ffc2dd465f6e4"
}
provider "aws" {
    region = "ap-south-1"
}
resource "aws_instance" "vaiable_test" {
  ami = var.ami_id
  instance_type = var.instance_type
}
## output variables
output "public_ip" {
  description = "public ip of the Ec2 instance"
  value = aws_instance.vaiable_test.public_ip
}
