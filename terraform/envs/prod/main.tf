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

  alb_target_group_arn  = module.alb.target_group_arn
  laravel_image         = var.laravel_image
  container_name        = var.container_name
  container_environment = var.container_environment
}

# -----------------------------
# RDS Password 生成
# -----------------------------
resource "random_password" "rds_password" {
  length  = 16
  special = true
}

# -----------------------------
# RDS Module 呼び出し
# -----------------------------
module "rds" {
  source = "../../modules/rds"

  project     = var.project
  environment = var.environment

  subnet_ids         = module.vpc.isolated_subnet_ids
  security_group_ids = [aws_security_group.rds_sg.id]

  db_name  = var.db_name
  username = var.db_username
  password = random_password.rds_password.result

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
# IAM Role
# ----------------------------


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
