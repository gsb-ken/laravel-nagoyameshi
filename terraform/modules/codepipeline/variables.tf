variable "project" {}
variable "environment" {}

variable "github_owner" {}
variable "github_repo" {}
variable "github_branch" {}
variable "github_oauth_token" {}

variable "codebuild_project_name" {}
variable "codepipeline_role_arn" {}
variable "artifact_bucket" {}
variable "ecs_cluster_name" {}
variable "ecs_service_name" {}
variable "codestar_connection_arn" {
  description = "ARN of the CodeStar connection to GitHub"
  type        = string
}
