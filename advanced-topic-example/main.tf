terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "~> 2.5.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

resource "local_file" "file" {
  content  = "File created to test 'local-exec' provisioner. \n Created at ${formatdate("DD/MM/YYYY - hh:mm:ss", timeadd(timestamp(), "-3h"))}"
  filename = "${path.module}/create-file-test-1.txt"

  provisioner "local-exec" {
    # This will run after the file is created
    command = "echo '${self.filename} created at ${formatdate("DD/MM/YYYY - hh:mm:ss", timeadd(timestamp(), "-3h"))}' >> log.txt"
  }
}

resource "local_file" "file" {
  count = 0
  content  = "File created to test 'local-exec' provisioner. \n Created at ${formatdate("DD/MM/YYYY - hh:mm:ss", timeadd(timestamp(), "-3h"))}"
  filename = "${path.module}/create-file-test-2.txt"

  provisioner "local-exec" {
    # This will run after the file is created
    command = "echo '${self.filename} created at ${formatdate("DD/MM/YYYY - hh:mm:ss", timeadd(timestamp(), "-3h"))}' >> log.txt"
  }

  provisioner "local-exec" {
    # This will run after the file is deleted
    command = "echo '${self.filename} deleted at ${formatdate("DD/MM/YYYY - hh:mm:ss", timeadd(timestamp(), "-3h"))}' >> log.txt"
    when = destroy
  }
}
