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

variable "ssm_dependency" {
  description = "Dependency on the SSM module to ensure parameters are created first"
  type        = any
}
