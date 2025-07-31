variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
  description = "List of public subnet IDs to attach to ALB"
}

variable "security_group_ids" {
  type = list(string)
  description = "List of security group IDs to attach to ALB"
}
