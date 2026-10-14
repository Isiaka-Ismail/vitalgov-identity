# Non-secret defaults. Secrets go through TF_VAR_* environment variables:
#   TF_VAR_db_password, TF_VAR_jwt_secret, TF_VAR_keycloak_admin_password,
#   TF_VAR_github_org_id, TF_VAR_github_repo_id, TF_VAR_container_image

environment = "production"
aws_profile = "admin"
aws_region  = "af-south-1"

vpc_cidr           = "10.20.0.0/16"
availability_zones = ["af-south-1a", "af-south-1b"]

# Subnet CIDRs per docs/cloud/ip-addressing-plan.md §3 + §6
public_subnet_cidrs = ["10.20.0.0/24", "10.20.1.0/24"]
app_subnet_cidrs    = ["10.20.16.0/24", "10.20.32.0/24"]
data_subnet_cidrs   = ["10.20.64.0/24", "10.20.65.0/24"]
pki_subnet_cidrs    = ["10.20.96.0/24", "10.20.97.0/24"]

db_name                 = "vitalgov"
backup_retention_period = 7  # open decision (I-011)
log_retention_days      = 90 # open decision (I-011)

budget_limit_usd = "200"
# Alarm/budget emails are not committed (public repo). Set at apply time:
#   export TF_VAR_budget_alert_emails='["team@example.com"]'
budget_alert_emails = []

github_org  = "lavikara"
github_repo = "vitalgov-identity"

# Placeholder host stays off until the I-007 CA software decision; the CA
# CMK is created regardless.
create_ca_host = false
