#------------------------------
# Terradorm configuration
#------------------------------
terraform {
  required_version = "1.12.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

#------------------------------
# VPC Module 呼び出し
#------------------------------
module "vpc" {
  source                = "../../modules/vpc"
  project               = var.project
  environment           = var.environment
  cidr_block            = var.vpc_cidr_block
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  isolated_subnet_cidrs = var.isolated_subnet_cidrs
}

#------------------------------
# ALB Module 呼び出し
#------------------------------
module "alb" {
  source = "../../modules/alb"

  project            = var.project
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [aws_security_group.alb_sg.id]
}

#------------------------------
# ECS Module 呼び出し
#------------------------------
module "ecs" {
  source = "../../modules/ecs"

  project     = var.project
  environment = var.environment
  aws_region  = var.aws_region

  cpu           = var.ecs_cpu
  memory        = var.ecs_memory
  desired_count = var.ecs_desired_count

  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [aws_security_group.ecs_sg.id]

  alb_target_group_arn   = module.alb.target_group_arn
  laravel_image          = var.laravel_image
  container_name         = var.container_name
  container_environment  = var.container_environment
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  ecs_task_role_arn      = module.iam.ecs_task_role_arn
}

#------------------------------
# ECS Migrate Module 呼び出し
#------------------------------
module "ecs_migrate_task" {
  source      = "../../modules/ecs/task_definition_migrate"
  project     = var.project
  environment = var.environment
  aws_region  = var.aws_region

  cpu                    = var.ecs_cpu
  memory                 = var.ecs_memory
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn

  laravel_image         = var.laravel_image
  container_name        = var.container_name
  container_environment = []
  log_group_name        = "/ecs/${var.project}-${var.environment}"
  log_stream_prefix     = "ecs-migrate"
}

# -----------------------------
# RDS Password 生成
# -----------------------------
# resource "random_password" "db_password" {
#   length  = 16
#   special = true
# }
# output "generated_db_password" {
#   value     = random_password.db_password.result
#   sensitive = true
# }


# -----------------------------
# RDS Module 呼び出し
# -----------------------------
module "rds" {
  source = "../../modules/rds"

  project     = var.project
  environment = var.environment

  subnet_ids         = module.vpc.isolated_subnet_ids
  security_group_ids = [aws_security_group.rds_sg.id]

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  instance_class = var.db_instance_class
  multi_az       = true
}


# ----------------------------
# Security Group
# ----------------------------

# alb security group
resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-${var.environment}-alb-sg"
  description = "Allow HTTP from CloudFront"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP from CloudFront"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project}-${var.environment}-alb-sg"
    Project = var.project
    Env     = var.environment
  }
}

# ecs security group
resource "aws_security_group" "ecs_sg" {
  name        = "${var.project}-${var.environment}-ecs-sg"
  description = "Allow traffic from ALB only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project}-${var.environment}-ecs-sg"
    Project = var.project
    Env     = var.environment
  }
}

# rds security group
resource "aws_security_group" "rds_sg" {
  name        = "${var.project}-${var.environment}-rds-sg"
  description = "Allow MySQL from ECS only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow MySQL from ECS"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  tags = {
    Name    = "${var.project}-${var.environment}-rds-sg"
    Project = var.project
    Env     = var.environment
  }
}


# ----------------------------
# IAM Role Module 呼び出し
# ----------------------------
module "iam" {
  source                    = "../../modules/iam"
  project                   = "nagoyameshi"
  environment               = "prod"
  aws_account_id            = data.aws_caller_identity.current.account_id
  aws_region                = var.aws_region
  artifact_bucket           = module.s3.artifact_bucket
  codestar_connection_arn   = var.codestar_connection_arn
  codebuild_project_name    = module.codebuild.name
  migration_task_definition = module.ecs_migrate_task.task_definition_arn
}

# ----------------------------
# SSM Module 呼び出し
# ----------------------------
module "ssm_parameters" {
  source      = "../../shared/ssm"
  project     = var.project
  environment = var.environment
  db_password = var.db_password
  db_username = var.db_username
  env_parameters = merge(
    var.env_parameters,
    {
      APP_URL = "http://${module.alb.alb_dns_name}"
      DB_HOST = module.rds.rds_endpoint
    }
  )
}

