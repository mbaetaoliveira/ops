terraform {
  backend "s3" {
    bucket = "smtx-live-us-east-1"
    key    = "iam/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  company = "smtx"
  env     = "live"
  group   = "it"
}