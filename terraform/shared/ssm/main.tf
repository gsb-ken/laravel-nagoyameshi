resource "aws_ssm_parameter" "env_parameters" {
  for_each = var.env_parameters
  
  name        = "/${var.project}/${var.environment}/${each.key}"
  type  = contains(var.env_secret_keys, each.key) ? "SecureString" : "String"
  value       = each.value

  tags = {
    Project = var.project
    Environment = var.environment
    Name = each.key
  }
}

