# CAUTION: arn number below is just an example. It is necessary to add a secret manager credentials in System Manager on aws, get the arn and write below
data "aws_secretsmanager_secret" "secret" {
  arn                       = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id                 = data.aws_secretsmanager_secret.secret.id
}

# To get "Host" and "DB" data in secret manager it is necessary to add a secret manager credentials in System Manager on aws (see instruction above) with key/value: Host/localhost and DB/db
resource "aws_instance" "instances" {
  count                     = var.instance_count
  ami                       = var.ami_id
  instance_type             = var.instance_type
  subnet_id                 = var.subnet_id
  vpc_security_group_ids    = var.security_group_ids
  tags = {
    project_name            = var.project_name
    Name                    = "${var.prefix}-node-${count.index}"
  }
  user_data = <<EOF
#!/bin/bash
DB_STRING="Server=${jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["Host"]};DB=${jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["DB"]}"
echo $DB_STRING > test.txt
EOF
}

# resource "aws_eip" "eip" {
#   instance = aws_instance.instance.id
#   tags = {
#     Project = "terraform-training-01"
#     Name = "eip-example-name"
#   }
#   depends_on = [ aws_internet_gateway.igw ]
# }

# resource "aws_ssm_parameter" "ssm_parameter" {
#   name  = "vm_ip"
#   type  = "String"
#   value = aws_eip.eip.public_ip
#   tags = {
#     Project = "terraform-training-01"
#   }
# }