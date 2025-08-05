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
      secrets = [
      for key in var.env_secret_keys : {
        name  = key
        valueFrom = "/${var.project}/${var.environment}/${key}"
      }
    ],
    environment = [
      for env in var.container_environment  : {
        name = env.name
        value = env.value
      }
      if !contains(var.env_secret_keys,env.name)
    ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
        awslogs-region        = var.aws_region
        awslogs-group         = "/ecs/${var.project}-${var.environment}/task/migrate"
        awslogs-stream-prefix = var.log_stream_prefix
        }
      }
    }
  ])
}
resource "aws_cloudwatch_log_group" "migrate" {
  name              = "/ecs/${var.project}-${var.environment}/task/migrate"
  retention_in_days = 7
}
