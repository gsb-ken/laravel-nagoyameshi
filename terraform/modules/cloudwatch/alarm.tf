locals {
  sns_arn = aws_sns_topic.alerts.arn
}

# ===== WAF BlockedRequests =====
resource "aws_cloudwatch_metric_alarm" "waf_blocked_high" {
  alarm_name          = "${local.name_prefix}-cloudwatch-alarm-waf-blocked"
  namespace           = "AWS/WAFV2"
  metric_name         = "BlockedRequests"
  statistic           = "Sum"
  period              = 60
  evaluation_periods  = 1
  threshold           = var.threshold_waf_blocked_sum_1m
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    WebACL = var.waf_web_acl_name
    Region = local.waf_region  # CLOUDFRONT=Global / REGIONAL=ap-northeast-1
  }
  alarm_actions = [local.sns_arn]
  ok_actions    = [local.sns_arn]
}

# ===== CloudFront Requests =====
resource "aws_cloudwatch_metric_alarm" "cf_requests_high" {
  alarm_name          = "${local.name_prefix}-cloudwatch-alarm-cloudfront-requests"
  namespace           = "AWS/CloudFront"
  metric_name         = "Requests"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = var.threshold_cf_requests_sum_5m
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    DistributionId = var.cloudfront_distribution_id
    Region         = "Global"
  }
  alarm_actions = [local.sns_arn]
  ok_actions    = [local.sns_arn]
}

# ===== CloudFront 5xx ErrorRate =====
resource "aws_cloudwatch_metric_alarm" "cf_5xx_rate_high" {
  alarm_name          = "${local.name_prefix}-cloudwatch-alarm-cloudfront-5xx"
  namespace           = "AWS/CloudFront"
  metric_name         = "5xxErrorRate"
  statistic           = "Average"
  unit                = "Percent"
  period              = 300
  evaluation_periods  = 1
  threshold           = var.threshold_cf_5xx_rate_avg_5m_percent
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    DistributionId = var.cloudfront_distribution_id
    Region         = "Global"
  }
  alarm_actions = [local.sns_arn]
  ok_actions    = [local.sns_arn]
}

# ===== ALB UnHealthyHostCount =====
resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {
  alarm_name          = "${local.name_prefix}-cloudwatch-alarm-alb-unhealthy-hosts"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "UnHealthyHostCount"
  statistic           = "Maximum"
  period              = 60
  evaluation_periods  = 1
  threshold           = var.threshold_alb_unhealthy_max_1m
  comparison_operator = "GreaterThanOrEqualToThreshold"
  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.tg_arn_suffix
  }
  alarm_actions = [local.sns_arn]
  ok_actions    = [local.sns_arn]
}

# ===== ECS CPU =====
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "${local.name_prefix}-cloudwatch-alarm-ecs-cpu"
  namespace           = "AWS/ECS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 1
  threshold           = var.threshold_ecs_cpu_avg_5m_percent
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }
  alarm_actions = [local.sns_arn]
  ok_actions    = [local.sns_arn]
}

# ===== ECS Memory =====
resource "aws_cloudwatch_metric_alarm" "ecs_mem_high" {
  alarm_name          = "${local.name_prefix}-cloudwatch-alarm-ecs-memory"
  namespace           = "AWS/ECS"
  metric_name         = "MemoryUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 1
  threshold           = var.threshold_ecs_mem_avg_5m_percent
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }
  alarm_actions = [local.sns_arn]
  ok_actions    = [local.sns_arn]
}

# ===== ECS RunningTaskCount =====
resource "aws_cloudwatch_metric_alarm" "ecs_taskcount_low" {
  alarm_name          = "${local.name_prefix}-cloudwatch-alarm-ecs-task-count"
  namespace           = "AWS/ECS"
  metric_name         = "RunningTaskCount"
  statistic           = "Minimum"
  period              = 60
  evaluation_periods  = 1
  threshold           = var.threshold_ecs_taskcount_min_1m
  comparison_operator = "LessThanThreshold"
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }
  alarm_actions = [local.sns_arn]
  ok_actions    = [local.sns_arn]
}

# ===== RDS CPU =====
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${local.name_prefix}-cloudwatch-alarm-rds-cpu"
  namespace           = "AWS/RDS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 1
  threshold           = var.threshold_rds_cpu_avg_5m_percent
  comparison_operator = "GreaterThanThreshold"
  dimensions = { DBInstanceIdentifier = var.rds_instance_id }
  alarm_actions = [local.sns_arn]
  ok_actions    = [local.sns_arn]
}

# ===== RDS FreeStorage (Bytes) =====
resource "aws_cloudwatch_metric_alarm" "rds_storage_low" {
  alarm_name          = "${local.name_prefix}-cloudwatch-alarm-rds-storage"
  namespace           = "AWS/RDS"
  metric_name         = "FreeStorageSpace"
  statistic           = "Minimum"
  period              = 300
  evaluation_periods  = 1
  threshold           = var.threshold_rds_free_storage_min_gb * 1024 * 1024 * 1024
  comparison_operator = "LessThanThreshold"
  dimensions = { DBInstanceIdentifier = var.rds_instance_id }
  alarm_actions = [local.sns_arn]
  ok_actions    = [local.sns_arn]
}

# ===== RDS Connections =====
resource "aws_cloudwatch_metric_alarm" "rds_conns_high" {
  alarm_name          = "${local.name_prefix}-cloudwatch-alarm-rds-conns"
  namespace           = "AWS/RDS"
  metric_name         = "DatabaseConnections"
  statistic           = "Maximum"
  period              = 60
  evaluation_periods  = 1
  threshold           = var.threshold_rds_conns_max_1m
  comparison_operator = "GreaterThanThreshold"
  dimensions = { DBInstanceIdentifier = var.rds_instance_id }
  alarm_actions = [local.sns_arn]
  ok_actions    = [local.sns_arn]
}
