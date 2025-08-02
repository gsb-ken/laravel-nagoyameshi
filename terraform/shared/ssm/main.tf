resource "aws_ssm_parameter" "laravel_env" {
  for_each = merge(
    var.env_parameters,
    {
      DB_PASSWORD = var.db_password
      DB_USERNAME = var.db_username
    }
  )

  name        = "/${var.project}/${var.environment}/${each.key}"
  type        = each.key == "DB_PASSWORD" ? "SecureString" : "String"
  value       = each.value
  overwrite   = true
  description = "Parameter for ${var.project} ${var.environment} (${each.key})"
}

