# APP_NAME
resource "aws_ssm_parameter" "app_name" {
  name      = "/${var.project}/${var.environment}/APP_NAME"
  type      = "SecureString"
  value     = var.env["APP_NAME"]
  overwrite = true
}

# APP_ENV
resource "aws_ssm_parameter" "app_env" {
  name      = "/${var.project}/${var.environment}/APP_ENV"
  type      = "SecureString"
  value     = var.env["APP_ENV"]
  overwrite = true
}

# APP_KEY
resource "aws_ssm_parameter" "app_key" {
  name      = "/${var.project}/${var.environment}/APP_KEY"
  type      = "SecureString"
  value     = var.env["APP_KEY"]
  overwrite = true
}

# APP_DEBUG
resource "aws_ssm_parameter" "app_debug" {
  name      = "/${var.project}/${var.environment}/APP_DEBUG"
  type      = "SecureString"
  value     = var.env["APP_DEBUG"]
  overwrite = true
}

# APP_URL
resource "aws_ssm_parameter" "app_url" {
  name      = "/${var.project}/${var.environment}/APP_URL"
  type      = "SecureString"
  value     = var.env["APP_URL"]
  overwrite = true
}

# LOG_CHANNEL
resource "aws_ssm_parameter" "log_channel" {
  name      = "/${var.project}/${var.environment}/LOG_CHANNEL"
  type      = "SecureString"
  value     = var.env["LOG_CHANNEL"]
  overwrite = true
}

# LOG_DEPRECATIONS_CHANNEL
resource "aws_ssm_parameter" "log_deprecations_channel" {
  name      = "/${var.project}/${var.environment}/LOG_DEPRECATIONS_CHANNEL"
  type      = "SecureString"
  value     = var.env["LOG_DEPRECATIONS_CHANNEL"]
  overwrite = true
}

# LOG_LEVEL
resource "aws_ssm_parameter" "log_level" {
  name      = "/${var.project}/${var.environment}/LOG_LEVEL"
  type      = "SecureString"
  value     = var.env["LOG_LEVEL"]
  overwrite = true
}

# DB_CONNECTION
resource "aws_ssm_parameter" "db_connection" {
  name      = "/${var.project}/${var.environment}/DB_CONNECTION"
  type      = "SecureString"
  value     = var.env["DB_CONNECTION"]
  overwrite = true
}

# DB_HOST
resource "aws_ssm_parameter" "db_host" {
  name      = "/${var.project}/${var.environment}/DB_HOST"
  type      = "SecureString"
  value     = var.env["DB_HOST"]
  overwrite = true
}

# DB_PORT
resource "aws_ssm_parameter" "db_port" {
  name      = "/${var.project}/${var.environment}/DB_PORT"
  type      = "SecureString"
  value     = var.env["DB_PORT"]
  overwrite = true
}

# DB_DATABASE
resource "aws_ssm_parameter" "db_database" {
  name      = "/${var.project}/${var.environment}/DB_DATABASE"
  type      = "SecureString"
  value     = var.env["DB_DATABASE"]
  overwrite = true
}

# DB_USERNAME
resource "aws_ssm_parameter" "db_username" {
  name      = "/${var.project}/${var.environment}/DB_USERNAME"
  type      = "SecureString"
  value     = var.env["DB_USERNAME"]
  overwrite = true
}

# DB_PASSWORD
resource "aws_ssm_parameter" "db_password" {
  name      = "/${var.project}/${var.environment}/DB_PASSWORD"
  type      = "SecureString"
  value     = var.env["DB_PASSWORD"]
  overwrite = true
}

# BROADCAST_DRIVER
resource "aws_ssm_parameter" "broadcast_driver" {
  name      = "/${var.project}/${var.environment}/BROADCAST_DRIVER"
  type      = "SecureString"
  value     = var.env["BROADCAST_DRIVER"]
  overwrite = true
}

# CACHE_DRIVER
resource "aws_ssm_parameter" "cache_driver" {
  name      = "/${var.project}/${var.environment}/CACHE_DRIVER"
  type      = "SecureString"
  value     = var.env["CACHE_DRIVER"]
  overwrite = true
}

# FILESYSTEM_DISK
resource "aws_ssm_parameter" "filesystem_disk" {
  name      = "/${var.project}/${var.environment}/FILESYSTEM_DISK"
  type      = "SecureString"
  value     = var.env["FILESYSTEM_DISK"]
  overwrite = true
}

# QUEUE_CONNECTION
resource "aws_ssm_parameter" "queue_connection" {
  name      = "/${var.project}/${var.environment}/QUEUE_CONNECTION"
  type      = "SecureString"
  value     = var.env["QUEUE_CONNECTION"]
  overwrite = true
}

