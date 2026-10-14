output "certificate_arn" {
  description = "ARN of the ACM certificate."
  value       = aws_acm_certificate.main.arn
}

output "domain_name" {
  description = "Domain name of the certificate."
  value       = aws_acm_certificate.main.domain_name
}
