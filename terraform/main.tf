module "networking" {
  source = "./modules/networking"
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.networking.vpc_id
}

module "compute" {
  source            = "./modules/compute"
  security_group_id = module.security_groups.security_group_id
  subnet_id         = module.networking.subnet_id
}
