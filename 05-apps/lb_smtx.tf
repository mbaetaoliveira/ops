// Create Target

resource "aws_lb_target_group" "target_smtx" {
  name     = "smtx-http-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.vpc.id}"
  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/rev.txt"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

// Create Listener
resource "aws_lb_listener" "smtx_http" {
  load_balancer_arn = aws_lb.lb_smtx.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_smtx.arn}"
  }
}

// Create ApplicationLB
resource "aws_lb" "lb_smtx" {
  name_prefix                = "smtx-"
  load_balancer_type         = "application"
  internal                   = false
  enable_deletion_protection = true
  subnets                    = element(data.aws_subnet_ids.private.*.ids, 0)
  security_groups            = [aws_security_group.smtx_lb_sg.id]

  tags = {
    company = "${local.company}"
    env     = "${local.env}"
    group   = "${local.group}"
    role    = "network"
    system  = "${local.system}"
    type    = "service"
  }
}



//// Create ELB Classical
//
//resource "aws_elb" "elb-smtx" {
//  name               = "live-smtx"
//  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
//  security_groups    = [aws_security_group.live_smtx_ec2_sg.id]
//  subnets            = element(data.aws_subnet_ids.public.*.ids, 0)
//  internal           = false
//
//  //access_logs {
//  //  bucket        = "smtx-live-us-east-1"
//  //  bucket_prefix = "smtx"
//  //  interval      = 60
//  //}
//
//  listener {
//    instance_port     = 80
//    instance_protocol = "tcp"
//    lb_port           = 80
//    lb_protocol       = "tcp"
//  }
//
//  health_check {
//    healthy_threshold   = 2
//    unhealthy_threshold = 2
//    timeout             = 3
//    target              = "TCP:80"
//    interval            = 30
//  }
//
//  // instances                   = ["${aws_instance.foo.id}"]
//  cross_zone_load_balancing = true
//  idle_timeout              = 60
//  connection_draining       = false
//  //  connection_draining_timeout = 400
//
//  tags = {
//    company = "${local.company}"
//    env     = "${local.env}"
//    group   = "${local.group}"
//    role    = "network"
//    system  = "${local.system}"
//    type    = "service"
//  }
//}
//

