resource "aws_ecs_task_definition" "migrate" {
  family                   = "${var.project}-${var.environment}-task-migrate"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "migrate"
      image     = var.laravel_image
      essential = true
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
      command = ["sh","-c","php artisan migrate --force; sleep 30"]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}-${var.environment}/task/migrate"
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}