resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project}-${var.environment}-ecs-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  execution_role_arn = var.ecs_execution_role_arn
  task_role_arn      = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.laravel_image
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ],
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}-${var.environment}/task/app"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      },
      secrets = [
        { name = "APP_NAME",  valueFrom = data.aws_ssm_parameter.app_name.arn },
        { name = "APP_ENV",   valueFrom = data.aws_ssm_parameter.app_env.arn },
        { name = "APP_KEY",   valueFrom = data.aws_ssm_parameter.app_key.arn },
        { name = "APP_DEBUG", valueFrom = data.aws_ssm_parameter.app_debug.arn },
        { name = "APP_URL",   valueFrom = data.aws_ssm_parameter.app_url.arn },

        { name = "LOG_CHANNEL",              valueFrom = data.aws_ssm_parameter.log_channel.arn },
        { name = "LOG_DEPRECATIONS_CHANNEL", valueFrom = data.aws_ssm_parameter.log_deprecations_channel.arn },
        { name = "LOG_LEVEL",                valueFrom = data.aws_ssm_parameter.log_level.arn },

        { name = "DB_CONNECTION", valueFrom = data.aws_ssm_parameter.db_connection.arn },
        { name = "DB_HOST",       valueFrom = data.aws_ssm_parameter.db_host.arn },
        { name = "DB_PORT",       valueFrom = data.aws_ssm_parameter.db_port.arn },
        { name = "DB_DATABASE",   valueFrom = data.aws_ssm_parameter.db_database.arn },
        { name = "DB_USERNAME",   valueFrom = data.aws_ssm_parameter.db_username.arn },
        { name = "DB_PASSWORD",   valueFrom = data.aws_ssm_parameter.db_password.arn },

        { name = "BROADCAST_DRIVER", valueFrom = data.aws_ssm_parameter.broadcast_driver.arn },
        { name = "CACHE_DRIVER",     valueFrom = data.aws_ssm_parameter.cache_driver.arn },
        { name = "FILESYSTEM_DISK",  valueFrom = data.aws_ssm_parameter.filesystem_disk.arn },
        { name = "QUEUE_CONNECTION", valueFrom = data.aws_ssm_parameter.queue_connection.arn },
        { name = "SESSION_DRIVER",   valueFrom = data.aws_ssm_parameter.session_driver.arn },
        { name = "SESSION_LIFETIME", valueFrom = data.aws_ssm_parameter.session_lifetime.arn },

        { name = "MEMCACHED_HOST", valueFrom = data.aws_ssm_parameter.memcached_host.arn },

        { name = "REDIS_HOST",     valueFrom = data.aws_ssm_parameter.redis_host.arn },
        { name = "REDIS_PASSWORD", valueFrom = data.aws_ssm_parameter.redis_password.arn },
        { name = "REDIS_PORT",     valueFrom = data.aws_ssm_parameter.redis_port.arn },

        { name = "MAIL_MAILER",       valueFrom = data.aws_ssm_parameter.mail_mailer.arn },
        { name = "MAIL_HOST",         valueFrom = data.aws_ssm_parameter.mail_host.arn },
        { name = "MAIL_PORT",         valueFrom = data.aws_ssm_parameter.mail_port.arn },
        { name = "MAIL_USERNAME",     valueFrom = data.aws_ssm_parameter.mail_username.arn },
        { name = "MAIL_PASSWORD",     valueFrom = data.aws_ssm_parameter.mail_password.arn },
        { name = "MAIL_ENCRYPTION",   valueFrom = data.aws_ssm_parameter.mail_encryption.arn },
        { name = "MAIL_FROM_ADDRESS", valueFrom = data.aws_ssm_parameter.mail_from_address.arn },
        { name = "MAIL_FROM_NAME",    valueFrom = data.aws_ssm_parameter.mail_from_name.arn },

        { name = "AWS_ACCESS_KEY_ID",           valueFrom = data.aws_ssm_parameter.aws_access_key_id.arn },
        { name = "AWS_SECRET_ACCESS_KEY",       valueFrom = data.aws_ssm_parameter.aws_secret_access_key.arn },
        { name = "AWS_DEFAULT_REGION",          valueFrom = data.aws_ssm_parameter.aws_default_region.arn },
        { name = "AWS_BUCKET",                  valueFrom = data.aws_ssm_parameter.aws_bucket.arn },
        { name = "AWS_USE_PATH_STYLE_ENDPOINT", valueFrom = data.aws_ssm_parameter.aws_use_path_style_endpoint.arn },

        { name = "PUSHER_APP_ID",      valueFrom = data.aws_ssm_parameter.pusher_app_id.arn },
        { name = "PUSHER_APP_KEY",     valueFrom = data.aws_ssm_parameter.pusher_app_key.arn },
        { name = "PUSHER_APP_SECRET",  valueFrom = data.aws_ssm_parameter.pusher_app_secret.arn },
        { name = "PUSHER_HOST",        valueFrom = data.aws_ssm_parameter.pusher_host.arn },
        { name = "PUSHER_PORT",        valueFrom = data.aws_ssm_parameter.pusher_port.arn },
        { name = "PUSHER_SCHEME",      valueFrom = data.aws_ssm_parameter.pusher_scheme.arn },
        { name = "PUSHER_APP_CLUSTER", valueFrom = data.aws_ssm_parameter.pusher_app_cluster.arn },

        { name = "VITE_APP_NAME",           valueFrom = data.aws_ssm_parameter.vite_app_name.arn },
        { name = "VITE_PUSHER_APP_KEY",     valueFrom = data.aws_ssm_parameter.vite_pusher_app_key.arn },
        { name = "VITE_PUSHER_HOST",        valueFrom = data.aws_ssm_parameter.vite_pusher_host.arn },
        { name = "VITE_PUSHER_PORT",        valueFrom = data.aws_ssm_parameter.vite_pusher_port.arn },
        { name = "VITE_PUSHER_SCHEME",      valueFrom = data.aws_ssm_parameter.vite_pusher_scheme.arn },
        { name = "VITE_PUSHER_APP_CLUSTER", valueFrom = data.aws_ssm_parameter.vite_pusher_app_cluster.arn }
      ]
      command = [
        "sh",
        "-lc",
        "echo \"[DEBUG] APP_URL=$APP_URL\"; php -r \"require __DIR__.'/vendor/autoload.php'; \\$app=require __DIR__.'/bootstrap/app.php'; \\$kernel=\\$app->make(Illuminate\\\\Contracts\\\\Console\\\\Kernel::class); \\$kernel->bootstrap(); echo 'CONFIG_APP_URL='.config('app.url').PHP_EOL;\"; exec apache2-foreground"
      ]


    }
  ])
}