# ----------------------------
# Codepipeline Module 呼び出し
# ----------------------------
module "codepipeline" {
  source = "../../modules/codepipeline"

  project                 = var.project
  environment             = var.environment
  github_owner            = var.github_owner
  github_repo             = var.github_repo
  github_branch           = var.github_branch
  github_oauth_token      = var.github_oauth_token
  codebuild_project_name  = module.codebuild.name
  codepipeline_role_arn   = module.iam.codepipeline_role_arn
  artifact_bucket         = module.s3.artifact_bucket
  ecs_cluster_name        = module.ecs.ecs_cluster_name
  ecs_service_name        = module.ecs.ecs_service_name
  codestar_connection_arn = var.codestar_connection_arn
}


# ----------------------------
# Codebuild Module 呼び出し
# ----------------------------
module "codebuild" {
  source = "../../modules/codebuild"

  project     = var.project
  environment = var.environment

  aws_region     = var.aws_region
  aws_account_id = data.aws_caller_identity.current.account_id

  github_owner   = var.github_owner
  github_repo    = var.github_repo
  github_branch  = var.github_branch
  buildspec_file = "buildspec.yml"

  ecr_repo_name             = module.ecr.repository_name
  ecr_repo_url              = module.ecr.repository_url
  container_name            = var.container_name
  ecs_cluster_name          = module.ecs.ecs_cluster_name
  migration_task_definition = module.ecs_migrate_task.ecs_task_definition_arn
  subnet_id_1               = module.vpc.public_subnet_ids[0]
  subnet_id_2               = module.vpc.public_subnet_ids[1]
  security_group_id         = aws_security_group.ecs_sg.id
  codebuild_role_arn        = module.iam.codebuild_role_arn
}

# ----------------------------
# S3 Module 呼び出し
# ----------------------------
module "s3" {
  source      = "../../modules/s3"
  project     = var.project
  environment = var.environment
}


# ----------------------------
# ECR Module 呼び出し
# ----------------------------
module "ecr" {
  source      = "../../modules/ecr"
  project     = var.project
  environment = var.environment
}


# AWS アカウント ID を取得
data "aws_caller_identity" "current" {}

# resource "aws_iam_role" "iam_role_codebuild" {
#   name = "${var.project}-${var.environment}-iam-role-codebuild"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect = "Allow",
#       Principal = {
#         Service = "codebuild.amazonaws.com"
#       },
#       Action = "sts:AssumeRole"
#     }]
#   })
# }
# resource "aws_iam_role_policy_attachment" "codebuild_ecr_attach" {
#   role       = aws_iam_role.iam_role_codebuild.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
# }
# resource "aws_iam_role_policy_attachment" "codebuild_logs_attach" {
#   role       = aws_iam_role.iam_role_codebuild.name
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
# }
# resource "aws_iam_role_policy_attachment" "codebuild_s3_attach" {
#   role       = aws_iam_role.iam_role_codebuild.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
# }


# resource "aws_iam_role" "iam_role_codepipeline" {
#   name = "${var.project}-${var.environment}-iam-role-codepipeline"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect = "Allow",
#       Principal = {
#         Service = "codepipeline.amazonaws.com"
#       },
#       Action = "sts:AssumeRole"
#     }]
#   })
# }
# resource "aws_iam_policy" "iam_policy_codepipeline" {
#   name = "${var.project}-${var.environment}-iam-policy-codepipeline"
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "codebuild:BatchGetBuilds",
#           "codebuild:StartBuild",
#           "ecs:UpdateService",
#           "iam:PassRole"
#         ],
#         Resource = "*"
#       },
#       {
#         Effect   = "Allow",
#         Action   = ["s3:GetObject"],
#         Resource = "arn:aws:s3:::${var.s3_bucket_name}/*" #todo #s3未作成
#       }
#     ]
#   })
# }
# resource "aws_iam_role_policy_attachment" "codepipeline_attach" {
#   role       = aws_iam_role.iam_role_codepipeline.name
#   policy_arn = aws_iam_policy.iam_policy_codepipeline.arn
# }