# SESSION_DRIVER
resource "aws_ssm_parameter" "session_driver" {
  name      = "/${var.project}/${var.environment}/SESSION_DRIVER"
  type      = "SecureString"
  value     = var.env["SESSION_DRIVER"]
  overwrite = true
}

# SESSION_LIFETIME
resource "aws_ssm_parameter" "session_lifetime" {
  name      = "/${var.project}/${var.environment}/SESSION_LIFETIME"
  type      = "SecureString"
  value     = var.env["SESSION_LIFETIME"]
  overwrite = true
}

# MEMCACHED_HOST
resource "aws_ssm_parameter" "memcached_host" {
  name      = "/${var.project}/${var.environment}/MEMCACHED_HOST"
  type      = "SecureString"
  value     = var.env["MEMCACHED_HOST"]
  overwrite = true
}

# REDIS_HOST
resource "aws_ssm_parameter" "redis_host" {
  name      = "/${var.project}/${var.environment}/REDIS_HOST"
  type      = "SecureString"
  value     = var.env["REDIS_HOST"]
  overwrite = true
}

# REDIS_PASSWORD
resource "aws_ssm_parameter" "redis_password" {
  name      = "/${var.project}/${var.environment}/REDIS_PASSWORD"
  type      = "SecureString"
  value     = var.env["REDIS_PASSWORD"]
  overwrite = true
}

# REDIS_PORT
resource "aws_ssm_parameter" "redis_port" {
  name      = "/${var.project}/${var.environment}/REDIS_PORT"
  type      = "SecureString"
  value     = var.env["REDIS_PORT"]
  overwrite = true
}

# MAIL_MAILER
resource "aws_ssm_parameter" "mail_mailer" {
  name      = "/${var.project}/${var.environment}/MAIL_MAILER"
  type      = "SecureString"
  value     = var.env["MAIL_MAILER"]
  overwrite = true
}

# MAIL_HOST
resource "aws_ssm_parameter" "mail_host" {
  name      = "/${var.project}/${var.environment}/MAIL_HOST"
  type      = "SecureString"
  value     = var.env["MAIL_HOST"]
  overwrite = true
}

# MAIL_PORT
resource "aws_ssm_parameter" "mail_port" {
  name      = "/${var.project}/${var.environment}/MAIL_PORT"
  type      = "SecureString"
  value     = var.env["MAIL_PORT"]
  overwrite = true
}

# MAIL_USERNAME
resource "aws_ssm_parameter" "mail_username" {
  name      = "/${var.project}/${var.environment}/MAIL_USERNAME"
  type      = "SecureString"
  value     = var.env["MAIL_USERNAME"]
  overwrite = true
}

# MAIL_PASSWORD
resource "aws_ssm_parameter" "mail_password" {
  name      = "/${var.project}/${var.environment}/MAIL_PASSWORD"
  type      = "SecureString"
  value     = var.env["MAIL_PASSWORD"]
  overwrite = true
}

# MAIL_ENCRYPTION
resource "aws_ssm_parameter" "mail_encryption" {
  name      = "/${var.project}/${var.environment}/MAIL_ENCRYPTION"
  type      = "SecureString"
  value     = var.env["MAIL_ENCRYPTION"]
  overwrite = true
}

# MAIL_FROM_ADDRESS
resource "aws_ssm_parameter" "mail_from_address" {
  name      = "/${var.project}/${var.environment}/MAIL_FROM_ADDRESS"
  type      = "SecureString"
  value     = var.env["MAIL_FROM_ADDRESS"]
  overwrite = true
}

# MAIL_FROM_NAME
resource "aws_ssm_parameter" "mail_from_name" {
  name      = "/${var.project}/${var.environment}/MAIL_FROM_NAME"
  type      = "SecureString"
  value     = var.env["MAIL_FROM_NAME"]
  overwrite = true
}

# AWS_ACCESS_KEY_ID
resource "aws_ssm_parameter" "aws_access_key_id" {
  name      = "/${var.project}/${var.environment}/AWS_ACCESS_KEY_ID"
  type      = "SecureString"
  value     = var.env["AWS_ACCESS_KEY_ID"]
  overwrite = true
}

# AWS_SECRET_ACCESS_KEY
resource "aws_ssm_parameter" "aws_secret_access_key" {
  name      = "/${var.project}/${var.environment}/AWS_SECRET_ACCESS_KEY"
  type      = "SecureString"
  value     = var.env["AWS_SECRET_ACCESS_KEY"]
  overwrite = true
}

# AWS_DEFAULT_REGION
resource "aws_ssm_parameter" "aws_default_region" {
  name      = "/${var.project}/${var.environment}/AWS_DEFAULT_REGION"
  type      = "SecureString"
  value     = var.env["AWS_DEFAULT_REGION"]
  overwrite = true
}

