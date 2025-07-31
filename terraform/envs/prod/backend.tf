terraform {
  backend "s3" {
    bucket  = "nagoyameshi-tfstate-899604731723"
    key     = "prod/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}