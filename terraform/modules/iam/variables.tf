variable "project" {
  type        = string
}

variable "environment" {
  type        = string
}
variable "codestar_connection_arn" {
  description = "ARN of the CodeStar connection to GitHub"
  type        = string
}
variable "artifact_bucket" {
  description = "Name of the S3 bucket used for CodePipeline artifacts"
  type        = string
}
variable "codebuild_project_name" {
  description = "Name of the CodeBuild project triggered by CodePipeline"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}
variable "migration_task_definition" {
  description = "マイグレーション用のタスク定義名"
  type        = string
}
