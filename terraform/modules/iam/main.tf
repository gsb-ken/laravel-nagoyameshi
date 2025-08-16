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

# AmazonECSTaskExecutionRolePolicy を付与（ECR, CloudWatch Logs 用）
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# SSM + KMS 読み取りポリシー（SecureString対応）
resource "aws_iam_role_policy" "ecs_execution_ssm_kms" {
  name = "${var.project}-${var.environment}-ecs-exec-ssm"
  role = aws_iam_role.ecs_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter/${var.project}/${var.environment}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["kms:Decrypt"]
        Resource = "*" # 専用KMSキーを使っている場合はここで絞る
      }
    ]
  })
}

# ECS Task Role -------------------------------------------------------
resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.project}-${var.environment}-iam-role-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

# ECSタスクが直接AWS APIを叩くときの権限
resource "aws_iam_role_policy" "ecs_task_inline_policy" {
  name   = "${var.project}-${var.environment}-iam-policy-ecs-task"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.ecs_task_permissions.json
}

# ECSタスク用 Assume Role ポリシー
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

# ECSタスクの実行中に使える権限
data "aws_iam_policy_document" "ecs_task_permissions" {
  statement {
    actions = [
      "s3:GetObject",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
      "kms:Decrypt",
      "logs:PutLogEvents"
    ]
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
# S3アーティファクトのバケット
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
# ECR push/pull
resource "aws_iam_role_policy_attachment" "codebuild_ecr_access" {
  role       = aws_iam_role.codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}
# Codebuildのログ出力
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
# ECS 実行/参照
resource "aws_iam_role_policy" "codebuild_ecs_run_task" {
  name = "${var.project}-${var.environment}-codebuild-ecs-run-task"
  role = aws_iam_role.codebuild.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # RunTask は taskdef をリソースに、cluster を Condition で絞る
      {
        Sid     = "RunMigrationTask",
        Effect  = "Allow",
        Action  = ["ecs:RunTask"],
        Resource = "arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:task-definition/${var.project}-${var.environment}-task-migrate:*",
        Condition = {
          ArnEquals = {
            "ecs:cluster" = "arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:cluster/${var.project}-${var.environment}-ecs-cluster"
          }
        }
      },
      # Describe 系はリソース絞り不可 → "*" 必須
      {
        Sid     = "DescribeEcsThings",
        Effect  = "Allow",
        Action  = [
          "ecs:DescribeTasks",
          "ecs:DescribeTaskDefinition",
          "ecs:ListTasks",
          "ecs:DescribeClusters"
        ],
        Resource = "*"
      },
      # タスク実行ロール/タスクロールの委譲
      {
        Sid     = "PassTaskRoles",
        Effect  = "Allow",
        Action  = "iam:PassRole",
        Resource = [
          aws_iam_role.ecs_execution_role.arn,
          aws_iam_role.ecs_task_role.arn
        ]
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
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ]
        Resource = [
          "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/ecs/${var.project}-${var.environment}/task/migrate",
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