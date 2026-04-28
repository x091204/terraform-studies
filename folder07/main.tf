provider "aws" {
  region = "ap-south-1"
}

provider "vault" {
  address = "http://13.234.113.250:8200"
  skip_child_token = true

  auth_login {
    path = "/auth/approle/login"

    parameters = {
      role_id = "4bbd97f7-0684-924d-9dfc-45e262ed1db4"
      secret_id = "41a950c0-c145-6fec-1fef-7ef34cf45a1c"
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