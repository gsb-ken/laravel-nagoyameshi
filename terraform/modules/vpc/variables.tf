variable "project" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "cidr_block" {
  type        = string
}

variable "availability_zones" {
  type        = list(string)
}

variable "public_subnet_cidrs" {
  type        = list(string)
}

variable "private_subnet_cidrs" {
  type        = list(string)
}

variable "isolated_subnet_cidrs" {
  type        = list(string)
}

variable "nat_mode" {
  type        = string
  description = "NAT mode: none | single | ha"
  default     = "single"
}
