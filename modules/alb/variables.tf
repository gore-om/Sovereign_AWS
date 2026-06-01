variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "backend_port" {
  type = number
}

variable "frontend_port" {
  type = number
}

variable "backend_health_check_path" {
  type = string
}

variable "frontend_health_check_path" {
  type = string
}

variable "alb_security_group_id" {
  type = string
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener"
  type        = string
}