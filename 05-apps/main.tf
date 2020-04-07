terraform {
  backend "s3" {
    bucket = "smtx-live-us-east-1"
    key    = "apps/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  company              = "smtx"
  env                  = "live"
  group                = "web"
  system               = "app"
  role                 = "server"
  type                 = "server"
  name_complete        = "smtx-${local.env}-${local.system}-${local.role}"
  keyname              = "aws-hamelek"
  instance_type        = "t2.small"
  iam_instance_profile = "live-smtx"
  vol_type_so          = "gp2"
  vol_size_so          = "30"
  image_id             = "ami-001efa431f19d816f"
  app                  = "app"
  SubnetType           = "Public"
}

data "aws_caller_identity" "current" {
}

// Describe VPC
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["live-smtx"]
  }
}

// Describe Subnets

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:subnet_type"
    values = ["Private"]
  }

  filter {
    name   = "tag:tier"
    values = ["private"]
  }

  filter {
    name   = "tag:type"
    values = ["service"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:subnet_type"
    values = ["Public"]
  }
}

//// LoadBalancer
//data "aws_lb" "live-smtx" {
//  name = "live-smtx"
//}

