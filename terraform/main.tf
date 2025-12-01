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

# Create ACM
module "acm" {
  source = "./modules/acm"
  domain_name = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method = "DNS"
  validate_certificate = true
  use_route53_validation = true
  route53_zone_id = var.route53_zone_id
}

# Create ALB
module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  alb_security_group_id = module.security_groups.alb_security_group_id
  public_subnet_ids = module.vpc.public_subnet_ids
  certificate_arn = module.acm.certificate_arn
  domain_name = var.domain_name
  route53_zone_id = var.route53_zone_id
}

# Create ECR Repository for Node.js Microservice
module "ecr" {
  source = "./modules/ecr"
}

# Create ECS
module "ecs" {
  source = "./modules/ecs"
  
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_security_group_id = module.security_groups.ecs_security_group_id
  task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  task_role_arn = module.iam.ecs_task_role_arn
  secret_arn = module.secrets_manager.secret_arn

  db_host = module.rds.db_instance_endpoint
  db_username = module.secrets_manager.db_username
  db_name = "wordpress"

  wordpress_target_group_arn = module.alb.wordpress_target_group_arn
  wordpress_image     = "public.ecr.aws/docker/library/wordpress:latest"

  microservice_target_group_arn = module.alb.microservice_target_group_arn
  microservice_image = "${module.ecr.repository_url}:latest"
}

# Create EC2 Instances
module "ec2" {
  source = "./modules/ec2"
  
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.ec2_security_group_id
  public_key_path = "~/.ssh/id_rsa.pub"
  domain_name = var.domain_name
  route53_zone_id = var.route53_zone_id
}