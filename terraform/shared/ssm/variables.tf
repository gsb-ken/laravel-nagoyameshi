variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g. dev, stg, prod)"
}

variable "env_parameters" {
  type = map(string)
  description = "Laravel environment variables to store in SSM"
  default = {
    APP_NAME                = "Laravel"
    APP_ENV                = "production"
    APP_KEY                = "base64:REPLACE_ME"
    APP_DEBUG              = "false"
    APP_URL                = "http://localhost"

    LOG_CHANNEL            = "stack"
    LOG_DEPRECATIONS_CHANNEL = "null"
    LOG_LEVEL              = "debug"

    DB_CONNECTION          = "mysql"
    DB_HOST                = "db"
    DB_PORT                = "3306"
    DB_DATABASE            = "laravel_nagoyameshi"
    DB_USERNAME            = "root"
    DB_PASSWORD            = "password"

    BROADCAST_DRIVER       = "log"
    CACHE_DRIVER           = "file"
    FILESYSTEM_DISK        = "local"
    QUEUE_CONNECTION       = "sync"
    SESSION_DRIVER         = "file"
    SESSION_LIFETIME       = "120"

    MEMCACHED_HOST         = "127.0.0.1"

    # REDIS_HOST             = "127.0.0.1"
    # REDIS_PASSWORD         = "null"
    # REDIS_PORT             = "6379"

    # MAIL_MAILER            = "smtp"
    # MAIL_HOST              = "mailpit"
    # MAIL_PORT              = "1025"
    # MAIL_USERNAME          = "null"
    # MAIL_PASSWORD          = "null"
    # MAIL_ENCRYPTION        = "null"
    # MAIL_FROM_ADDRESS      = "hello@example.com"
    # MAIL_FROM_NAME         = "Laravel"

    # AWS_ACCESS_KEY_ID      = ""
    # AWS_SECRET_ACCESS_KEY  = ""
    # AWS_DEFAULT_REGION     = "us-east-1"
    # AWS_BUCKET             = ""
    # AWS_USE_PATH_STYLE_ENDPOINT = "false"

    # PUSHER_APP_ID          = ""
    # PUSHER_APP_KEY         = ""
    # PUSHER_APP_SECRET      = ""
    # PUSHER_HOST            = ""
    # PUSHER_PORT            = "443"
    # PUSHER_SCHEME          = "https"
    # PUSHER_APP_CLUSTER     = "mt1"

    # VITE_APP_NAME          = "Laravel"
    # VITE_PUSHER_APP_KEY    = ""
    # VITE_PUSHER_HOST       = ""
    # VITE_PUSHER_PORT       = "443"
    # VITE_PUSHER_SCHEME     = "https"
    # VITE_PUSHER_APP_CLUSTER = "mt1"
  }
}
variable "env_secret_keys" {
  type        = list(string)
  description = "Keys from env_parameters to be treated as secrets (SecureString)"
  default     = []
}
