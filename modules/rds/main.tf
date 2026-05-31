resource "aws_db_instance" "postgres" {
  identifier = "${var.project_name}-db"

  engine         = "postgres"
  engine_version = "16.13"
  instance_class = var.db_instance_class

  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = 0
  storage_type          = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  port                = 5432
  publicly_accessible = var.publicly_accessible

  skip_final_snapshot      = true
  delete_automated_backups = true
  deletion_protection      = false

  backup_retention_period = 1
  multi_az                = false

  auto_minor_version_upgrade = true

  vpc_security_group_ids = var.vpc_security_group_ids

  db_subnet_group_name = var.db_subnet_group_name

}