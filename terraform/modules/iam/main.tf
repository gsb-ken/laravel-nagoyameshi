# ------------------------------
# IAM Role Definitions
# ------------------------------
data "aws_caller_identity" "current" {}

# ------------------------------
# ECS Roles and Policies
# ------------------------------

# ECS execution ----------------
resource "aws_iam_role" "ecs_execution_role" {
  name               = "${var.project}-${var.environment}-iam-role-ecs-exec"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS task ---------------------
resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.project}-${var.environment}-iam-role-ecs-task"
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
    actions   = ["s3:GetObject", "ssm:GetParameter", "logs:PutLogEvents"]
    resources = ["*"]
  }
}

# ------------------------------
# CodeBuild Role and Policies
# ------------------------------

resource "aws_iam_role" "codebuild" {
  name = "${var.project}-${var.environment}-codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy" "codebuild_s3_access" {
  name = "${var.project}-${var.environment}-codebuild-s3-access"
  role = aws_iam_role.codebuild.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:PutObject", "s3:GetObject", "s3:GetObjectVersion"],
        Resource = ["arn:aws:s3:::${var.artifact_bucket}/*"]
      },
      {
        Effect = "Allow",
        Action = ["s3:ListBucket"],
        Resource = ["arn:aws:s3:::${var.artifact_bucket}"]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "codebuild_ecr_access" {
  role       = aws_iam_role.codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}
resource "aws_iam_role_policy" "codebuild_cloudwatch_logs" {
  name = "${var.project}-${var.environment}-codebuild-logs"
  role = aws_iam_role.codebuild.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = ["arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/codebuild/*"]
      }
    ]
  })
}
resource "aws_iam_role_policy" "codebuild_ecs_run_task" {
  name = "${var.project}-${var.environment}-codebuild-ecs-run-task"
  role = aws_iam_role.codebuild.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:RunTask",
          "ecs:DescribeTasks",
          "ecs:DescribeTaskDefinition",
          "ecs:ListTasks",
          "ecs:DescribeClusters"
        ],
        Resource =[ "arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:task-definition/${var.project}-${var.environment}-task-migrate:*"
        ]
      },
      {
        Effect = "Allow",
        Action = "iam:PassRole",
        Resource = [
          aws_iam_role.ecs_execution_role.arn,
          aws_iam_role.ecs_task_role.arn
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
         ],
        "Resource": "*"
      }

    ]
  })
}
resource "aws_iam_role_policy" "codebuild_cloudwatch_ecs_logs" {
  name = "${var.project}-${var.environment}-codebuild-ecs-logs"
  role = aws_iam_role.codebuild.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogStreams",
          "logs:GetLogEvents"
        ]
        Resource = [
          "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/ecs/${var.project}-${var.environment}/task/migrate:*"
        ]
      }
    ]
  })
}


# ------------------------------
# CodePipeline Role and Policies
# ------------------------------

resource "aws_iam_role" "codepipeline" {
  name = "${var.project}-${var.environment}-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "codepipeline_policy" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}
resource "aws_iam_role_policy" "allow_codestar_connections" {
  name = "${var.project}-${var.environment}-allow-codestar-connection"
  role = aws_iam_role.codepipeline.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["codestar-connections:UseConnection"],
        Resource = var.codestar_connection_arn
      }
    ]
  })
}
resource "aws_iam_role_policy" "codepipeline_s3_access" {
  name = "${var.project}-${var.environment}-codepipeline-s3-policy"
  role = aws_iam_role.codepipeline.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:GetObject", "s3:GetObjectVersion", "s3:PutObject"],
        Resource = ["arn:aws:s3:::${var.artifact_bucket}/*"]
      },
      {
        Effect = "Allow",
        Action = ["s3:ListBucket"],
        Resource = ["arn:aws:s3:::${var.artifact_bucket}"]
      }
    ]
  })
}
resource "aws_iam_role_policy" "codepipeline_start_codebuild" {
  name = "${var.project}-${var.environment}-start-codebuild"
  role = aws_iam_role.codepipeline.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds"
        ],
        Resource = "arn:aws:codebuild:ap-northeast-1:${data.aws_caller_identity.current.account_id}:project/${var.project}-${var.environment}-build"
      }
    ]
  })
}
resource "aws_iam_role_policy" "codepipeline_ecs_deploy" {
  name = "${var.project}-${var.environment}-codepipeline-ecs-deploy"
  role = aws_iam_role.codepipeline.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowECSDeploy"
        Effect = "Allow"
        Action = [
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowPassRoleToECS"
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = [
          aws_iam_role.ecs_execution_role.arn,
          aws_iam_role.ecs_task_role.arn
        ]
      }
    ]
  })
}