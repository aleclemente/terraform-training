module "network" {
  source            = "./modules/network"
  project_name      = var.project_name
  prefix            = var.prefix
  vpc_cidr_block    = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_blocks
}

module "cluster" {
  source              = "./modules/cluster"
  project_name        = var.project_name
  prefix              = var.prefix
  ami_id              = var.ami_id
  instance_count      = var.instance_count
  instance_type       = var.instance_type
  security_group_ids  = [module.network.security_group_id]
  subnet_ids          = module.network.subnet_ids
}