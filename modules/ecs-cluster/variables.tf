variable "project_name" {
  type = string
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
  default = "/"
}

variable "frontend_health_check_path" {
  type    = string
  default = "/"
}