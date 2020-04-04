terraform {
  backend "s3" {
    bucket = "smtx-live-us-east-1"
    key    = "bastion/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  company        = "smtx"
  env            = "live"
  group          = "store"
  system         = "bastion"
  role           = "server"
  name           = "smtx-${local.env}-${local.system}-${local.role}"
  keyname        = "aws-hamelek"
  instance_type  = "t2.small"
  vol_type_so    = "gp2"
  vol_size_so    = "10"
  bastion_ami_id = "ami-001efa431f19d816f"
}


// Describe VPC
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["live-smtx"]
  }
}

// Describe Subnets

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:subnet_type"
    values = ["Public"]
  }

  filter {
    name   = "tag:tier"
    values = ["public"]
  }

  filter {
    name   = "tag:type"
    values = ["service"]
  }  
}





