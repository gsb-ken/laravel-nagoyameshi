# -------------------------
# RDS parameter group
# -------------------------
resource "aws_db_parameter_group" "rds_parametergroup" {
  name   = "${var.project}-${var.environment}-rds-parametergroup"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

# -------------------------
# RDS option group
# -------------------------
resource "aws_db_option_group" "rds_optiongroup" {
  name                 = "${var.project}-${var.environment}-rds-optiongroup"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# -------------------------
# RDS subnet group
# -------------------------
resource "aws_db_subnet_group" "rds_subnetgroup" {
  name = "${var.project}-${var.environment}-rds-subnetgroup"
  subnet_ids = var.subnet_ids

  tags = {
    Name    = "${var.project}-${var.environment}-rds-subnetgroup"
    Project = var.project
    Env     = var.environment
  }
}

# -------------------------
# RDS instance
# -------------------------
resource "aws_db_instance" "rds" {
  engine         = "mysql"
  engine_version = "8.0"

  identifier = "${var.project}-${var.environment}-rds"

  username = var.username
  password = var.password

  instance_class = var.instance_class
  allocated_storage     = var.allocated_storage
  storage_type          = "gp2"
  storage_encrypted     = true

  multi_az               = var.multi_az
  db_subnet_group_name   = aws_db_subnet_group.rds_subnetgroup.name
  vpc_security_group_ids = var.security_group_ids
  publicly_accessible    = false
  port                   = 3306

  name                 = var.db_name#"laravel_nagoyameshi"
  parameter_group_name = aws_db_parameter_group.rds_parametergroup.name
  option_group_name    = aws_db_option_group.rds_optiongroup.name

  maintenance_window         = "Mon:05:00-Mon:08:00"

  deletion_protection = false
  skip_final_snapshot = true

  apply_immediately = true

  tags = {
    Name    = "${var.project}-${var.environment}-rds"
    Project = var.project
    Env     = var.environment
  }
}