# ----------------------------
# ECS Cluster
# ----------------------------
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project}-${var.environment}-ecs-cluster"

  tags = {
    Name    = "${var.project}-${var.environment}-ecs-cluster"
    Project = var.project
    Env     = var.environment
  }
}

# ----------------------------
# ECS Service (Laravel App)
# ----------------------------
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.project}-${var.environment}-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = module.task_definition_app.task_definition_arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  enable_execute_command = true

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.container_name
    container_port   = 80
  }

  tags = {
    Name    = "${var.project}-${var.environment}-ecs-service"
    Project = var.project
    Env     = var.environment
  }
}

# ----------------------------
# App Task Definition Module
# ----------------------------
module "task_definition_app" {
  source = "./task_definition_app"

  project         = var.project
  environment     = var.environment
  container_name  = var.container_name
  laravel_image   = var.laravel_image
  aws_region      = var.aws_region
  cpu             = var.cpu
  memory          = var.memory

  log_group_name    = "/ecs/${var.project}-${var.environment}/task/migrate"
  log_stream_prefix = "ecs-migrate"

  ecs_execution_role_arn = var.ecs_execution_role_arn
  ecs_task_role_arn      = var.ecs_task_role_arn
  ssm_dependency = var.ssm_dependency

}

# ----------------------------
# Migrate Task Definition Module
# ----------------------------
module "task_definition_migrate" {
  source = "./task_definition_migrate"

  project     = var.project
  environment = var.environment
  aws_region  = var.aws_region

  cpu            = var.cpu
  memory         = var.memory
  container_name = var.container_name
  laravel_image  = var.laravel_image

  log_group_name    = "/ecs/${var.project}-${var.environment}/task/migrate"
  log_stream_prefix = "ecs-migrate"

  ecs_execution_role_arn = var.ecs_execution_role_arn
  ecs_task_role_arn      = var.ecs_task_role_arn
  ssm_dependency = var.ssm_dependency

}
