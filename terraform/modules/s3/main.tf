resource "aws_s3_bucket" "artifact" {
  bucket = "${var.project}-${var.environment}-codepipeline-artifact"
  force_destroy = true

  tags = {
    Name        = "${var.project}-${var.environment}-artifact"
    Environment = var.environment
  }
}
