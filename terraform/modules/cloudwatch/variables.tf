variable "project"      {}
variable "environment"  {}
variable "region"       {}

# WAF（CloudFront 連携の想定）
variable "waf_web_acl_name" {}        # 例
variable "waf_rule_name"    {}            # 例
# WAF のスコープ: CloudFrontにアタッチなら "CLOUDFRONT"（Region は必ず "Global"）
variable "waf_scope"        { default = "CLOUDFRONT" }

variable "cloudfront_distribution_id" {
  type    = string
  default = null
}

# ALB / Target Group の ARNサフィックス
variable "alb_arn_suffix" {
  type    = string
  default = null
}
variable "tg_arn_suffix" {
  type    = string
  default = null
}

variable "ecs_cluster_name" {
  type    = string
  default = null
}
variable "ecs_service_name" {
  type    = string
  default = null
}

variable "rds_instance_id" {
  type    = string
  default = null
}

variable "alert_email" {
  description = "通知を送るEmailアドレス"
  type        = string
}

variable "threshold_waf_blocked_sum_1m"         {
   type = number
    default = 100   
    }
variable "threshold_cf_requests_sum_5m"         { 
  type = number
   default = 10000 
   }
variable "threshold_cf_5xx_rate_avg_5m_percent" { 
  type = number
   default = 1.0  
    }
variable "threshold_alb_unhealthy_max_1m"       { 
  type = number
   default = 1    
    }
variable "threshold_ecs_cpu_avg_5m_percent"     {
   type = number
    default = 80    
    }
variable "threshold_ecs_mem_avg_5m_percent"     {
   type = number
    default = 80    
    }
variable "threshold_ecs_taskcount_min_1m"       { 
  type = number
  default = 1     
  }
variable "threshold_rds_cpu_avg_5m_percent"     { 
  type = number
   default = 80    
   }
variable "threshold_rds_free_storage_min_gb"    { 
  type = number
  default = 1    
   } # GB
variable "threshold_rds_conns_max_1m"           {
   type = number
    default = 900   
    } # max_connections=1000の90%

variable "ecs_retention" { 
  type = number
   default = 30 
   }
variable "rds_retention" {
   type = number
    default = 30 
    }
variable "waf_retention" {
   type = number
    default = 30 
    }
