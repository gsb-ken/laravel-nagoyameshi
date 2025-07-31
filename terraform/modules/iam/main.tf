# ------------------------------
# IAM Role
# ------------------------------
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.project}-${var.environment}-iam-role-ecs-exec"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project}-${var.environment}-iam-role-ecs-task"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}
resource "aws_iam_role_policy" "ecs_task_inline_policy" {
  name   = "${var.project}-${var.environment}-iam-policy-ecs-task"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.ecs_task_permissions.json
}

data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ecs_task_permissions" {
  statement {
    actions = [
      "s3:GetObject",
      "ssm:GetParameter",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}
