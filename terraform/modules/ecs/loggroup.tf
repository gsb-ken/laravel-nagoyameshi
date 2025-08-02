resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.project}-${var.environment}"
  retention_in_days = 7

  tags = {
    Name    = "${var.project}-${var.environment}-ecs-log-group"
    Project = var.project
    Env     = var.environment
  }
}


resource "aws_cloudwatch_log_group" "ecs_task_log_group" {
  name              = "/ecs/${var.project}-${var.environment}/task"
  retention_in_days = 7

  tags = {
    Name    = "${var.project}-${var.environment}-ecs-task-log-group"
    Project = var.project
    Env     = var.environment
  }
}
