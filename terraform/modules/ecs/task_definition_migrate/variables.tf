variable "project" {}
variable "environment" {}
variable "aws_region" {}

variable "cpu" {}
variable "memory" {}

variable "container_name" {}
variable "laravel_image" {}
variable "container_environment" {
  type    = list(object({ name = string, value = string }))
  default = []
}
variable "ecs_execution_role_arn" {
  type        = string
}
variable "log_group_name" {
  type        = string
  description = "CloudWatch Logs group name"
}

variable "log_stream_prefix" {
  type        = string
  description = "CloudWatch Logs stream prefix"
}