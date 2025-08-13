project_name        = "tf-training-1"
prefix              = "tf-training"
vpc_cidr_block      = "10.0.0.0/16"
subnet_cidr_blocks  = ["10.0.0.0/24", "10.0.1.0/24"]
image_id            = "ami-0de716d6197524dd9"
instance_count      = 2
instance_type       = "t2.micro"
min_size            = 1
desired_capacity    = 2
max_size            = 3
scale_in = {
  cooldown           = 60
  threshold          = 20
  scaling_adjustment = -1
}
scale_out = {
  cooldown           = 60
  threshold          = 70
  scaling_adjustment = 1
}