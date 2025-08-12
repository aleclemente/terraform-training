variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "tf-training-1"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "tf-training"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_blocks" {
  description = "CIDR block for the subnet"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}