variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr_blocks" {
  description = "CIDR block for the subnet"
  type        = list(string)
}