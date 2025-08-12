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
  user_data           = var.user_data
  desired_capacity    = 2
  min_size            = 1
  max_size            = 3
  scale_in            = var.scale_in
  scale_out           = var.scale_out
}