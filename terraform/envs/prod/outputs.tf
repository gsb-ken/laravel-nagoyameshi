output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
# output "db_password" {
#   value     = random_password.db_password.result
#   sensitive = true
# }
output "alb_url" {
  value       = module.alb.alb_url
  description = "Full URL of the ALB"
}
