variable "project" {}
variable "environment" {}

variable "aws_region" {
  default = "ap-northeast-1"
}

variable "aws_account_id" {}

variable "github_owner" {}
variable "github_repo" {}
variable "github_branch" {
  default = "main"
}

variable "buildspec_file" {
  description = "Relative path to buildspec.yml"
  default     = "buildspec.yml"
}

variable "ecr_repo_name" {}

variable "container_name" {}

variable "codebuild_role_arn" {
  description = "IAM role ARN for CodeBuild service"
}
variable "ecr_repo_url" {
  description = "ECR のリポジトリURL"
  type        = string
}
variable "ecs_cluster_name" {}
variable "migration_task_definition" {}
variable "subnet_id_1" {}
variable "subnet_id_2" {}
variable "security_group_id" {}
