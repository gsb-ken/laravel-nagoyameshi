variable "project"     { type = string }
variable "environment" { type = string }
variable "env" {
  description = ".env の key=value を map(string) で渡す"
  type        = map(string)
}
