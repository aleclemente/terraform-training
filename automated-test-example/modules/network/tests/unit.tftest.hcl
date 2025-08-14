provider "aws" {
  region            = "us-east-1"
}

variables {
  project_name      = "test-project"
  prefix = "test"
  vpc_cidr_block = "10.0.0.0/16"
  subnet_cidr_blocks = ["10.0.0.0/24", "10.0.1.0/24"]
}

run "validate_vpc" {

    command = plan

    assert {
        condition = aws_vpc.vpc.tags["Name"] == "${var.prefix}-vpc"
        error_message = "VPC Name tag does not match expected value."
    }

    assert {
        condition = aws_vpc.vpc.cidr_block == var.vpc_cidr_block
        error_message = "VPC CIDR block does not match expected value."
    }
}

run "validate_subnets" {

    command = plan

    assert {
        condition = length(aws_subnet.subnets) == length(var.subnet_cidr_blocks)
        error_message = "Subnet count does not match expected value."
    }

    assert {
        condition = alltrue([
            aws_subnet.subnets[0].cidr_block == var.subnet_cidr_blocks[0],
            aws_subnet.subnets[1].cidr_block == var.subnet_cidr_blocks[1]
        ])
        error_message = "Subnet CIDR blocks do not match expected values."
    }

    #test if AZ of subnets are different
    assert {
        condition = aws_subnet.subnets[0].availability_zone != aws_subnet.subnets[1].availability_zone
        error_message = "Subnets shouldn't be in the same availability zones."
    }
}