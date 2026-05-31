output "frontend_ecr_url" {
  value = module.ecr.frontend_repository_url
}

output "backend_ecr_url" {
  value = module.ecr.backend_repository_url
}

output "ecs_task_execution_role_arn" {
  value = module.iam.ecs_task_execution_role_arn
}

output "backend_log_group_name" {
  value = module.cloudwatch.backend_log_group_name
}

output "frontend_log_group_name" {
  value = module.cloudwatch.frontend_log_group_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "rds_port" {
  value = module.rds.db_port
}

output "db_secret_arn" {
  value     = module.secrets.secret_arn
  sensitive = true
}

output "ecs_cluster_name" {
  value = module.ecs_cluster.cluster_name
}

output "ecs_cluster_arn" {
  value = module.ecs_cluster.cluster_arn
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "backend_service_name" {
  value = module.ecs_service.backend_service_name
}

output "frontend_service_name" {
  value = module.ecs_service.frontend_service_name
}

output "ecs_security_group_id" {
  value = module.security_groups.ecs_security_group_id
}

output "rds_security_group_id" {
  value = module.security_groups.rds_security_group_id
}

output "alb_security_group_id" {
  value = module.security_groups.alb_security_group_id
}

output "db_subnet_group_name" {
  value = module.rds_subnet_group.db_subnet_group_name
}

output "ecs_task_role_arn" {
  value = module.iam.ecs_task_role_arn
}