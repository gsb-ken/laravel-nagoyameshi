output "endpoint" {
  value = aws_db_instance.rds.endpoint
}

output "db_instance_identifier" {
  value = aws_db_instance.rds.id
}
