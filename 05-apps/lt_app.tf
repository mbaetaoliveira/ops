// Launch Template

resource "aws_launch_template" "smtx_template" {
  name_prefix            = "smtx-lt-"
  image_id               = local.image_id
  vpc_security_group_ids = ["${aws_security_group.live_smtx_ec2_sg.id}"]
  key_name               = local.keyname
  //iam_instance_profile   = "${aws_iam_instance_profile.live_smtx.id}"

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "llive-smtx-app-AS"
      company = "gfg"
      env     = "live"
      group   = "store"
      type    = "server"
      role    = "api"
      system  = "smtx"
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name    = "smtx-live-app-AS"
      company = "gfg"
      env     = "live"
      group   = "store"
      type    = "server"
      role    = "api"
      system  = "smtx"
    }
  }
}