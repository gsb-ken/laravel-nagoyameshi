locals {
  name_prefix = "${var.project}-${var.environment}"
  waf_region  = var.waf_scope == "CLOUDFRONT" ? "Global" : var.region

  has_cf  = var.cloudfront_distribution_id != null && length(trimspace(var.cloudfront_distribution_id)) > 0
  has_alb = var.alb_arn_suffix != null && length(trimspace(var.alb_arn_suffix)) > 0 && var.tg_arn_suffix  != null && length(trimspace(var.tg_arn_suffix))  > 0
  has_ecs = var.ecs_cluster_name != null && length(trimspace(var.ecs_cluster_name)) > 0 && var.ecs_service_name != null && length(trimspace(var.ecs_service_name)) > 0
  has_rds = var.rds_instance_id  != null && length(trimspace(var.rds_instance_id))  > 0

  # 1: WAF
  widget_waf = {
    type   = "metric"
    x      = 0
    y      = 0
    width  = 24
    height = 6
    properties = {
      title  = "WAF Blocked Requests (rule: ${var.waf_rule_name})"
      view   = "timeSeries"
      region = var.region
      stat   = "Sum"
      period = 60
      metrics = [
        ["AWS/WAFV2", "BlockedRequests",
          "WebACL", var.waf_web_acl_name,
          "Rule",   var.waf_rule_name,
          "Region", local.waf_region
        ]
      ]
    }
  }

  # 2: CloudFront Requests
  widget_cf_requests = {
    type   = "metric"
    x      = 0
    y      = 6
    width  = 24
    height = 6
    properties = {
      title  = "CloudFront Requests"
      view   = "timeSeries"
      stat   = "Sum"
      period = 300
      region = var.region
      metrics = [
        ["AWS/CloudFront", "Requests", "DistributionId", var.cloudfront_distribution_id, "Region", "Global"]
      ]
    }
  }

  # 3: CloudFront 4xx/5xx ErrorRate
  widget_cf_error_rate = {
    type   = "metric"
    x      = 0
    y      = 12
    width  = 24
    height = 6
    properties = {
      title  = "CloudFront 4xx/5xx ErrorRate"
      view   = "timeSeries"
      stat   = "Average"
      period = 300
      region = var.region
      metrics = [
        ["AWS/CloudFront", "4xxErrorRate", "DistributionId", var.cloudfront_distribution_id, "Region", "Global"],
        ["AWS/CloudFront", "5xxErrorRate", "DistributionId", var.cloudfront_distribution_id, "Region", "Global"]
      ]
      # 必要なら y軸を % 固定:
      # "yAxis": { "left": { "min": 0, "max": 100 } }
    }
  }

    # 4: ALB UnHealthyHostCount
  widget_alb_unhealthy = {
    type   = "metric"
    x      = 0
    y      = 18
    width  = 24
    height = 6
    properties = {
      title  = "ALB UnHealthyHostCount"
      view   = "timeSeries"
      region = var.region
      stat   = "Maximum"
      period = 60
      metrics = [
        ["AWS/ApplicationELB", "UnHealthyHostCount",
          "LoadBalancer", var.alb_arn_suffix,
          "TargetGroup",  var.tg_arn_suffix
        ]
      ]
    }
  }

    # 5: ECS CPU / Memory
  widget_ecs_cpu_mem = {
    type   = "metric"
    x      = 0
    y      = 24
    width  = 24
    height = 6
    properties = {
      title  = "ECS CPU / Memory Utilization"
      view   = "timeSeries"
      region = var.region
      stat   = "Average"
      period = 300
      metrics = [
        ["AWS/ECS", "CPUUtilization",    "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name],
        ["AWS/ECS", "MemoryUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name]
      ]
    }
  }

    # 6: ECS RunningTaskCount
  widget_ecs_taskcount = {
    type   = "metric"
    x      = 0
    y      = 30
    width  = 24
    height = 6
    properties = {
      title  = "ECS RunningTaskCount"
      view   = "timeSeries"
      region = var.region
      stat   = "Minimum"
      period = 60
      metrics = [
        ["AWS/ECS", "RunningTaskCount", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name]
      ]
    }
  }

    # 7: RDS CPU Utilization
  widget_rds_cpu = {
    type   = "metric"
    x      = 0
    y      = 36
    width  = 24
    height = 6
    properties = {
      title  = "RDS CPUUtilization"
      view   = "timeSeries"
      region = var.region
      stat   = "Average"
      period = 300
      metrics = [
        ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.rds_instance_id]
      ]
    }
  }

  # 8: RDS FreeStorageSpace を GB で表示
  widget_rds_free_gb = {
    type   = "metric"
    x      = 0
    y      = 42
    width  = 24
    height = 6
    properties = {
      title  = "RDS FreeStorageSpace (GB)"
      view   = "timeSeries"
      region = var.region
      stat   = "Minimum"
      period = 300
      metrics = [
        [ { "expression": "m1/1024/1024/1024", "label": "FreeStorage (GB)", "id": "e1" } ],
        [ "AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", var.rds_instance_id, { "id": "m1", "visible": false } ]
      ],
      yAxis = { left = { min = 0 } }
    }
  }

  # 9: RDS DatabaseConnections（接続数）
  widget_rds_conns = {
    type   = "metric"
    x      = 0
    y      = 48
    width  = 24
    height = 6
    properties = {
      title  = "RDS DatabaseConnections"
      view   = "timeSeries"
      region = var.region
      stat   = "Maximum"
      period = 60
      metrics = [
        ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", var.rds_instance_id]
      ]
    }
  }

  widgets = [
    for w in [
      local.widget_waf,
      local.has_cf  ? local.widget_cf_requests    : null,
      local.has_cf  ? local.widget_cf_error_rate  : null,
      local.has_alb ? local.widget_alb_unhealthy  : null,
      local.has_ecs ? local.widget_ecs_cpu_mem    : null,
      local.has_ecs ? local.widget_ecs_taskcount  : null,
      local.has_rds ? local.widget_rds_cpu        : null,
      local.has_rds ? local.widget_rds_free_gb    : null,
      local.has_rds ? local.widget_rds_conns      : null
    ] : w if w != null
  ]
}


  



resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = "${local.name_prefix}-cloudwatch-dashboard"
  dashboard_body = jsonencode({
    widgets = local.widgets
  })
}
