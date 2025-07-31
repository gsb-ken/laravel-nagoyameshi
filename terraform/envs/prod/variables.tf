#------------------------------
# Variable
#------------------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}
variable "isolated_subnet_cidrs" {
  type = list(string)
}

variable "aws_region" {
  type = string
}

# ECS関連 -------------------------------------------------
variable "ecs_cpu" {
  default = "256"
}
variable "ecs_memory" {
  default = "512"
}
variable "ecs_desired_count" {
  default = 2
}
variable "laravel_image" {}
variable "container_name" {
  default = "nagoyameshi-prod-ecs-container"
}
variable "container_environment" {
  type    = list(object({ name = string, value = string }))
  default = []
}

# RDS関連 --------------------------------------------------
variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}
# db_passwordはrandom_passwordで生成している