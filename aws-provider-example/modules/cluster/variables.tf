variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "ami_id" {
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