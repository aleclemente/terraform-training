terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "~> 2.5.1"
    }
  }
}

resource "local_file" "txtFileExample" {
  filename = "${path.module}/example.txt"
  content  = "This is an example text file created by Terraform."
  
}