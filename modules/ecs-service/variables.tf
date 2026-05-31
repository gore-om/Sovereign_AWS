variable "project_name" { type = string }
variable "cluster_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }

variable "backend_image_url" { type = string }
variable "frontend_image_url" { type = string }

variable "backend_port" { type = number }
variable "frontend_port" { type = number }

variable "backend_target_group_arn" { type = string }
variable "frontend_target_group_arn" { type = string }

variable "ecs_task_execution_role_arn" { type = string }
variable "backend_log_group_name" { type = string }
variable "frontend_log_group_name" { type = string }

variable "secret_arn" { type = string }

variable "ecs_security_group_id" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}