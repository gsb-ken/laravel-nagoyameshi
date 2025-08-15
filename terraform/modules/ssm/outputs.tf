# --- APP ---
output "app_name_arn"       { value = aws_ssm_parameter.app_name.arn }
output "app_env_arn"        { value = aws_ssm_parameter.app_env.arn }
output "app_key_arn"        { value = aws_ssm_parameter.app_key.arn }
output "app_debug_arn"      { value = aws_ssm_parameter.app_debug.arn }
output "app_url_arn"        { value = aws_ssm_parameter.app_url.arn }

# --- Logging ---
output "log_channel_arn"               { value = aws_ssm_parameter.log_channel.arn }
output "log_deprecations_channel_arn"  { value = aws_ssm_parameter.log_deprecations_channel.arn }
output "log_level_arn"                 { value = aws_ssm_parameter.log_level.arn }

# --- DB ---
output "db_connection_arn" { value = aws_ssm_parameter.db_connection.arn }
output "db_host_arn"       { value = aws_ssm_parameter.db_host.arn }
output "db_port_arn"       { value = aws_ssm_parameter.db_port.arn }
output "db_database_arn"   { value = aws_ssm_parameter.db_database.arn }
output "db_username_arn"   { value = aws_ssm_parameter.db_username.arn }
output "db_password_arn"   { value = aws_ssm_parameter.db_password.arn }

# --- Cache/Queue/Session ---
output "broadcast_driver_arn" { value = aws_ssm_parameter.broadcast_driver.arn }
output "cache_driver_arn"     { value = aws_ssm_parameter.cache_driver.arn }
output "filesystem_disk_arn"  { value = aws_ssm_parameter.filesystem_disk.arn }
output "queue_connection_arn" { value = aws_ssm_parameter.queue_connection.arn }
output "session_driver_arn"   { value = aws_ssm_parameter.session_driver.arn }
output "session_lifetime_arn" { value = aws_ssm_parameter.session_lifetime.arn }

# --- Memcached/Redis ---
output "memcached_host_arn" { value = aws_ssm_parameter.memcached_host.arn }
output "redis_host_arn"     { value = aws_ssm_parameter.redis_host.arn }
output "redis_password_arn" { value = aws_ssm_parameter.redis_password.arn }
output "redis_port_arn"     { value = aws_ssm_parameter.redis_port.arn }

# --- Mail ---
output "mail_mailer_arn"       { value = aws_ssm_parameter.mail_mailer.arn }
output "mail_host_arn"         { value = aws_ssm_parameter.mail_host.arn }
output "mail_port_arn"         { value = aws_ssm_parameter.mail_port.arn }
output "mail_username_arn"     { value = aws_ssm_parameter.mail_username.arn }
output "mail_password_arn"     { value = aws_ssm_parameter.mail_password.arn }
output "mail_encryption_arn"   { value = aws_ssm_parameter.mail_encryption.arn }
output "mail_from_address_arn" { value = aws_ssm_parameter.mail_from_address.arn }
output "mail_from_name_arn"    { value = aws_ssm_parameter.mail_from_name.arn }

# --- AWS ---
output "aws_access_key_id_arn"           { value = aws_ssm_parameter.aws_access_key_id.arn }
output "aws_secret_access_key_arn"       { value = aws_ssm_parameter.aws_secret_access_key.arn }
output "aws_default_region_arn"          { value = aws_ssm_parameter.aws_default_region.arn }
output "aws_bucket_arn"                  { value = aws_ssm_parameter.aws_bucket.arn }
output "aws_use_path_style_endpoint_arn" { value = aws_ssm_parameter.aws_use_path_style_endpoint.arn }

# --- Pusher ---
output "pusher_app_id_arn"      { value = aws_ssm_parameter.pusher_app_id.arn }
output "pusher_app_key_arn"     { value = aws_ssm_parameter.pusher_app_key.arn }
output "pusher_app_secret_arn"  { value = aws_ssm_parameter.pusher_app_secret.arn }
output "pusher_host_arn"        { value = aws_ssm_parameter.pusher_host.arn }
output "pusher_port_arn"        { value = aws_ssm_parameter.pusher_port.arn }
output "pusher_scheme_arn"      { value = aws_ssm_parameter.pusher_scheme.arn }
output "pusher_app_cluster_arn" { value = aws_ssm_parameter.pusher_app_cluster.arn }

# --- Vite ---
output "vite_app_name_arn"          { value = aws_ssm_parameter.vite_app_name.arn }
output "vite_pusher_app_key_arn"    { value = aws_ssm_parameter.vite_pusher_app_key.arn }
output "vite_pusher_host_arn"       { value = aws_ssm_parameter.vite_pusher_host.arn }
output "vite_pusher_port_arn"       { value = aws_ssm_parameter.vite_pusher_port.arn }
output "vite_pusher_scheme_arn"     { value = aws_ssm_parameter.vite_pusher_scheme.arn }
output "vite_pusher_app_cluster_arn"{ value = aws_ssm_parameter.vite_pusher_app_cluster.arn }
