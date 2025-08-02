variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "env_parameters" {
  type = map(string)
  description = "Laravel application environment variables"
}
variable "db_password" {
  type = string
}
variable "db_username" {
  type = string
}