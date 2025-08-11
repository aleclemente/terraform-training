terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.8.0"
    }
  }
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

resource "aws_instance" "instance_example" {
  ami = "ami-0de716d6197524dd9"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_example.id
  tags = {
    Project = "terraform-training-01"
    Name = "instance-example-name"
  }
}