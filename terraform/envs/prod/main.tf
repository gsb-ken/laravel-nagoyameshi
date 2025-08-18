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

  subnet_ids           = module.vpc.private_subnet_ids
  security_group_ids   = [aws_security_group.ecs_sg.id]
  alb_target_group_arn = module.alb.target_group_arn

  laravel_image          = var.laravel_image
  container_name         = var.container_name
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  ecs_task_role_arn      = module.iam.ecs_task_role_arn

  ssm_dependency = module.ssm
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
  multi_az       = false
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
  project                   = var.project
  environment               = var.environment
  aws_account_id            = data.aws_caller_identity.current.account_id
  aws_region                = var.aws_region
  artifact_bucket           = module.s3.artifact_bucket
  codestar_connection_arn   = var.codestar_connection_arn
  codebuild_project_name    = module.codebuild.name
  migration_task_definition = module.ecs.migrate_task_definition_arn
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
  migration_task_definition = module.ecs.migration_task_definition_name
  subnet_id_1               = module.vpc.private_subnet_ids[0]
  subnet_id_2               = try(module.vpc.private_subnet_ids[1], module.vpc.private_subnet_ids[0])
  security_group_id         = aws_security_group.ecs_sg.id
  codebuild_role_arn        = module.iam.codebuild_role_arn
  public_subnet_id_1        = module.vpc.public_subnet_ids[0]
  public_subnet_id_2        = try(module.vpc.public_subnet_ids[1], module.vpc.public_subnet_ids[0])
}

# ----------------------------
# SSM Module 呼び出し
# ----------------------------
module "ssm" {
  source      = "../../modules/ssm"
  project     = var.project
  environment = var.environment
  env         = var.env
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

# ----------------------------
# Cloudwatch Module 呼び出し
# ----------------------------
module "cloudwatch" {
  source = "../../modules/cloudwatch"

  project     = var.project
  environment = var.environment
  region      = var.region

  waf_web_acl_name           = var.waf_web_acl_name
  waf_rule_name              = var.waf_rule_name
  waf_scope                  = var.waf_scope
  cloudfront_distribution_id = var.cloudfront_distribution_id

  alb_arn_suffix = var.alb_arn_suffix
  tg_arn_suffix  = var.tg_arn_suffix

  ecs_cluster_name = var.ecs_cluster_name
  ecs_service_name = var.ecs_service_name

  rds_instance_id = var.rds_instance_id

  alert_email = var.alert_email

  threshold_waf_blocked_sum_1m         = var.threshold_waf_blocked_sum_1m
  threshold_cf_requests_sum_5m         = var.threshold_cf_requests_sum_5m
  threshold_cf_5xx_rate_avg_5m_percent = var.threshold_cf_5xx_rate_avg_5m_percent
  threshold_alb_unhealthy_max_1m       = var.threshold_alb_unhealthy_max_1m
  threshold_ecs_cpu_avg_5m_percent     = var.threshold_ecs_cpu_avg_5m_percent
  threshold_ecs_mem_avg_5m_percent     = var.threshold_ecs_mem_avg_5m_percent
  threshold_ecs_taskcount_min_1m       = var.threshold_ecs_taskcount_min_1m
  threshold_rds_cpu_avg_5m_percent     = var.threshold_rds_cpu_avg_5m_percent
  threshold_rds_free_storage_min_gb    = var.threshold_rds_free_storage_min_gb
  threshold_rds_conns_max_1m           = var.threshold_rds_conns_max_1m
  ecs_retention                        = var.ecs_retention
  rds_retention                        = var.rds_retention
  waf_retention                        = var.waf_retention

}



# AWS アカウント ID を取得
data "aws_caller_identity" "current" {}
