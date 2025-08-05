
resource "aws_codebuild_project" "codebuild" {
  name          = "${var.project}-${var.environment}-build"
  description   = "Build Docker image for ${var.project} (${var.environment})"
  service_role  = var.codebuild_role_arn
  build_timeout = 30

  source {
    type            = "GITHUB"
    location        = "https://github.com/${var.github_owner}/${var.github_repo}.git"
    git_clone_depth = 1
    buildspec       = var.buildspec_file
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true  # Docker build 必須
    image_pull_credentials_type = "CODEBUILD"

  
    environment_variable {
      name  = "PROJECT"
      value = var.project
    }

    environment_variable {
      name  = "ENVIRONMENT"
      value = var.environment
    }
  
    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "ECR_REPO_NAME"
      value = var.ecr_repo_name
    }

    environment_variable {
      name  = "CONTAINER_NAME"
      value = var.container_name
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }
    environment_variable {
    name  = "REPOSITORY_URI"
    value = var.ecr_repo_url
  }

  environment_variable {
    name  = "ECS_CLUSTER_NAME"
    value = var.ecs_cluster_name
  }

  environment_variable {
    name  = "MIGRATION_TASK_DEFINITION"
    value = var.migration_task_definition
  }

  environment_variable {
    name  = "SUBNET_ID_1"
    value = var.subnet_id_1
  }

  environment_variable {
    name  = "SUBNET_ID_2"
    value = var.subnet_id_2
  }

  environment_variable {
    name  = "SECURITY_GROUP_ID"
    value = var.security_group_id
  }
  }

  source_version = var.github_branch
}
