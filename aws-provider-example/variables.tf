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

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 2
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

variable "user_data" {
  description = "User data to provide when launching the instance"
  type        = string
  default     = <<EOF
#!/bin/bash
yum update -y
yum install -y nginx
systemctl start nginx
systemctl enable nginx
public_ip=$(curl http://checkip.amazonaws.com/)
echo "
<html>
  <head><title>Hello from Nginx!</title></head>
  <body><h1>Hello from Nginx!</h1>
  <p>Your public IP is: $public_ip</p>
  </body>
</html>" | tee /usr/share/nginx/html/index.html > dev/null
systemctl restart nginx
EOF
}