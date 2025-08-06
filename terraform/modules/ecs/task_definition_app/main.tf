resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project}-${var.environment}-ecs-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  execution_role_arn = var.ecs_execution_role_arn
  task_role_arn      = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.laravel_image
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ],
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}-${var.environment}/task/app"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      },
      environment = [
        { name = "APP_NAME",  value = var.app_name },
        { name = "APP_ENV",   value = var.app_env },
        { name = "APP_KEY",   value = var.app_key },
        { name = "APP_DEBUG", value = var.app_debug },
        { name = "APP_URL",   value = var.app_url },

        { name = "LOG_CHANNEL",              value = var.log_channel },
        { name = "LOG_DEPRECATIONS_CHANNEL", value = var.log_deprecations_channel },
        { name = "LOG_LEVEL",                value = var.log_level },

        { name = "DB_CONNECTION", value = var.db_connection },
        { name = "DB_HOST",       value = var.db_host },
        { name = "DB_PORT",       value = var.db_port },
        { name = "DB_DATABASE",   value = var.db_database },
        { name = "DB_USERNAME",   value = var.db_username },
        { name = "DB_PASSWORD",   value = var.db_password }
      ]
    }
  ])
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.app.arn
}
