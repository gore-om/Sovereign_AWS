resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.project_name}-backend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-backend"
      image     = "${var.backend_image_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = var.backend_port
          protocol      = "tcp"
        }
      ]

      secrets = [
        {
          name      = "DATABASE_URL"
          valueFrom = "${var.secret_arn}:DATABASE_URL::"
        },
        {
          name      = "DB_HOST"
          valueFrom = "${var.secret_arn}:DB_HOST::"
        },
        {
          name      = "DB_PORT"
          valueFrom = "${var.secret_arn}:DB_PORT::"
        },
        {
          name      = "DB_NAME"
          valueFrom = "${var.secret_arn}:DB_NAME::"
        },
        {
          name      = "DB_USER"
          valueFrom = "${var.secret_arn}:DB_USER::"
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = "${var.secret_arn}:DB_PASSWORD::"
        },
        {
          name      = "DB_SSL"
          valueFrom = "${var.secret_arn}:DB_SSL::"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.backend_log_group_name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "frontend" {
  family                   = "${var.project_name}-frontend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-frontend"
      image     = "${var.frontend_image_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = var.frontend_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.frontend_log_group_name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "backend" {
  name            = "${var.project_name}-backend-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.backend_target_group_arn
    container_name   = "${var.project_name}-backend"
    container_port   = var.backend_port
  }

  depends_on = [aws_ecs_task_definition.backend]
}

resource "aws_ecs_service" "frontend" {
  name            = "${var.project_name}-frontend-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.frontend_target_group_arn
    container_name   = "${var.project_name}-frontend"
    container_port   = var.frontend_port
  }

  depends_on = [aws_ecs_task_definition.frontend]
}