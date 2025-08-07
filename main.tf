
resource "local_file" "txtFileExample" {
  filename = "${path.module}/example.txt"
  content  = "This is an example text file created by Terraform."
  
}