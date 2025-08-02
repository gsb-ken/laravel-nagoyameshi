# ------------------------------
# ALB
# ------------------------------
resource "aws_lb" "alb" {
  name               = "${var.project}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets = var.subnet_ids

  tags = {
    Name    = "${var.project}-${var.environment}-alb"
    Project = var.project
    Env     = var.environment
  }
}

# ------------------------------
# target group
# ------------------------------
resource "aws_lb_target_group" "tg" {
  name        = "${var.project}-${var.environment}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" # ECS Fargate

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name    = "${var.project}-${var.environment}-tg"
    Project = var.project
    Env     = var.environment
  }
}

# ------------------------------
# listner
# ------------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
