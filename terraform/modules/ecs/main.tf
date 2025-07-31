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
# IAM Role
# ----------------------------
resource "aws_iam_role" "execution_role" {
  name = "${var.project}-${var.environment}-iam-role-ecs-exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "ecs_exec_attach" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task_role" {
  name = "${var.project}-${var.environment}-iam-role-ecs-task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy" "ecs_task_policy" {
  name = "${var.project}-${var.environment}-ecs-task-policy"
  role = aws_iam_role.task_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject"
        ],
        Resource = "*"
      }
    ]
  })
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

  execution_role_arn = aws_iam_role.execution_role.arn
  task_role_arn      = aws_iam_role.task_role.arn

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
      environment = var.container_environment
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}-${var.environment}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
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
# ----------------------------
# Log Group
# ----------------------------
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.project}-${var.environment}"
  retention_in_days = 7  # 任意、7日間ログ保持

  tags = {
    Name    = "${var.project}-${var.environment}-ecs-log-group"
    Project = var.project
    Env     = var.environment
  }
}
