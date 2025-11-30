# Create VPC
module "vpc" {
  source = "./modules/vpc"
}

# Create Security Groups
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"
}

module "secrets_manager" {
  source = "./modules/secrets_manager"
  db_username = "admin"
  db_password = "password"
}