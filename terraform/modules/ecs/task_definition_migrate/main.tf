resource "aws_ecs_task_definition" "migrate" {
  family                   = "${var.project}-${var.environment}-migrate"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  execution_role_arn = var.ecs_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.laravel_image
      essential = true
      command   = ["sh", "-c", "php artisan migrate --force"]
      environment = var.container_environment
      logConfiguration = {
        logDriver = "awslogs"
        options = {
        awslogs-region        = var.aws_region
        awslogs-group         = var.log_group_name
        awslogs-stream-prefix = var.log_stream_prefix
        }
      }
    }
  ])
}

# ----------------------------
# Log Group
# ----------------------------
resource "aws_cloudwatch_log_group" "migrate_log_group" {
  name              = "/ecs/migrate/${var.project}-${var.environment}"
  retention_in_days = 7  # 任意、7日間ログ保持

  tags = {
    Name    = "${var.project}-${var.environment}-ecs-migrate-log-group"
    Project = var.project
    Env     = var.environment
  }
}
