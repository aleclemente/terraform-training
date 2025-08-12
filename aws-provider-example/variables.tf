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

variable "subnet_ids" {
  description = "List of Subnet IDs"
  type        = list(string)
}

variable "subnet_cidr_blocks" {
  description = "CIDR block for the subnet"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (HVM), SSD Volume Type - us-east-1
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "Type of instance to create"
  type        = string
  default     = "t2.micro"
}