resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    project_name = var.project_name
    Name = "${var.prefix}-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "subnets" {
  count = length(var.subnet_cidr_block)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  tags = {
    project_name = var.project_name
    Name = "${var.prefix}-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    project_name = var.project_name
    Name = "${var.prefix}-igw"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  count = length(var.subnet_cidr_block)
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  name = "${var.prefix}-allow-ssh"
  tags = {
    project_name = var.project_name
    Name = "${var.prefix}-allow-ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sg_ingress_rule" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  tags = {
    project_name = var.project_name
    Name = "${var.prefix}-sg-ingress"
  }
}

resource "aws_vpc_security_group_egress_rule" "sg_egress_rule" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
  tags = {
    project_name = var.project_name
    Name = "${var.prefix}-sg-egress"
  }
}