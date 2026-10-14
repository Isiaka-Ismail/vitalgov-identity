# All resources live in af-south-1 (brief requirement, residency ADR-012).
# No second regional provider: no Amplify/CloudFront, no cross-region cert work.

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile != "" ? var.aws_profile : null

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
