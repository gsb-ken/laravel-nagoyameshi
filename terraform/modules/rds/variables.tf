variable "project" {
  type = string
}
variable "environment" {
  type = string
}
variable "subnet_ids" {
  type        = list(string)
  description = "Isolated subnet IDs for RDS"
}
variable "security_group_ids" {
  type        = list(string)
  description = "RDS security group IDs"
}
variable "db_name" {
  type = string
}
variable "username" {
  type = string
}
variable "password" {
  type      = string
  sensitive = true
}
variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}
variable "allocated_storage" {
  type    = number
  default = 20
}
variable "multi_az" {
  type    = bool
  default = true
}
