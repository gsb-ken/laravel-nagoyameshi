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

variable "nat_mode" {

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
variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}
variable "db_password" {
  type = string
}
variable "db_username" {
  type = string
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
# SSM 変数 -------------------------------------------------
variable "env" { type = map(string) }

# Cloudwatch ----------------------------------------------
variable "region" {
  default = "ap-northeast-1"
}
variable "waf_web_acl_name" {}
variable "waf_rule_name" {}
variable "waf_scope" {}
variable "cloudfront_distribution_id" {}
variable "alb_arn_suffix" {}
variable "tg_arn_suffix" {}
variable "ecs_cluster_name" {}
variable "ecs_service_name" {}
variable "rds_instance_id" {}
variable "alert_email" {}

variable "threshold_waf_blocked_sum_1m" {
  type    = number
  default = 100
}
variable "threshold_cf_requests_sum_5m" {
  type    = number
  default = 10000
}
variable "threshold_cf_5xx_rate_avg_5m_percent" {
  type    = number
  default = 1.0
}
variable "threshold_alb_unhealthy_max_1m" {
  type    = number
  default = 1
}
variable "threshold_ecs_cpu_avg_5m_percent" {
  type    = number
  default = 80
}
variable "threshold_ecs_mem_avg_5m_percent" {
  type    = number
  default = 80
}
variable "threshold_ecs_taskcount_min_1m" {
  type    = number
  default = 1
}
variable "threshold_rds_cpu_avg_5m_percent" {
  type    = number
  default = 80
}
variable "threshold_rds_free_storage_min_gb" {
  type    = number
  default = 1
} # GB
variable "threshold_rds_conns_max_1m" {
  type    = number
  default = 900
} # max_connections=1000の90%
variable "ecs_retention" {
  type    = number
  default = 30
}
variable "rds_retention" {
  type    = number
  default = 30
}
variable "waf_retention" {
  type    = number
  default = 30
}
