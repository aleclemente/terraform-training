terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.8.0"
    }
  }
}

//CAUTION:arn below ir just an example. It is necessary to add a secret manager credentials in System Manager on aws, get the arn and write below
data "aws_secretsmanager_secret" "secret_example" {
  arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secret_example.id
}

provider "aws" {
  region     = "us-east-1"
  profile    = "default"
}

resource "aws_vpc" "vpc_example" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Project = "terraform-training-01"
    Name = "vpc-example-name"
  }
}

resource "aws_subnet" "subnet_example" {
  vpc_id     = aws_vpc.vpc_example.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Project = "terraform-training-01"
    Name = "subnet-example-name"
  }
}

resource "aws_security_group" "sg_example" {
  vpc_id = aws_vpc.vpc_example.id
  name = "Allow SSH"
  tags = {
    Project = "terraform-training-01"
    Name    = "Allow SSH"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sg_ingress_rule_example" {
  security_group_id = aws_security_group.sg_example.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
}

resource "aws_vpc_security_group_egress_rule" "sg_egress_rule_example" {
  security_group_id = aws_security_group.sg_example.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
}

//To get "Host" and "DB" data in secret manager it is necessary to add a secret manager credentials in System Manager on aws (see instruction above) with key/value: Host/localhost and DB/db
resource "aws_instance" "instance_example" {
  ami = "ami-0de716d6197524dd9"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_example.id
  vpc_security_group_ids = [ aws_security_group.sg_example.id ]
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

resource "aws_internet_gateway" "igw_example" {
  vpc_id = aws_vpc.vpc_example.id
  tags = {
    Project = "terraform-training-01"
    Name = "igw-example-name"
  }
}

resource "aws_route_table" "route_table_example" {
  vpc_id = aws_vpc.vpc_example.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_example.id
  }
  tags = {
    Project = "terraform-training-01"
    Name    = "route-table-example-name"
  }
}

resource "aws_eip" "eip_example" {
  instance = aws_instance.instance_example.id
  tags = {
    Project = "terraform-training-01"
    Name = "eip-example-name"
  }
  depends_on = [ aws_internet_gateway.igw_example ]
}

resource "aws_route_table_association" "route_table_association_example" {
  subnet_id      = aws_subnet.subnet_example.id
  route_table_id = aws_route_table.route_table_example.id
}

resource "aws_ssm_parameter" "ssm_parameter_example" {
  name  = "vm_ip"
  type  = "String"
  value = aws_eip.eip_example.public_ip
  tags = {
    Project = "terraform-training-01"
  }
}

output "private_dns" {
  value = aws_instance.instance_example.private_dns
}

output "eip" {
  value = aws_eip.eip_example.public_ip
}