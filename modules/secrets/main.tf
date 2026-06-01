locals {
  database_url = "postgresql://${var.db_username}:${var.db_password}@${var.db_host}:${var.db_port}/${var.db_name}"
}

resource "aws_secretsmanager_secret" "db" {
  name                    = "${var.project_name}-db-secret-v2"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({
    DB_HOST      = var.db_host
    DB_PORT      = tostring(var.db_port)
    DB_NAME      = var.db_name
    DB_USER      = var.db_username
    DB_PASSWORD  = var.db_password
    DB_SSL       = "true"
    DATABASE_URL = local.database_url
  })
}