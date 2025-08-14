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

variable "scale_in" {
  type = object({
    scaling_adjustment = number
    cooldown           = number
    threshold          = number
  })
}

variable "scale_out" {
  type = object({
    scaling_adjustment = number
    cooldown           = number
    threshold          = number
  })
}

variable "image_id" {
  description = "AMI ID for the instance"
  type        = string
  default     = "ami-0de716d6197524dd9" # Amazon Linux 2 AMI (HVM), SSD Volume Type - us-east-1
}

variable "instance_type" {
  description = "Type of instance to create"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "Minimum size for the auto scaling group"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "Desired capacity for the auto scaling group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum size for the auto scaling group"
  type        = number
  default     = 3
}