module "network" {
  source = "./modules/network"
}

# CAUTION: arn number below is just an example. It is necessary to add a secret manager credentials in System Manager on aws, get the arn and write below
data "aws_secretsmanager_secret" "secret_example" {
  arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secret_example.id
}

# To get "Host" and "DB" data in secret manager it is necessary to add a secret manager credentials in System Manager on aws (see instruction above) with key/value: Host/localhost and DB/db
resource "aws_instance" "instance_example" {
  ami = "ami-0de716d6197524dd9"
  instance_type = "t2.micro"
  subnet_id = module.network.subnet_id
  vpc_security_group_ids = [ module.network.security_group_id ]
  tags = {
    Project = "terraform-training-01"
    Name = "instance-example-name"
  }
  user_data = <<EOF
#!/bin/bash
DB_STRING="Server=${jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["Host"]};DB=${jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["DB"]}"
echo $DB_STRING > test.txt
EOF
}

# resource "aws_eip" "eip_example" {
#   instance = aws_instance.instance_example.id
#   tags = {
#     Project = "terraform-training-01"
#     Name = "eip-example-name"
#   }
#   depends_on = [ aws_internet_gateway.igw_example ]
# }

# resource "aws_ssm_parameter" "ssm_parameter_example" {
#   name  = "vm_ip"
#   type  = "String"
#   value = aws_eip.eip_example.public_ip
#   tags = {
#     Project = "terraform-training-01"
#   }
# }
