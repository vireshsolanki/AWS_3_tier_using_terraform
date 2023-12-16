resource "aws_launch_template" "web-alt" {
    name = "${var.project-name}-web-alt"
    image_id = var.ami
    instance_type = var.instance-type
    key_name = var.key-name
    user_data = filebase64("../modules/webtierasg/config.sh")  
    vpc_security_group_ids = [var.web-tier-sg-id]
    tags = {
      Name = "${var.project-name}-web-alt"
    }
}

resource "aws_autoscaling_group" "web-asg" {
  name                      = "${var.project-name}-asg"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  vpc_zone_identifier = [var.public-1-1a-id,var.public-2-1b-id]
  target_group_arns = [var.tg-internet-arn]
 enabled_metrics = [
  "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
 ]
 metrics_granularity = "1Minute"
launch_template {
  id = aws_launch_template.web-alt.id
  version = aws_launch_template.web-alt.latest_version
}
}

resource "aws_autoscaling_policy" "scale-up" {
  name                   = "${var.project-name}-asg-scale-up"
  autoscaling_group_name = aws_autoscaling_group.web-asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" #increasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scale-up-alarm" {
  alarm_name          = "${var.project-name}-scaleup-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30" # New instance will be created once CPU utilization is higher than 30 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.web-asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale-up.arn]
}

resource "aws_autoscaling_policy" "scale-down" {
  name                   = "${var.project-name}-asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.web-asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decreasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scale-down-alarm" {
  alarm_name          = "${var.project-name}-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5" # Instance will scale down when CPU utilization is lower than 5 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.web-asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale-down.arn]
}