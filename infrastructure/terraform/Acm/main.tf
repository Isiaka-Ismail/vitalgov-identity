locals {
  common_tags = merge(
    var.common_tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Layer       = "Security"
    }
  )
}

# Dormant until a domain exists (count = 0 in main.tf without domain_name).
# The zone lives on a free external DNS service (not Route 53), so validation
# is manual: apply with -target=module.acm, create the CNAME from the
# validation_record output at the DNS provider, wait for ISSUED, then apply
# the rest (a pending certificate cannot attach to the ALB listener).
resource "aws_acm_certificate" "main" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-certificate"
    }
  )
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_acm_certificate.main.domain_validation_options : record.resource_record_name]
}
