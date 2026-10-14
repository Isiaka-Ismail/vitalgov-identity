# Endpoint inventory per docs/cloud/aws-architecture.md §4.7, trimmed to the
# endpoints that have a consumer the NAT gateway cannot serve:
#   * KMS + SSM + SSMMessages, required by the CA tier (PKI subnets have no
#     NAT route, V10) for key operations and Session Manager admin (ADR-011)
#   * Secrets Manager, task credential injection must not traverse the NAT
# S3 gateway endpoint (free) covers backups/log delivery/ECR layers on the
# app, data AND pki route tables.
# Everything else (ECR API, CloudWatch, ECS, STS) egresses via the shared NAT;
# CloudTrail has no endpoint at all (ADR-006 / I-005 documented exception).
#
# Placement: single AZ (app subnet 0), same resilience trade-off already
# accepted for the single NAT gateway (ADR-010). endpoint_az_count = 2
# restores dual-AZ endpoints if the review requires it.

locals {
  common_tags = merge(
    var.common_tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Layer       = "VpcEndpoints"
    }
  )

  interface_endpoints = {
    kms            = "kms"
    secretsmanager = "secretsmanager"
    ssm            = "ssm"
    ssmmessages    = "ssmmessages"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = concat(
    var.app_route_table_ids,
    var.data_route_table_ids,
    var.pki_route_table_ids,
  )

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-s3-endpoint"
    }
  )
}

resource "aws_vpc_endpoint" "interface" {
  for_each = local.interface_endpoints

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = slice(var.app_subnet_ids, 0, var.endpoint_az_count)
  security_group_ids  = [var.endpoints_security_group_id]
  private_dns_enabled = true

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-${each.key}-endpoint"
    }
  )
}
