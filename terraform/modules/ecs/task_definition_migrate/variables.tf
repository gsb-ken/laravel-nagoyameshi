variable "project" { type = string }
variable "environment" { type = string }
variable "aws_region" { type = string }
variable "cpu" { type = number }
variable "memory" { type = number }
variable "container_name" { type = string }
variable "log_group_name" { type = string }
variable "log_stream_prefix" { type = string }

variable "laravel_image" { type = string }

variable "ecs_execution_role_arn" { type = string }
variable "ecs_task_role_arn"      { type = string }

variable "ssm_dependency" {
  description = "Dependency on the SSM module to ensure parameters are created first"
  type        = any
}