module "network" {
  source = "./modules/network"
  project_name = var.project_name
  prefix = var.prefix
  vpc_cidr_block = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_blocks
}

# CAUTION: arn number below is just an example. It is necessary to add a secret manager credentials in System Manager on aws, get the arn and write below
data "aws_secretsmanager_secret" "secret" {
  arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}

# To get "Host" and "DB" data in secret manager it is necessary to add a secret manager credentials in System Manager on aws (see instruction above) with key/value: Host/localhost and DB/db
resource "aws_instance" "instance" {
  ami = "ami-0de716d6197524dd9"
  instance_type = "t2.micro"
  subnet_id = module.network.subnet_ids[0]
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
