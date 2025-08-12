resource "aws_launch_template" "template" {
  image_id                  = var.image_id
  instance_type             = var.instance_type
  tags = {
    project_name            = var.project_name
    Name                    = "${var.prefix}-template"
  }
  user_data = base64encode(var.user_data)

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.security_group_ids
  }

  tag_specifications {
    resource_type   = "instance"
    tags = {
      project_name  = var.project_name
      Name          = "${var.prefix}-node"
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  name              = "${var.prefix}-asg"
  min_size          = var.min_size
  desired_capacity  = var.desired_capacity
  max_size          = var.max_size
  vpc_zone_identifier = var.subnet_ids
  target_group_arns = [ aws_lb_target_group.app_tg.arn ]

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "${var.prefix}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = var.scale_out.scaling_adjustment
  cooldown               = var.scale_out.cooldown
}

resource "aws_cloudwatch_metric_alarm" "scale_out_alarm" {
  alarm_description   = "Monitor Average CPU Utilization"
  alarm_name          = "${var.prefix}-scale-out-alarm"
  namespace          = "AWS/EC2"
  metric_name        = "CPUUtilization"
  threshold          = var.scale_out.threshold
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  period             = "30"
  statistic          = "Average"
  alarm_actions = [aws_autoscaling_policy.scale_out_policy.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "${var.prefix}-scale-in"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = var.scale_in.scaling_adjustment
  cooldown               = var.scale_in.cooldown
}

resource "aws_cloudwatch_metric_alarm" "scale_in_alarm" {
  alarm_description   = "Monitor Average CPU Utilization"
  alarm_name          = "${var.prefix}-scale-in-alarm"
  namespace          = "AWS/EC2"
  metric_name        = "CPUUtilization"
  threshold          = var.scale_in.threshold
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "3"
  period             = "30"
  statistic          = "Average"
  alarm_actions = [aws_autoscaling_policy.scale_in_policy.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

resource "aws_lb" "aws_alb" {
  name               = "${var.prefix}-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    project_name = var.project_name
    Name         = "${var.prefix}-app-alb"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "${var.prefix}-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
  }

  tags = {
    project_name = var.project_name
    Name         = "${var.prefix}-app-tg"
  }
}

resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.aws_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  tags = {
    project_name = var.project_name
    Name         = "${var.prefix}-app-lb-listener"
  }
}