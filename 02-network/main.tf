terraform {
  backend "s3" {
    bucket = "smtx-live-us-east-1"
    key    = "network/terraform.tfstate"
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

// Create VPC

module "aws_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "live-smtx"
  cidr = "10.205.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  private_subnets = ["10.205.101.0/24", "10.205.102.0/24", "10.205.103.0/24", "10.205.104.0/24"]
  public_subnets  = ["10.205.1.0/24", "10.205.2.0/24", "10.205.3.0/24", "10.205.4.0/24"]

  enable_dns_hostnames               = true
  enable_dns_support                 = true
  enable_nat_gateway                 = true
  enable_s3_endpoint                 = true
  enable_vpn_gateway                 = true
  one_nat_gateway_per_az             = false
  propagate_private_route_tables_vgw = true
  propagate_public_route_tables_vgw  = true
  single_nat_gateway                 = true

  private_subnet_tags = {
    "env"         = "${local.env}"
    "subnet_type" = "Private"
    "tier"        = "private"
  }

  public_subnet_tags = {
    "env"         = "${local.env}"
    "subnet_type" = "Public"
    "tier"        = "public"
  }

  tags = {
    company = "${local.company}"
    env     = "${local.env}"
    group   = "it"
    role    = "network"
    type    = "service"
  }
}
