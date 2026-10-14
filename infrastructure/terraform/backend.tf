# Backend is configured at init time (bucket/key/region via -backend-config).
# Locking is S3-native (use_lockfile); the DynamoDB table in ./state is legacy.

terraform {
  backend "s3" {
    encrypt = true
  }
}
