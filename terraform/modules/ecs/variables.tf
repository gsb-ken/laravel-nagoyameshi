variable "project" {
  type        = string
}
variable "environment" {
  type        = string
}
variable "aws_region" {
  type        = string
}
variable "cpu" {
  type        = string
  default     = "256"
}
variable "memory" {
  type        = string
  default     = "512"
}
variable "desired_count" {
  type        = number
  default     = 1
}
variable "subnet_ids" {
  type        = list(string)
}
variable "security_group_ids" {
  type        = list(string)
}
variable "alb_target_group_arn" {
  type        = string
}
variable "laravel_image" {
  type        = string
}
variable "container_name" {
  type        = string
}

variable "ecs_execution_role_arn" {
  type        = string
}
variable "ecs_task_role_arn" {
  type        = string
}

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