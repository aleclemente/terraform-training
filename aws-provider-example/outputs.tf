output "private_dns" {
  value = aws_instance.instance_example.private_dns
}

# output "eip" {
#   value = aws_eip.eip_example.public_ip
# }