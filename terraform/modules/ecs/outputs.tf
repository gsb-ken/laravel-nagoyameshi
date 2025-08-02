output "ecs_cluster_name" {
  description = "ECS Cluster name"
  value       = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_service_name" {
  description = "ECS Service name"
  value       = aws_ecs_service.ecs_service.name
}

output "ecs_task_definition_arn" {
  description = "ECS Task Definition ARN"
  value       = aws_ecs_task_definition.ecs-task.arn
}