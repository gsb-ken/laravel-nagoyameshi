output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.migrate.arn
}

output "task_definition_family" {
  value = aws_ecs_task_definition.migrate.family
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.migrate.arn
}
