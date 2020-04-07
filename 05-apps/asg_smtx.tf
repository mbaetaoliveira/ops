// Autoscaling smtx

resource "aws_autoscaling_group" "asg_smtx_lt" {
  name_prefix         = "asg-smtx-lt-"
  default_cooldown    = "300"
  desired_capacity    = 3
  max_size            = 3
  min_size            = 1
  target_group_arns   = [aws_lb_target_group.target_smtx.arn]
  vpc_zone_identifier = element(data.aws_subnet_ids.private.*.ids, 0)
  tags = [
    {
      key                 = "company"
      value               = local.company
      propagate_at_launch = true
    },
    {
      key                 = "env"
      value               = local.env
      propagate_at_launch = true
    },
    {
      key                 = "group"
      value               = local.group
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "${local.company}-${local.env}-${local.app}-AS"
      propagate_at_launch = true
    },
    {
      key                 = "app"
      value               = "${local.app}"
      propagate_at_launch = true
    },
    {
      key                 = "type"
      value               = local.type
      propagate_at_launch = true
    },
  ]
  mixed_instances_policy {
    instances_distribution {
      on_demand_allocation_strategy            = "prioritized"
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "capacity-optimized"
      spot_instance_pools                      = 0
    }
    launch_template {
      launch_template_specification {
        launch_template_id = "${aws_launch_template.smtx_template.id}"
        version            = "$Latest"
      }
      override {
        instance_type = "t2.small"
      }

      override {
        instance_type = "t3.small"
      }
    }
  }
}

// Scaling policy

resource "aws_autoscaling_policy" "scaling_up" {
  name                   = "scaleup"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg_smtx_lt.name
}

resource "aws_cloudwatch_metric_alarm" "cpualarm_up" {
  alarm_name          = "CPU-alarm-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_smtx_lt.name
  }

  alarm_description = "This metric monitor EC2 instance cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scaling_up.arn]
}

resource "aws_autoscaling_policy" "scaling_down" {
  name                   = "scaledown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg_smtx_lt.name
}

resource "aws_cloudwatch_metric_alarm" "cpualarm_down" {
  alarm_name          = "CPU-alarm-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "900"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_smtx_lt.name
  }

  alarm_description = "This metric monitor EC2 instance cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scaling_down.arn]
}