# AWS_BUCKET
resource "aws_ssm_parameter" "aws_bucket" {
  name      = "/${var.project}/${var.environment}/AWS_BUCKET"
  type      = "SecureString"
  value     = var.env["AWS_BUCKET"]
  overwrite = true
}

# AWS_USE_PATH_STYLE_ENDPOINT
resource "aws_ssm_parameter" "aws_use_path_style_endpoint" {
  name      = "/${var.project}/${var.environment}/AWS_USE_PATH_STYLE_ENDPOINT"
  type      = "SecureString"
  value     = var.env["AWS_USE_PATH_STYLE_ENDPOINT"]
  overwrite = true
}

# PUSHER_APP_ID
resource "aws_ssm_parameter" "pusher_app_id" {
  name      = "/${var.project}/${var.environment}/PUSHER_APP_ID"
  type      = "SecureString"
  value     = var.env["PUSHER_APP_ID"]
  overwrite = true
}

# PUSHER_APP_KEY
resource "aws_ssm_parameter" "pusher_app_key" {
  name      = "/${var.project}/${var.environment}/PUSHER_APP_KEY"
  type      = "SecureString"
  value     = var.env["PUSHER_APP_KEY"]
  overwrite = true
}

# PUSHER_APP_SECRET
resource "aws_ssm_parameter" "pusher_app_secret" {
  name      = "/${var.project}/${var.environment}/PUSHER_APP_SECRET"
  type      = "SecureString"
  value     = var.env["PUSHER_APP_SECRET"]
  overwrite = true
}

# PUSHER_HOST
resource "aws_ssm_parameter" "pusher_host" {
  name      = "/${var.project}/${var.environment}/PUSHER_HOST"
  type      = "SecureString"
  value     = var.env["PUSHER_HOST"]
  overwrite = true
}

# PUSHER_PORT
resource "aws_ssm_parameter" "pusher_port" {
  name      = "/${var.project}/${var.environment}/PUSHER_PORT"
  type      = "SecureString"
  value     = var.env["PUSHER_PORT"]
  overwrite = true
}

# PUSHER_SCHEME
resource "aws_ssm_parameter" "pusher_scheme" {
  name      = "/${var.project}/${var.environment}/PUSHER_SCHEME"
  type      = "SecureString"
  value     = var.env["PUSHER_SCHEME"]
  overwrite = true
}

# PUSHER_APP_CLUSTER
resource "aws_ssm_parameter" "pusher_app_cluster" {
  name      = "/${var.project}/${var.environment}/PUSHER_APP_CLUSTER"
  type      = "SecureString"
  value     = var.env["PUSHER_APP_CLUSTER"]
  overwrite = true
}

# VITE_APP_NAME
resource "aws_ssm_parameter" "vite_app_name" {
  name      = "/${var.project}/${var.environment}/VITE_APP_NAME"
  type      = "SecureString"
  value     = var.env["VITE_APP_NAME"]
  overwrite = true
}

# VITE_PUSHER_APP_KEY
resource "aws_ssm_parameter" "vite_pusher_app_key" {
  name      = "/${var.project}/${var.environment}/VITE_PUSHER_APP_KEY"
  type      = "SecureString"
  value     = var.env["VITE_PUSHER_APP_KEY"]
  overwrite = true
}

# VITE_PUSHER_HOST
resource "aws_ssm_parameter" "vite_pusher_host" {
  name      = "/${var.project}/${var.environment}/VITE_PUSHER_HOST"
  type      = "SecureString"
  value     = var.env["VITE_PUSHER_HOST"]
  overwrite = true
}

# VITE_PUSHER_PORT
resource "aws_ssm_parameter" "vite_pusher_port" {
  name      = "/${var.project}/${var.environment}/VITE_PUSHER_PORT"
  type      = "SecureString"
  value     = var.env["VITE_PUSHER_PORT"]
  overwrite = true
}

# VITE_PUSHER_SCHEME
resource "aws_ssm_parameter" "vite_pusher_scheme" {
  name      = "/${var.project}/${var.environment}/VITE_PUSHER_SCHEME"
  type      = "SecureString"
  value     = var.env["VITE_PUSHER_SCHEME"]
  overwrite = true
}

# VITE_PUSHER_APP_CLUSTER
resource "aws_ssm_parameter" "vite_pusher_app_cluster" {
  name      = "/${var.project}/${var.environment}/VITE_PUSHER_APP_CLUSTER"
  type      = "SecureString"
  value     = var.env["VITE_PUSHER_APP_CLUSTER"]
  overwrite = true
}