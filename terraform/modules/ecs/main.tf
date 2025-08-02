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

# ------------------------------
# Task Definition
# ------------------------------
resource "aws_ecs_task_definition" "ecs-task" {
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
    environment = [
      for key, value in var.container_environment :
      {
        name  = key
        value = value
      }
      if !contains([
        "APP_ENV",
        "APP_DEBUG",
        "APP_URL",
        "DB_CONNECTION",
        "DB_HOST",
        "DB_PORT",
        "DB_DATABASE",
        "DB_USERNAME",
        "DB_PASSWORD"
      ], key)
    ],
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/${var.project}-${var.environment}/task"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    },
    secrets = [
      for key in [
        "APP_ENV",
        "APP_DEBUG",
        "APP_URL",
        "DB_CONNECTION",
        "DB_HOST",
        "DB_PORT",
        "DB_DATABASE",
        "DB_USERNAME",
        "DB_PASSWORD"
      ] : {
        name      = key
        valueFrom = "/${var.project}/${var.environment}/${key}"
      }
    ]
  }
])
}


# ----------------------------
# ECS Service
# ----------------------------
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.project}-${var.environment}-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs-task.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  network_configuration {
    subnets         = var.subnet_ids
    security_groups  = var.security_group_ids
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
