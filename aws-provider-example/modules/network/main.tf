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

resource "aws_route_table_association" "route_table_association_example" {
  subnet_id      = aws_subnet.subnet_example.id
  route_table_id = aws_route_table.route_table_example.id
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