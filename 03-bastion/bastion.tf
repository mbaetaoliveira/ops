// EC2 Bastion
resource "aws_instance" "bastion_live" {
  ami                         = local.bastion_ami_id
  key_name                    = local.keyname
  instance_type               = local.instance_type
  vpc_security_group_ids      = [aws_security_group.live_smtx_bation_sg.id]
  subnet_id     = "subnet-08003b3537a15d1e5"

  associate_public_ip_address = true
  //iam_instance_profile        = data.aws_iam_role.smtx.name

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "10"
    delete_on_termination = true
  }

  tags = {
    Name    = "bastion-live"
    company = local.company
    env     = local.env
    group   = local.group
    role    = local.role
    system  = "bastion"
    type    = local.instance_type
  }
}