# --- App ---
data "aws_ssm_parameter" "app_name" {
  name        = "/${var.project}/${var.environment}/APP_NAME"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "app_env" {
  name        = "/${var.project}/${var.environment}/APP_ENV"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "app_key" {
  name        = "/${var.project}/${var.environment}/APP_KEY"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "app_debug" {
  name        = "/${var.project}/${var.environment}/APP_DEBUG"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "app_url" {
  name        = "/${var.project}/${var.environment}/APP_URL"
  depends_on  = [var.ssm_dependency]
}

# --- Logging ---
data "aws_ssm_parameter" "log_channel" {
  name        = "/${var.project}/${var.environment}/LOG_CHANNEL"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "log_deprecations_channel" {
  name        = "/${var.project}/${var.environment}/LOG_DEPRECATIONS_CHANNEL"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "log_level" {
  name        = "/${var.project}/${var.environment}/LOG_LEVEL"
  depends_on  = [var.ssm_dependency]
}

# --- DB ---
data "aws_ssm_parameter" "db_connection" {
  name        = "/${var.project}/${var.environment}/DB_CONNECTION"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "db_host" {
  name        = "/${var.project}/${var.environment}/DB_HOST"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "db_port" {
  name        = "/${var.project}/${var.environment}/DB_PORT"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "db_database" {
  name        = "/${var.project}/${var.environment}/DB_DATABASE"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "db_username" {
  name        = "/${var.project}/${var.environment}/DB_USERNAME"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "db_password" {
  name        = "/${var.project}/${var.environment}/DB_PASSWORD"
  depends_on  = [var.ssm_dependency]
}

# --- Cache/Queue/Session ---
data "aws_ssm_parameter" "broadcast_driver" {
  name        = "/${var.project}/${var.environment}/BROADCAST_DRIVER"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "cache_driver" {
  name        = "/${var.project}/${var.environment}/CACHE_DRIVER"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "filesystem_disk" {
  name        = "/${var.project}/${var.environment}/FILESYSTEM_DISK"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "queue_connection" {
  name        = "/${var.project}/${var.environment}/QUEUE_CONNECTION"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "session_driver" {
  name        = "/${var.project}/${var.environment}/SESSION_DRIVER"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "session_lifetime" {
  name        = "/${var.project}/${var.environment}/SESSION_LIFETIME"
  depends_on  = [var.ssm_dependency]
}

# --- Memcached/Redis ---
data "aws_ssm_parameter" "memcached_host" {
  name        = "/${var.project}/${var.environment}/MEMCACHED_HOST"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "redis_host" {
  name        = "/${var.project}/${var.environment}/REDIS_HOST"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "redis_password" {
  name        = "/${var.project}/${var.environment}/REDIS_PASSWORD"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "redis_port" {
  name        = "/${var.project}/${var.environment}/REDIS_PORT"
  depends_on  = [var.ssm_dependency]
}

# --- Mail ---
data "aws_ssm_parameter" "mail_mailer" {
  name        = "/${var.project}/${var.environment}/MAIL_MAILER"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "mail_host" {
  name        = "/${var.project}/${var.environment}/MAIL_HOST"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "mail_port" {
  name        = "/${var.project}/${var.environment}/MAIL_PORT"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "mail_username" {
  name        = "/${var.project}/${var.environment}/MAIL_USERNAME"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "mail_password" {
  name        = "/${var.project}/${var.environment}/MAIL_PASSWORD"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "mail_encryption" {
  name        = "/${var.project}/${var.environment}/MAIL_ENCRYPTION"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "mail_from_address" {
  name        = "/${var.project}/${var.environment}/MAIL_FROM_ADDRESS"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "mail_from_name" {
  name        = "/${var.project}/${var.environment}/MAIL_FROM_NAME"
  depends_on  = [var.ssm_dependency]
}

# --- AWS ---
data "aws_ssm_parameter" "aws_access_key_id" {
  name        = "/${var.project}/${var.environment}/AWS_ACCESS_KEY_ID"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "aws_secret_access_key" {
  name        = "/${var.project}/${var.environment}/AWS_SECRET_ACCESS_KEY"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "aws_default_region" {
  name        = "/${var.project}/${var.environment}/AWS_DEFAULT_REGION"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "aws_bucket" {
  name        = "/${var.project}/${var.environment}/AWS_BUCKET"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "aws_use_path_style_endpoint" {
  name        = "/${var.project}/${var.environment}/AWS_USE_PATH_STYLE_ENDPOINT"
  depends_on  = [var.ssm_dependency]
}

# --- Pusher ---
data "aws_ssm_parameter" "pusher_app_id" {
  name        = "/${var.project}/${var.environment}/PUSHER_APP_ID"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "pusher_app_key" {
  name        = "/${var.project}/${var.environment}/PUSHER_APP_KEY"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "pusher_app_secret" {
  name        = "/${var.project}/${var.environment}/PUSHER_APP_SECRET"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "pusher_host" {
  name        = "/${var.project}/${var.environment}/PUSHER_HOST"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "pusher_port" {
  name        = "/${var.project}/${var.environment}/PUSHER_PORT"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "pusher_scheme" {
  name        = "/${var.project}/${var.environment}/PUSHER_SCHEME"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "pusher_app_cluster" {
  name        = "/${var.project}/${var.environment}/PUSHER_APP_CLUSTER"
  depends_on  = [var.ssm_dependency]
}

# --- Vite ---
data "aws_ssm_parameter" "vite_app_name" {
  name        = "/${var.project}/${var.environment}/VITE_APP_NAME"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "vite_pusher_app_key" {
  name        = "/${var.project}/${var.environment}/VITE_PUSHER_APP_KEY"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "vite_pusher_host" {
  name        = "/${var.project}/${var.environment}/VITE_PUSHER_HOST"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "vite_pusher_port" {
  name        = "/${var.project}/${var.environment}/VITE_PUSHER_PORT"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "vite_pusher_scheme" {
  name        = "/${var.project}/${var.environment}/VITE_PUSHER_SCHEME"
  depends_on  = [var.ssm_dependency]
}

data "aws_ssm_parameter" "vite_pusher_app_cluster" {
  name        = "/${var.project}/${var.environment}/VITE_PUSHER_APP_CLUSTER"
  depends_on  = [var.ssm_dependency]
}
