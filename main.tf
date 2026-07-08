#Code written by OG

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

module "cloudwatch" {
  source       = "./modules/cloudwatch"
  project_name = var.project_name
}

module "rds_subnet_group" {
  source = "./modules/rds-subnet-group"

  project_name = var.project_name
  subnet_ids   = data.aws_subnets.default.ids
}

module "rds" {
  source = "./modules/rds"

  project_name           = var.project_name
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  db_instance_class      = var.db_instance_class
  db_allocated_storage   = var.db_allocated_storage
  publicly_accessible    = var.db_publicly_accessible
  vpc_security_group_ids = [module.security_groups.rds_security_group_id]
  db_subnet_group_name   = module.rds_subnet_group.db_subnet_group_name

  depends_on = [
    module.security_groups,
    module.rds_subnet_group
  ]
}

module "secrets" {
  source = "./modules/secrets"

  project_name = var.project_name
  db_host      = module.rds.db_endpoint
  db_port      = module.rds.db_port
  db_name      = var.db_name
  db_username  = var.db_username
  db_password  = var.db_password

  depends_on = [module.rds]
}

module "ecs_cluster" {
  source       = "./modules/ecs-cluster"
  project_name = var.project_name
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "alb" {
  source                     = "./modules/alb"
  project_name               = var.project_name
  vpc_id                     = data.aws_vpc.default.id
  subnet_ids                 = data.aws_subnets.default.ids
  alb_security_group_id      = module.security_groups.alb_security_group_id
  backend_port               = var.backend_container_port
  frontend_port              = var.frontend_container_port
  backend_health_check_path  = var.backend_health_check_path
  frontend_health_check_path = var.frontend_health_check_path
  acm_certificate_arn        = var.acm_certificate_arn

  depends_on = [module.security_groups]
}

module "ecs_service" {
  source = "./modules/ecs-service"

  project_name = var.project_name
  cluster_id   = module.ecs_cluster.cluster_id
  subnet_ids   = data.aws_subnets.default.ids
  vpc_id       = data.aws_vpc.default.id

  backend_image_url  = module.ecr.backend_repository_url
  frontend_image_url = module.ecr.frontend_repository_url

  backend_port  = var.backend_container_port
  frontend_port = var.frontend_container_port

  backend_target_group_arn  = module.alb.backend_target_group_arn
  frontend_target_group_arn = module.alb.frontend_target_group_arn
  ecs_security_group_id     = module.security_groups.ecs_security_group_id

  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.iam.ecs_task_role_arn
  backend_log_group_name      = module.cloudwatch.backend_log_group_name
  frontend_log_group_name     = module.cloudwatch.frontend_log_group_name

  secret_arn = module.secrets.secret_arn

  depends_on = [
    module.alb,
    module.secrets,
    module.cloudwatch,
    module.iam
  ]
}

module "security_groups" {
  source = "./modules/security-groups"

  project_name  = var.project_name
  vpc_id        = data.aws_vpc.default.id
  frontend_port = var.frontend_container_port
  backend_port  = var.backend_container_port
  db_port       = var.db_port
}