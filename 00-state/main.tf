provider "aws" {
  region = "us-east-1"
}

locals {
  company = "smtx"
  env     = "live"
  group   = "it"
}

resource "aws_s3_bucket" "terraform-state" {
  bucket        = "smtx-live-us-east-1"
  acl           = "log-delivery-write"
  region        = "us-east-1"
  force_destroy = true

  // Disable to destroy state bucket.
  lifecycle {
    prevent_destroy = true
  }

  logging {
    target_bucket = "smtx-live-us-east-1" // self
    target_prefix = "logs/"
  }

  versioning {
    enabled = true
  }

  tags = {
    Name    = "Smtx US Terraform state for live environment"
    company = local.company
    env     = local.env
    group   = local.group
    role    = "storage"
    system  = "terraform"
    type    = "service"
  }
}
