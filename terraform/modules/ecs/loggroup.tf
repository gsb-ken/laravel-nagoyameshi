resource "aws_cloudwatch_log_group" "ecs_app" {
  name              = "/ecs/${var.project}-${var.environment}/task/app"
  retention_in_days = 7
}


resource "aws_cloudwatch_log_group" "ecs_migrate" {
  name              = "/ecs/${var.project}-${var.environment}/task/migrate"
  retention_in_days = 7
}
