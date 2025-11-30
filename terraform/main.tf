# Create VPC
module "vpc" {
  source = "./modules/vpc"
}

# Create Security Groups
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}