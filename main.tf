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
  content  = "string content: ${var.string_content}\n number content: ${var.number_content}\n boolean content: ${var.boolean_content}"
}