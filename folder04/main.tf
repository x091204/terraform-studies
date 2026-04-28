provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "folder02" {
  ami = "ami-08e7318c2e031024c"
  instance_type = "t3.micro"
}
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "terraform-bakend-test-bucket"
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  
}