output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
output "db_password" {
  value     = random_password.rds_password.result
  sensitive = true
}