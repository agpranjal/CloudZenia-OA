# Create VPC
module "vpc" {
  source = "./modules/vpc"
}

# Create Security Groups
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

# Create IAM
module "iam" {
  source = "./modules/iam"
}

# Create Secrets Manager
module "secrets_manager" {
  source = "./modules/secrets_manager"
  db_username = "admin"
  db_password = "password"
}

# Create RDS
module "rds" {
  source = "./modules/rds"
  
  secret_arn = module.secrets_manager.secret_arn
  rds_security_group_id = module.security_groups.rds_security_group_id
  private_subnet_ids = module.vpc.private_subnet_ids
}