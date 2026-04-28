provider "aws" {
  region = "ap-south-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_key_pair" "terraform_study" {
  key_name   = "terraform_study"
  public_key = file("~/.ssh/terraform.pub")
}

resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "terraform_subnet" {
  vpc_id = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
}

resource "aws_route_table" "terrafrom_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }
}

resource "aws_route_table_association" "terrafrom_rta" {
  subnet_id = aws_subnet.terraform_subnet.id
  route_table_id = aws_route_table.terrafrom_rt.id
}

resource "aws_security_group" "terraform_sg" {
  name = "terraform_sg"
  vpc_id = aws_vpc.terraform_vpc.id

  ingress {
    description = "HTTP from vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "terraform_sg"
  }
}

resource "aws_instance" "terraform_instance" {
  ami           = "ami-0e12ffc2dd465f6e4"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.terraform_sg.id]
  subnet_id     = aws_subnet.terraform_subnet.id
  key_name      = aws_key_pair.terraform_study.key_name

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("~/.ssh/terraform")
    host = self.public_ip
  }

  provisioner "file" {
    source = "app.py"
    destination = "/home/ec2-user/app.py"   
  }

  provisioner "remote-exec" {
    inline = [ 
        "echo 'hello from the remote instance'",
        "sudo yum update -y",
        "sudo yum install python3-pip -y",
        "cd /home/ec2-user",
        "sudo pip3 install flask",
        "sudo python3 app.py &",
     ]
  }
}
