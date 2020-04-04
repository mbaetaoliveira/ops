//bastion
resource "aws_security_group" "live_smtx_bation_sg" {
  name        = "llive_smtx_bation_sg"
  description = "Security Group - Live Bastion smtx"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "live_smtx"
    cidr_blocks = ["10.205.0.0/16"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "Office-House"
    cidr_blocks = ["178.2.79.101/32"]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "temp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "${local.env}-${local.system}-sg"
    system  = local.system
    env     = local.env
    company = local.company
    group   = local.group
    role    = "network"
    type    = "resource"
  }

  vpc_id = data.aws_vpc.vpc.id
}