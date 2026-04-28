terraform {
  backend "s3" {
    bucket = "terraform-bakend-test-bucket"
    key    = "folder04/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-locks"
  }
}