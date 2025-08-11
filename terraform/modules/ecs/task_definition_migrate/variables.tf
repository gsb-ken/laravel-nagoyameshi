variable "project" { type = string }
variable "environment" { type = string }
variable "aws_region" { type = string }
variable "cpu" { type = number }
variable "memory" { type = number }
variable "container_name" { type = string }
variable "log_group_name" { type = string }
variable "log_stream_prefix" { type = string }

variable "laravel_image" { type = string }

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

variable "filesystem_disk" {type = string}
variable "aws_default_region" {type = string}
variable "aws_bucket" {type = string}
variable "aws_url" {type = string}
variable "aws_use_path_style_endpoint" {type = string}

variable "ecs_execution_role_arn" { type = string }
variable "ecs_task_role_arn"      { type = string }
