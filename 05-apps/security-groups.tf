//Ec2
resource "aws_security_group" "live_smtx_ec2_sg" {
  name        = "live_smtx_ec2_sg"
  description = "Security Group - Live EC2 smtx"

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
    cidr_blocks = ["178.8.173.2/32"]
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


// Security Group Smtx Instance

resource "aws_security_group" "smtx_lb_sg" {
  name        = "smtx-lb-sg"
  description = "Security Group for smtx web"


  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    //  description = "temp"
    cidr_blocks = ["10.205.0.0/16"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    //  description = "temp"
    cidr_blocks = ["172.20.0.0/16"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    //  description = "temp"
    cidr_blocks = ["172.31.24.213/32"]
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
    Name = "SMTX Web SG"
  }
  vpc_id = data.aws_vpc.vpc.id
}