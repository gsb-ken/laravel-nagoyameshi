output "ecs_cluster_name" {
  description = "ECS Cluster name"
  value       = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_service_name" {
  description = "ECS Service name"
  value       = aws_ecs_service.ecs_service.name
}
output "app_task_definition_arn" {
  value = module.task_definition_app.ecs_task_definition_arn
}

output "migrate_task_definition_arn" {
  value = module.task_definition_migrate.ecs_task_definition_arn
}

output "migration_task_definition_family" {
  value = module.task_definition_migrate.task_definition_family
}

output "migration_task_definition_arn" {
  value = module.task_definition_migrate.task_definition_arn
}

output "migration_task_definition_name" {
  value = module.task_definition_migrate.task_definition_family
}

