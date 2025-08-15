#------------------------------
# Variable
#------------------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}
variable "isolated_subnet_cidrs" {
  type = list(string)
}

variable "aws_region" {
  type = string
}

# ECS関連 -------------------------------------------------
variable "ecs_cpu" {
  default = "256"
}
variable "ecs_memory" {
  default = "512"
}
variable "ecs_desired_count" {
  default = 2
}
variable "laravel_image" {}
variable "container_name" {
  default = "nagoyameshi-prod-ecs-container"
}
variable "ecr_repository_url" {
  description = "ECR repository URL for the Laravel image"
  type        = string
}


# RDS関連 --------------------------------------------------
variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}
variable "db_password" {
  type      = string
  sensitive = true
}

variable "github_owner" {
  description = "GitHub username or organization name"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branch" {
  description = "Branch to track (e.g. main)"
  type        = string
  default     = "main"
}

variable "github_oauth_token" {
  description = "GitHub Personal Access Token for CodePipeline"
  type        = string
  sensitive   = true
}
variable "codestar_connection_arn" {
  type        = string
  description = "CodeStar Connections ARN for GitHub"
}

variable "app_name" { type = string }
variable "app_env" { type = string }
variable "app_key" { type = string }
variable "app_debug" { type = string }

variable "log_channel" { type = string }
variable "log_deprecations_channel" { type = string }
variable "log_level" { type = string }

variable "db_connection" { type = string }
variable "db_host" { type = string }
variable "db_port" { type = string }
variable "db_database" { type = string }

variable "filesystem_disk" { type = string }
variable "aws_default_region" { type = string }
variable "aws_bucket" { type = string }
variable "aws_url" { type = string }
variable "aws_use_path_style_endpoint" { type = string }