module "network" {
  source            = "./modules/network"
  project_name      = var.project_name
  prefix            = var.prefix
  vpc_cidr_block    = var.vpc_cidr_block
  subnet_cidr_blocks = var.subnet_cidr_blocks
}

module "cluster" {
  source              = "./modules/cluster"
  project_name        = var.project_name
  prefix              = var.prefix
  image_id            = var.image_id
  instance_count      = var.instance_count
  instance_type       = var.instance_type
  security_group_ids  = [module.network.security_group_id]
  subnet_ids          = module.network.subnet_ids
  vpc_id              = module.network.vpc_id
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  scale_in            = var.scale_in
  scale_out           = var.scale_out
  user_data           = file("install_nginx.sh")
}