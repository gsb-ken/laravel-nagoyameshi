variable "project" { type = string }
variable "environment" { type = string }
variable "aws_region" { type = string }

variable "container_name" { type = string }
variable "laravel_image" { type = string }
variable "cpu" { type = number }
variable "memory" { type = number }

variable "ecs_execution_role_arn" { type = string }
variable "ecs_task_role_arn" { type = string }

variable "log_group_name" {
  type        = string
  description = "CloudWatch Logs group name"
}

variable "log_stream_prefix" {
  type        = string
  description = "CloudWatch Logs stream prefix"
}
variable "ssm_dependency" {
  description = "Dependency on the SSM module to ensure parameters are created first"
  type        = any
}