variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of Subnet ID"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "image_id" {
  description = "AMI ID for the instance"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
}

variable "instance_type" {
  description = "Type of instance to create"
  type        = string
}

variable "user_data" {
  type = string
}

variable "desired_capacity" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
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