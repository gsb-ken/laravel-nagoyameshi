output "merged_env_parameters" {
  value = merge(
    var.env_parameters,
    {
      DB_PASSWORD = var.db_password
      DB_USERNAME = var.db_username
    }
  )
}
