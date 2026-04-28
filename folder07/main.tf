provider "aws" {
  region = "ap-south-1"
}

provider "vault" {
  address = "<ip:8200"
  skip_child_token = true

  auth_login {
    path = "/auth/approle/login"

    parameters = {
      role_id = ""
      secret_id = ""
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test-secret"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0e12ffc2dd465f6e4"
  instance_type = "t3.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}