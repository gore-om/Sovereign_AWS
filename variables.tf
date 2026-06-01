variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type    = string
  default = "devops-admin"
}

variable "project_name" {
  type    = string
  default = "expenses"
}

variable "db_name" {
  type    = string
  default = "expensesdb"
}

variable "db_username" {
  type    = string
  default = "postgres"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_publicly_accessible" {
  type    = bool
  default = true
}

variable "backend_container_port" {
  type    = number
  default = 8080
}

variable "frontend_container_port" {
  type    = number
  default = 80
}

variable "backend_health_check_path" {
  type    = string
  default = "/ping"
}

variable "frontend_health_check_path" {
  type    = string
  default = "/"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN"
  type        = string
}