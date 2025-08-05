variable "project" { type = string }
variable "environment" { type = string }
variable "aws_region" { type = string }

variable "container_name" { type = string }
variable "laravel_image" { type = string }
variable "cpu" { type = number }
variable "memory" { type = number }

variable "ecs_execution_role_arn" { type = string }
variable "ecs_task_role_arn" { type = string }

variable "app_name"  { type = string }
variable "app_env"   { type = string }
variable "app_key"   { type = string }
variable "app_debug" { type = string }
variable "app_url"   { type = string }

variable "log_channel"              { type = string }
variable "log_deprecations_channel" { type = string }
variable "log_level"                { type = string }

variable "db_connection" { type = string }
variable "db_host"       { type = string }
variable "db_port"       { type = string }
variable "db_database"   { type = string }
variable "db_username"   { type = string }
variable "db_password"   { type = string }
variable "log_group_name" {
  type        = string
  description = "CloudWatch Logs group name"
}

variable "log_stream_prefix" {
  type        = string
  description = "CloudWatch Logs stream prefix"
}
